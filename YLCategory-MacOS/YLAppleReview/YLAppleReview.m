//
//  YLAppleReview.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import "YLAppleReview.h"

@interface YLAppleReview ()

@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) NSDate *endDate;

@end

@implementation YLAppleReview

+ (instancetype)share {
    static YLAppleReview *appleReview = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appleReview = [[YLAppleReview alloc] init];
    });
    return appleReview;
}

+ (void)setAppleReviewBeginDate:(NSString *)beginDate endDate:(NSString *)endData {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [YLAppleReview share].beginDate = [formatter dateFromString:beginDate];
    [YLAppleReview share].endDate = [formatter dateFromString:endData];
}

+ (void)setAppleReviewEndDate:(NSString *)endData {
    [self setAppleReviewBeginDate:nil endDate:endData];
}

+ (BOOL)isAppleReview {
    NSDate *beginDate = [YLAppleReview share].beginDate;
    NSDate *endDate = [YLAppleReview share].endDate;
    if(beginDate == nil && endDate == nil) {
        return NO;
    }
    if(beginDate == nil && [endDate timeIntervalSinceNow] > 0) {
        return YES;
    }
    if(endDate == nil && [beginDate timeIntervalSince1970] < 0) {
        return YES;
    }
    return [beginDate timeIntervalSinceNow] < 0 && [endDate timeIntervalSinceNow] > 0;
}

@end
