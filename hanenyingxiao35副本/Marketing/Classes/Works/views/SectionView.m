//
//  SectionView.m
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/31.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "SectionView.h"

@implementation SectionView

- (id)initWithFrame:(CGRect)frame withIndex:(NSInteger)index
{
    if (self == [super initWithFrame:frame]) {
        [self addSubviewsWithIndex:index];
        
//        self.backgroundColor = [UIColor redColor];
    }
    return self;
}
- (void)addSubviewsWithIndex:(NSInteger)index
{
    _visit = [[UILabel alloc] initWithFrame:CGRectMake1(15, 5, 130, 15)];
    //        _visit.backgroundColor = [UIColor redColor];
    _reportOne = [[UILabel alloc] initWithFrame:CGRectMake1(15, 25, 80, 15)];
    //         _reportOne.backgroundColor = [UIColor redColor];
    _reportOne.textColor = grayFontColor;
    [_reportOne setFont:[UIView getFontWithSize:12.0]];
    
    _reportOneNum = [[UILabel alloc] initWithFrame:CGRectMake1(95, 25, 30, 15)];
    //        _reportOneNum.backgroundColor = darkOrangeColor;
    _reportOneNum.textColor = grayFontColor;
    [_reportOneNum setFont:[UIView getFontWithSize:12.0]];
    
    _reportTwo = [[UILabel alloc] initWithFrame:CGRectMake1(15, 45, 80, 15)];
    //        _reportTwo.backgroundColor = cyanFontColor;
    _reportTwo.textColor = grayFontColor;
    
    [_reportTwo setFont:[UIView getFontWithSize:12.0]];
    _reportTwoNum = [[UILabel alloc] initWithFrame:CGRectMake1(95, 45, 50, 15)];
    //        _reportTwoNum.backgroundColor = cyanFontColor;
    _reportTwoNum.textColor = grayFontColor;
    _reportTwoNum.font = [UIView getFontWithSize:12.0];
    
    _Num = [[UILabel alloc] initWithFrame:CGRectMake(KSCreenW - 15 - 100, [UIView getWidth:15.0f], 80.0f, 25.0f)];//30 是这个之前设定的左右空隙........唉
    _Num.textAlignment = NSTextAlignmentRight;
    _Num.font = [UIView getFontWithSize:25.0f];
    
    _arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(_Num.maxX, _Num.y, 15, _Num.height)];
    self.arrowView.image = [UIImage imageNamed:@"箭头"];
    [self addSubview:_arrowView];
    
    //        _Num.backgroundColor = [UIColor blueColor];
    _NumBottom = [[UILabel alloc] initWithFrame:CGRectMake(KSCreenW - 15 - 100, [UIView getWidth:40.0], 100, 15)];
    _NumBottom.textAlignment = NSTextAlignmentRight;
    _NumBottom.textColor = grayFontColor;
    //        _NumBottom.backgroundColor = cyanFontColor;
    [_NumBottom setFont:[UIView getFontWithSize:12]];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake([UIView getWidth:15], _reportTwoNum.maxY + 5, KSCreenW - 2 * [UIView getWidth:15], 1)];
    lineV.backgroundColor = grayLineColor;
    
    _btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
 
    [_btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _btn.tag = 51 + index;
    NSLog(@"按钮的tag值%d",_btn.tag);
    _btn.selected = NO;
    
    [self addSubview:_visit];
    [self addSubview:_reportOne];
    [self addSubview:_reportOneNum];
    [self addSubview:_reportTwo];
    [self addSubview:_reportTwoNum];
    [self addSubview:_Num];
    [self addSubview:_NumBottom];
    [self addSubview:lineV];
    [self addSubview:_btn];
}

- (void)clickBtn:(UIButton * )btn
{
    if ([self.delegate respondsToSelector:@selector(addBtnwithIndex:)]) {
        [self.delegate addBtnwithIndex:btn];
    }
}
- (void)setIsUp:(int)isUp
{
    _isUp = isUp;
    if (isUp == 1) {
        CGAffineTransform transfrom =  CGAffineTransformMakeRotation(M_PI);
        self.arrowView.transform = transfrom;
    }
}
CG_INLINE CGRect
CGRectMake1(CGFloat x,CGFloat y,CGFloat width,CGFloat height)
{
    //创建appDelegate 在这不会产生类的对象,(不存在引起循环引用的问题)
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    //计算返回
    return CGRectMake(x * app.autoSizeScaleX, y * app.autoSizeScaleY, width * app.autoSizeScaleX, height * app.autoSizeScaleY);
}
@end
