//
//  DailRecordCell.m
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/1.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "DailRecordCell.h"
#import "RecordModel.h"

@interface DailRecordCell ()
{
    CGFloat  space;
    
    UIImageView  *_personImage;
    UILabel      *_nameLabel;
    UILabel      *_recordLabel;
    UILabel      *_timeLabel;
    UILabel      *_dateLabel;
}
@end

@implementation DailRecordCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *DailRecordId = @"DailRecordId";
    DailRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:DailRecordId];
    if (!cell) {
        cell = [[DailRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DailRecordId];
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
    CGFloat  cellH = [DailRecordCell cellHeight];
    _personImage = [[UIImageView alloc] initWithFrame:CGRectMake( space, space, cellH - 2 * space, cellH - 2 * space)];
    _personImage.backgroundColor = blueFontColor;
    _personImage.layer.cornerRadius = _personImage.width / 2.0f;
    _personImage.layer.masksToBounds = YES;
    [self.contentView addSubview:_personImage];
    
    _nameLabel = [ViewTool getLabelWith:CGRectMake(_personImage.maxX + space, _personImage.y + space / 2.0f, [UIView getWidth:200], 20) WithTitle:@"" WithFontSize:16.0f WithTitleColor:blackFontColor WithTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_nameLabel];
    
    _recordLabel = [ViewTool getLabelWith:CGRectMake(_personImage.maxX + space, _nameLabel.maxY + space, KSCreenW - _personImage.maxX - space - 100, 15) WithTitle:@"" WithFontSize:14.0f WithTitleColor:grayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_recordLabel];
    
    _dateLabel = [ViewTool getLabelWith:CGRectMake(KSCreenW -  space - 100 , _nameLabel.maxY,100, 15) WithTitle:@"" WithFontSize:13.0f WithTitleColor:blueFontColor WithTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:_dateLabel];
    
    _timeLabel = [ViewTool getLabelWith:CGRectMake(KSCreenW -  space - _dateLabel.width , _dateLabel.maxY,_dateLabel.width, 15) WithTitle:@"" WithFontSize:13.0f WithTitleColor:blueFontColor WithTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:_timeLabel];
    
    

    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake( space, cellH -1, KSCreenW - 2 * space, 1)];
    label.backgroundColor = grayLineColor;
    [self.contentView addSubview:label];
}

+ (CGFloat)cellHeight
{
    return [UIView getWidth:70];
}

- (void)setModel:(RecordModel *)model
{
    _model = model;
    
    [_personImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LoadImageUrl,model.logo]] placeholderImage:nil];
    NSLog(@"日志质类型%d",model.type);
//    if (model.username) {
        if (model.type == 1) {
            _nameLabel.text = [NSString stringWithFormat:@"%@/今日报表",model.name];
        }else if (model.type == 2){
            _nameLabel.text = _nameLabel.text = [NSString stringWithFormat:@"%@/本月报表",model.name];
        }else if(model.type == 3){
            _nameLabel.text =  [NSString stringWithFormat:@"%@/本周报表",model.name];
        }
//    }
    
    _recordLabel.text = model.topic;
//    NSRange rang = [model.addtime rangeOfString:@" "];
//    NSString * dateStr = [model.addtime substringToIndex:rang.location ];
//    NSRange rang2 = [model.addtime rangeOfString:@":" options:NSBackwardsSearch];
//    NSString * time = [model.addtime substringWithRange:NSMakeRange(rang.location + 1, rang2.location - rang.location+ 1)];
    NSString *dateStr = [DateTool getYearmonthFromStr:model.addtime];
    NSString *time = [DateTool getDateFromStr:model.addtime];
//    NSString *hourMinStr = [time substringWithRange:NSMakeRange(0, 5)];
    _dateLabel.text = dateStr;
    _timeLabel.text = time;
    
}
@end
