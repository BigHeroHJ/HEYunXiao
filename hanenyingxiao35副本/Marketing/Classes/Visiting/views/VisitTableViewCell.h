//
//  VisitTableViewCell.h
//  Marketing
//
//  Created by wmm on 16/2/29.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VisitTableViewCellDelegate <NSObject>

- (void)jumpControllerToMap:(NSString *)btnTitle;

@end

@interface VisitTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *companyLab;
@property (strong, nonatomic) UILabel *addressLab;
@property (strong, nonatomic) UIButton *addressbtn;
@property (strong, nonatomic) UILabel *visitTimeLab;
@property (strong, nonatomic) UILabel *visitStausLab;
@property (strong, nonatomic) UILabel *visitStausLab2;
@property (strong, nonatomic) UIImageView *companyLevelImage;

@property (nonatomic, weak) id<VisitTableViewCellDelegate>delegate;
@end
