//
//  ApproSubVIew.h
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/3.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    postAppro = 0,//发出请假的一类
    approLeaving//审批请假的一类
    
}approType;


@interface ApproSubVIew : UIView
@property (nonatomic, assign) int approvalState;//已审批的请假详情
@property (nonatomic, strong) UIImageView *approvalStateImage;
@property (nonatomic, strong) NSString * stateImageName;
@property (nonatomic, strong) NSString * leavingPersonLogo;//请假人的头像
@property (nonatomic, strong) NSString * handleLeavingLogo;//审批人的头像
@property (nonatomic, assign) approType apptype;

@property (nonatomic, strong) NSString * nameString;

@property (nonatomic, strong) NSString * postApproName;//请假人的名字
@property (nonatomic, strong) NSString * approLevingname;//审批人的名字
@end
