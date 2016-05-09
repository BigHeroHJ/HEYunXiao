//
//  SelectViewController.m
//  Marketing
//
//  Created by wmm on 16/3/2.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "SelectViewController.h"

@interface SelectViewController (){

    UIView *dimmingView;
    UIView *_backView;
    
}

@property (nonatomic,strong) UIView *alphaView;

@end

@implementation SelectViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor clearColor];
    _alphaView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, self.view.width-50, self.view.height)];
    UIView *baseView = [[UIView alloc] initWithFrame:self.view.frame];
    _alphaView.backgroundColor = [UIColor clearColor];
    baseView.backgroundColor = [UIColor blackColor];
    baseView.alpha = 0.4;
    UIButton *backViewBtn = [[UIButton alloc] initWithFrame:baseView.frame];
    [backViewBtn addTarget:self action:@selector(closeSelectView) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:backViewBtn];
    [self.view addSubview:baseView];
    [self.view addSubview:_alphaView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.view.frame=CGRectMake(0,20,KSCreenW,KSCreenH-20);
//    self.view.bounds.origin.y = 20;
    UIView *navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 20, _alphaView.width, 44)];
    navBar.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [_alphaView addSubview:navBar];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 35, [UIView getWidth:15], [UIView getWidth:15])];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(closeSelectView) forControlEvents:UIControlEventTouchUpInside];
    [_alphaView addSubview:backBtn];    
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(40,30, _alphaView.width-80, 30)];
    titleLbl.text = @"人员";
    titleLbl.font = [UIFont systemFontOfSize:17.0f];
    titleLbl.textColor = blackFontColor;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [_alphaView addSubview:titleLbl];
    
    [_alphaView addSubview:[ViewTool getLineViewWith:CGRectMake(0,63, _alphaView.width, 1) withBackgroudColor:grayListColor]];
    
    UIButton *resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(_alphaView.width-40, 35,[UIView getWidth:15], [UIView getWidth:15])];
    [resetBtn setBackgroundImage:[UIImage imageNamed:@"reset.png"] forState:UIControlStateNormal];
    [resetBtn setBackgroundImage:[UIImage imageNamed:@"reset.png"] forState:UIControlStateHighlighted];
    [resetBtn addTarget:self action:@selector(resetView:) forControlEvents:UIControlEventTouchUpInside];
    [_alphaView addSubview:resetBtn];
    
    self.isAll = NO;
    [self initTableView];
    _departs = [NSMutableArray array];
    _selectedDeparts = [NSMutableArray array];
    _selectedUsers = [NSMutableArray array];
    _users = [NSMutableArray array];
    _allUsers = [NSMutableArray array];
    _selectedArray = [NSMutableArray array];
    [self initData];
    [self addSearchBar];
    
//    UILabel *lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, KSCreenH-TabbarH-1, _alphaView.width, 1)];
//    lineLab.layer.borderWidth = 1;
//    lineLab.layer.borderColor = [graySectionColor CGColor];
//    [_alphaView addSubview:lineLab];
    
    UIView *line = [ViewTool getLineViewWith:CGRectMake(0, KSCreenH-TabbarH-1, _alphaView.width, 1) withBackgroudColor:grayListColor];
    [_alphaView addSubview:line];
    _selectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_selectBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [_selectBtn setTitleColor:mainOrangeColor forState:UIControlStateNormal];
    [_selectBtn.titleLabel setFont:[UIView getFontWithSize:15.0f]];
    _selectBtn.frame = CGRectMake(0, KSCreenH-TabbarH, _alphaView.width, TabbarH);
    _selectBtn.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [_selectBtn addTarget:self action:@selector(selectStaff) forControlEvents:UIControlEventTouchUpInside];
    
    [_alphaView addSubview:_selectBtn];

}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.hidesBottomBarWhenPushed = YES;
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    self.navigationController.navigationBarHidden = YES;
//    self.tabBarController.hidesBottomBarWhenPushed = NO;
//}

- (void)goToBack{
    [_selectedDeparts removeAllObjects];
    [_selectedUsers removeAllObjects];
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
//- (void)viewWillDisappear:(BOOL)animated
//{
//    self.tabBarController.hidesBottomBarWhenPushed = YES;
//}
//- (void)viewWillAppear:(BOOL)animated
//{
//    self.tabBarController.hidesBottomBarWhenPushed = NO;
//}

- (void)refresh{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, _alphaView.width, _alphaView.height-64-TabbarH)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_alphaView addSubview:_tableView];
    _tableView.hidden = NO;
    
    _staffTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, _alphaView.width, _alphaView.height-64-TabbarH)];
    _staffTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _staffTableView.delegate = self;
    _staffTableView.dataSource = self;
    [_alphaView addSubview:_staffTableView];
    _staffTableView.hidden = YES;
    
}

-(void)selectStaff{
    if (_isAllSelected) {
        if (_allUsers.count == 0) {
            [self addAllUsers2];
        }else{
            [_delegate getSelectedStaff:_allUsers];
        }
    }else{
        if (_selectedArray.count == 0) {
            [self.view makeToast:@"请选择人员"];
            return;
        }else{
            [_delegate getSelectedStaff:_selectedArray];
        }
    
//    if (_selectedUsers.count != 0) {
//        [_selectedArray addObjectsFromArray:_selectedUsers];
//    }
//    
//    if (_selectedDeparts.count != 0) {
//
//    }else{
//        [_delegate getSelectedStaff:_selectedArray];
//    }
    }
    [self goToBack];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_searchBar resignFirstResponder];
    [_searchBar2 resignFirstResponder];
}

-(void)closeSelectView{
    [_searchBar resignFirstResponder]; //退出键盘
    [_searchBar2 resignFirstResponder];
    if (self.tableView.hidden) {
        self.tableView.hidden = NO;
        self.staffTableView.hidden = YES;
        [_users removeAllObjects];
        [self.staffTableView reloadData];
    }else{
        [self goToBack];
    }
}

-(void)resetView:(UIButton *)btn{
    [_selectedDeparts removeAllObjects];
    [_selectedUsers removeAllObjects];
    [_tableView reloadData];
    [_staffTableView reloadData];
}

//SelectStaffViewCellDelegate
- (void)selectAllIsSelected:(BOOL)isSelected{
    if (isSelected) {
        _isAllSelected = YES;
        [self addAllUsers2];
    }else{
        _isAllSelected = NO;
//        [_allUsers removeAllObjects];
//        [self removeAllUsers];
    }
    
}

- (void)selectDepart:(DepartmentModel *)model isSelected:(BOOL)isSelected{
    if (isSelected) {
        [self.selectedDeparts addObject:model];
        [self getSelectedDepartStaff:model];
    }else{
        [self.selectedDeparts removeObject:model];
        [self removeSelectedDepartStaff:model];
    }
}
- (void)selectUser:(UserModel *)model isSelected:(BOOL)isSelected{
    if (isSelected) {
        [self.selectedArray addObject:model];
    }else{
        [self.selectedArray removeObject:model];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (tableView == _tableView) {
        if (_isSearching) {
            return _searchArray.count;
        }
        return _departs.count+1;
    }else{
        if (_isSearching) {
            return _searchArray2.count;
        }if (_isAll) {
            return _allUsers.count;
        }
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
        if (indexPath.row == 0) {
            cell = [[SelectStaffViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier withDapart:nil];
            cell.delegate = self;
        }else{
        
            DepartmentModel *depart;
            if (_isSearching) {
                depart=_searchArray[indexPath.row-1];
            }else{
                depart=_departs[indexPath.row-1];
            }
        
            cell = [[SelectStaffViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier withDapart:depart];
            cell.delegate = self;
        }
    }else{
        UserModel *user;
        if (_isSearching) {
            user=_searchArray2[indexPath.row];
        }else if(_isAll){
            NSLog(@"12121");
            user=_allUsers[indexPath.row];
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
        if (indexPath.row == 0) {
            self.isAll = YES;
            [self addAllUsers];
        }else{
            self.isAll = NO;
            [self getDepartStaff:_departs[indexPath.row-1]];
        }
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
    //    [self.view resetSearch]; //重新 加载分类数据
    [_searchBar resignFirstResponder]; //退出键盘
}

#pragma mark 输入搜索关键字
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if([searchText isEqual:@""]){
        _isSearching=NO;
        
        [self.tableView reloadData];
        [self.staffTableView reloadData];
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, searchBar.maxY , _searchBar.width, KSCreenH - searchBar.maxY - 64)];
        _backView.backgroundColor = [UIColor clearColor];
        if(_tableView.hidden){
            [self.staffTableView insertSubview:_backView atIndex:1];
        }else{
            [_tableView insertSubview:_backView atIndex:1];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [_backView addGestureRecognizer:tap];

        return;
    }
    [self searchDataWithKeyWord:searchText withSearchBar:searchBar];
}
- (void)handleTap:(UIGestureRecognizer *)tap
{
    UIView *view = tap.view;
    [view removeFromSuperview];
    [_searchBar resignFirstResponder];
    [_searchBar2 resignFirstResponder];
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
    [self.view makeToastActivity];
    NSDictionary * params2 = [NSDictionary dictionaryWithObjectsAndKeys:@(UID), @"uid", TOKEN, @"token", nil];
    AFHTTPRequestOperationManager * manager2 = [AFHTTPRequestOperationManager manager];
    manager2.requestSerializer.timeoutInterval = 20;
    [manager2 POST:GET_DEPARTMENT_URL parameters:params2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.view hideToastActivity];
        NSLog(@"GET_DEPARTMENT_URL:%@",responseObject);
        NSArray * userArray = [(NSDictionary *)responseObject objectForKey:@"data"];
        for (NSDictionary *dapart in userArray) {
            _model = [[DepartmentModel alloc]init];
            [_model setValuesForKeysWithDictionary:dapart];
            [_departs addObject:_model];
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view hideToastActivity];
        NSLog(@"%@",error);
    }];
}

//GET_USER_BY_DEPARTMENT_URL
- (void)addAllUsers{

    if (_allUsers.count == 0) {
    [self.view makeToastActivity];
    NSDictionary * dic =@{@"token":TOKEN,@"uid":@(UID)};
    [DataTool sendGetWithUrl:BUSINESS_ADDRESS_BOOK_URL parameters:dic success:^(id data) {
        [self.view hideToastActivity];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *array = jsonDic[@"data"];
        for (int i =0; i<array.count; i++) {
            //sfsdf
            UserModel *userModel = [[UserModel alloc]init];
            id dd = [DataTool changeType:array[i]];
            [userModel setValuesForKeysWithDictionary:dd];
            [_allUsers addObject:userModel];
        }
        [_staffTableView reloadData];
    } fail:^(NSError *error) {
        [self.view hideToastActivity];
        NSLog(@"%@",error);
    }];
    }
}

- (void)addAllUsers2{

    if (_allUsers.count == 0) {
        [self.view makeToastActivity];
        NSDictionary * dic =@{@"token":TOKEN,@"uid":@(UID)};
        [DataTool sendGetWithUrl:BUSINESS_ADDRESS_BOOK_URL parameters:dic success:^(id data) {
            [self.view hideToastActivity];
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSMutableArray *array = jsonDic[@"data"];
            for (int i =0; i<array.count; i++) {
                UserModel *userModel = [[UserModel alloc]init];
                id dd = [DataTool changeType:array[i]];
                [userModel setValuesForKeysWithDictionary:dd];
                [_allUsers addObject:userModel];
            }
            [_delegate getSelectedStaff:_allUsers];
        } fail:^(NSError *error) {
            [self.view hideToastActivity];
            NSLog(@"%@",error);
        }];
    }else{
       [_delegate getSelectedStaff:_allUsers];
    }
}

- (void)getDepartStaff:(DepartmentModel *)depart{
    [_users removeAllObjects];
    [self.view makeToastActivity];
    NSDictionary * params2 = [NSDictionary dictionaryWithObjectsAndKeys:@(UID), @"uid", TOKEN, @"token", @(depart.departId), @"department", nil];
    AFHTTPRequestOperationManager * manager2 = [AFHTTPRequestOperationManager manager];
    manager2.requestSerializer.timeoutInterval = 20;
    [manager2 POST:GET_USER_BY_DEPARTMENT_URL parameters:params2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.view hideToastActivity];
        NSLog(@"GET_USER_BY_DEPARTMENT_URL:%@",responseObject);
        NSArray * departArray = [(NSDictionary *)responseObject objectForKey:@"data"];
        for (NSDictionary *user  in departArray) {
            _userModel = [[UserModel alloc]init];
            [_userModel setValuesForKeysWithDictionary:user];
            [_users addObject:_userModel];
        }
        [_staffTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view hideToastActivity];
        NSLog(@"%@",error);
    }];
}

- (void)getSelectedDepartStaff:(DepartmentModel *)depart{
    [self.view makeToastActivity];
    NSDictionary * params2 = [NSDictionary dictionaryWithObjectsAndKeys:@(UID), @"uid", TOKEN, @"token", @(depart.departId), @"department", nil];
    AFHTTPRequestOperationManager * manager2 = [AFHTTPRequestOperationManager manager];
    manager2.requestSerializer.timeoutInterval = 20;
    [manager2 POST:GET_USER_BY_DEPARTMENT_URL parameters:params2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.view hideToastActivity];
        NSLog(@"GET_USER_BY_DEPARTMENT_URL:%@",responseObject);
        NSArray * departArray = [(NSDictionary *)responseObject objectForKey:@"data"];
        for (NSDictionary *user  in departArray) {
            _userModel = [[UserModel alloc]init];
            [_userModel setValuesForKeysWithDictionary:user];
//            NSString *uid = [NSString stringWithFormat:@"%d",_userModel.uid];
            [_selectedArray addObject:_userModel];
            NSLog(@"12121212");
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view hideToastActivity];
        NSLog(@"%@",error);
    }];
}

- (void)removeSelectedDepartStaff:(DepartmentModel *)depart{
    
    for (UserModel *user in _selectedArray) {
        if (user.department == depart.departId) {
            [_selectedArray removeObject:user];
        }
    }
    
//    
//    NSDictionary * params2 = [NSDictionary dictionaryWithObjectsAndKeys:@(UID), @"uid", TOKEN, @"token", @(depart.departId), @"department", nil];
//    AFHTTPRequestOperationManager * manager2 = [AFHTTPRequestOperationManager manager];
//    manager2.requestSerializer.timeoutInterval = 20;
//    [manager2 POST:GET_USER_BY_DEPARTMENT_URL parameters:params2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"GET_USER_BY_DEPARTMENT_URL:%@",responseObject);
//        NSArray * departArray = [(NSDictionary *)responseObject objectForKey:@"data"];
//        for (NSDictionary *user  in departArray) {
//            _userModel = [[UserModel alloc]init];
//            [_userModel setValuesForKeysWithDictionary:user];
//            //            NSString *uid = [NSString stringWithFormat:@"%d",_userModel.uid];
//            [_selectedArray addObject:_userModel];
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",error);
//    }];
}


#pragma mark 搜索形成新数据
-(void)searchDataWithKeyWord:(NSString *)keyWord withSearchBar:(UISearchBar *)searchBar{
    _isSearching=YES;
    _searchArray=[NSMutableArray array];
    _searchArray2=[NSMutableArray array];
    
    if (searchBar == _searchBar) {
        for (DepartmentModel *depart in _departs) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {//ios8出来的方法
                
                if ([depart.dname.uppercaseString containsString:keyWord.uppercaseString]) {
                    [_searchArray addObject:depart];
                }
                
            }else{
                
                NSRange range = [depart.dname.uppercaseString rangeOfString:keyWord.uppercaseString];
                if(range.length > 0)
                {
                    [_searchArray addObject:depart];
                    
                }
            }
        }
        //刷新表格
        [self.tableView reloadData];
        
    }else{

        UserModel *user;
        for (int i = 0; i < _allUsers.count; i++) {
            if (_isAll) {
                user = _allUsers[i];
            }else{
                user = _users[i];
            }
        }
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {//ios8出来的方法
            
            if ([user.name.uppercaseString containsString:keyWord.uppercaseString]) {
                [_searchArray2 addObject:user];
            }
                
        }else{
                
            NSRange range = [user.name.uppercaseString rangeOfString:keyWord.uppercaseString];
            if(range.length > 0){
                [_searchArray2 addObject:user];
            }
        }
        //刷新表格
        [self.staffTableView reloadData];
    }
    
}

#pragma mark 添加搜索栏
-(void)addSearchBar{
//    CGRect searchBarRect=CGRectMake(0, 0, _alphaView.width, 44);
    UIView *vi1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _alphaView.width, 44)];
    vi1.backgroundColor  = graySectionColor;
//    [self.view addSubview:vi1];
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, vi1.width , 44)];
    [_searchBar setBackgroundImage:[ViewTool getImageFromColor:graySectionColor WithRect:_searchBar.frame]];
    //    _searchBar.showsCancelButton = YES;
    _searchBar.placeholder =@"搜索";
    [vi1 addSubview:_searchBar];
    //    for (UIView *view in [_searchBar.subviews[0] subviews]) {
    //        if ([view isKindOfClass:[UIButton class]]) {
    //            UIButton *btn = (UIButton *)view;
    //            [btn setTitle:@"取消" forState:UIControlStateNormal];
    //            [btn setTitleColor:grayFontColor forState:UIControlStateNormal];
    //            btn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    //        }
    //    }
    _searchBar.delegate = self;

//    _searchBar=[[UISearchBar alloc]initWithFrame:searchBarRect];
//    _searchBar.placeholder=@"搜索";
//    _searchBar.showsCancelButton=YES;//显示取消按钮
    //添加搜索框到页眉位置
//    _searchBar.delegate=self;
    
    self.tableView.tableHeaderView = vi1;
//    CGRect searchBarRect2=CGRectMake(0, 0, _alphaView.width, 44);
    UIView *vi2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _alphaView.width, 44)];
    vi2.backgroundColor  = graySectionColor;
//    [self.view addSubview:vi2];
    
    _searchBar2 = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, vi2.width , 44)];
    [_searchBar2 setBackgroundImage:[ViewTool getImageFromColor:graySectionColor WithRect:_searchBar.frame]];
    //    _searchBar.showsCancelButton = YES;
    _searchBar2.placeholder =@"搜索";
    [vi2 addSubview:_searchBar2];
    //    for (UIView *view in [_searchBar.subviews[0] subviews]) {
    //        if ([view isKindOfClass:[UIButton class]]) {
    //            UIButton *btn = (UIButton *)view;
    //            [btn setTitle:@"取消" forState:UIControlStateNormal];
    //            [btn setTitleColor:grayFontColor forState:UIControlStateNormal];
    //            btn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    //        }
    //    }
    _searchBar2.delegate = self;

//    _searchBar2=[[UISearchBar alloc]initWithFrame:searchBarRect2];
//    _searchBar2.placeholder=@"搜索";
//    _searchBar2.showsCancelButton=YES;//显示取消按钮
    //添加搜索框到页眉位置
//    _searchBar2.delegate=self;
    
    self.staffTableView.tableHeaderView = vi2;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
     [_searchBar resignFirstResponder]; //退出键盘
}
@end
