//
//  Person StatisticsController.m
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/1.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//个人统计

#import "Person StatisticsController.h"
#import "StatisticCell.h"
#import "StatisticModel.h"
#import "SginDetailViewController.h"

@interface Person_StatisticsController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView    *_tabeleView;
    
    NSMutableArray *_dataArray;
    
}
@end

@implementation Person_StatisticsController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if(!self.isManagerCheckSign){
        self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:[[NSUserDefaults standardUserDefaults] objectForKey:@"name"]];
    }else{
        
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:self.nameString];
    }
   
    self.automaticallyAdjustsScrollViewInsets = NO;
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    self.navigationItem.leftBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithAction:@selector(popViewcontroll)];
    
    [self drawTableView];

    [self initData];//初始化数据
}

- (void)drawTableView
{
    _tabeleView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KSCreenW, KSCreenH - 64) style:UITableViewStylePlain];
    _tabeleView.delegate = self;
    _tabeleView.dataSource = self;
    _tabeleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tabeleView];
    
}

- (void)initData
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid" : @(UID),@"token" : TOKEN}];
    NSString *url ;
    if (!self.isManagerCheckSign) {
        url = SIGN_STATISTIC_URL;
    }else{
        url = MANAGER_CHECK_WORKER_SIGN_LIST_URL;
        [dict setValue:@(self.mansId) forKey:@"id"];
    }
       [DataTool sendGetWithUrl:url parameters:dict success:^(id data) {
        id backData = CRMJsonParserWithData(data);
        NSLog(@"%@",backData);
        NSArray * listArr = backData [@"list"];
        for (int i = 0; i < listArr.count; i ++) {
            StatisticModel * model = [[StatisticModel alloc] init];
            [model setValuesForKeysWithDictionary:listArr[i]];
            [_dataArray addObject:model];
        }
        [_tabeleView reloadData];
        
    } fail:^(NSError *error) {
        NSLog(@"error:%@",error.localizedDescription);
    }];
}
#pragma mark --tableview代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
//    return 10;
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StatisticCell *cell = [StatisticCell cellWithTableView:tableView];
    cell.model = _dataArray[indexPath.row];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [StatisticCell cellHeight];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SginDetailViewController *vc = [[SginDetailViewController alloc] init];
    StatisticModel *model = _dataArray[indexPath.row];
    vc.signImage = model.img;
    vc.company = model.company;
    vc.signType = model.type;
    vc.remarkSign = model.remark;
    vc.addTime = model.addtime;
    vc.currentPlace = model.address;
    vc.name =model.name;
    [self.navigationController  pushViewController:vc animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = NO;
}
- (void)popViewcontroll
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
