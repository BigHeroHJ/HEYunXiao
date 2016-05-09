//
//  MineViewController.h
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
//  Created by Hanen 3G 01 on 16/2/23.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "BaseController.h"

@interface MineViewController : BaseController

@property(nonatomic,strong)UIButton    *headerBtn;
@property(nonatomic,strong)UIButton    *qrBtn;
@property(nonatomic,strong)UILabel     *nameLabel;
@property(nonatomic,strong)UILabel     *phoneLabel;
@property(nonatomic,strong)UITableView *tableView;

@end
