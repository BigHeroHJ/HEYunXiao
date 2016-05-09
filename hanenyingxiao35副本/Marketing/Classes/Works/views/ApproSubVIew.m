//
//  ApproSubVIew.m
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/3.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "ApproSubVIew.h"

@interface ApproSubVIew ()
{
//    UIImageView    *_approvalStateImage;
    UIView         *_infoApproView;
    UIImageView    *_personLogo;
    UILabel        *_nameLable;
    UILabel        *_stateLabel;
    
    UILabel        *_datelabel;
    UILabel        *_timeLabel;
}
@end

@implementation ApproSubVIew

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = lightGrayBackColor;
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    CGFloat stateW = 20.0f;
    _approvalStateImage  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, stateW, stateW)];
    _approvalStateImage.layer.cornerRadius = stateW / 2.0f;
    _approvalStateImage.layer.masksToBounds = YES;
    [self addSubview:_approvalStateImage];
    
    CGFloat space = [UIView getWidth:15.0f];
    _infoApproView = [[UIView alloc] initWithFrame:CGRectMake(_approvalStateImage.maxX + 2 * space, 0, self.width - _approvalStateImage.maxX - 2 * space, self.height)];
    _infoApproView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_infoApproView];
    
    CGFloat logoW = _infoApproView.height - 1.5 * space;
    _personLogo = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, logoW, logoW)];
    _personLogo.layer.cornerRadius = logoW / 2.0f;
    _personLogo.layer.masksToBounds = YES;
    _personLogo.contentMode = UIViewContentModeScaleAspectFill;
//    _personLogo.backgroundColor = blueFontColor;
    [_infoApproView addSubview:_personLogo];
    
    _nameLable = [ViewTool getLabelWith:CGRectMake(_personLogo.maxX + space, _personLogo.y, [UIView getWidth:85], [UIView getWidth:15.0f ]) WithTitle:nil WithFontSize:16.0f WithTitleColor:blackFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_infoApproView addSubview:_nameLable];
    
    
  _stateLabel = [ViewTool getLabelWith:CGRectMake(_personLogo.maxX + space, _nameLable.maxY + 0.5 * space, [UIView getWidth:70], [UIView getWidth:15.0f ]) WithTitle:nil WithFontSize:14.0f WithTitleColor:grayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_infoApproView addSubview:_stateLabel];
    if(_approvalState == 1){
        _datelabel = [ViewTool getLabelWith:CGRectMake(_infoApproView.width - [UIView getWidth: 40], _nameLable.maxY - 0.5 * space, [UIView getWidth: 40], [UIView getWidth:10.0f]) WithTitle:@" " WithFontSize:13.0 WithTitleColor:blueFontColor WithTextAlignment:NSTextAlignmentRight];
        [_infoApproView addSubview:_datelabel];
        
        _timeLabel = [ViewTool getLabelWith:CGRectMake(_infoApproView.width - [UIView getWidth: 30], _datelabel.maxY , [UIView getWidth: 30], [UIView getWidth:10.0f]) WithTitle:@" " WithFontSize:14.0 WithTitleColor:blueFontColor WithTextAlignment:NSTextAlignmentRight];
        [_infoApproView addSubview:_timeLabel];
    }
    
//    UIView *line1 = [ViewTool getLineViewWith:CGRectMake(space / 2.0f, 0, 1, self.height) withBackgroudColor:grayLineColor];
//    [self addSubview:line1];
}
- (void)setApptype:(approType)apptype
{
    _apptype = apptype;
    
    if (_approvalState == 0) {//待通过
        if (apptype == 0) {
            //发出申请的人头像 url
            [_personLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LoadImageUrl, self.leavingPersonLogo]] placeholderImage:nil];
            _approvalStateImage.image = [UIImage imageNamed:@"完成状态"];
            //设置名字
            _personLogo.backgroundColor = blueFontColor;
            _stateLabel.text = @"发起申请";
        }else{
            [_personLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LoadImageUrl, self.handleLeavingLogo]] placeholderImage:nil];
            
            _approvalStateImage.image = [UIImage imageNamed:@"等待状态"];
            //
            _personLogo.backgroundColor = blueFontColor;
            _stateLabel.text = @"等待审批";
        }
    }else if(_approvalState == 3){//撤销的
        _approvalStateImage.image = [UIImage imageNamed:@"完成状态"];

        if (apptype == 0) {
            //发出申请的人头像 url
              _personLogo.backgroundColor = blueFontColor;
            [_personLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LoadImageUrl, self.leavingPersonLogo]] placeholderImage:nil];
                        //设置名字
          
            _stateLabel.text = @"发起申请";
        }else{
            //
            _personLogo.backgroundColor = blueFontColor;
            [_personLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LoadImageUrl, self.leavingPersonLogo]] placeholderImage:nil];
            _stateLabel.text = @"已撤销";
        }
    }else if(_approvalState == 1){//已审批同意的
        _approvalStateImage.image = [UIImage imageNamed:@"完成状态"];
        
        if (apptype == 0) {
            //发出申请的人头像 url
            _personLogo.backgroundColor = blueFontColor;
            [_personLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LoadImageUrl, self.leavingPersonLogo]] placeholderImage:nil];
            //设置名字
            
            _stateLabel.text = @"发起申请";
        }else{
            //
            _personLogo.backgroundColor = blueFontColor;
            [_personLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LoadImageUrl, self.handleLeavingLogo]] placeholderImage:nil];
            _stateLabel.text = @"已同意";
        }
    }else if(_approvalState == 2){//未通过审批的
        _approvalStateImage.image = [UIImage imageNamed:@"完成状态"];
        
        if (apptype == 0) {
            //发出申请的人头像 url
            _personLogo.backgroundColor = blueFontColor;
            [_personLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LoadImageUrl, self.leavingPersonLogo]] placeholderImage:nil];
            //设置名字
            
            _stateLabel.text = @"发起申请";
        }else{
            //
            _personLogo.backgroundColor = blueFontColor;
            [_personLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LoadImageUrl, self.handleLeavingLogo]] placeholderImage:nil];
            _stateLabel.text = @"不同意审批";
    }
   
}
}
//- (void)setLeavingPersonLogo:(NSString *)leavingPersonLogo
//{
//    //发出申请的人头像 url
//    [_personLogo sd_setImageWithURL:[NSURL URLWithString:leavingPersonLogo] placeholderImage:nil];
//    _personLogo.backgroundColor = blueFontColor;
//    
//}


- (void)setNameString:(NSString *)nameString
{
    _nameString = nameString;
    _nameLable.text = nameString;
}
    
@end
