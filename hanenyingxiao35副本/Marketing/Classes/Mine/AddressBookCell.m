//
//  AddressBookCell.m
//  Marketing
//
//  Created by HanenDev on 16/3/3.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "AddressBookCell.h"

#define STARTX [UIView getWidth:10]
#define CELLHEIGHT 50

@implementation AddressBookCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat cellY = 10;
    
        
        _headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(STARTX, cellY, 30, 30)];
        _headerImage.layer.cornerRadius = 15;
        _headerImage.layer.masksToBounds =YES;
        [self.contentView addSubview:_headerImage];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headerImage.maxX + 10, cellY, 200, 30)];
        _nameLabel.textColor = blackFontColor;
        [ViewTool setLableFont14:_nameLabel];
        [self.contentView addSubview:_nameLabel];
        
        _phoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(KSCreenW - STARTX - 30 , cellY+10, 20, 20)];
        [_phoneBtn setImage:[UIImage imageNamed:@"电话1"] forState:UIControlStateNormal];
        [self.contentView addSubview:_phoneBtn];
        
        UIView * lineView =[[UIView alloc]initWithFrame:CGRectMake(STARTX, CELLHEIGHT - 1, KSCreenW -2*STARTX, 1)];
        lineView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:0.5];
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
