//
//  SginDetailViewController.h
//  Marketing
//
//  Created by Hanen 3G 01 on 16/4/7.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SginDetailViewController : UIViewController
@property (nonatomic, assign) int   signType;//签到还是签退
@property (nonatomic, strong) NSString * addTime;
@property (nonatomic, strong) NSString * remarkSign;
@property (nonatomic, strong) NSString * currentPlace;
@property (nonatomic, strong) NSString * signImage;
@property (nonatomic, strong) NSString * company;
@property (nonatomic, strong) NSString *name;
@end
