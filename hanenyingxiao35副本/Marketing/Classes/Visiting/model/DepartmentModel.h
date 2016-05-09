//
//  DepartmentModel.h
//  Marketing
//
//  Created by wmm on 16/3/9.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DepartmentModel : NSObject

@property (nonatomic, assign) int departId;//部门ID
@property (nonatomic, strong) NSString *dname;//部门名称
@property (nonatomic, strong) NSString *img;//部门图标
@property (nonatomic, assign) int uid;//部门创建人id
@property (nonatomic, assign) int muid;//部门负责人id
@property (nonatomic, strong) NSString *muidname;//部门负责人名称
@property (nonatomic, strong) NSString *ids;
@end
