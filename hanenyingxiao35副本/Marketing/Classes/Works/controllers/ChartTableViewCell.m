//
//  ChartTableViewCell.m
//  Marketing
//
//  Created by User on 16/3/11.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "ChartTableViewCell.h"
#import "AppDelegate.h"


@implementation ChartTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
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
//        _reportTwo.backgroundColor = blueFontColor;
        _reportTwo.textColor = grayFontColor;
        
       [_reportTwo setFont:[UIView getFontWithSize:12.0]];
        _reportTwoNum = [[UILabel alloc] initWithFrame:CGRectMake1(95, 45, 50, 15)];
//        _reportTwoNum.backgroundColor = blueFontColor;
        _reportTwoNum.textColor = grayFontColor;
        _reportTwoNum.font = [UIView getFontWithSize:12.0];
        
        _Num = [[UILabel alloc] initWithFrame:CGRectMake(KSCreenW - 15 - 100, [UIView getWidth:15.0f], 80.0f, 25.0f)];//30 是这个之前设定的左右空隙........唉
        _Num.textAlignment = NSTextAlignmentRight;
        _Num.font = [UIView getFontWithSize:25.0f];
  
        _arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(_Num.maxX, _Num.y, 15, _Num.height)];
        self.arrowView.image = [UIImage imageNamed:@"箭头"];
        [self.contentView addSubview:_arrowView];
        
//        _Num.backgroundColor = [UIColor blueColor];
        _NumBottom = [[UILabel alloc] initWithFrame:CGRectMake(KSCreenW - 15 - 100, [UIView getWidth:40.0], 100, 15)];
        _NumBottom.textAlignment = NSTextAlignmentRight;
        _NumBottom.textColor = grayFontColor;
//        _NumBottom.backgroundColor = blueFontColor;
        [_NumBottom setFont:[UIView getFontWithSize:12]];
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake([UIView getWidth:20], _reportTwoNum.maxY + [UIView getWidth:5], KSCreenW - 2 * [UIView getWidth:15], 1)];
        lineV.backgroundColor = grayLineColor;
       
        
         [self.contentView addSubview:_visit];
         [self.contentView addSubview:_reportOne];
         [self.contentView addSubview:_reportOneNum];
         [self.contentView addSubview:_reportTwo];
         [self.contentView addSubview:_reportTwoNum];
         [self.contentView addSubview:_Num];
         [self.contentView addSubview:_NumBottom];
         [self.contentView addSubview:lineV];
    }
    return self;
}
- (void)setIsUp:(BOOL)isUp
{
    _isUp = isUp;
    if (isUp == YES) {
        CGAffineTransform transfrom =  CGAffineTransformMakeRotation(M_PI);
        self.arrowView.transform = transfrom;
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
