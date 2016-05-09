//
//  ManagerNoticeBtnView.m
//  Marketing
//
//  Created by Hanen 3G 01 on 16/2/26.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "ManagerNoticeBtnView.h"


@implementation ManagerNoticeBtnView
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubviews];
//        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)addSubviews
{
    CGFloat btnw = self.width/ 2.0 - [UIView getWidth:10]* 2;
    CGFloat btnSpace = [UIView getWidth:5.0f];
    self.otherNotice =[UIButton buttonWithType:UIButtonTypeSystem];
    self.otherNotice.frame = CGRectMake(self.width / 2.0 - btnw - btnSpace,0,btnw,44);
    //self.specialPerformance.backgroundColor = [UIColor cyanColor];
//    [self.otherNotice setTitle:self.leftTitle forState: UIControlStateNormal];
    [self.otherNotice setTitleColor:darkOrangeColor forState:UIControlStateNormal];
    [self.otherNotice addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.otherNotice.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    self.otherNotice.tag = 122;
    [self addSubview:self.otherNotice];
    
    self.redLine1 = [[UILabel alloc]init];
    self.redLine1.frame = CGRectMake(0, 41, CGRectGetWidth(self.otherNotice.frame), 3);
    self.redLine1.backgroundColor = darkOrangeColor;
    [self.otherNotice addSubview:self.redLine1];
    
    self.myNotice = [UIButton buttonWithType:UIButtonTypeSystem];
    self.myNotice.frame = CGRectMake(self.width / 2.0 + btnSpace, 0, self.otherNotice.width, 44);
    self.myNotice.titleLabel.font = [UIFont systemFontOfSize:17.0f];
//    [self.myNotice setTitle:self.rightTitle forState: UIControlStateNormal];
    [self.myNotice setTitleColor:blackFontColor forState:UIControlStateNormal];
    [self.myNotice addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.myNotice.tag = 123;
    //self.priceSpecialPerformance.backgroundColor = [UIColor cyanColor];
    [self addSubview:self.myNotice];
    
    self.redLine2 = [[UILabel alloc]init];
    self.redLine2.frame = CGRectMake(0, 41, KSCreenW/4-6, 3);
//    self.line2.backgroundColor = TabbarColor;
    [self.myNotice addSubview:self.redLine2];
    
}

//不能放到添加视图里面 添加self.leftTitle 因为那时候都没有。
- (void)setLeftTitle:(NSString *)leftTitle
{
    _leftTitle = leftTitle;
   
          [self.otherNotice setTitle:self.leftTitle forState: UIControlStateNormal];
}

- (void)setRightTitle:(NSString *)rightTitle
{
    _rightTitle = rightTitle;
    
    [self.myNotice setTitle:self.rightTitle forState: UIControlStateNormal];
}

- (void)setLeftAttributeStr:(NSAttributedString *)leftAttributeStr
{
    _leftAttributeStr = leftAttributeStr;
    [self.otherNotice setAttributedTitle:leftAttributeStr forState:UIControlStateNormal];
}

- (void)setRightAttributeStr:(NSAttributedString *)rightAttributeStr
{
    _rightAttributeStr = rightAttributeStr;
    [self.myNotice setAttributedTitle:rightAttributeStr forState:UIControlStateNormal];
}


-(void)btnAction:(UIButton *)sender{
    

    if (self.delegate && [self.delegate respondsToSelector:@selector(changeNoticeView:)]) {
        
        [self.delegate changeNoticeView:sender.tag];
    }
    
}
@end
