//
//  AttendContentVC.h
//  Marketing
//
//  Created by User on 16/3/13.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendContentVC : UIViewController

@property (nonatomic, assign) int workId;//那个人的id
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *addTime;//签到的时间

@end
