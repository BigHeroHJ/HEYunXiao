//
//  VisitDetailViewController.h
//  Marketing
//
//  Created by wmm on 16/3/4.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VisitDetailViewController : UIViewController<UITextViewDelegate>

@property(nonatomic,assign) int visitId;
@property(nonatomic,assign) BOOL canChangeText;

@property(nonatomic,assign)int clilkID;
@end
