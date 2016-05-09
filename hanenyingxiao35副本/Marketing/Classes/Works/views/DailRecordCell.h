//
//  DailRecordCell.h
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/1.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecordModel;

@interface DailRecordCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

@property (nonatomic, strong) RecordModel * model;
@end
