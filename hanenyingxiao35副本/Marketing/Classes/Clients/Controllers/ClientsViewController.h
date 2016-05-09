//
//  ClientsViewController.h
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
#import "MapClientViewController.h"

@protocol ClientLocationDelegate <NSObject>

- (void)getLocationOnMap:(NSString *)string;

@end

@interface ClientsViewController : BaseController

@property(nonatomic,weak)id<ClientLocationDelegate>delegate;

@end
