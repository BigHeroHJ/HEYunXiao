//
//  SelectClientViewController.h
//  Marketing
//
//  Created by wmm on 16/3/6.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectClientViewDelegate <NSObject>

- (void)selectClient:(int)tag withName:(NSString *)companyName withCname:(NSString *)cName withAddress:(NSString *)address;

@end

@interface SelectClientViewController : UIViewController

@property (nonatomic, weak) id <SelectClientViewDelegate>delegate;

@end
