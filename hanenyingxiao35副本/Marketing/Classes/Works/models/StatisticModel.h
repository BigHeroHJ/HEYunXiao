//
//  StatisticModel.h
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/2.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatisticModel : NSObject
@property (nonatomic, strong) NSString * logo;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) int signID;
@property (nonatomic, strong) NSString * remark;
@property (nonatomic, strong) NSString * addtime;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *lon;
@property (nonatomic, strong)NSString*img;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, assign) int type;
@end
