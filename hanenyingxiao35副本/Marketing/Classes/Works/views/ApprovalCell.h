//
//  ApprovalCell.h
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/3.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LeavingModel;

@interface ApprovalCell : UITableViewCell

@property (nonatomic, assign) BOOL isWaitingApproval;//待审批
@property (nonatomic, strong) LeavingModel * model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


+ (CGFloat)cellHeight;

@end
