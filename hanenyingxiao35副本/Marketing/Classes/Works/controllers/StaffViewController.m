//
//  StaffViewController.m
//  Marketing
//
//  Created by wmm on 16/3/11.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "StaffViewController.h"
#import "DepartmentModel.h"
#import "UserModel.h"
#import "SelectStaffViewCell.h"
#import "StaffDetailViewController.h"
#import "DepartModifyViewController.h"

#define STARTX [UIView getWidth:20]

@interface StaffViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray     *_userArray;
}

@property (strong, nonatomic) UITableView *departStaffTableView;


@end

@implementation StaffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = _depart.dname;

    self.navigationItem.leftBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithAction:@selector(popViewController)];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleBordered target:self action:@selector(clickToSetDepartment)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    self.navigationItem.rightBarButtonItem.tintColor = mainOrangeColor;
    _userArray = [NSMutableArray array];
    [self initTableView];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    [_departStaffTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = YES;
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initData{
    [_userArray removeAllObjects];
    [self.view makeToastActivity];
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:@(UID), @"uid", TOKEN, @"token", @(_depart.departId), @"department", nil];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:GET_USER_BY_DEPARTMENT_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.view hideToastActivity];
        
        NSLog(@"GET_USER_BY_DEPARTMENT_URL:%@",responseObject);
        NSArray * departArray = [(NSDictionary *)responseObject objectForKey:@"data"];
        NSLog(@"%@",departArray);
        for (NSDictionary *user  in departArray) {
            UserModel *userModel = [[UserModel alloc]init];
            [userModel setValuesForKeysWithDictionary:user];
            [_userArray addObject:userModel];
        }
        [_departStaffTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view hideToastActivity];
        NSLog(@"%@",error);
    }];
}

- (void)initTableView{
    _departStaffTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCreenW, KSCreenH-64)];
    _departStaffTableView.dataSource = self;
    _departStaffTableView.delegate = self;
    _departStaffTableView.separatorStyle = UITableViewCellSelectionStyleNone;//去掉分割线
    [self.view addSubview:_departStaffTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickToSetDepartment{
    DepartModifyViewController *departModifyViewController = [[DepartModifyViewController alloc] init];
    departModifyViewController.depart = _depart;
    [self.navigationController pushViewController:departModifyViewController animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _userArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    SelectStaffViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        UserModel *user = _userArray[indexPath.row];
        cell = [[SelectStaffViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withUser:user];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    StaffDetailViewController *staffDetailViewController = [[StaffDetailViewController alloc] init];
    UserModel *user = _userArray[indexPath.row];
    staffDetailViewController.user = user;
    [self.navigationController pushViewController:staffDetailViewController animated:YES];
}

@end
