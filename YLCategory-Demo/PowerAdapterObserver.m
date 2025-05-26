//
//  PowerAdapterObserver.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2025/1/7.
//

#import "PowerAdapterObserver.h"
#import <IOKit/ps/IOPowerSources.h>
#import <IOKit/ps/IOPSKeys.h>

@implementation PowerAdapterObserver {
    CFRunLoopSourceRef powerSourceNotification;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        [self startMonitoringPowerAdapter];
    }
    return self;
}

- (void)dealloc {
    [self stopMonitoringPowerAdapter];
}

- (void)startMonitoringPowerAdapter {
    powerSourceNotification = IOPSNotificationCreateRunLoopSource(PowerSourceCallback, (__bridge void *)self);
    if (powerSourceNotification) {
        CFRunLoopAddSource(CFRunLoopGetCurrent(), powerSourceNotification, kCFRunLoopDefaultMode);
    }
    
    // 初始检查状态
    [self handlePowerSourceChange];
}

- (void)stopMonitoringPowerAdapter {
    if (powerSourceNotification) {
        CFRunLoopRemoveSource(CFRunLoopGetCurrent(), powerSourceNotification, kCFRunLoopDefaultMode);
        CFRelease(powerSourceNotification);
        powerSourceNotification = NULL;
    }
}

void PowerSourceCallback(void *context) {
    PowerAdapterObserver *observer = (__bridge PowerAdapterObserver *)context;
    [observer handlePowerSourceChange];
}

- (void)handlePowerSourceChange {
    CFTypeRef powerSourcesInfo = IOPSCopyPowerSourcesInfo();
    CFArrayRef powerSourcesList = IOPSCopyPowerSourcesList(powerSourcesInfo);
    
    if (powerSourcesList) {
        for (CFIndex i = 0; i < CFArrayGetCount(powerSourcesList); i++) {
            CFTypeRef powerSource = CFArrayGetValueAtIndex(powerSourcesList, i);
            CFDictionaryRef description = IOPSGetPowerSourceDescription(powerSourcesInfo, powerSource);
            
            if (description) {
                CFStringRef powerSourceType = CFDictionaryGetValue(description, CFSTR(kIOPSPowerSourceStateKey));
                if (CFStringCompare(powerSourceType, CFSTR(kIOPSACPowerValue), 0) == kCFCompareEqualTo) {
                    NSLog(@"Power adapter is plugged in.");
                } else if (CFStringCompare(powerSourceType, CFSTR(kIOPSBatteryPowerValue), 0) == kCFCompareEqualTo) {
                    NSLog(@"Running on battery power.");
                }
            }
        }
        CFRelease(powerSourcesList);
    }
    if (powerSourcesInfo) {
        CFRelease(powerSourcesInfo);
    }
}

@end
