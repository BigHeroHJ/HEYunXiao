//
//  levaingCell.m
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/13.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "levaingCell.h"
#import "LeavingModel.h"




@interface levaingCell ()
{
    CGFloat topSpace;
    UIImageView     *_personLogo;
    UIImageView     *_waiteLoga;
    UILabel         *_nameLabel;
    UILabel         *_waiteLabel;
    UILabel         *_dateLabel;
    UILabel         *_timeLabel;
}
@end
@implementation levaingCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString  *noticeCellId = @"leavingID";
    
    levaingCell *cell = [tableView dequeueReusableCellWithIdentifier:noticeCellId];
    
    if (!cell) {
        cell = [[levaingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noticeCellId];
        //        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:.1];
        [cell addSubviews];
    }
    
    return cell;
    
}

- (void)addSubviews
{
    if (IPhone4SInCell) {
        topSpace = 10.0f;
    }else{
        topSpace = [UIView getWidth:10.0f];
    }
    CGFloat cellH = [levaingCell cellHeight];
    CGFloat logoW = (cellH - 2 * topSpace);
    _personLogo = [[UIImageView alloc] initWithFrame:CGRectMake( topSpace, topSpace, logoW, logoW)];
    //    _personLogo.backgroundColor = blueFontColor;
    [_personLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LoadImageUrl,[[NSUserDefaults standardUserDefaults] objectForKey:@"name"]]] placeholderImage:nil];
    _personLogo.layer.cornerRadius = logoW / 2.0f;
    _personLogo.layer.masksToBounds = YES;
    [self.contentView addSubview:_personLogo];
    
    CGFloat waiteLogoW = [UIView getWidth:13.0f];
    _waiteLoga = [[UIImageView alloc] initWithFrame:CGRectMake(logoW , _personLogo.maxY - waiteLogoW, waiteLogoW , waiteLogoW)];
    //    _waiteLoga.backgroundColor = [UIColor redColor];
    _waiteLoga.image = [UIImage imageNamed:@"等待"];
    [self.contentView addSubview:_waiteLoga];
    
    _nameLabel = [ViewTool getLabelWith:CGRectMake(_personLogo.maxX + 1.5 * topSpace, _personLogo.y, KSCreenW - _personLogo.maxX - 4 * topSpace, [UIView getHeight:20]) WithTitle:@" " WithFontSize:16.0f WithTitleColor:blackFontColor WithTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_nameLabel];
    
    _waiteLabel = [ViewTool getLabelWith:CGRectMake(_nameLabel.x, _nameLabel.maxY + topSpace, [UIView getWidth:100], [UIView getHeight:15]) WithTitle:@" " WithFontSize:14.0f WithTitleColor:grayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_waiteLabel];
    
    CGFloat  dateTimeW = 125;//时间和日期 总共的长度
    CGFloat  dateX = KSCreenW - topSpace - dateTimeW;
    _dateLabel = [ViewTool getLabelWith:CGRectMake(dateX , _waiteLabel.y, 80, [UIView getHeight:15]) WithTitle:@" " WithFontSize:14.0f WithTitleColor:blueFontColor WithTextAlignment:NSTextAlignmentRight];
    //    _dateLabel.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:_dateLabel];
    
    
    _timeLabel = [ViewTool getLabelWith:CGRectMake(_dateLabel.maxX +3, _waiteLabel.y, dateTimeW - _dateLabel.width, [UIView getHeight:15]) WithTitle:@" " WithFontSize:14.0f WithTitleColor:blueFontColor WithTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:_timeLabel];
    
    UIView *line = [ViewTool getLineViewWith:CGRectMake(topSpace, cellH - 1, KSCreenW - 2 * topSpace, 1) withBackgroudColor:grayLineColor];
    [self.contentView addSubview:line];
    
    
}

//- (void)setIsWaitingApproval:(BOOL)isWaitingApproval
//{
//    if (isWaitingApproval) {
//        [self.contentView addSubview:_waiteLoga];
//        _waiteLabel.text = @"待审批";
//    }else{
//        _waiteLabel.text = @"已完成审批";
//    }
//    
//}

- (void)setModel:(LeavingModel *)model
{
    _model = model;
    if (model.lstatus == 0) {
        _waiteLabel.text = [NSString stringWithFormat:@"等待%@的审批",model.mname];
        _waiteLoga.hidden = NO;
    }else if(model.lstatus == 1){
        _waiteLabel.text = [NSString stringWithFormat:@"已通过审批"];
        _waiteLoga.hidden = YES;
    }else if (model.lstatus == 2){
        _waiteLabel.text = [NSString stringWithFormat:@"未通过审批"];
        _waiteLoga.hidden = YES;
    }else{
        _waiteLabel.text = [NSString stringWithFormat:@"已撤销"];
        _waiteLoga.hidden = YES;
    }
    [_personLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LoadImageUrl,[[NSUserDefaults standardUserDefaults] objectForKey:@"logo"]]] placeholderImage:nil];
    
    _nameLabel.text  = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    
    NSString * dateStr = [model.addtime substringToIndex:10];
    NSString *timeStr = [model.addtime substringWithRange:NSMakeRange(11, 5)];
    _dateLabel.text = dateStr;
    _timeLabel.text = timeStr;

}
+ (CGFloat)cellHeight{
    return [UIView getWidth:70];
}

@end
