//
//  StatisticCell.m
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/1.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "StatisticCell.h"
#import "StatisticModel.h"

@interface StatisticCell ()
{
    CGFloat  space;
    
    UIImageView  *_personImage;
    UILabel      *_nameLabel;
    UILabel      *_recordLabel;
    UILabel      *_dateLabel;
}
@end

@implementation StatisticCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *statisticId = @"statisticId";
    StatisticCell * cell = [tableView dequeueReusableCellWithIdentifier:statisticId];
    if (!cell) {
        cell = [[StatisticCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:statisticId];
        [cell addSubviews];
    }
    return cell;
}

- (void)addSubviews
{
    if (IPhone4SInCell) {
        space = 5.0f;
    }else{
        space = [UIView getWidth:10.0f];
    }
  CGFloat  cellH = [StatisticCell cellHeight];
    _personImage = [[UIImageView alloc] initWithFrame:CGRectMake( space, space, cellH - 2 * space, cellH - 2 * space)];
    _personImage.backgroundColor = [UIColor redColor];
    _personImage.layer.cornerRadius = _personImage.width / 2.0f;
    _personImage.layer.masksToBounds = YES;
    [self.contentView addSubview:_personImage];
    
    _nameLabel = [ViewTool getLabelWith:CGRectMake(_personImage.maxX + space, _personImage.y + space/2.0f, 150, 20) WithTitle:@"小花花" WithFontSize:16.0f WithTitleColor:blackFontColor WithTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_nameLabel];
    
    _recordLabel = [ViewTool getLabelWith:CGRectMake(_personImage.maxX + space, _nameLabel.maxY + space, KSCreenW - _personImage.maxX - space - 100, 20) WithTitle:@" " WithFontSize:14.0f WithTitleColor:grayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_recordLabel];
    
    _dateLabel = [ViewTool getLabelWith:CGRectMake(_recordLabel.maxX , _recordLabel.y,100, 20) WithTitle:@" " WithFontSize:14.0f WithTitleColor:blueFontColor WithTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_dateLabel];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake( space, cellH -1, KSCreenW - 2 * space, 1)];
    label.backgroundColor = grayLineColor;
    [self.contentView addSubview:label];
}

+ (CGFloat)cellHeight
{
    return [UIView getWidth:70];
}

- (void)setModel:(StatisticModel *)model
{
    _model = model;
    //给cel赋值
    [_personImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LoadImageUrl,model.logo]] placeholderImage:nil];
    _nameLabel.text = model.name;
    _recordLabel.text = model.remark;
    _dateLabel.text = [DateTool getYearmonthFromStr:model.addtime];
    
}
@end
