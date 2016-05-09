//
//  SelectStaffView.m
//  Marketing
//
//  Created by wmm on 16/3/2.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "SelectStaffView.h"

@implementation SelectStaffView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSLog(@"initWithFrame:%f,%f",self.width,self.height);
        
        self.backgroundColor = [UIColor whiteColor];
//        
//        [self setWidth:KSCreenW-50];
        UIView *navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 64)];
        navBar.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [self addSubview:navBar];
        
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, [UIView getWidth:20], [UIView getWidth:20])];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(40,25, self.width-80, 30)];
        titleLbl.text = @"人员";
        titleLbl.textColor = lightGrayBackColor;
        titleLbl.font = [UIView getFontWithSize:15.0f];
        titleLbl.textColor = blackFontColor;
        titleLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLbl];
        
        UIButton *resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width-40, 30, [UIView getWidth:20], [UIView getWidth:20])];
        [resetBtn setBackgroundImage:[UIImage imageNamed:@"reset.png"] forState:UIControlStateNormal];
        [resetBtn addTarget:self action:@selector(resetView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:resetBtn];
        
        self.isDepart = YES;
        [self initTableView];
        _departs = [NSMutableArray array];
        _selectedDeparts = [NSMutableArray array];
        _users = [NSMutableArray array];
        [self initData];
        [self addSearchBar];
        
        
        UILabel *lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, KSCreenH-TabbarH, self.width, 1)];
        lineLab.layer.borderWidth = 1;
        lineLab.layer.borderColor = [grayFontColor CGColor];
        [self addSubview:lineLab];
        
        _selectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_selectBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
        [_selectBtn setTitleColor:mainOrangeColor forState:UIControlStateNormal];
        [_selectBtn.titleLabel setFont:[UIView getFontWithSize:15.0f]];
        _selectBtn.frame = CGRectMake(0, KSCreenH-TabbarH, self.width, TabbarH);
        [_selectBtn addTarget:self action:@selector(selectStaff) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_selectBtn];
        
    }
    return self;
}

- (void)initTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.width, self.height-64-44)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
    _tableView.hidden = NO;
    
    _staffTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.width, self.height-64-44)];
    _staffTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _staffTableView.delegate = self;
    _staffTableView.dataSource = self;
    [self addSubview:_staffTableView];
    _staffTableView.hidden = YES;
    
}

-(void)selectStaff{
    [self closeView];
    [_selectedArray addObjectsFromArray:_selectedUsers];
    for (DepartmentModel *model in _departs) {
        [self getSelectedDepartStaff:model];
    }
    
    [_delegate getSelectedStaff:_selectedArray];
}


- (void)drawRect:(CGRect)rect {
    
    NSLog(@"drawRect");
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_searchBar resignFirstResponder];
    [_searchBar2 resignFirstResponder];
}

-(void)closeView{
    
    [_searchBar resignFirstResponder]; //退出键盘
    [_searchBar2 resignFirstResponder];
    if (self.tableView.hidden) {
        self.tableView.hidden = NO;
        self.staffTableView.hidden = YES;
        [_users removeAllObjects];
//        _users = [NSMutableArray array];
        [self.staffTableView reloadData];
    }else{
        [self removeFromSuperview];
    }

}

-(void)resetView{
    NSLog(@"0000000");
    [_tableView reloadData];
}

//SelectStaffViewCellDelegate
- (void)selectAllIsSelected:(BOOL)isSelected{
    if (isSelected) {
        self.selectedUsers = _allUsers;
    }else{
        [self.selectedDeparts removeObject:model];
    }
}

- (void)selectDepart:(DepartmentModel *)model isSelected:(BOOL)isSelected{
    if (isSelected) {
        [self.selectedDeparts addObject:model];
    }else{
        [self.selectedDeparts removeObject:model];
    }
}
- (void)selectUser:(UserModel *)model isSelected:(BOOL)isSelected{
    if (isSelected) {
        [self.selectedUsers addObject:model];
    }else{
        [self.selectedDeparts removeObject:model];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isSearching) {
        return _searchArray.count;
    }
    if (tableView == _tableView) {
        return _departs.count;
    }else{
        return _users.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier =@"cell";
    SelectStaffViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (tableView == _tableView) {
            NSLog(@"tableView");
        DepartmentModel *depart;
        if (_isSearching) {
            depart=_searchArray[indexPath.row];
        }else{
            depart=_departs[indexPath.row];
        }

        if (cell == nil) {
            //         cell = [[SelectStaffViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell = [[SelectStaffViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier withDapart:depart];
            cell.delegate = self;
        }
    }else{

        UserModel *user;
        if (_isSearching) {
            user=_searchArray[indexPath.row];
        }else{
            user=_users[indexPath.row];
        }
        cell = [[SelectStaffViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier withUser:user];
        cell.delegate = self;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_searchBar resignFirstResponder];
    if (tableView == _tableView) {
        [self getDepartStaff:_departs[indexPath.row]];
        _tableView.hidden = YES;
        _staffTableView.hidden = NO;
    }
}

//#pragma mark - 搜索框代理
#pragma mark  取消搜索
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    _isSearching=NO;
    _searchBar.text=@"";
    [self.tableView reloadData];
    [self.staffTableView reloadData];
    //    [self resetSearch]; //重新 加载分类数据
    [_searchBar resignFirstResponder]; //退出键盘
}

#pragma mark 输入搜索关键字
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if([_searchBar.text isEqual:@""]){
        _isSearching=NO;
        [self.tableView reloadData];
        [self.staffTableView reloadData];
        return;
    }
    [self searchDataWithKeyWord:_searchBar.text withSearchBar:searchBar];
}

#pragma mark 点击虚拟键盘上的搜索时
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self searchDataWithKeyWord:_searchBar.text withSearchBar:searchBar];
    
    [searchBar resignFirstResponder];//放弃第一响应者对象，关闭虚拟键盘
}


#pragma mark 重写状态样式方法
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark 加载数据
-(void)initData{
    NSDictionary * params2 = [NSDictionary dictionaryWithObjectsAndKeys:@(UID), @"uid", TOKEN, @"token", nil];
    AFHTTPRequestOperationManager * manager2 = [AFHTTPRequestOperationManager manager];
    manager2.requestSerializer.timeoutInterval = 20;
    [manager2 POST:GET_DEPARTMENT_URL parameters:params2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"GET_DEPARTMENT_URL:%@",responseObject);
        NSArray * userArray = [(NSDictionary *)responseObject objectForKey:@"data"];
        for (NSDictionary *dapart in userArray) {
            _model = [[DepartmentModel alloc]init];
            [_model setValuesForKeysWithDictionary:dapart];
            [_departs addObject:_model];
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

//GET_USER_BY_DEPARTMENT_URL
- (void)getDepartStaff:(DepartmentModel *)depart{
    
            [_users removeAllObjects];
    NSDictionary * params2 = [NSDictionary dictionaryWithObjectsAndKeys:@(UID), @"uid", TOKEN, @"token", @(depart.departId), @"department", nil];
    AFHTTPRequestOperationManager * manager2 = [AFHTTPRequestOperationManager manager];
    manager2.requestSerializer.timeoutInterval = 20;
    [manager2 POST:GET_USER_BY_DEPARTMENT_URL parameters:params2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"GET_USER_BY_DEPARTMENT_URL:%@",responseObject);
        NSArray * departArray = [(NSDictionary *)responseObject objectForKey:@"data"];
        for (NSDictionary *user  in departArray) {
            _userModel = [[UserModel alloc]init];
            [_userModel setValuesForKeysWithDictionary:user];
            [_users addObject:_userModel];
        }
        NSLog(@"%@2222222222222",_users);
        [_staffTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)getSelectedDepartStaff:(DepartmentModel *)depart{
    
    
    NSDictionary * params2 = [NSDictionary dictionaryWithObjectsAndKeys:@(UID), @"uid", TOKEN, @"token", @(depart.departId), @"department", nil];
    AFHTTPRequestOperationManager * manager2 = [AFHTTPRequestOperationManager manager];
    manager2.requestSerializer.timeoutInterval = 20;
    [manager2 POST:GET_USER_BY_DEPARTMENT_URL parameters:params2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"GET_USER_BY_DEPARTMENT_URL:%@",responseObject);
        NSArray * departArray = [(NSDictionary *)responseObject objectForKey:@"data"];
        for (NSDictionary *user  in departArray) {
            _userModel = [[UserModel alloc]init];
            [_userModel setValuesForKeysWithDictionary:user];
            [_selectedArray addObject:_userModel];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}



#pragma mark 搜索形成新数据
-(void)searchDataWithKeyWord:(NSString *)keyWord withSearchBar:(UISearchBar *)searchBar{
    _isSearching=YES;
    _searchArray=[NSMutableArray array];
    
    if (searchBar == _searchBar) {
        for (DepartmentModel *depart in _departs) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {//ios8出来的方法
                
                if ([depart.dname.uppercaseString containsString:keyWord.uppercaseString]) {
                    [_searchArray addObject:depart];
                }
                
            }else{
                
                NSRange range = [depart.dname.uppercaseString rangeOfString:keyWord.uppercaseString];
                NSLog(@"111");
                if(range.length > 0)
                {
                    [_searchArray addObject:depart];
                    
                }
            }
        }
        //刷新表格
        [self.tableView reloadData];

    }else{
        for (UserModel *user in _users) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {//ios8出来的方法
                
                if ([user.name.uppercaseString containsString:keyWord.uppercaseString]) {
                    [_searchArray addObject:user];
                }
                
            }else{
                
                NSRange range = [user.name.uppercaseString rangeOfString:keyWord.uppercaseString];
                NSLog(@"111");
                if(range.length > 0)
                {
                    [_searchArray addObject:user];
                    
                }
            }
        }
        //刷新表格
        [self.staffTableView reloadData];
    }
    
}

#pragma mark 添加搜索栏
-(void)addSearchBar{
    CGRect searchBarRect=CGRectMake(0, 0, self.width, 44);
    _searchBar=[[UISearchBar alloc]initWithFrame:searchBarRect];
    _searchBar.placeholder=@"搜索";
    _searchBar.showsCancelButton=YES;//显示取消按钮
    //添加搜索框到页眉位置
    _searchBar.delegate=self;
    
    self.tableView.tableHeaderView = _searchBar;
    
    
    CGRect searchBarRect2=CGRectMake(0, 0, self.width, 44);
    _searchBar2=[[UISearchBar alloc]initWithFrame:searchBarRect2];
    _searchBar2.placeholder=@"搜索";
    _searchBar2.showsCancelButton=YES;//显示取消按钮
    //添加搜索框到页眉位置
    _searchBar2.delegate=self;
    
    self.staffTableView.tableHeaderView = _searchBar2;
}

//- (void)changeSearchHeader{
//    NSLog(@"klklk");
//    if (_tableView.hidden) {
//        self.staffTableView.tableHeaderView = _searchBar;
//    }else{
//            NSLog(@"klklk");
//        self.tableView.tableHeaderView = _searchBar;
//    }
//    
//}

- (void)layoutSubviews {
    // 一定要调用super的方法
    [super layoutSubviews];
    
    // 确定子控件的frame（这里得到的self的frame/bounds才是准确的）
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    //    self.imageView.frame = CGRectMake(0, 0, width, width);
    //    self.label.frame = CGRectMake(0, width, width, height - width);
}


@end

