//
//  ApprovalDetailController.h
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/3.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "BaseController.h"

@interface ApprovalDetailController : BaseController

@property (nonatomic, assign) int approID;
@property (nonatomic, assign) BOOL lstatus;//看看已审批还是未审批 0 为未审批 1 为已审批
@property (nonatomic, strong ) NSString *leavingPersonName;
@property (nonatomic, strong ) NSString *leavingPersonLogo;
@end
