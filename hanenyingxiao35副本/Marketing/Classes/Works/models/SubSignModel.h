//
//  SubSignModel.h
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/7.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "BaseController.h"

@interface SubSignModel : BaseController
@property (nonatomic, strong) NSString * company;
@property (nonatomic, strong) NSString * remark;
@property (nonatomic, strong) NSString * img;
@property (nonatomic, strong) NSString * signId;
@property (nonatomic, strong) NSString * addtime;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, assign) int type;
//@property (nonatomic, assign) BOOL type;
@end
