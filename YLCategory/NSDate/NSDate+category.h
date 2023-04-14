
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, Weekday) {
    Monday = 1,
    Tuesday,
    Wednesday,
    Thursday,
    Friday,
    Saturday,
    Sunday,
};

@interface NSDate (category)


/**
 *  今天所在的周是一年中的第几周
 */
+ (NSUInteger)indexOfWeekInYearWithToday;

/**
 *  将日期转换成字符串
 *
 *  @param formatStr @"yyyy-MM-dd"
 *
 *  @return @"2015-05-05"
 */
- (NSString *)stringValueWithFormat:(NSString *)formatStr;

/**
 *  将日期格式化成对应格式的日期
 *
 *  @param formatStr @"yyyy-MM-dd HH:mm:ss"
 *
 *  @return 2015-05-05 13:10:12
 */
- (NSDate *)dateWithFormatString:(NSString *)formatStr;

/**
 *  当前月的第一天
 */
+ (NSDate *)firstDayOfCurrentMonth;

/**
 *  当前月的最后一天
 */
+ (NSDate *)lastDayOfCurrentMonth;

/**
 *  根据日期格式和字符串 创建日期实例
 *
 *  @param format 例如 @"yyyy-MM-dd"
 *  @param date   @"2015-07-31"
 */
+ (NSDate *)dateWithFormat:(NSString *)format string:(NSString *)date;

/**
 *  根据日期格式和时间戳 返回对应的时间字符串
 *
 *  @param format 例如 @"yyyy-MM-dd"
 *  @param timeInterval   1631502739
 */
+ (NSString *)dateStringWithFormat:(NSString *)format timeInterval:(NSTimeInterval)timeInterval;

/**
 *  获取当前日期增加dayCount天的日期
 *
 *  @param dayCount 相差的天数（可为负数）
 *
 *  @return 对应的日期
 */
- (NSDate *)dateAddDays:(NSInteger)dayCount;

/**
 *  获取昨天的日历
 */
- (NSDate *)yesterday;

/**
 *  根据传入的某个日期，获取整个星期的日期
 *
 *  @return 存放7个日期的数组（从周一到周日）
 */
- (NSArray <NSDate *> *)datesForWholeWeek;

/**
 *  计算当前月的第一天是礼拜几
 */
- (Weekday)dayOfFirstDayInCurrentMonth;

/**
 *  当前时间对应的周是当前年中的第几周
 */
- (NSUInteger)indexOfWeekInYear;

/**
 *  所选日期所在月的第一天
 */
- (NSDate *)firstDayOfMonth;

/**
 *  所选日期所在月的最后一天
 */
- (NSDate *)lastDayOfMonth;

/**
 *  上个月的这一天
 */
- (NSDate *)dayInThePreviousMonth;

/**
 *  下个月的这一天
 */
- (NSDate *)dayInTheNextMonth;

/**
 *  计算当前日期的月份有多少天
 */
- (NSUInteger)numberOfDaysInMonth;

/**
 *  获取日期对应的年份
 *
 *  @return 如：2015
 */
- (NSUInteger)year;

/**
 *  获取日期对应的月份
 *
 *  @return 如：8
 */
- (NSUInteger)month;

/**
 *  获取日期对应的号
 *
 *  @return 如：13
 */
- (NSUInteger)day;

/**
 *  获取日期对应的小时数
 *
 *  @return 如：11
 */
- (NSUInteger)hour;

/**
 *  获取日期对应的分钟数
 *
 *  @return 如：25
 */
- (NSUInteger)minute;

/**
 *  获取日期对应的秒数
 *
 *  @return 如： 59
 */
- (NSUInteger)second;

/**
 *  获取日期为星期几
 */
- (Weekday)weekday;

/**
 把星期几转换成文字 如 "星期一"
 */
- (NSString *)transformWeekdayToString:(Weekday)weekday;

/**
 获取日期为星期几 如 "星期一"
 */
- (NSString *)weekdayString;

/**
 *  是否为同一天的同一个小时同一分钟
 *
 *  @param otherDate 另一个日期
 */
- (BOOL)sameMinuteWithDate:(NSDate *)otherDate;

/**
 *  是否为同一天的同一个小时
 *
 *  @param otherDate 另一个日期
 */
- (BOOL)sameHourWithDate:(NSDate *)otherDate;

/**
 *  是否为同一天
 *
 *  @param otherDate 另一个日期
 */
- (BOOL)sameDayWithDate:(NSDate *)otherDate;

/**
 *  是否在同一周
 *
 *  @param otherDate 另一个日期
 */
- (BOOL)sameWeekWithDate:(NSDate *)otherDate;

/**
 *  是否在同一个月
 *
 *  @param otherDate 另一个日期
 */
- (BOOL)sameMonthWithDate:(NSDate *)otherDate;

/**
 *  是否在同一年
 *
 *  @param otherDate 另一个日期
 */
- (BOOL)sameYearWithDate:(NSDate *)otherDate;

@end
