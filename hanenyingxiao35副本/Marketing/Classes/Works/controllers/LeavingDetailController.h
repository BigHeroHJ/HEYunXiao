//
//  LeavingDetailController.h
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/4.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "BaseController.h"

@interface LeavingDetailController : BaseController

@property (nonatomic, assign)  int leaveID;

@property (nonatomic, strong) NSString *manLogo;
@property (nonatomic, strong) NSString *manName;

@property (nonatomic, assign) int lstatusType;

@end
