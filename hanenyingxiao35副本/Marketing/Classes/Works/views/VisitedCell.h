//
//  VisitedCell.h
//  Marketing
//
//  Created by Hanen 3G 01 on 16/2/26.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SubSignModel;
@interface VisitedCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableview;

+ (CGFloat)cellHeight;

@property (nonatomic, strong) SubSignModel *model;
@end
