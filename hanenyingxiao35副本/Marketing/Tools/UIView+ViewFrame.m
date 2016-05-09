//
//  UIView+ViewFrame.m
//  08-屏幕适配
//
//  Created by MS on 15-9-23.
//  Copyright (c) 2015年 XiaoBing. All rights reserved.
//

#import "UIView+ViewFrame.h"
#define IWScale [UIScreen mainScreen].bounds.size.width/320.0f
#define IHScale [UIScreen mainScreen].bounds.size.height/568.0f

@implementation UIView (ViewFrame)

//以5s为基准
+(CGRect)getRectWithX:(CGFloat)x Y:(CGFloat)y width:(CGFloat)width andHeight:(CGFloat)height
{
    return CGRectMake(IWScale * x, IHScale * y, IWScale * width, IWScale * height);
}

+ (CGRect)getSizeWithX:(CGFloat)x Y:(CGFloat)y width:(CGFloat)width andHeight:(CGFloat)height
{
    return CGRectMake(x, y, IWScale * width, IWScale * height);
}

+ (CGFloat)getWidth:(CGFloat)width
{
    return IWScale * width;
}

+ (CGFloat)getHeight:(CGFloat)height
{
    return IHScale * height;
}

+ (UIFont *)getFontWithSize:(CGFloat)size
{
    return [UIFont systemFontOfSize:IWScale * size];
}

+ (UIFont *)getFontWithFontName:(NSString *)fontName Size:(CGFloat)size
{
    return  [UIFont fontWithName:fontName size:IWScale * size];
}
@end
