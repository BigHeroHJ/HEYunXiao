//
//  ToolButton.m
//  Marketing
//
//  Created by HanenDev on 16/3/2.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "ToolButton.h"

#define labelRatdio 0.3

@implementation ToolButton

#pragma mark 设置button内部的image的范围

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageW = contentRect.size.width - 20;
    CGRect imageRect = CGRectMake( 10 , 0 , imageW, contentRect.size.height * (1 - labelRatdio));
    return imageRect;
    
}

#pragma mark 设置button内部的title的范围

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    CGRect titleRect = CGRectMake(0, contentRect.size.height - contentRect.size.height * labelRatdio , contentRect.size.width, contentRect.size.height * labelRatdio);
    return titleRect;
}


@end
