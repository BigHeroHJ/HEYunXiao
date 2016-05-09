//
//  ManagerCheckController.m
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/2.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//管理员日志查看

#import "ManagerCheckController.h"
#import "DailRecordCell.h"
#import "RecordModel.h"
#import "AppDelegate.h"
#import "MyTabBarController.h"
#import "RecordDetailController.h"
#import "SelectViewController.h"
#import "UserModel.h"

@interface ManagerCheckController ()<UITableViewDataSource,UITableViewDelegate,SelectStaffViewDelegate>
{
    UITableView  *_tableView;
    NSMutableArray  *_dataArray;
    
    int   pageCount;
    UserModel *usermodel;
//    SelectStaffView  *_selectStaffView;
//    UIView   *_backView;
}
@end


@implementation ManagerCheckController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray array];
    self.navigationItem.leftBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithAction:@selector(popViewController)];
    self.navigationItem.rightBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithString:@"筛选" WithAction:@selector(choosePerson:)];
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:@"日志查看"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addTableView];
    
    [self initAllData];
    
}

- (void)initAllData
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"token" : TOKEN,@"uid" : @(UID)}];
   
    [DataTool sendGetWithUrl:MANAGER_ALL_RECORD_URL parameters:dict success:^(id data) {
        id backData = CRMJsonParserWithData(data);
        NSLog(@"%@",backData);
        NSArray *dataArry = backData[@"list"];
        for (int i = 0; i< dataArry.count ; i++) {
            RecordModel * model = [[RecordModel alloc] init];
            [model setValuesForKeysWithDictionary:dataArry[i]];
            [_dataArray addObject:model];
        }
        [_tableView reloadData];
    } fail:^(NSError *error) {
        NSLog(@"error %@ ",error.localizedDescription);
    }];
}

- (void)addTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KSCreenW, KSCreenH - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DailRecordCell * cell = [DailRecordCell cellWithTableView:tableView];
    cell.model = _dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //dfdf234324
    return  [UIView getWidth:70];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RecordDetailController * recordDetaVC = [[RecordDetailController alloc] init];
    RecordModel *model = _dataArray[indexPath.row];
//        NSLog(@"%d,%d",_dataArray.count,model.recordId);
    recordDetaVC.recId = model.recordId;
    
    [self.navigationController pushViewController:recordDetaVC animated:YES];
    
}
//点击右上角的筛选
- (void)choosePerson:(UIButton*)btn
{
  
//    SelectViewController *selectViewController = [[SelectViewController alloc]init];
//    self.modalPresentationStyle =  UIModalPresentationPageSheet;
//    
//    selectViewController.delegate = self;
//    
//    [self presentViewController:selectViewController animated:YES completion:^{
//        selectViewController.view.superview.frame = CGRectMake(0, 0, KSCreenW, KSCreenH);
//    }];
    SelectViewController *selectViewController = [[SelectViewController alloc]init];
    selectViewController.modalPresentationStyle =  UIModalPresentationPageSheet;
    selectViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    selectViewController.delegate = self;
    
    [self.navigationController pushViewController:selectViewController animated:YES];
    
}
- (void)getSelectedStaff:(NSArray *)array
{
    if (array.count == 1) {
        usermodel = array[0];
        [self checkOneRecordWith:[NSString stringWithFormat:@"%d",usermodel.uid]];
    }
}
- (void)checkOneRecordWith:(NSString *)uid
{
    [_dataArray removeAllObjects];
    NSDictionary * dict = @{@"token" : TOKEN,@"uid" : @(UID),@"yuid" : @([uid intValue])};
    [DataTool sendGetWithUrl:MANAGER_CHECK_ONEWORKER_ALLREORD_URL parameters:dict success:^(id data) {
        id backData = CRMJsonParserWithData(data);
        NSLog(@"%@",backData);
        NSArray *dataArry = backData[@"list"];
        for (int i = 0; i< dataArry.count ; i++) {
            RecordModel * model = [[RecordModel alloc] init];
            [model setValuesForKeysWithDictionary:dataArry[i]];
            [_dataArray addObject:model];
        }
        [_tableView reloadData];
    } fail:^(NSError *error) {
        NSLog(@"error %@ ",error.localizedDescription);
    }];
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
- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
