//
//  ViewTool.m
//  移动营销
//
//  Created by Hanen 3G 01 on 16/2/24.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "ViewTool.h"
#import "UIView+ViewFrame.h"

@implementation ViewTool

+ (void)setLableFont14:(UILabel *)label{
    
    if(KSCreenH>568){
        label.font = [UIFont systemFontOfSize:15.0f];
    }else{
        label.font = [UIFont systemFontOfSize:14.0f];
    }
//    label.textColor = blackFontColor;
}
+ (void)setLableFont13:(UILabel *)label{
    if(KSCreenH>568){
        label.font = [UIFont systemFontOfSize:14.0f];
    }else{
        label.font = [UIFont systemFontOfSize:13.0f];
    }
}
+ (void)setLableFont12:(UILabel *)label{
    if(KSCreenH>568){
        label.font = [UIFont systemFontOfSize:13.0f];
    }else{
        label.font = [UIFont systemFontOfSize:12.0f];
    }
}
+ (void)setLableFont11:(UILabel *)label{
    label.font = [UIFont systemFontOfSize:11.0f];
}
+ (void)setTFPlaceholderFont14:(UITextField *)field{
    
    if(KSCreenH>568){
        field.font = [UIFont systemFontOfSize:15.0f];
        [field setValue:[UIFont systemFontOfSize:15.0f] forKeyPath:@"_placeholderLabel.font"];
    }else{
        field.font = [UIFont systemFontOfSize:14.0f];
        [field setValue:[UIFont systemFontOfSize:14.0f] forKeyPath:@"_placeholderLabel.font"];
    }
}
+ (void)setTextViewFont14:(UITextView *)textView{
    
    if(KSCreenH>568){
        textView.font = [UIFont systemFontOfSize:15.0f];
    }else{
        textView.font = [UIFont systemFontOfSize:14.0f];
    }
    //    label.textColor = blackFontColor;
}

+ (UIFont *)getFont14{
    
    if(KSCreenH>568){
        return [UIFont systemFontOfSize:15.0f];
    }else{
        return [UIFont systemFontOfSize:14.0f];
    }
    //    label.textColor = blackFontColor;
}

+(UIView *)getLineViewWith:(CGRect)frame withBackgroudColor:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}

+ (UILabel *)getLabelWith:(CGRect)frame WithTitle:(NSString *)title WithFontSize:(CGFloat)fontSize WithTitleColor:(UIColor *)color WithTextAlignment:(NSTextAlignment )textAlignment
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.textColor = color;
    label.textAlignment = textAlignment;
//    label.font = [UIView getFontWithSize:fontSize];
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
    
}
+ (UILabel *)getLabelWithFrame:(CGRect)frame WithAttrbuteString:(NSMutableAttributedString *)attrbuteTitle
{
    UILabel *attrbuteLabel = [[UILabel alloc] initWithFrame:frame];
    attrbuteLabel.attributedText = attrbuteTitle;
    return attrbuteLabel;
}

+ (UIBarButtonItem *)getBarButtonItemWithTarget:(id)target WithAction:(SEL)action
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIView getWidth:15], [UIView getWidth:15])];
    [btn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

+ (UIBarButtonItem *)getBarButtonItemWithTarget:(id)target WithString:(NSString *)string WithAction:(SEL)action{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIView getWidth:15], [UIView getWidth:15])];
    [btn setBackgroundImage:[UIImage imageNamed:string] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:string] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

+ (UIImage *)getImageFromColor:(UIColor *)color WithRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}
+ (UILabel *)getNavigitionTitleLabel:(NSString *)title
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    label.textAlignment  = NSTextAlignmentCenter;
    label.text = title;
    label.font = [UIFont systemFontOfSize:17.0f];
    label.textColor  = blackFontColor;
    return label;
}



@end
