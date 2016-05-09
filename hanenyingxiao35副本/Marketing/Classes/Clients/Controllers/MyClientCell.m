//
//  MyClientCell.m
//  Marketing
//
//  Created by HanenDev on 16/3/1.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "MyClientCell.h"

#define STARTX [UIView getWidth:10]
#define CELLHEIGHT 60.0f

@implementation MyClientCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat cellY = 7.5;
        //公司名称
        _companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(STARTX, cellY, [UIView getWidth:200], 20)];
        _companyLabel.textColor = blackFontColor;
//        _companyLabel.font = [UIFont systemFontOfSize:16.0f];
        [ViewTool setLableFont14:_companyLabel];

        [self.contentView addSubview:_companyLabel];
        //等级图片
        //_levelImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_companyLabel.maxX, cellY +8 , [UIView getWidth:20], [UIView getHeight:15])];
        _levelImageView = [[UIImageView alloc]init];
        //_levelImageView.image = [UIImage imageNamed:@"vip"];
        [self.contentView addSubview:_levelImageView];
        
        //定位
        _locationBtn = [[UIButton alloc]initWithFrame:CGRectMake(STARTX, _companyLabel.maxY+8, 15, 15)];
        [_locationBtn setImage:[UIImage imageNamed:@"定位"] forState:UIControlStateNormal];
        [self.contentView addSubview:_locationBtn];
        
        
        //地址
        _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(_locationBtn.maxX, _companyLabel.maxY +5, KSCreenW - [UIView getWidth:70]- STARTX, 20)];
        _addressLabel.textColor = grayFontColor;
        _addressLabel.font = [UIFont systemFontOfSize:13.0f];
        [self.contentView addSubview:_addressLabel];
        
        
//        self.addressbtn = [[UIButton alloc] initWithFrame:CGRectMake(_locationBtn.maxX-3, _companyLabel.maxY+5, KSCreenW - [UIView getWidth:70]- STARTX,20)];
//        [self.addressbtn setTitleColor:grayFontColor forState:UIControlStateNormal];
//        self.addressbtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
//        [self.addressbtn addTarget:self action:@selector(clickToJimpMap:) forControlEvents:UIControlEventTouchUpInside];
//        self.addressbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        self.addressbtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
//        [self.contentView addSubview:self.addressbtn];
        
        //负责人
        _principalLabel = [[UILabel alloc]initWithFrame:CGRectMake(_addressLabel.x, _addressLabel.maxY+5, KSCreenW, 20)];
        _principalLabel.font = [UIFont systemFontOfSize:14.0f];
        _principalLabel.textColor = grayFontColor;
        [self.contentView addSubview:_principalLabel];
        
        //
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(KSCreenW -STARTX - [UIView getWidth:110], cellY +12.5, [UIView getWidth:100], 20)];
        _timeLabel.textColor = blueFontColor;
        //        _timeLabel.font = [UIFont systemFontOfSize:14.0f];
        [ViewTool setLableFont12:_timeLabel];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timeLabel];

        
        //状态
        _statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(KSCreenW -STARTX - [UIView getWidth:110], _timeLabel.maxY + 5, [UIView getWidth:100], 20)];
        _statusLabel.textAlignment = NSTextAlignmentRight;
        _statusLabel.textColor = blueFontColor;
        //        _statusLabel.font = [UIFont systemFontOfSize:14.0f];
        [ViewTool setLableFont12:_statusLabel];
        [self.contentView addSubview:_statusLabel];
        
        //状态
        _statusCenterLabel = [[UILabel alloc]initWithFrame:CGRectMake(KSCreenW -STARTX - [UIView getWidth:110], _companyLabel.maxY + 5, [UIView getWidth:100], 20)];
        _statusCenterLabel.textAlignment = NSTextAlignmentRight;
        _statusCenterLabel.textColor = blueFontColor;
        //        _statusLabel.font = [UIFont systemFontOfSize:14.0f];
        [ViewTool setLableFont12:_statusCenterLabel];
        [self.contentView addSubview:_statusCenterLabel];
        
//        UIView *lineV = [ViewTool getLineViewWith:CGRectMake(STARTX, self.height - 1, KSCreenW - 2 * STARTX, 1) withBackgroudColor:grayLineColor];
//        [self.contentView addSubview:lineV];
    }
    return self;
}

- (void)clickToJimpMap:(UIButton *)btn
{
    NSLog(@"fsdfsd");
    if ([self.delegate respondsToSelector:@selector(jumpControllerToMap:)]) {
        NSLog(@"fssd");
        [self.delegate jumpControllerToMap:btn.currentTitle];
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
