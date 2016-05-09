//
//  AppDelegate.h
//  Marketing
//
//  Created by Hanen 3G 01 on 16/2/24.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyTabBarController;

@class MyNavigationController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property float autoSizeScaleX;
@property float autoSizeScaleY;
@property (strong, nonatomic) MyTabBarController * tabbarControl;
@property (strong, nonatomic) MyNavigationController *mainNavController;
@end

