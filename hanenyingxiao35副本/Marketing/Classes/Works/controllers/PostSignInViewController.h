//
//  PostSignInViewController.h
//  Marketing
//    ___________   __________          __
//   / _________/  / ________/         /  \
//  / /           | |                 / /\ \
//  | |           | |      ____      / /  \ \
//  | |           | |     /__  |    / /____\ \
//  | |           | |        | |   / /______\ \
//  |  \_________ |  \_______| |  / /        \ \
//   \__________/  \___________| /_/          \_\
//
//  Created by Hanen 3G 01 on 16/2/25.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "BaseController.h"

@interface PostSignInViewController : BaseController
@property (nonatomic, strong) NSString * currentTime;
@property (nonatomic, strong) NSString * currentPlace;
@property (nonatomic, assign) int   signType;//签到还是签退

@property (nonatomic, strong) NSString *longt;
@property (nonatomic, strong) NSString *lati;

@end
