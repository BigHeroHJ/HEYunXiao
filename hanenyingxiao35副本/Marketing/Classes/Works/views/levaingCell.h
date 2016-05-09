//
//  levaingCell.h
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/13.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LeavingModel;
@interface levaingCell : UITableViewCell
@property (nonatomic, strong) LeavingModel * model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


+ (CGFloat)cellHeight;
@end
