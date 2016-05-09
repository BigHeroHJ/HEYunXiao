//
//  LevelCell.m
//  Marketing
//
//  Created by HanenDev on 16/3/7.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "LevelCell.h"

#define STARTX [UIView getWidth:10]
#define CELLHEIGHT 40

@implementation LevelCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat cellY = 5;
        
        _headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(STARTX, cellY, 30, 30)];
        _headerImage.layer.cornerRadius = 15;
        _headerImage.layer.masksToBounds =YES;
        [self.contentView addSubview:_headerImage];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headerImage.maxX + 10, cellY, 200, 30)];
        _nameLabel.textColor = blackFontColor;
        _nameLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_nameLabel];
        
        
        UIView * lineView =[[UIView alloc]initWithFrame:CGRectMake(STARTX, CELLHEIGHT - 1, KSCreenW -2*STARTX, 1)];
        lineView.backgroundColor = grayLineColor;
        [self.contentView addSubview:lineView];
        
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
