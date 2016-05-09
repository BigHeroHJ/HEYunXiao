//
//  VisitTableViewCell.m
//  Marketing
//
//  Created by wmm on 16/2/29.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "VisitTableViewCell.h"
#import "CRM_PrefixHeader.pch"

@implementation VisitTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        //选中单元格
        //        UIView *bgView = [[UIView alloc] init];
        //        bgView.backgroundColor = [UIColor colorWithRed:(20.0f/255.0f) green:(30.0f/255.0f) blue:(40.0f/255.0f) alpha:0.5f];
        //        self.selectedBackgroundView = bgView;
        
        self.imageView.contentMode = UIViewContentModeCenter;
        
        self.companyLab = [[UILabel alloc] initWithFrame:CGRectMake(LEFTWIDTH, 7.5, KSCreenW/3*2, 20)];
        self.companyLab.textColor = blackFontColor;

        _companyLevelImage = [[UIImageView alloc] init];

        
        self.visitTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(KSCreenW-90, 7.5, 70, 20)];
        self.visitTimeLab.textColor = blueFontColor;
        self.visitTimeLab.textAlignment = NSTextAlignmentRight;
        
        UIImageView *addressImage = [[UIImageView alloc] initWithFrame:CGRectMake(LEFTWIDTH, self.companyLab.maxY+8, 15, 15)];
        addressImage.image = [UIImage imageNamed:@"address.png"];
        
        self.addressLab = [ViewTool getLabelWith:CGRectMake(addressImage.maxX, self.companyLab.maxY+5, KSCreenW/4*3, 20) WithTitle:@" " WithFontSize:13.0f WithTitleColor:lightGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
        
        self.visitStausLab = [[UILabel alloc] initWithFrame:CGRectMake(KSCreenW-100, self.companyLab.maxY+5, 80, 20)];
        self.visitStausLab.textColor = blueFontColor;
        self.visitStausLab.textAlignment = NSTextAlignmentRight;
        
        self.visitStausLab2 = [[UILabel alloc] initWithFrame:CGRectMake(KSCreenW-100, 20, 80, 20)];
        self.visitStausLab2.textColor = grayListColor;
        self.visitStausLab2.textAlignment = NSTextAlignmentRight;
        
        UILabel *lineLab = [[UILabel alloc] initWithFrame:CGRectMake(LEFTWIDTH, CELLHEIGHT2-1, KSCreenW-LEFTWIDTH*2, 1)];
        lineLab.layer.borderWidth = 1;
        lineLab.layer.borderColor = [grayLineColor CGColor];
        
        [ViewTool setLableFont12:self.addressLab];
        [ViewTool setLableFont12:self.visitStausLab];
        [ViewTool setLableFont12:self.visitStausLab2];
        [ViewTool setLableFont12:self.visitTimeLab];
        [ViewTool setLableFont14:self.companyLab];
        
        [self.contentView addSubview:self.companyLab];
        [self.contentView addSubview:_companyLevelImage];
        [self.contentView addSubview:self.visitTimeLab];
        [self.contentView addSubview:addressImage];
        [self.contentView addSubview:self.addressLab];
        [self.contentView addSubview:self.visitStausLab];
        [self.contentView addSubview:self.visitStausLab2];
        [self.contentView addSubview:lineLab];
        
    }
    return self;
}
- (void)clickToJimpMap:(UIButton *)btn
{
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
