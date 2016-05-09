//
//  MyClientView.h
//  Marketing
//
//  Created by HanenDev on 16/3/1.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyClientViewDelegate <NSObject>

- (void)changeNoticeView:(NSInteger)tag;

@end

@interface MyClientView : UIView

@property (nonatomic, strong) UIButton *otherClient;
@property (nonatomic, strong) UIView   *redLine1;
@property (nonatomic, strong) UIButton *myClient;
@property (nonatomic, strong) UIView   *redLine2;
@property (nonatomic, weak) id <MyClientViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame withLeftTitle:(NSString *)leftTitle andRightTitle:(NSString *)rightTitle;
@end
