//
//  TabBarButton.m
//  CSR
//
//  Created by Hanen 3G 01 on 16/2/15.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "TabBarButton.h"
#define labelRatdio 0.28//button按钮中文字占得高度

@interface TabBarButton ()
{
    CGFloat  h;
    CGFloat  y;
    CGFloat ImageW;
    CGRect   Rect;
}
@end
@implementation TabBarButton


#pragma mark 设置button内部的image的范围
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        self.titleLabel.center.x = self.width / 2.0f;
//        self.imageView.center.x = self.width / 2.0f;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    if(KSCreenW == 320){ //4s 5 5s
        h = 0;
        y = 0;
        ImageW = 35;
        
    }else if (KSCreenH == 736){//6p
        ImageW = 41;
        h = [UIView getHeight:3];
        y = [UIView getHeight:1];
    }
    else{//6 6s
        ImageW = 38;
        h = [UIView getHeight:4];
        y = [UIView getHeight:4];
    }
    
    CGRect imageRect;
    if (self.isTwo) {
//        CGFloat imageW = contentRect.size.width - [UIView getWidth: 38];
       imageRect  = CGRectMake( contentRect.size.width / 2.0f - ImageW / 2.0f + 3 , 0 , ImageW, ImageW);
    }else{
//        CGFloat imageW = contentRect.size.width - [UIView getWidth: 38];
     imageRect = CGRectMake( contentRect.size.width / 2.0f - ImageW / 2.0f , 0 , ImageW, ImageW);
    }
    
//    NSLog(@"tabbarBtn imageRect ,%f,%f",h,y);
    return imageRect;
    
}

#pragma mark 设置button内部的title的范围

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
   
    CGRect titleRect = CGRectMake(0,ImageW - y, contentRect.size.width, TabbarH - ImageW);
   
//        NSLog(@"tabbarBtn titleRect %@",NSStringFromCGRect(titleRect)); contentRect.size.height - contentRect.size.height * labelRatdio + y, contentRect.size.width
    return titleRect;
}
- (void)setHighlighted:(BOOL)highlighted{
    //    [super setHighlighted:highlighted];
}
@end
