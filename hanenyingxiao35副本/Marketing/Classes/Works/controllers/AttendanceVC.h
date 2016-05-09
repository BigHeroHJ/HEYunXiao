//
//  AttendanceVC.h
//  Marketing
//
//  Created by User on 16/3/13.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"
@interface AttendanceVC : UIViewController<UITableViewDataSource,UITableViewDelegate,JTCalendarDataSource>

@property (strong, nonatomic) JTCalendarMenuView *calendarMenuView;
@property (strong, nonatomic) JTCalendarContentView *calendarContentView;

@property (strong, nonatomic) NSLayoutConstraint *calendarContentViewHeight;

@property (strong, nonatomic) JTCalendar *calendar;

@end
