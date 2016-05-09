//
//  NoticeCell.h
//  移动营销
//    ___________   __________          __
//   / _________/  / ________/         /  \
//  / /           | |                 / /\ \
//  | |           | |      ____      / /  \ \
//  | |           | |     /__  |    / /____\ \
//  | |           | |        | |   / /______\ \
//  |  \_________ |  \_______| |  / /        \ \
//   \__________/  \___________| /_/          \_\
//
//  Created by Hanen 3G 01 on 16/2/24.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NoticeModel;

@interface NoticeCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;


+ (CGFloat)cellHeight;

@property (nonatomic, strong) NoticeModel * model;
@property (nonatomic, strong) UILabel *redLable;

@property (nonatomic, assign) BOOL ismanager;

@end
