//
//  YLAppleScript.m
//  Test
//
//  Created by 魏宇龙 on 2022/11/16.
//

#import "YLAppleScript.h"
#import <AppKit/AppKit.h>
#import <Carbon/Carbon.h>
#import "YLHud.h"

NSString *YLAppleScriptLocalizeString(NSString *key, NSString *comment) {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle bundleForClass:[YLAppleScript class]];
    });
    return [bundle localizedStringForKey:key value:@"" table:@"YLAppleScript"];
}

@implementation YLAppleScript

#pragma mark 获取APP脚本库的路径
+ (NSURL *)getScriptLocalURL {
    static NSURL *url;
    if(url == nil) {
        dispatch_semaphore_t sem = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSError *error = nil;
            // 该方法会警告，不能在主线程调用
            url = [[NSFileManager defaultManager] URLForDirectory:NSApplicationScriptsDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
            NSLog(@"Apple script install directory: %@", url.path);
            if(error) {
                NSLog(@"【%s】 error: %@", __FUNCTION__, error);
            }
            dispatch_semaphore_signal(sem);
        });
        dispatch_semaphore_wait(sem, dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC));
    }
    return url;
}

+ (void)executeScriptWithFile:(NSString *)fileName {
    [self executeScriptWithFile:fileName completionHandler:nil];
}

+ (void)executeScriptWithFile:(NSString *)fileName completionHandler:(NSUserAppleScriptTaskCompletionHandler)handler {
    [self executeScriptWithFile:fileName funcName:nil arguments:nil completionHandler:handler];
}

#pragma mark 执行脚本
+ (void)executeScriptWithFile:(NSString *)fileName
                     funcName:(NSString *)funcName
                    arguments:(NSArray *)arguments
            completionHandler:(NSUserAppleScriptTaskCompletionHandler)handler {
    if([fileName isKindOfClass:[NSString class]] == NO || fileName.length == 0) {
        NSLog(@"【%s】 file name is incorrect: %@", __FUNCTION__, fileName);
        return;
    }
    if([fileName hasSuffix:@".scpt"] == NO) {
        // 如果没有传入后缀，则自动拼接上
        fileName = [NSString stringWithFormat:@"%@.scpt", fileName];
    }
    if([[[NSProcessInfo processInfo] environment] objectForKey:@"APP_SANDBOX_CONTAINER_ID"] != nil) {
        // 沙盒
        NSError *error = nil;
        NSURL *scriptDirUrl = [self getScriptLocalURL];
        NSURL *scriptUrl = [scriptDirUrl URLByAppendingPathComponent:fileName];
        if([[NSFileManager defaultManager] fileExistsAtPath:scriptUrl.path]) {
            // 已经存在了脚本, 执行
            NSUserAppleScriptTask *task = [[NSUserAppleScriptTask alloc] initWithURL:scriptUrl error:&error];
            if(task) {
                // 任务创建成功,如果传入有方法名称和参数，则创建事件，否则就执行文件
                NSAppleEventDescriptor *descriptor = [self createEventDescriptorWithFuncName:funcName arguments:arguments];
                [task executeWithAppleEvent:descriptor completionHandler:^(NSAppleEventDescriptor * _Nullable result, NSError * _Nullable error) {
                    if(handler) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            handler(result, error);
                        });
                    }
                }];
            } else {
                NSLog(@"【%s】create user applle script task error: %@", __FUNCTION__, error);
                [YLHud showError:YLAppleScriptLocalizeString(@"Script task creation failed", @"") toWindow:NSApp.windows.lastObject];
            }
            return;
        }
        // 脚本未安装，安装脚本
        [self installScriptWithFile:fileName completionHandler:^(BOOL success) {
            if(success) {
                [self executeScriptWithFile:fileName funcName:funcName arguments:arguments completionHandler:handler];
            } else {
                [YLHud showError:YLAppleScriptLocalizeString(@"Install failed", @"") toWindow:NSApp.windows.lastObject];
            }
        }];
    } else {
        // 非沙盒
        NSURL *scriptUrl = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        if(scriptUrl == nil) {
            NSLog(@"【%s】 script file not exist : %@", __FUNCTION__, fileName);
            return;
        }
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSAppleScript *appleScript = [[NSAppleScript alloc] initWithContentsOfURL:scriptUrl error:nil];
            NSAppleEventDescriptor *descriptor = [self createEventDescriptorWithFuncName:funcName arguments:arguments];
            NSDictionary *error = nil;
            NSAppleEventDescriptor *result = [appleScript executeAppleEvent:descriptor error:&error];
            if(handler) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(result) {
                        handler(result, nil);
                    } else {
                        // 有错误
                        handler(result, [NSError errorWithDomain:NSPOSIXErrorDomain code:2 userInfo:error]);
                    }
                });
            }
        });
    }
}

#pragma mark 根据函数名和参数创建 eventDescriptor
+ (nullable NSAppleEventDescriptor *)createEventDescriptorWithFuncName:(NSString *)funcName arguments:(NSArray *)arguments {
    if([funcName isKindOfClass:[NSString class]] == NO || funcName.length == 0) {
        return nil;
    }
    
    NSAppleEventDescriptor *target = nil;
    NSAppleEventDescriptor *function = nil;
    NSAppleEventDescriptor *parameters = nil;
    
    // target
    ProcessSerialNumber psn = {0, kCurrentProcess};
    target = [NSAppleEventDescriptor descriptorWithDescriptorType:typeProcessSerialNumber bytes:&psn length:sizeof(ProcessSerialNumber)];
    
    // function
    function = [NSAppleEventDescriptor descriptorWithString:funcName];
    
    // parameter
    if(arguments.count) {
        parameters = [NSAppleEventDescriptor listDescriptor];
        for (int i = 1; i <= arguments.count; i ++) {
            id arg = arguments[i - 1];
            NSAppleEventDescriptor *param;
            if([arg isKindOfClass:[NSString class]]) {
                NSString *argStr = (NSString *)arg;
                if([argStr isEqualToString:@"YES"] ||
                   [argStr isEqualToString:@"yes"] ||
                   [argStr isEqualToString:@"TRUE"] ||
                   [argStr isEqualToString:@"true"]) {
                    param = [NSAppleEventDescriptor descriptorWithBoolean:YES];
                } else if ([argStr isEqualToString:@"NO"] ||
                           [argStr isEqualToString:@"no"] ||
                           [argStr isEqualToString:@"FALSE"] ||
                           [argStr isEqualToString:@"false"]) {
                    param = [NSAppleEventDescriptor descriptorWithBoolean:NO];
                } else {
                    param = [NSAppleEventDescriptor descriptorWithString:argStr];
                }
            } else if ([arg isKindOfClass:[NSNumber class]]) {
                CGFloat value = [arg doubleValue];
                if(ceil(value) == floor(value)) {
                    // 整数
                    param = [NSAppleEventDescriptor descriptorWithInt32:[arg intValue]];
                } else {
                    // 小数
                    param = [NSAppleEventDescriptor descriptorWithDouble:value];
                }
            } else if ([arg isKindOfClass:[NSDate class]]) {
                param = [NSAppleEventDescriptor descriptorWithDate:arg];
            }
            
            if(param) {
                [parameters insertDescriptor:param atIndex:i];
            }
        }
    }
    
    // event
    NSAppleEventDescriptor *event = [NSAppleEventDescriptor appleEventWithEventClass:kASAppleScriptSuite eventID:kASSubroutineEvent targetDescriptor:target returnID:kAutoGenerateReturnID transactionID:kAnyTransactionID];
    if(function)    [event setParamDescriptor:function forKeyword:keyASSubroutineName];
    if(parameters)  [event setParamDescriptor:parameters forKeyword:keyDirectObject];
    return event;
}

#pragma mark 脚本是否安装过
+ (BOOL)scriptFileHasInstalled:(NSString *)fileName {
    if([fileName isKindOfClass:[NSString class]] == NO || fileName.length == 0)    return NO;
    NSURL *scriptDirUrl = [self getScriptLocalURL];
    NSURL *destionationUrl = [scriptDirUrl URLByAppendingPathComponent:fileName];
    return [[NSFileManager defaultManager] fileExistsAtPath:destionationUrl.path];
}

#pragma mark 将脚本文件写入APP的脚本库
+ (void)installScriptWithFile:(NSString *)fileName completionHandler:(void (^)(BOOL))handler {
    if([fileName isKindOfClass:[NSString class]] == NO || fileName.length == 0) {
        NSLog(@"【%s】 file name is incorrect: %@", __FUNCTION__, fileName);
        if(handler) {
            handler(NO);
        }
        return;
    }
    [self installScriptsWithArr:@[fileName] completionHandler:handler];
}

#pragma mark 将多个脚本同时写入APP脚本库
+ (void)installScriptsWithArr:(NSArray<NSString *> *)fileNameArr completionHandler:(void (^)(BOOL))handler {
    if(fileNameArr.count == 0) {
        NSLog(@"【%s】 file name array is 0 count", __FUNCTION__);
        if(handler) {
            handler(NO);
        }
        return;
    }
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = YLAppleScriptLocalizeString(@"Kind tips", @"");
    alert.informativeText = YLAppleScriptLocalizeString(@"Install first", @"");
    [alert addButtonWithTitle:YLAppleScriptLocalizeString(@"Install", @"")];
    [alert addButtonWithTitle:YLAppleScriptLocalizeString(@"Cancel", @"")];
    NSModalResponse returnCode = [alert runModal];
    if(returnCode == NSAlertFirstButtonReturn) {
        [self beginInstallScripts:fileNameArr completionHandler:handler];
    }
}

#pragma mark 开始安装脚本
+ (void)beginInstallScripts:(NSArray <NSString *> *)fileNameArr completionHandler:(void (^)(BOOL))handler {
    NSURL *scriptDirUrl = [self getScriptLocalURL];
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.directoryURL = scriptDirUrl;
    openPanel.canChooseDirectories = YES;
    openPanel.canChooseFiles = NO;
    openPanel.prompt = YLAppleScriptLocalizeString(@"Install script", @"");
    openPanel.message = YLAppleScriptLocalizeString(@"Install script in current folder", @"");
    [openPanel beginWithCompletionHandler:^(NSModalResponse result) {
        if(result == NSModalResponseOK) {
            NSURL *selectUrl = openPanel.URL;
            if([selectUrl isEqual:scriptDirUrl]) {
                // 选择了正确的文件夹
                BOOL flag = YES;
                for(NSString *fileName in fileNameArr) {
                    NSURL *destionationUrl = [selectUrl URLByAppendingPathComponent:fileName];
                    NSURL *sourceUrl = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
                    NSError *error = nil;
                    if(sourceUrl == nil) {
                        NSLog(@"【%s】%@ is not exist", __FUNCTION__, fileName);
                        flag = NO;
                    } else {
                        if([[NSFileManager defaultManager] fileExistsAtPath:destionationUrl.path]) {
                            // 文件存在，移除
                            [[NSFileManager defaultManager] removeItemAtURL:destionationUrl error:nil];
                        }
                        if([[NSFileManager defaultManager] copyItemAtURL:sourceUrl toURL:destionationUrl error:&error]) {
                            // 复制成功
                            [YLHud showText:YLAppleScriptLocalizeString(@"Install succeed", @"") toWindow:NSApp.orderedWindows.firstObject];
                            NSLog(@"【%s】 copy item to local success: %@", __FUNCTION__, fileName);
                        } else {
                            NSLog(@"【%s】 copy item to local fail: %@", __FUNCTION__, error);
                            [YLHud showText:YLAppleScriptLocalizeString(@"Install failed", @"") toWindow:NSApp.orderedWindows.firstObject];
                            flag = NO;
                        }
                    }
                }
                if(handler) {
                    handler(flag);
                }
            } else {
                // 选的文件夹不是目标文件夹，重新选择
                [self reinstallScripts:fileNameArr toCorrectURLWithCompletionHandler:handler];
            }
        } else {
            NSLog(@"【%s】 user cancel", __FUNCTION__);
            if(handler) {
                handler(NO);
            }
        }
    }];
}

+ (void)reinstallScripts:(NSArray <NSString *> *)fileNameArr toCorrectURLWithCompletionHandler:(void (^)(BOOL))handler {
    NSAlert *alert = [[NSAlert alloc] init];
    alert.alertStyle = NSAlertStyleWarning;
    alert.messageText = YLAppleScriptLocalizeString(@"Kind tips", @"");
    alert.informativeText = YLAppleScriptLocalizeString(@"Install error path", @"");
    [alert addButtonWithTitle:YLAppleScriptLocalizeString(@"Reselect", @"")];
    [alert addButtonWithTitle:YLAppleScriptLocalizeString(@"Cancel", @"")];
    NSModalResponse returnCode = [alert runModal];
    if(returnCode == NSAlertFirstButtonReturn) {
        [self beginInstallScripts:fileNameArr completionHandler:handler];
    }
}

@end
