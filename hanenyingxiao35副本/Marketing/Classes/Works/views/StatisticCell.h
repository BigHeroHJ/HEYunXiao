//
//  StatisticCell.h
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/1.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StatisticModel;

@interface StatisticCell : UITableViewCell

@property (nonatomic, strong) StatisticModel * model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;
@end
