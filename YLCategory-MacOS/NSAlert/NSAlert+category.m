//
//  NSAlert+category.m
//  iCopy
//
//  Created by 魏宇龙 on 2022/11/21.
//

#import "NSAlert+category.h"

@implementation NSAlert (category)

+ (void)showForModalWindow:(NSWindow *)window
                 withTitle:(NSString *)title
                   buttons:(NSArray<NSString *> *)buttons
         completionHandler:(void (^)(NSInteger))completionHandler {
    [self showForModalWindow:window withTitle:title message:nil buttons:buttons completionHandler:completionHandler];
}

+ (void)showWithTitle:(NSString *)title message:(NSString *)message buttons:(NSArray<NSString *> *)buttons completionHandler:(void (^)(NSInteger))completionHandler {
    [self showForModalWindow:nil withTitle:title message:message buttons:buttons completionHandler:completionHandler];
}

+ (void)showWithTitle:(NSString *)title buttons:(NSArray<NSString *> *)buttons completionHandler:(void (^)(NSInteger))completionHandler {
    [self showWithTitle:title message:nil buttons:buttons completionHandler:completionHandler];
}

+ (void)showForModalWindow:(NSWindow *)window
                 withTitle:(NSString *)title
                   message:(NSString *)message
                   buttons:(NSArray<NSString *> *)buttons
         completionHandler:(void (^)(NSInteger))completionHandler {
    NSAlert *alert = [[self alloc] init];
    alert.alertStyle = NSAlertStyleWarning;
    if(title)   alert.messageText = title;
    if(message) alert.informativeText = message;
    for (NSString *buttonTitle in buttons) {
        [alert addButtonWithTitle:buttonTitle];
    }
    if(window) {
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            if(completionHandler) {
                if(returnCode == NSAlertFirstButtonReturn) {
                    completionHandler(0);
                } else if (returnCode == NSAlertSecondButtonReturn) {
                    completionHandler(1);
                } else if (returnCode == NSAlertThirdButtonReturn) {
                    completionHandler(2);
                }
            }
        }];
    } else {
        NSModalResponse returnCode = [alert runModal];
        if(completionHandler) {
            if(returnCode == NSAlertFirstButtonReturn) {
                completionHandler(0);
            } else if (returnCode == NSAlertSecondButtonReturn) {
                completionHandler(1);
            } else if (returnCode == NSAlertThirdButtonReturn) {
                completionHandler(2);
            }
        }
    }
}

@end
