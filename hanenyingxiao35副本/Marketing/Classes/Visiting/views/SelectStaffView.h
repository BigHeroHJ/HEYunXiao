//
//  SelectStaffView.h
//  Marketing
//
//  Created by wmm on 16/3/2.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectStaffViewCell.h"
#import "DepartmentModel.h"
#import "UserModel.h"

@protocol SelectStaffDelegate <NSObject>

- (void)getSelectedStaff:(NSArray *)array;

//- (void)calendar:(SelectStaffView *)selectStaffView didSelectStaff:(NSString *)staffName;

@end

@interface SelectStaffView : UIView<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,SelectStaffViewCellDelegate>

@property (nonatomic) BOOL isSearching;

@property (strong, nonatomic) NSMutableArray *searchArray;
@property (strong, nonatomic) NSMutableArray *searchArray2;

@property (strong, nonatomic) NSMutableArray *selectedArray;

@property (strong, nonatomic) UISearchBar * searchBar;
@property (strong, nonatomic) UISearchBar * searchBar2;
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) UITableView * staffTableView;

@property (strong, nonatomic) UIButton * selectBtn;

@property(nonatomic,strong)id<SelectStaffDelegate>delegate;

@property (strong, nonatomic) DepartmentModel *model;
@property (strong, nonatomic) NSMutableArray *departs;

@property (strong, nonatomic) NSMutableArray *selectedDeparts;

@property (strong, nonatomic) UserModel *userModel;
@property (strong, nonatomic) NSMutableArray *users;

@property (strong, nonatomic) NSMutableArray *selectedUsers;

@property (nonatomic) BOOL isDepart;

@property (strong, nonatomic) NSMutableArray *allUsers;

@end

