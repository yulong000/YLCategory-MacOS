//
//  PowerAdapterObserver.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2025/1/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PowerAdapterObserver : NSObject

- (void)startMonitoringPowerAdapter;
- (void)stopMonitoringPowerAdapter;

@end

NS_ASSUME_NONNULL_END
