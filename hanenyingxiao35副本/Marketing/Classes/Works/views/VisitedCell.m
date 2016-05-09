//
//  VisitedCell.m
//  Marketing
//
//  Created by Hanen 3G 01 on 16/2/26.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "VisitedCell.h"
#import "SubSignModel.h"

@interface VisitedCell ()
{
    CGFloat topSpace;
    UIImageView  *_imageView;
    UILabel      *_recordLabel;
    UIImageView  *_placeImage;
    UILabel      *_placeLabel;
    UILabel      *_signState;
    UILabel      *_timeLabel;
    
    CGFloat   lastY;
    
    
}
@end

@implementation VisitedCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}
+ (instancetype)cellWithTableView:(UITableView *)tableview
{
    
    
    static  NSString *  const visitedCellId = @"visitedCellId";
    VisitedCell * cell = [tableview dequeueReusableCellWithIdentifier:visitedCellId];
    if (!cell) {
        cell = [[VisitedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:visitedCellId];
        [cell addSubviews];
    }
    return cell;
}
- (void)addSubviews
{
    lastY = 0;
    if (IPhone4SInCell) {
    
            topSpace = 9.0f;
        }else{
            topSpace =[UIView getWidth: 9.0f];
        }

    CGFloat cellW = KSCreenW;
    CGFloat cellh = [VisitedCell cellHeight];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake( topSpace, topSpace, cellh - topSpace / 2.0f, cellh - 2 * topSpace)];
//    _imageView.image = [UIImage imageNamed:@"相机"];
//    _imageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_imageView];
    
    
    [UIColor colorWithWhite:0.3 alpha:1];
    _recordLabel = [ViewTool getLabelWith:CGRectMake(_imageView.maxX + topSpace,  _imageView.y, cellW - _imageView.maxX - 2 * topSpace, [UIView getHeight:20]) WithTitle:nil WithFontSize:16.0f WithTitleColor: blackFontColor WithTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_recordLabel];
    
    
    _placeImage = [[UIImageView alloc] initWithFrame:CGRectMake(_recordLabel.x, _recordLabel.maxY + 5, [UIView getWidth:10], [UIView getWidth:10.0f])];
//    _placeImage.backgroundColor = [UIColor redColor];
    _placeImage.image = [UIImage imageNamed:@"定位"];
    [self.contentView addSubview:_placeImage];
    
    _placeLabel = [ViewTool getLabelWith:CGRectMake(_placeImage.maxX , _recordLabel.maxY , cellW - _placeImage.maxX, 20) WithTitle:@"  " WithFontSize:14.0 WithTitleColor: [UIColor colorWithWhite:0.6 alpha:1] WithTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_placeLabel];
    
    _signState = [ViewTool getLabelWith:CGRectMake(_recordLabel.x, _placeImage.maxY +  topSpace / 2.0f, 80, 15) WithTitle:nil WithFontSize:12.0 WithTitleColor:blueFontColor WithTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_signState];
    
    _timeLabel = [ViewTool getLabelWith:CGRectMake(_signState.maxX, _signState.y, 100, _signState.height) WithTitle:nil WithFontSize:12.0 WithTitleColor:blueFontColor WithTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_timeLabel];
    
    UIView *line = [ViewTool getLineViewWith:CGRectMake( topSpace, _imageView.maxY + topSpace -1, cellW - 2 * topSpace, 0.8) withBackgroudColor:grayLineColor];
    [self.contentView addSubview:line];
    
    lastY = line.maxY;
    
    
}

- (void)setModel:(SubSignModel *)model
{
    _model = model;
//    NSLog(@"头像 %@",model.img);
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@%@",LoadImageUrl,model.img]] placeholderImage:nil];
    _recordLabel.text = model.remark;
    NSLog(@"address %@",model.address);
    _placeLabel.text = model.address;
    _timeLabel.text = [DateTool getDateFromStr:model.addtime];
    
    if(model.type == 1 ){
        _signState.text = @"已签到";
    }else if(model.type == 2){
        _signState.text = @"已签退";
    }
    
    
    
}
+ (CGFloat)cellHeight
{
    return [UIView getHeight:70];
}
@end
