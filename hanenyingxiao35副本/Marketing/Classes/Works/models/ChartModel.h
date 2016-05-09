//
//  ChartModel.h
//  Marketing
//
//  Created by User on 16/3/11.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@property (copy)NSString *visitMonthAvg;
@property (copy)NSString *visitYesterdayAvg;
@property (copy)NSString *yestVisitCount;
@property (copy)NSString *allCustCount;
@property (copy)NSString *custYesterDayCount;
@property (copy)NSString *custMonthCount;
//@property (copy)NSString *NumBottom;

@end
