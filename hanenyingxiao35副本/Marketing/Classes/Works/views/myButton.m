//
//  myButton.m
//  移动营销
//
//  Created by Hanen 3G 01 on 16/2/24.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "myButton.h"

#define labelRatdio 0.4//button按钮中文字占得高度

@implementation myButton


#pragma mark 设置button内部的image的范围

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageW = [UIView getWidth:15];
    CGFloat H = [UIView getWidth:15];
    CGRect imageRect = CGRectMake( contentRect.size.width / 2.0f - imageW - 5, TabbarH - 2 * H , imageW, H);
    return imageRect;
    
}

#pragma mark 设置button内部的title的范围

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleW = [UIView getWidth:80];
    CGFloat titleH = [UIView getWidth:15];
    CGRect titleRect = CGRectMake( contentRect.size.width / 2.0f + 5 ,  TabbarH - 2*titleH, titleW, titleH);
    return titleRect;
}
@end
