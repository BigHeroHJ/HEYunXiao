//
//  ManagerCheckSignCell.m
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/14.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "ManagerCheckSignCell.h"

#import "Managercheckcell.h"

@interface ManagerCheckSignCell ()
{
    CGFloat topSpace;
    UIImageView     *_personLogo;

    UILabel         *_nameLabel;
    UILabel         *_signInLabel;
    UILabel         *_signOutLabel;
    UILabel         *_remarkLabel;
   
}
@end
@implementation ManagerCheckSignCell

+(CGFloat)cellHeight
{
    return [UIView getWidth:70.0f];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * managercheckCell = @"managercheckCellID";
    ManagerCheckSignCell *cell = [tableView dequeueReusableCellWithIdentifier:managercheckCell];
    if (!cell) {
        cell = [[ManagerCheckSignCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:managercheckCell];
        [cell addSubviews];
    }
    return cell;
}
- (void)addSubviews
{
    if (IPhone4SInCell) {
        topSpace = 5.0f;
    }else{
        topSpace = [UIView getWidth:10.0f];
    }
    CGFloat imageW = ([ManagerCheckSignCell cellHeight] - 2 * topSpace);
    _personLogo = [[UIImageView alloc] initWithFrame:CGRectMake(2 * topSpace, topSpace, imageW, imageW)];
    _personLogo.layer.cornerRadius = imageW/ 2.0f;
    _personLogo.layer.masksToBounds = YES;
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_personLogo.maxX + 2 * topSpace, _personLogo.y, 100, [UIView getWidth: 20.0f])];
    _nameLabel.font = [UIFont systemFontOfSize:16.0f];
    _nameLabel.textColor = blackFontColor;
//    _nameLabel.backgroundColor = blueFontColor;
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_personLogo];
    [self.contentView addSubview:_nameLabel];
    
    _remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.x , _nameLabel.maxY + topSpace, 100, [UIView getWidth: 20.0f])];
//    _remarkLabel.backgroundColor = blueFontColor;
    _remarkLabel.font = [UIFont systemFontOfSize:13.0f];
    _remarkLabel.textColor = grayFontColor;
    _remarkLabel.textAlignment = NSTextAlignmentLeft;

    
    _signInLabel = [[UILabel alloc] initWithFrame:CGRectMake(KSCreenW -  topSpace - [UIView getWidth:80.0f] , _nameLabel.y, [UIView getWidth:80], [UIView getWidth: 20.0f])];
    _signInLabel.font = [UIFont systemFontOfSize:13.0f];
//    _signInLabel.textColor = grayFontColor;
//    _signInLabel.backgroundColor = blueFontColor;
    _signInLabel.textAlignment = NSTextAlignmentRight;
    
  _signOutLabel = [[UILabel alloc] initWithFrame:CGRectMake(KSCreenW -  topSpace - [UIView getWidth:80.0f] , _remarkLabel.y, [UIView getWidth:80], [UIView getWidth: 20.0f])];
    _signOutLabel.font = [UIFont systemFontOfSize:13.0f];
//    _signOutLabel.textColor = grayFontColor;
//    _signOutLabel.backgroundColor = blueFontColor;
    
    _signOutLabel.textAlignment = NSTextAlignmentRight;
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(topSpace, [ManagerCheckSignCell cellHeight] - 1, KSCreenW - 2 * topSpace, 1)];
    lable.backgroundColor = grayLineColor;
    [self.contentView addSubview:lable];
    
    
    [self.contentView addSubview:_remarkLabel];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_signOutLabel];
    [self.contentView addSubview:_signInLabel];

    
}

- (void)setModel:(Managercheckcell *)model
{
    _signInLabel.text = @"";
    _signOutLabel.text = @"";
    _model = model;
    [_personLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LoadImageUrl,model.logo]] placeholderImage:nil];
    
    _nameLabel.text = model.name;
    
    _remarkLabel.text = model.remark;
    
    if (model.type == 1) {//签到
        _signInLabel.frame = CGRectMake(KSCreenW -  topSpace - [UIView getWidth:80.0f] , _remarkLabel.y, [UIView getWidth:80], [UIView getWidth: 15.0f]);
        _signInLabel.textColor = blueFontColor;
        _signInLabel.text = @"已签到";
      
    }else{//签退
        _signInLabel.frame = CGRectMake(KSCreenW -  topSpace - [UIView getWidth:80.0f] , _nameLabel.maxY - 10, [UIView getWidth:80], [UIView getWidth: 15.0f]);
        _signInLabel.textColor = grayFontColor;
          _signInLabel.text = @"已签到";
        
        _signOutLabel.frame = CGRectMake(KSCreenW -  topSpace - [UIView getWidth:80.0f] , _remarkLabel.y, [UIView getWidth:80], [UIView getWidth: 15.0f]);
        _signOutLabel.textColor = grayFontColor;
          _signOutLabel.text = @"已签退";
    }
}
@end
