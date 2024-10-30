
#import "NSDate+category.h"

@implementation NSDate (category)
#pragma mark 根据日期格式和字符串 创建日期实例
+ (NSDate *)dateWithFormat:(NSString *)format string:(NSString *)dateStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateStr];
}

#pragma mark 根据时间戳，返回格式化的字符串
+ (NSString *)dateStringWithFormat:(NSString *)format timeInterval:(NSTimeInterval)timeInterval {
    return [[NSDate dateWithTimeIntervalSince1970:timeInterval] stringValueWithFormat:format];
}

#pragma mark 将日期转换成字符串
- (NSString *)stringValueWithFormat:(NSString *)formatStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setDateFormat:formatStr];
    return [formatter stringFromDate:self];
}
#pragma mark 将日期格式化成对应格式的日期
- (NSDate *)dateWithFormatString:(NSString *)formatStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setDateFormat:formatStr];
    NSString *dateStr = [formatter stringFromDate:self];
    return [formatter dateFromString:dateStr];
}
#pragma mark 计算当前月的第一天是礼拜几
- (Weekday)dayOfFirstDayInCurrentMonth {
    return [[NSDate firstDayOfCurrentMonth] weekday];
}

#pragma mark 当前时间对应的周是当前年中的第几周
- (NSUInteger)indexOfWeekInYear {
    // 1月1日 为第一周
    if(self.day == 1 && self.month == 1) {
        return 1;
    }
    // 其他的调整1天时间, 默认的周日为第一天
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitWeekOfYear inUnit:NSCalendarUnitYear forDate:[self dateAddDays:-1]];
}
#pragma mark 今天所在的周是一年中的第几周
+ (NSUInteger)indexOfWeekInYearWithToday {
    return [[NSDate date] indexOfWeekInYear];
}

#pragma mark 所选日期所在月的第一天
- (NSDate *)firstDayOfMonth {
    NSDate *startDate = nil;
    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth startDate:&startDate interval:NULL forDate:self];
    return startDate;
}
#pragma mark 所选日期所在月的最后一天
- (NSDate *)lastDayOfMonth {
    NSCalendarUnit calendarUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:calendarUnit fromDate:self];
    dateComponents.day = [self numberOfDaysInMonth];
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

#pragma mark 当前月的第一天
+ (NSDate *)firstDayOfCurrentMonth {
    NSDate *startDate = nil;
    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth startDate:&startDate interval:NULL forDate:[NSDate date]];
    return startDate;
}
#pragma mark 当前月的最后一天
+ (NSDate *)lastDayOfCurrentMonth {
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    dateComponents.day = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]].length;
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

#pragma mark 上个月的这一天
- (NSDate *)dayInThePreviousMonth {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

#pragma mark 下个月的这一天
- (NSDate *)dayInTheNextMonth {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = 1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

#pragma mark 计算当前日期的月份有多少天
- (NSUInteger)numberOfDaysInMonth {
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
}

#pragma mark 获取日期对应的年份
- (NSUInteger)year {
    return [self dateComponents].year;
}

#pragma mark 获取日期对应的月份
- (NSUInteger)month {
    return [self dateComponents].month;
}

#pragma mark 获取日期对应的天
- (NSUInteger)day {
    return [self dateComponents].day;
}

#pragma mark 获取日期对应的小时数
- (NSUInteger)hour {
    return [self dateComponents].hour;
}

#pragma mark 获取日期对应的分钟数
- (NSUInteger)minute {
    return [self dateComponents].minute;
}

#pragma mark 获取日期对应的秒数
- (NSUInteger)second {
    return [self dateComponents].second;
}

#pragma mark 获取日期为星期几
- (Weekday)weekday {
    Weekday day = Monday;
    NSInteger index = [self dateComponents].weekday;
    switch (index) {
        case 1: day = Sunday;       break;
        case 2: day = Monday;       break;
        case 3: day = Tuesday;      break;
        case 4: day = Wednesday;    break;
        case 5: day = Thursday;     break;
        case 6: day = Friday;       break;
        case 7: day = Saturday;     break;
        default:
            break;
    }
    return day;
}
#pragma mark 把星期几转换成文字
- (NSString *)transformWeekdayToString:(Weekday)weekday {
    switch (weekday) {
        case Monday:    return @"星期一";
        case Tuesday:   return @"星期二";
        case Wednesday: return @"星期三";
        case Thursday:  return @"星期四";
        case Friday:    return @"星期五";
        case Saturday:  return @"星期六";
        case Sunday:    return @"星期日";
        default:
            break;
    }
    return @"";
}
#pragma mark 获取日期为星期几 如 "星期一"
- (NSString *)weekdayString {
    return [self transformWeekdayToString:self.weekday];
}

#pragma mark 获取一个NSDateComponents实例
- (NSDateComponents *)dateComponents {
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:
                                        NSCalendarUnitYear |
                                        NSCalendarUnitMonth |
                                        NSCalendarUnitDay |
                                        NSCalendarUnitWeekday |
                                        NSCalendarUnitHour |
                                        NSCalendarUnitMinute |
                                        NSCalendarUnitSecond fromDate:self];
    return dateComponents;
}

#pragma mark 获取某个日期对应的前一天的日期
- (NSDate *)yesterday {
    return [self dateAddDays:-1];
}

#pragma mark 获取当前日期增加dayCount天的日期
- (NSDate *)dateAddDays:(NSInteger)dayCount {
    return [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:dayCount toDate:self options:0];
}

#pragma mark 根据传入的某个日期，获取整个星期的日期
- (NSArray *)datesForWholeWeek {
    // 星期几
    Weekday weekday = [self weekday];
    // 星期一
    NSDate *monday = [self dateAddDays: - weekday + 1];
    NSTimeInterval timeInterval = 24 * 60 * 60;
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:7];
    for(int i = 0; i < 7; i++) {
        NSDate *date = [NSDate dateWithTimeInterval:timeInterval * i  sinceDate:monday];
        [arr addObject:date];
    }
    return [NSArray arrayWithArray:arr];
}

#pragma mark 是否为同一分钟
- (BOOL)sameMinuteWithDate:(NSDate *)otherDate {
    return [self sameHourWithDate:otherDate] && self.minute == otherDate.minute;
}

#pragma mark 是否为同一小时
- (BOOL)sameHourWithDate:(NSDate *)otherDate {
    return [self sameDayWithDate:otherDate] && self.hour == otherDate.hour;
}

#pragma mark 是否为同一天
- (BOOL)sameDayWithDate:(NSDate *)otherDate {
    return [self sameMonthWithDate:otherDate] && self.day == otherDate.day;
}

#pragma mark 是否在同一周
- (BOOL)sameWeekWithDate:(NSDate *)otherDate {
    return [self sameYearWithDate:otherDate] && self.indexOfWeekInYear == otherDate.indexOfWeekInYear;
}

#pragma mark 是否在同一个月
- (BOOL)sameMonthWithDate:(NSDate *)otherDate {
    return [self sameYearWithDate:otherDate] && self.month == otherDate.month;
}

#pragma mark 是否在同一年
- (BOOL)sameYearWithDate:(NSDate *)otherDate {
    return self.year == otherDate.year;
}

@end
