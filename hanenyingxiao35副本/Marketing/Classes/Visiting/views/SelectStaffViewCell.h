//
//  SelectStaffViewCell.h
//  Marketing
//
//  Created by wmm on 16/3/3.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DepartmentModel.h"
#import "UserModel.h"

@protocol SelectStaffViewCellDelegate <NSObject>

- (void)selectAllIsSelected:(BOOL)isSelected;
- (void)selectDepart:(DepartmentModel *)model isSelected:(BOOL)isSelected;
- (void)selectUser:(UserModel *)model isSelected:(BOOL)isSelected;

@end

@interface SelectStaffViewCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDapart:(DepartmentModel *)model;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withUser:(UserModel *)userModel;

@property (strong, nonatomic) DepartmentModel *model;
@property (strong, nonatomic) UserModel *userModel;
//@property (strong, nonatomic) UIButton *headerBtn;
@property (strong, nonatomic) UIImageView *selectedImg;
@property (strong, nonatomic) UILabel *nameLbl;
@property (nonatomic) BOOL isSelected;
//@property (assign, nonatomic) NSInteger *cellId;
@property (nonatomic, weak) id <SelectStaffViewCellDelegate>delegate;

@end
