//
//  MineCell.m
//  移动营销
//
//  Created by HanenDev on 16/2/24.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "MineCell.h"

#define STARTX [UIView getWidth:10]
#define CELLHEIGHT 50.0f

@implementation MineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat cellY = 10;
        CGFloat labelH = CELLHEIGHT - 2*cellY ;
        
        _headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(STARTX, cellY+ 5, 18.0 , 18.0)];
        [self.contentView addSubview:_headerImage];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headerImage.maxX + 10, cellY - 2, 100, labelH)];
        _titleLabel.textColor = blackFontColor;
        [ViewTool setLableFont14:_titleLabel];
        [self.contentView addSubview:_titleLabel];
        
        _phoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(KSCreenW - labelH-STARTX, cellY, labelH, labelH)];
        [self.contentView addSubview:_phoneBtn];
        
        _lineView =[[UIView alloc]initWithFrame:CGRectMake(STARTX, CELLHEIGHT - 1, KSCreenW -2*STARTX, 1)];
        _lineView.backgroundColor = grayLineColor;
        [self.contentView addSubview:_lineView];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
