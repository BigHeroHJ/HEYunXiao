//
//  RecordModel.h
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/2.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordModel : NSObject
@property (nonatomic, strong) NSString * logo;
@property (nonatomic, assign) int recordId;
@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSString * topic;
@property (nonatomic, strong) NSString * addtime;//检查接口参数类型
//管理员查看日志的时候需要显示员工的名字 其他显示信息和普通员工一样
@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* name;
@end
