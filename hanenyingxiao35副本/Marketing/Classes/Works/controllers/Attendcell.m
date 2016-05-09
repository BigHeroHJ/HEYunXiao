//
//  Attendcell.m
//  Marketing
//
//  Created by User on 16/3/13.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "Attendcell.h"

@implementation Attendcell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.clipsToBounds = YES;
        CGFloat width = [[[NSUserDefaults standardUserDefaults] objectForKey:@"width"] floatValue];
        NSLog( @"%f",width);
        _titleText = [[UILabel alloc] initWithFrame:CGRectMake1(70, 20, 100, 10)];
        _titleText.tag = 0;
        _nameText = [[UILabel alloc] initWithFrame:CGRectMake1(70, 35, 200, 10)];
        _nameText.tag = 1;
        _Attendyes = [[UILabel alloc] initWithFrame:CGRectMake1(250, 20, 60, 10)];
        _Attendyes.tag = 2;
        _Attendno = [[UILabel alloc] initWithFrame:CGRectMake1(250, 35, 60, 10)];
        _Attendno.tag = 3;
        _header = [[UIImageView alloc] initWithFrame:CGRectMake2(30, 10, 50, 50)];
        
        [self setFontLabel:_titleText byscale:width];
        [self setFontLabel:_nameText byscale:width];
        [self setFontLabel:_Attendyes byscale:width];
        [self setFontLabel:_Attendno byscale:width];
        
        [self.contentView addSubview:_titleText];
        [self.contentView addSubview:_Attendyes];
        [self.contentView addSubview:_Attendno];
        [self.contentView addSubview:_nameText];
        [self.contentView addSubview:_header];
        
    }
    return self;
}

- (void)setFontLabel:(UILabel *)label  byscale:(CGFloat )width
{
    int size;
    if (width == 1) {
        size = 12;
    }
    else if (width >1&&width <1.29) {
        size = 14;
    }
    else
    {
        size = 16;
    }
    if (label.tag == 0) {
        [label setFont:[UIFont systemFontOfSize:size]];
        
    }
    else
    {
        [label setFont:[UIFont systemFontOfSize:size-2]];
        label.textColor = [UIColor grayColor];
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
CG_INLINE CGRect
CGRectMake2(CGFloat x,CGFloat y,CGFloat width,CGFloat height)
{
    //创建appDelegate 在这不会产生类的对象,(不存在引起循环引用的问题)
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    //计算返回
    return CGRectMake(x * app.autoSizeScaleX, y * app.autoSizeScaleY, width * app.autoSizeScaleX, height * app.autoSizeScaleX);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
