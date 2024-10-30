//
//  YLAppleReview.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLAppleReview : NSObject

/// 设置审核屏蔽的时间段
/// - Parameters:
///   - beginDate: 开始时间（北京时间）  yyyy-MM-dd HH:mm:ss
///   - endData: 结束时间（北京时间  yyyy-MM-dd HH:mm:ss
+ (void)setAppleReviewBeginDate:(nullable NSString *)beginDate endDate:(nullable NSString *)endData;

/// 设置审核屏蔽的结束时间
/// - Parameters:
///   - endData: 结束时间（北京时间  yyyy-MM-dd HH:mm:ss
+ (void)setAppleReviewEndDate:(NSString *)endData;

// 是否处于审核中
+ (BOOL)isAppleReview;

@end

NS_ASSUME_NONNULL_END
