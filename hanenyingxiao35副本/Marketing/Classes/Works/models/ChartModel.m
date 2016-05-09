//
//  ChartModel.m
//  Marketing
//
//  Created by User on 16/3/11.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "ChartModel.h"

@implementation ChartModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _visitMonthAvg = [dic objectForKey:@"visitMonthAvg"];
        _visitYesterdayAvg = [dic objectForKey:@"visitYesterdayAvg"];
        _yestVisitCount = [dic objectForKey:@"yestVisitCount"] ;
        _allCustCount = [dic objectForKey:@"allCustCount"];
        _custYesterDayCount = [dic objectForKey:@"custYesterDayCount"] ;
        _custMonthCount = [dic objectForKey:@"custMonthCount"] ;
                
    }
    return self;
    
    
}


@end
