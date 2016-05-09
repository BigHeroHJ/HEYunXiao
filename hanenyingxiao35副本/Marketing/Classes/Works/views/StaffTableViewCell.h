//
//  StaffTableViewCell.h
//  Marketing
//
//  Created by wmm on 16/3/10.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DepartmentModel.h"
#import "UserModel.h"

@interface StaffTableViewCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDapart:(DepartmentModel *)model;

@property (strong, nonatomic) DepartmentModel *model;

@property (strong, nonatomic) NSMutableArray *users;


@end
