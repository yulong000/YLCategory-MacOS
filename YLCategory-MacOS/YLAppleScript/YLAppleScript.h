//
//  YLAppleScript.h
//  Test
//
//  Created by 魏宇龙 on 2022/11/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLAppleScript : NSObject

/// 脚本文件是否已安装
/// - Parameter fileName: 脚本文件名, 例如： apple_script.scpt
+ (BOOL)scriptFileHasInstalled:(NSString *)fileName;

/// 获取脚本的安装路径
+ (NSURL *)getScriptLocalURL;

/// 执行简单的脚本文件，如果本地不存在，从项目内copy到本地再执行
/// - Parameter fileName: 文件名, 例如： apple_script.scpt
+ (void)executeScriptWithFile:(NSString *)fileName;

/// 执行简单的脚本文件，如果本地不存在，从项目内copy到本地再执行
/// - Parameters:
///   - fileName: 文件名, 例如： apple_script.scpt
///   - handler: 执行结果回调
+ (void)executeScriptWithFile:(NSString *)fileName
            completionHandler:(nullable NSUserAppleScriptTaskCompletionHandler)handler;

/// 执行脚本文件内的函数，如果本地不存在，从项目内copy到本地再执行
/// - Parameters:
///   - fileName: 文件名, 例如： apple_script.scpt
///   - func: 脚本函数名
///   - arguments: 传入的参数, NSString (@"YES", @"NO"), NSNumber (@100, @1.5), NSDate
///   - descType: 返回值类型
///   - handler: 结果回调
+ (void)executeScriptWithFile:(NSString *)fileName
                     funcName:(nullable NSString *)funcName
                    arguments:(nullable NSArray *)arguments
            completionHandler:(nullable NSUserAppleScriptTaskCompletionHandler)handler;

/// 安装脚本文件到APP脚本库
/// - Parameters:
///   - fileName: 脚本名
///   - handler: 结果回调
+ (void)installScriptWithFile:(NSString *)fileName completionHandler:(void (^_Nullable)(BOOL success))handler;

///  安装多个脚本到APP脚本库
/// - Parameters:
///   - fileNameArr: 脚本文件名数组
///   - handler: 结果回调
+ (void)installScriptsWithArr:(NSArray <NSString *> *)fileNameArr completionHandler:(void (^_Nullable)(BOOL success))handler;

@end

NS_ASSUME_NONNULL_END
