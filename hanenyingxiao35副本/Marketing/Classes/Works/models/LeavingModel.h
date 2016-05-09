//
//  LeavingModel.h
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/8.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//
//管理员的审批 和请假列表 用的同一个model
#import <Foundation/Foundation.h>

@interface LeavingModel : NSObject
@property (nonatomic, strong) NSString * logo;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) int  leavingID;
@property (nonatomic, assign) int lstatus;
@property (nonatomic, strong) NSString *addtime;

@property (nonatomic,strong )NSString *mname;
@end
