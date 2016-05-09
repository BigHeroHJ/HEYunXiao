//
//  StaffManagerViewController.m
//  Marketing
//
//  Created by wmm on 16/3/4.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "StaffManagerViewController.h"
#import "DepartmentModel.h"
#import "StaffTableViewCell.h"
#import "StaffViewController.h"
#import "AddDepertViewController.h"

#define STARTX [UIView getWidth:10]

@interface StaffManagerViewController (){
    NSMutableArray     *_departArray;
    NSArray     *_departNumArray;
}

@property (strong, nonatomic) UITableView *departmentTableView;


@end

@implementation StaffManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:@"人员管理"];
    self.navigationItem.leftBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithAction:@selector(popViewController)];
    self.navigationItem.rightBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithString:@"新建" WithAction:@selector(clickToNewDepartment)];
    
    _departArray = [NSMutableArray array];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    [self initData];
    [_departmentTableView reloadData];
//    _departmentTableView.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = NO;
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)initData{
//    _departNameArray = @[@"行政部",@"人事部",@"销售部",@"运营部",@"客户服务部",@"投资发展部部"];
//    _departNumArray = @[@"21",@"2",@"3",@"4",@"5",@"16"];
//    [self initTableView];
//}
-(void)initData{
    [_departArray removeAllObjects];
    [self.view makeToastActivity];
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:@(UID), @"uid", TOKEN, @"token", nil];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:GET_DEPARTMENT_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.view hideToastActivity];
        NSLog(@"GET_DEPARTMENT_URL:%@",responseObject);
        NSArray * userArray = [(NSDictionary *)responseObject objectForKey:@"data"];
        for (NSDictionary *dapart in userArray) {
            DepartmentModel *model= [[DepartmentModel alloc]init];
            [model setValuesForKeysWithDictionary:dapart];
            [_departArray addObject:model];
        }
        [_departmentTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view hideToastActivity];
        NSLog(@"%@",error);
    }];
}

- (void)initTableView{
    _departmentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCreenW, KSCreenH)];
    _departmentTableView.separatorStyle = UITableViewCellSelectionStyleNone;//去掉分割线
    _departmentTableView.dataSource = self;
    _departmentTableView.delegate = self;
    [self.view addSubview:_departmentTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickToNewDepartment{
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;//可更改为其他方式
    transition.subtype = kCATransitionFromTop;//可更改为其他方式
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    AddDepertViewController *addDepertViewController = [[AddDepertViewController alloc] init];
    [self.navigationController pushViewController:addDepertViewController animated:NO];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _departArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELLHEIGHT2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SECTIONHEIGHT;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, 30)];
//    view.backgroundColor = graySectionColor;
//    
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(STARTX, 5, 5, 20)];
//    
//    imageView.image = [UIImage imageNamed:@"lanse.png"];
//    [view addSubview:imageView];
//    
//    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(STARTX + 10, 5, 100, 20)];
//    lab.text = @"组织架构";
//    lab.textColor = blackFontColor;
//    lab.font = [UIFont systemFontOfSize:12];
//    [view addSubview:lab];
//    
//    UIView *lineView = [ViewTool getLineViewWith:CGRectMake(STARTX, 30-1, KSCreenW - 2*STARTX, 1) withBackgroudColor:grayLineColor];
//    [view addSubview:lineView];
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, 30)];
    view.backgroundColor = graySectionColor;
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(STARTX, 8, 5, view.height - 16)];
    imageView1.image = [UIImage imageNamed:@"lanse"];
    [view addSubview:imageView1];
    
    UILabel *basicLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView1.maxX + 5, 5, 200, 20)];
    basicLabel.text = @"组织架构";
    basicLabel.font = [UIFont systemFontOfSize: 14.0f];
    basicLabel.textColor = blackFontColor;
    [view addSubview:basicLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 30 - 1, KSCreenW -STARTX*2, 1)];
    lineView.backgroundColor = grayLineColor;
    [view addSubview:lineView];
    
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    StaffTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        DepartmentModel *depart = _departArray[indexPath.row];
        NSLog(@"%@",_departArray[indexPath.row]);
        cell = [[StaffTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withDapart:depart];
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    StaffViewController *staffViewController = [[StaffViewController alloc] init];
    DepartmentModel *depart = _departArray[indexPath.row];
    staffViewController.depart = depart;
//    staffViewController.departId = depart.departId;
//    staffViewController.departName = depart.dname;
    [self.navigationController pushViewController:staffViewController animated:YES];
}

@end
