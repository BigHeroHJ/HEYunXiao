//
//  NoticeViewController.m
//  移动营销
//
//  Created by Hanen 3G 01 on 16/2/24.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//公告页

#import "NoticeViewController.h"
#import "NoticeModel.h"
#import "NoticeCell.h"
#import "ManagerNoticeBtnView.h"
#import "NoticeDetailController.h"
#import "DistributeNoticeController.h"

@interface NoticeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView      * _noticeTableView;
    NSMutableArray   *_dataArray;
    BOOL  isManager;
    BOOL  isOtherNotice;
    int        _pageCount;
    
//    NSInteger  _notReadCount;
    NSMutableArray  *_isreadArr;
    NSMutableArray  *_isNotReadArr;
}
@property (nonatomic, strong)ManagerNoticeBtnView * topBtnView;
@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _dataArray = [NSMutableArray array];
    _isreadArr = [NSMutableArray array];
    _isNotReadArr  = [NSMutableArray array];
    _pageCount = 1;
    
    if ([TYPE isEqualToString:@"1"]) {
        isManager = NO;
    }else if([TYPE isEqualToString:@"2"]){
        isManager = YES;
        
    }
    NSLog(@"是否是管理员 ： %d",isManager);
    isOtherNotice = YES;
  
//    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithString:@"新建" WithAction:@selector(createNewDistibute)];
//    self.topBtnView = [[ManagerNoticeBtnView alloc] initWithFrame:CGRectMake(0, 0, [UIView getWidth:200], 44)];
//    self.topBtnView.rightTitle = @"我的公告";
//    self.topBtnView.leftTitle = @"其他公告";
//    self.topBtnView.delegate = self;
//    if (isManager) {
//        self.navigationItem.titleView = self.topBtnView;
//        
//    }else{
          self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:@"公告"];
//    }
  
//      [self initData];
//    [self initData1];//已读数据
    [self initTableView];
  
    
    self.navigationItem.leftBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithAction:@selector(popLastView)];
}
#pragma mark --获取数据
- (void)initData //普通用户和管理员我的公告列表是 一样的根据uid type 是什么类型//未读的
{
    
    NSMutableDictionary * paramesdictionary = [NSMutableDictionary dictionaryWithDictionary: @{@"token": TOKEN,@"uid" : @(UID)}];
    NSLog(@"%@,-----%d",TOKEN,UID);
    NSString *url ;
    if (isManager) {
        url =  MANAGERS_NOTICE_URL;
    }else{
        url = COMMEN_USER_NOTICE_URL;
        [paramesdictionary setObject: @(0) forKey:@"isread"];
    }
     [DataTool sendGetWithUrl:url parameters:paramesdictionary success:^(id data) {
             id backData = CRMJsonParserWithData(data);
         NSLog(@"未读%@",backData);
         NSMutableArray *dataArr = backData[@"list"];
         for (int i = 0; i < dataArr.count; i ++) {
             NoticeModel * model = [[NoticeModel alloc] init];
//             [model setValuesForKeysWithDictionary:dataArr[i]];
         
             model.addtime = dataArr[i][@"addtime"];
             model.title = dataArr[i][@"title"];
             model.name = dataArr[i][@"name"];
             model.logo = dataArr[i][@"logo"];
             model.noticeId = [dataArr[i][@"id"] intValue];
             if (!isManager) {
                 model.isread = 0;
                 
             }
             
             [_dataArray addObject:model];
         }
         if(!isManager){
             [self initData1];//已读数据
         }
//         _notReadCount = [dataArr count];
//         [_dataArray addObjectsFromArray:_isreadArr];
         [_noticeTableView reloadData];
     } fail:^(NSError *error) {
         NSLog(@"%@",error.localizedDescription);
     }];
    
}
- (void)initData1 //普通用户和管理员我的公告列表是 一样的根据uid type 是什么类型//已读的
{
    NSMutableDictionary * paramesdictionary = [NSMutableDictionary dictionaryWithDictionary: @{@"token": TOKEN,@"uid" : @(UID)}];
    NSLog(@"%@,-----%d",TOKEN,UID);
    NSString *url ;
    if (isManager) {
        url =  MANAGERS_NOTICE_URL;
    }else{
        url = COMMEN_USER_NOTICE_URL;
        [paramesdictionary setObject: @(1) forKey:@"isread"];
    }
    [DataTool sendGetWithUrl:url parameters:paramesdictionary success:^(id data) {
        id backData = CRMJsonParserWithData(data);
        NSLog(@"已读%@",backData);
        NSMutableArray *dataArr = backData[@"list"];
        for (int i = 0; i < dataArr.count; i ++) {
            NoticeModel * model = [[NoticeModel alloc] init];
//            [model setValuesForKeysWithDictionary:dataArr[i]];
            if (!isManager) {
                model.isread = 1;
            }
            model.addtime = dataArr[i][@"addtime"];
            model.title = dataArr[i][@"title"];
            model.name = dataArr[i][@"name"];
            model.logo = dataArr[i][@"logo"];
            model.noticeId = [dataArr[i][@"id"] intValue];
            [_dataArray addObject:model];
        }
//        for (NoticeModel *model1 in _dataArray) {
//            NSLog(@"是否已读 %@",model1.isread);
//        }
//        [_dataArray addObjectsFromArray:_isNotReadArr];
        [_noticeTableView reloadData];
    } fail:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
   
}

- (void)initTableView
{
    _noticeTableView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 64, KSCreenW, KSCreenH - 64) style:UITableViewStylePlain];
    _noticeTableView.delegate = self;
    _noticeTableView.dataSource = self;
    _noticeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _noticeTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_noticeTableView];
//    self.view.selectedBackgroundView = selcectBackView;
//    selcectBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:.1];
    
}

#pragma mark --tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
//    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeCell * cell = [NoticeCell cellWithTableView:tableView];
    NoticeModel *model2 = _dataArray[indexPath.row];
    cell.model = model2;
//    if (indexPath.row > _notReadCount - 1) {
//        cell.redLable.hidden = YES;
//    }
    cell.ismanager = isManager;
    NSLog(@"%d",model2.isread);
    if(isManager){
         cell.redLable.hidden = YES;
    }else{
        if(model2.isread == 1){
              cell.redLable.hidden = YES;
        }
    }
    
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NoticeCell cellHeight];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NoticeDetailController * noticeDetailVC = [[NoticeDetailController alloc] init];
    NoticeModel *model = _dataArray[indexPath.row];
    noticeDetailVC.BigTitle = model.title;
    noticeDetailVC.noticeID = [NSString stringWithFormat:@"%d",model.noticeId];//说是传入id是int类型
    if(!model.isread){
    [self changeNoticeReaderWithID:model.noticeId];
    }
    
    NSLog(@"公告的id %@",@(model.noticeId));
    [self.navigationController pushViewController:noticeDetailVC animated:YES];
    
}
- (void)changeNoticeReaderWithID:(int)NoticeId
{
    NSDictionary *dict = @{@"token" : TOKEN,@"uid" : @(UID),@"nid" : @(NoticeId)};
    NSLog(@"修改公告的参数%@",dict);
    [DataTool sendGetWithUrl:XIUGAI_NOTICE_READER_URL  parameters:dict success:^(id data) {
        id backData = CRMJsonParserWithData(data);
        NSLog(@"backData  %@",backData);
        if ([backData[@"code"] intValue] == 100) {
            [self.view makeToast:@"已读"];
        }
    } fail:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark --managerBtnchange delagte
//- (void)changeNoticeView:(NSInteger)tag
//{
//    
//    if (tag == 122) {
//        isOtherNotice = YES;
//        [self.topBtnView.otherNotice setTitleColor:darkOrangeColor forState:UIControlStateNormal];
//        [self.topBtnView.myNotice setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateNormal];
//        self.topBtnView.redLine1.backgroundColor = darkOrangeColor;
//        self.topBtnView.redLine2.backgroundColor = [UIColor whiteColor];
//        
//     
//        
//    }else if (tag == 123){
//        isOtherNotice = NO;
//        [self.topBtnView.otherNotice setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateNormal];
//        [self.topBtnView.myNotice setTitleColor:darkOrangeColor forState:UIControlStateNormal];
//        self.topBtnView.redLine1.backgroundColor = [UIColor whiteColor];
//        self.topBtnView.redLine2.backgroundColor = darkOrangeColor;
//        
//    }
//}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    [_dataArray removeAllObjects];
    [self initData];
    
   
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)popLastView
{
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)createNewDistibute
//{
//    DistributeNoticeController *ditribute = [[DistributeNoticeController alloc] init];
//    [self.navigationController pushViewController:ditribute animated:YES];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
