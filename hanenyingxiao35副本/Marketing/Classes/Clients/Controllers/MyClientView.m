//
//  MyClientView.m
//  Marketing
//
//  Created by HanenDev on 16/3/1.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "MyClientView.h"

@implementation MyClientView

- (id)initWithFrame:(CGRect)frame withLeftTitle:(NSString *)leftTitle andRightTitle:(NSString *)rightTitle
{
    if (self = [super initWithFrame:frame]) {
        [self addSubviews:leftTitle andRightTitle:rightTitle];
        //        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)addSubviews:(NSString *)leftTitle andRightTitle:(NSString *)rightTitle
{
    CGFloat btnw = self.width/ 2.0 - [UIView getWidth:10]* 2;
    CGFloat btnSpace = [UIView getWidth:5.0f];
    self.otherClient =[UIButton buttonWithType:UIButtonTypeSystem];
    self.otherClient.frame = CGRectMake(self.width / 2.0 - btnw - btnSpace,0,btnw,44);
    //self.specialPerformance.backgroundColor = [UIColor cyanColor];
    if(leftTitle == nil | leftTitle.length == 0){
        [self.otherClient setTitle:@"下属客户" forState: UIControlStateNormal];
    }else{
        [self.otherClient setTitle:leftTitle forState: UIControlStateNormal];
    }
    [self.otherClient setTitleColor:blackFontColor forState:UIControlStateNormal];
    self.otherClient.titleLabel.font = [UIFont systemFontOfSize:17.0f];
//    [UIView getFontWithSize:15.0f];

    [self.otherClient addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.otherClient.tag = 1111;
    [self addSubview:self.otherClient];
    
    self.redLine1 = [[UILabel alloc]init];
    self.redLine1.frame = CGRectMake(0, 40, CGRectGetWidth(self.otherClient.frame), 3);
    //self.redLine1.backgroundColor = darkOrangeColor;
    [self.otherClient addSubview:self.redLine1];
    
    self.myClient = [UIButton buttonWithType:UIButtonTypeSystem];
    self.myClient.frame = CGRectMake(self.width / 2.0 + btnSpace, 0, self.otherClient.width, 44);
    if(rightTitle == nil | rightTitle.length == 0){
        [self.myClient setTitle:@"我的客户" forState: UIControlStateNormal];
    }else{
        [self.myClient setTitle:rightTitle forState: UIControlStateNormal];
    }
    self.myClient.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [self.myClient setTitleColor:darkOrangeColor forState:UIControlStateNormal];
    [self.myClient addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.myClient.tag = 2222;
    //self.priceSpecialPerformance.backgroundColor = [UIColor cyanColor];
    [self addSubview:self.myClient];
    
    self.redLine2 = [[UILabel alloc]init];
    self.redLine2.frame = CGRectMake(0, 40, KSCreenW/4-6, 3);
    self.redLine2.backgroundColor = darkOrangeColor;
    [self.myClient addSubview:self.redLine2];
    
}


-(void)setTitle:(NSString *)leftTile{

    
}

-(void)btnAction:(UIButton *)sender{
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeNoticeView:)]) {
        
        [self.delegate changeNoticeView:sender.tag];
    }
    
}

@end
