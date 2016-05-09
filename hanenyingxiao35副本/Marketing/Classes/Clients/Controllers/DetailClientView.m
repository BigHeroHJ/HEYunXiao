//
//  DetailClientView.m
//  Marketing
//
//  Created by HanenDev on 16/3/1.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "DetailClientView.h"

@implementation DetailClientView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubviews];
        self.backgroundColor = graySectionColor;
    }
    return self;
}
- (void)addSubviews{
    self.detailBtn = [[ToolButton alloc]initWithFrame:CGRectMake((self.width/2 - [UIView getWidth:40])/2, [UIView getHeight:5], [UIView getWidth:40], [UIView getHeight:40])];
    //[self.detailBtn setImage:[UIImage imageNamed:@"客户详情"] forState:UIControlStateNormal];
    [self.detailBtn setImage:[UIImage imageNamed:@"客户详情 enter"] forState:UIControlStateNormal];
    [self.detailBtn setTitle:@"客户详情" forState:UIControlStateNormal];
    [self.detailBtn setTitleColor:blackFontColor forState:UIControlStateNormal];
    self.detailBtn.isSelected = YES;
    //[self.detailBtn setTitleColor:lightGrayFontColor forState:UIControlStateNormal];
    self.detailBtn.titleLabel.font = [UIView getFontWithSize:10];
    [self.detailBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.detailBtn.tag =1111;
    [self addSubview:self.detailBtn];
    
    self.visitBtn = [[ToolButton alloc]initWithFrame:CGRectMake(self.width/2 + (self.width/2 - [UIView getWidth:40])/2, [UIView getHeight:5], [UIView getWidth:40], [UIView getHeight:40])];
    [self.visitBtn setImage:[UIImage imageNamed:@"拜访历史"] forState:UIControlStateNormal];
    //[self.visitBtn setImage:[UIImage imageNamed:@"拜访历史 enter"] forState:UIControlStateSelected];
    [self.visitBtn setTitle:@"拜访历史" forState:UIControlStateNormal];
    [self.visitBtn setTitleColor:lightGrayFontColor forState:UIControlStateNormal];
    self.visitBtn.isSelected = NO;
    //[self.visitBtn setTitleColor:blackFontColor forState:UIControlStateNormal];
    self.visitBtn.titleLabel.font = [UIView getFontWithSize:10];
    [self.visitBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.visitBtn.tag =2222;
    [self addSubview:self.visitBtn];
}
- (void)btnClick:(ToolButton *)btn{
    if ([self.delegate respondsToSelector:@selector(changeDetailClientView:)]) {
        [self.delegate changeDetailClientView:btn.tag];
    }
}

@end
