/*!
 Here , We Become Master!
  @header DateTool.h
  @abstract 项目名字：移动营销

 
 
  @author Created by Hanen 3G 01 on 16/2/24.
  @version 1.00 16/2/24 Creation
  Copyright © 2016年 Hanen 3G 01. All rights reserved.
*/

#import <Foundation/Foundation.h>
//typedef enum {
//    dateFormateType1, //yyyy-MM-dd-hh-mm-ss
//    dateFormateType2  //yyyy.MM.dd.hh.mm.ss
//}dateFormateType;

@interface DateTool : NSObject

+ (NSString *)getCurrentDate;//得到当前的日期

+ (NSString *)getCurrentWeekDay;//得到当前的星期

+ (NSString *)getYearmonthFromStr:(NSString *)dateStr;//得到时间前面的一部分

+ (NSString *)getDateFromStr:(NSString *)dateStr;

+(void)startTime:(UIButton *)button;//按钮倒计时

+ (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2;//是否同一天

+ (NSString *)getYear:(NSDate *)date;

+ (NSString *)getMonth:(NSDate *)date;

+ (NSString *)getDay:(NSDate *)date;

+ (NSString *)getLastMonthFromDate:(NSDate *)fromDate withLastOrMore:(BOOL)isLast;

+ (NSString *)getStringFormDate:(NSDate *)date;

+ (NSDate * )getLastDateFormString:(NSString *)lastMonthStr;

+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;
@end
