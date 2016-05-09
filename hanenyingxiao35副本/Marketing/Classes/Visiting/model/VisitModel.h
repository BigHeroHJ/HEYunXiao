//
//  VisitModel.h
//  Marketing
//
//  Created by wmm on 16/3/6.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VisitModel : NSObject

@property (nonatomic, assign) int visitId;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *cname;
@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *ordertime;
@property (nonatomic, strong) NSString *visittime;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *visittype;
@property (nonatomic, strong) NSString *lon;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, assign) int cid;

@end
