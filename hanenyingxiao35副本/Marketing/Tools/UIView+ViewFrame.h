//
//  UIView+ViewFrame.h
//  08-屏幕适配
//
//  Created by MS on 15-9-23.
//  Copyright (c) 2015年 XiaoBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ViewFrame)

+ (CGRect)getRectWithX:(CGFloat)x Y:(CGFloat)y width:(CGFloat)width andHeight:(CGFloat)height;
+ (CGRect)getSizeWithX:(CGFloat)x Y:(CGFloat)y width:(CGFloat)width andHeight:(CGFloat)height;

+ (CGFloat)getWidth:(CGFloat)width;
+ (CGFloat)getHeight:(CGFloat)height;

//字体适配
+ (UIFont *)getFontWithSize:(CGFloat)size ;

+ (UIFont *)getFontWithFontName: (NSString *)fontName Size:(CGFloat)size;
@end
