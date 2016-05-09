//
//  MyClientButton.m
//  Marketing
//
//  Created by HanenDev on 16/3/1.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "MyClientButton.h"

@implementation MyClientButton

#pragma mark - 设置按钮内部图片和文字的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat W = [UIView getWidth:10] ;
    CGFloat H = (contentRect.size.height /2.0f -W/2.0f + 5 / 2.0f);
    
    return CGRectMake(self.titleLabel.maxX + 5 , H, W , W - 5);
    
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat W = contentRect.size.width - 20.0f;
    CGFloat H = contentRect.size.height;
    return CGRectMake(5, 0, W, H);
    
}


@end
