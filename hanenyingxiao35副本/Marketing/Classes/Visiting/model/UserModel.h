//
//  UserModel.h
//  Marketing
//
//  Created by wmm on 16/3/9.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, assign) int uid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *name;//1：普通2：管理员
@property (nonatomic, assign) int type;
@property (nonatomic, assign) int department;
@property (nonatomic, strong) NSString *departmentName;
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *positionname;
@property (nonatomic, assign) int position;

@end
