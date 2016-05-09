//
//  LeavingController.m
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/3.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "LeavingController.h"
#import "levaingCell.h"
#import "CreatLeavingController.h"
#import "LeavingDetailController.h"
#import "LeavingModel.h"

@interface LeavingController ()<UITableViewDataSource,UITableViewDelegate>
{
    CGFloat  space;
    UITableView  *_tableView;
    NSMutableArray *_dataArray;
    BOOL     isManger;
}
@end


@implementation LeavingController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IPhone4S) {
        space = 5.0f;
    }else{
        space = [UIView getWidth:10.0f];
    }
    if ([TYPE isEqualToString:@"1"]) {
        isManger = 0;
    }else{
        isManger = 1;
    }
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor = [UIColor whiteColor];
        self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:@"请假"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithAction:@selector(popViewController)];
//    
//    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 20, 20, 20)];
//    //    [btn setTitle:@"统计" forState:UIControlStateNormal];
//    //    [btn setTitleColor:darkOrangeColor forState:UIControlStateNormal];
//    //    btn.titleLabel.font = [UIView getFontWithSize:12.0f];
//    [btn setImage:[UIImage imageNamed:@"新建"] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(creatLeaving) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    self.navigationItem.rightBarButtonItem = rightBarItem;
     self.navigationItem.rightBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithString:@"新建" WithAction:@selector(creatLeaving)];
    [self drawtableView];
//    [self initData];
}

- (void)initData
{
    [_dataArray removeAllObjects];
    NSDictionary *paramdict = @{@"token" : TOKEN,@"uid" : @(UID)};
    [DataTool sendGetWithUrl:LEAVING_COMMEN_URL parameters:paramdict success:^(id data) {
        id backData = CRMJsonParserWithData(data);
        NSLog(@"请假数据%@",backData);
        NSArray * dataArr = backData[@"list"];
        for (int i = 0; i < dataArr.count; i++) {
            LeavingModel *model = [[LeavingModel alloc] init];
            [model setValuesForKeysWithDictionary:dataArr[i]];
            [_dataArray addObject:model];
        }
        if(dataArr){
          [_tableView reloadData];
        }
       
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)drawtableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KSCreenW, KSCreenH - TabbarH) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
}


#pragma mark --tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    levaingCell * cell = [levaingCell cellWithTableView:tableView];
    cell.model = _dataArray[indexPath.row];
   
//    cell.isWaitingApproval = NO;//看数据 中的已审批和待审批的设定 这个boo值
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LeavingDetailController * leaving = [[LeavingDetailController alloc] init];
    LeavingModel *model = _dataArray[indexPath.row];
    NSLog(@"请假列表的id %d",model.leavingID);
    leaving.leaveID = model.leavingID;
    leaving.lstatusType = model.lstatus;
    [self.navigationController pushViewController:leaving animated:YES];
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [levaingCell cellHeight];
}


- (void)creatLeaving
{
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;//可更改为其他方式
    transition.subtype = kCATransitionFromTop;//可更改为其他方式
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    CreatLeavingController * creatVC = [[CreatLeavingController alloc] init];
   
    [self.navigationController pushViewController:creatVC animated:NO];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.hidesBottomBarWhenPushed = YES;
      [self initData];
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
