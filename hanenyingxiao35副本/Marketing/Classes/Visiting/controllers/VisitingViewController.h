//
//  VisitingViewController.h
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
#import "JTCalendar.h"

@interface VisitingViewController : BaseController<UITableViewDataSource,UITableViewDelegate,JTCalendarDataSource>

@property (strong, nonatomic) JTCalendarMenuView *calendarMenuView;
@property (strong, nonatomic) JTCalendarContentView *calendarContentView;

@property (strong, nonatomic) NSLayoutConstraint *calendarContentViewHeight;

@property (strong, nonatomic) JTCalendar *calendar;

@end
