//
//  MapLineCell.m
//  Marketing
//
//  Created by HanenDev on 16/3/8.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "MapLineCell.h"

#define STARTX [UIView getWidth:20]
#define CELLHEIGHT 60.0f

@implementation MapLineCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGFloat cellY = 7.5;
        CGFloat lineW = KSCreenW -2*STARTX;
        CGFloat labW = (lineW - 3*20)/3 -5;
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(STARTX, cellY, KSCreenW - 2*STARTX - 60, 20)];
        self.timeLabel.textColor = blackFontColor;
        [self.contentView addSubview:self.titleLabel];
        
        self.subTitLab = [[UILabel alloc]initWithFrame:CGRectMake(KSCreenW - STARTX - 60, cellY, 60 , 20)];
        self.subTitLab.font = [UIFont systemFontOfSize:15.0f];
        self.subTitLab.textColor = blueFontColor;
        [self.contentView addSubview:self.subTitLab];
        
        self.mileImage = [[UIImageView alloc]initWithFrame:CGRectMake(STARTX, self.titleLabel.maxY + 5, 20, 20)];
        self.mileImage.image = [UIImage imageNamed:@"距离"];
        [self.contentView addSubview:self.mileImage];
        
        self.mileLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.mileImage.maxX + 5, self.titleLabel.maxY +5 , labW, 20)];
        self.mileLabel.font = [UIFont systemFontOfSize:15.0f];
        self.mileLabel.textColor = grayFontColor;
        [self.contentView addSubview:self.mileLabel];
        
        self.timeImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.mileLabel.maxX, self.titleLabel.maxY+5, 20, 20)];
        self.timeImage.image = [UIImage imageNamed:@"站数"];
        [self.contentView addSubview:self.timeImage];
        
        self.timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.timeImage.maxX + 5, self.titleLabel.maxY + 5, labW, 20)];
        self.timeLabel.font = [UIFont systemFontOfSize:15.0f];
        self.timeLabel.textColor = grayFontColor;
        [self.contentView addSubview:self.timeLabel];
        
        self.walkImage=[[UIImageView alloc]initWithFrame:CGRectMake(self.timeLabel.maxX, self.titleLabel.maxY + 5, 20, 20)];
        self.walkImage.image = [UIImage imageNamed:@"步行副本"];
        [self.contentView addSubview:self.walkImage];
        
        self.walkLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.walkImage.maxX + 5, self.titleLabel.maxY + 5, labW, 20)];
        self.walkLabel.font = [UIFont systemFontOfSize:15.0f];
        self.walkLabel.textColor = grayFontColor;
        [self.contentView addSubview:self.walkLabel];
        
        self.xiaBtn = [[MapButton alloc]initWithFrame:CGRectMake(KSCreenW - STARTX, 20, 15, 12)];
        [self.xiaBtn setImage:[UIImage imageNamed:@"箭头1"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.xiaBtn];
        
        
       UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(STARTX, CELLHEIGHT - 1, KSCreenW -2*STARTX, 1)];
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
