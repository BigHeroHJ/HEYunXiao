//
//  DateTool.m
//  移动营销
//
//  Created by Hanen 3G 01 on 16/2/24.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "DateTool.h"

@implementation DateTool

+ (NSString *)getCurrentDate;
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm"];//HH 大写就是24小时制 小写就是12小时制
    NSString * dateStr = [formate stringFromDate:date];
   
//    NSLog(@"currentdate:%@",dateStr);
    return dateStr;
    
}
+ (NSString *)getStringFormDate:(NSDate *)date
{
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm"];//HH 大写就是24小时制 小写就是12小时制
    NSString * dateStr = [formate stringFromDate:date];
    return dateStr;
}
+ (NSDate * )getLastDateFormString:(NSString *)lastMonthStr
{
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm"];//HH 大写就是24小时制 小写就是12小时制
    NSDate * date = [formate dateFromString:lastMonthStr];
    return date;
}
+ (NSString *)getYearmonthFromStr:(NSString *)dateStr
{
//    NSLog(@"dateStr%@",dateStr);

//    if ([dateStr containsString:@"-"]) {
   NSString * Str = [dateStr stringByReplacingOccurrencesOfString:@"-" withString:@"."];
//    }
    
    NSRange rang = [Str rangeOfString:@" "];
    NSString * dateS = [Str substringToIndex:rang.location];
//    NSLog(@"dateS%@1",dateS);
    return dateS;
}

+ (NSString *)getDateFromStr:(NSString *)dateStr
{
//    NSString *Str = [dateStr stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSRange rang = [dateStr rangeOfString:@" "];
    NSString * dateS = [dateStr substringFromIndex:rang.location + 1];

    return dateS;
}

+ (NSString *)getLastMonthFromDate:(NSDate *)fromDate withLastOrMore:(BOOL)isLast
{
    
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//HH 大写就是24小时制 小写就是12小时制
    NSDate *date ;
    if (isLast) {
        date = [NSDate dateWithTimeInterval:-(30 * 24 * 60 * 60) sinceDate:fromDate];
    }else{
        date = [NSDate dateWithTimeInterval:(30 * 24 * 60 * 60) sinceDate:fromDate];
    }
    NSString * dateStr = [formate stringFromDate:date];
    return dateStr;
    
}
+ (NSString *)getCurrentWeekDay
{
    NSInteger  weekdayNum =  [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:[NSDate date]];
    if (weekdayNum == 1) {
        return @"星期日";
    }else if(weekdayNum == 2){
        return @"星期一";
    }else if(weekdayNum == 3){
        return @"星期二";
    }else if(weekdayNum == 4){
        return @"星期三";
    }else if(weekdayNum == 5){
        return @"星期四";
    }else if(weekdayNum == 6){
        return @"星期五";
    }else if(weekdayNum == 7){
        return @"星期六";
    }
    
    return nil;
    
}

//按钮倒计时
+(void)startTime:(UIButton *)button{
    __block int timeout=30; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [button setTitle:@"获取验证码" forState:UIControlStateNormal];
                button.userInteractionEnabled = YES;
                button.alpha=1;//变灰
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [button setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                button.userInteractionEnabled = NO;
                button.alpha=0.4;//变灰
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

/**
 *  是否为同一天
 */
+ (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2
{
    if ([[self getYear:date1] isEqualToString:[self getYear:date2]]) {
        if ([[self getMonth:date1] isEqualToString:[self getMonth:date2]]) {
            if ([[self getDay:date1] isEqualToString:[self getDay:date2]]) {
                return YES;
            }
        }
    }
    
    return NO;
//    return [[self getYear:date1] isEqualToString:[self getYear:date2]] &
//    [[self getMonth:date1] isEqualToString:[self getMonth:date2]] &
//    [[self getDay:date1] isEqualToString:[self getDay:date2]];
//    NSCalendar* calendar = [NSCalendar currentCalendar];
//    
//    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
//    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
//    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
//    
//    return [comp1 day]   == [comp2 day] &&
//    [comp1 month] == [comp2 month] &&
//    [comp1 year]  == [comp2 year];
}

+ (NSString *)getYear:(NSDate *)date{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    NSString *yearStr = [NSString stringWithFormat:@"%d",(int)[dateComponent year]];
    return yearStr;
}

+ (NSString *)getMonth:(NSDate *)date{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    
    int month = (int)[dateComponent month] ;
    NSString *monStr = [NSString stringWithFormat:@"%d",month];
    if (month<10) {
         monStr = [NSString stringWithFormat:@"0%@",monStr];
    }
    return monStr;

}

+ (NSString *)getDay:(NSDate *)date{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    
    int day = (int)[dateComponent day] ;
    NSString *dayStr = [NSString stringWithFormat:@"%d",day];
    if (day<10) {
        dayStr = [NSString stringWithFormat:@"0%@",dayStr];
    }
    return dayStr;
}

+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        NSLog(@"Date1 is in the past");
        return -1;
    }
    NSLog(@"Both dates are the same");
    return 0;
    
}

@end

