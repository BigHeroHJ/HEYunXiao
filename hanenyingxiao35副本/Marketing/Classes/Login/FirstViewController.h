//
//  FirstViewController.h
//  移动营销
//
//  Created by wmm on 16/2/24.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@class LoginViewController;

@interface FirstViewController : UIViewController <UIApplicationDelegate>
@property (nonatomic, strong) LoginViewController * loginViewController;
@end
