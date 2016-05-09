//
//  ApprovalController.m
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/2.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//审批

#import "ApprovalController.h"
#import "ManagerNoticeBtnView.h"
#import "ApprovalCell.h"
#import "ApprovalDetailController.h"
#import "LeavingModel.h"

@interface ApprovalController ()<ManagerNoticeBtnViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UIView        *_topView;
    UITextField   *_searchfield;
    
    UITableView   *_tableView;
    NSMutableArray *_dataArray;
    
    NSMutableArray *_waiteArray;
    NSMutableArray *_hadHandleArray;
    
    UITableView   *_tableView2;
    
    UITableView   *_searchTableView;
    
    BOOL    isWaiteHanle;
    CGFloat   space;
    
    NSMutableArray  *_searchArray;
    BOOL  isSeacher;
    
    
    UIButton  *_cancelBtn;
    
    UISearchBar   *_searchBar;
    
    UIView  *_backView;
    
}

@end

@implementation ApprovalController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IPhone4S) {
        space = 5.0f;
    }else{
        space = [UIView getWidth:10.0f];
    }
    isWaiteHanle = YES;
    isSeacher = NO;
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.title = @"审批";
//    _dataArray = [NSMutableArray arrayWithCapacity:0];
    _waiteArray = [NSMutableArray arrayWithCapacity:0];
    _hadHandleArray = [NSMutableArray arrayWithCapacity:0];
     _searchArray=[NSMutableArray array];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithAction:@selector(popViewController)];
    self.approvleBtnView = [[ManagerNoticeBtnView alloc] initWithFrame:CGRectMake(0, 0, [UIView getWidth:200], 44)];

    self.navigationItem.titleView = self.approvleBtnView;
    self.approvleBtnView.rightTitle = @"已审批";
    
    
    //获取待审批的 数字
    NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"待审批(%@)",@".."]];
    [attributeStr setAttributes:@{NSForegroundColorAttributeName : darkOrangeColor,NSFontAttributeName : [UIView getFontWithSize:11.0f]} range:NSMakeRange(0, attributeStr.length)];
    [attributeStr setAttributes:@{NSForegroundColorAttributeName : darkOrangeColor,NSFontAttributeName : [UIView getFontWithSize:13.0f]} range:NSMakeRange(0, 3)];
    self.approvleBtnView.leftAttributeStr = attributeStr;
    [self setTopBtnAttributeStrWithClick:YES];
    
//    self.approvleBtnView.leftTitle = @"待审批";
    self.approvleBtnView.delegate = self;
    
    [self drawSearchField];
    [self drawtableView];
//    [self initWaiteAppro];
//    [self initHadAppro];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow1:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide1:) name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)setTopBtnAttributeStrWithClick:(BOOL)isClick//是否被点击
{
    //获取待审批的 数字
    NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"待审批(%d)",(int)_waiteArray.count]];
    [attributeStr setAttributes:@{NSForegroundColorAttributeName : darkOrangeColor,NSFontAttributeName : [UIFont systemFontOfSize:14.0f]} range:NSMakeRange(0, attributeStr.length)];
    [attributeStr setAttributes:@{NSForegroundColorAttributeName : darkOrangeColor,NSFontAttributeName : [UIFont systemFontOfSize:17.0f]} range:NSMakeRange(0, 3)];
    if(!isClick){
//        [attributeStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:0.4 alpha:1]} range:NSMakeRange(0, attributeStr.length)];
        [attributeStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:0.4 alpha:1],NSFontAttributeName : [UIFont systemFontOfSize:14.0f]} range:NSMakeRange(0, attributeStr.length)];
        [attributeStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:0.4 alpha:1],NSFontAttributeName : [UIFont systemFontOfSize:17.0f]} range:NSMakeRange(0, 3)];
    }
    self.approvleBtnView.leftAttributeStr = attributeStr;
}
- (void)drawSearchField
{
    
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KSCreenW, 44)];
    _topView.backgroundColor  = graySectionColor;
    [self.view addSubview:_topView];
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, KSCreenW , 44)];
    [_searchBar setBackgroundImage:[ViewTool getImageFromColor:graySectionColor WithRect:_searchBar.frame]];
//    _searchBar.showsCancelButton = YES;
    _searchBar.placeholder =@"搜索";
//    for (UIView *view in [_searchBar.subviews[0] subviews]) {
//        if ([view isKindOfClass:[UIButton class]]) {
//            UIButton *btn = (UIButton *)view;
//            [btn setTitle:@"取消" forState:UIControlStateNormal];
//            [btn setTitleColor:grayFontColor forState:UIControlStateNormal];
//            btn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
//        }
//    }
    _searchBar.delegate = self;
    [_topView addSubview:_searchBar];

//    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, KSCreenW, 44)];
//    _topView.backgroundColor = graySectionColor;
//    [self.view addSubview:_topView];
//    
//    
//    _searchfield = [[UITextField alloc] initWithFrame:CGRectMake(  space, 0.75 * space , _topView.width - 6 * space , _topView.height - 1.5 * space)];
//    _searchfield.delegate = self;
//    _searchfield.layer.cornerRadius = 5;
//    _searchfield.layer.masksToBounds = YES;
//    _searchfield.backgroundColor = [UIColor whiteColor];
//    [_topView addSubview:_searchfield];
//    
//    
//    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(_searchfield.maxX + 0.5 * space, _searchfield.y, _topView.width - _searchfield.maxX - space, _searchfield.height)];
//    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//    [_cancelBtn setTitleColor:grayFontColor forState:UIControlStateNormal];
//    _cancelBtn.titleLabel.font = [UIView getFontWithSize:11.0f];
//    [_topView addSubview:_cancelBtn];
//    [_cancelBtn addTarget:self action:@selector(cancelFind) forControlEvents:UIControlEventTouchUpInside];
//    CGFloat btnW = [UIView getWidth:13];
    
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(_searchfield.width / 2.0 - btnW/2.0, 5, btnW, _searchfield.height - 10)];
////    btn.backgroundColor = [UIColor redColor];
//    [btn setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
//    btn.imageView.frame = CGRectMake(0, 0, btn.width * 0.5, btn.width);
//    [btn setTitle:@"搜索" forState:UIControlStateNormal];
//    [btn setTitleColor:blackFontColor forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIView getFontWithSize:12.0f];
//    [_searchfield addSubview:btn];
//    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(_searchfield.width / 2.0 - (_searchfield.height - 13), 5, _searchfield.height - 13, _searchfield.height - 13)];
//    imageV.tag = 393939;
//    imageV.image= [UIImage imageNamed:@"搜索"];
//    UILabel *la = [ViewTool getLabelWith:CGRectMake(_searchfield.width / 2.0f, 5, 30, _searchfield.height - 10) WithTitle:@"搜索" WithFontSize:14.0 WithTitleColor:grayFontColor WithTextAlignment:NSTextAlignmentRight];
//    la.tag = 383838;
//    [_searchfield addSubview:la];
//    [_searchfield addSubview:imageV];
    
}

- (void)drawtableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _topView.maxY, KSCreenW, KSCreenH - _topView.maxY) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0, _topView.maxY, KSCreenW, KSCreenH - _topView.maxY) style:UITableViewStylePlain];
    [self.view addSubview:_tableView2];
//    _tableView2.backgroundColor = blueFontColor;
    _tableView2.hidden = YES;
    _tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView2.delegate = self;
    _tableView2.dataSource = self;
    
    
    _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _topView.maxY, KSCreenW, KSCreenH - _topView.maxY) style:UITableViewStylePlain];
//    _searchTableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_searchTableView];
    //    _tableView2.backgroundColor = blueFontColor;
    _searchTableView.hidden = YES;
    _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    
}
#pragma mark -- 获取数据
- (void)initWaiteAppro
{
    [_waiteArray removeAllObjects];
    NSDictionary *dict = @{@"token" : TOKEN,@"uid": @(UID),@"lstatus": @(0)};
    [DataTool sendGetWithUrl:MANAGER_RECIVE_LEAVING_LIST_URL parameters:dict success:^(id data) {
        id backData = CRMJsonParserWithData(data);
        NSLog(@"backData待审批 ：%@",backData);
      
        NSArray *listArray = backData[@"list"];
        for (int i = 0; i< listArray.count; i++) {
           LeavingModel *model = [[LeavingModel alloc] init];
           [model setValuesForKeysWithDictionary:listArray[i]];
            [_waiteArray addObject:model];
            
        }
//        [_tableView2 reloadData];
        [_tableView reloadData];
         [self setTopViewNum];
    } fail:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)initHadAppro
{
    [_hadHandleArray removeAllObjects];
    NSDictionary *dict = @{@"token" : TOKEN,@"uid": @(UID),@"lstatus": @(1)};
    [DataTool sendGetWithUrl:MANAGER_RECIVE_LEAVING_LIST_URL parameters:dict success:^(id data) {
        id backData = CRMJsonParserWithData(data);
        NSLog(@"backData已审批%@",backData);
        
        NSArray *listArray = backData[@"list"];
        for (int i = 0; i< listArray.count; i++) {
            LeavingModel *model = [[LeavingModel alloc] init];
            [model setValuesForKeysWithDictionary:listArray[i]];
            [_hadHandleArray addObject:model];
            
        }
                [_tableView2 reloadData];
//        [_tableView reloadData];
//        [self setTopViewNum];
    } fail:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}
- (void)setTopViewNum
{
    [self setTopBtnAttributeStrWithClick:YES];
//    NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"待审批(%ld)",_waiteArray.count]];
//    [attributeStr setAttributes:@{NSForegroundColorAttributeName : darkOrangeColor,NSFontAttributeName : [UIView getFontWithSize:11.0f]} range:NSMakeRange(0, attributeStr.length)];
//    [attributeStr setAttributes:@{NSForegroundColorAttributeName : darkOrangeColor,NSFontAttributeName : [UIView getFontWithSize:13.0f]} range:NSMakeRange(0, 3)];
//     self.approvleBtnView.leftAttributeStr = attributeStr;
}
#pragma mark --tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!isSeacher) {
        if (tableView == _tableView) {
            return _waiteArray.count;
        }else{
            return _hadHandleArray.count;
        }
    }else{
        return _searchArray.count;
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isSeacher) {
        if (tableView == _tableView) {
            ApprovalCell * cell = [ApprovalCell cellWithTableView:tableView];
            cell.model = _waiteArray[indexPath.row];
//            cell.isWaitingApproval = YES;
            return cell;
        }else if(tableView == _tableView2){
            ApprovalCell * cell = [ApprovalCell cellWithTableView:tableView];
            cell.model = _hadHandleArray[indexPath.row];
//            cell.isWaitingApproval = NO;
            return cell;
        }
    }else if(tableView == _searchTableView){
        ApprovalCell * cell = [ApprovalCell cellWithTableView:tableView];
        cell.model = _searchArray[indexPath.row];
//        cell.isWaitingApproval = NO;
        return cell;
    }
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ApprovalDetailController * approvaVC = [[ApprovalDetailController alloc] init];
    LeavingModel *modle;
    
    if (tableView ==_tableView) {
        modle = _waiteArray[indexPath.row];
        approvaVC.lstatus = 0;
    }else if(tableView == _tableView2){
        modle = _hadHandleArray[indexPath.row];
        approvaVC.lstatus = 1;
    }else{
        modle = _searchArray[indexPath.row];
        approvaVC.lstatus = isWaiteHanle == YES ? 0 : 1;
    }
    approvaVC.leavingPersonLogo = modle.logo;
    approvaVC.leavingPersonName = modle.name;
     approvaVC.approID = modle.leavingID;
    [_searchBar resignFirstResponder];
    [self.navigationController pushViewController:approvaVC animated:YES];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ApprovalCell cellHeight];
}
#pragma mark --textfiled 代理
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    
//}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    if ([searchBar.text isEqualToString:@""]) {
        isSeacher = NO;
        if (isWaiteHanle) {
            [_tableView reloadData];
        }else{
            [_tableView2 reloadData];
        }
    }else{
        [self findPersonName:searchBar.text];
    }
//    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [_searchArray removeAllObjects];
    if ([searchBar.text isEqualToString:@""]) {
        isSeacher = NO;
//           [_searchArray removeAllObjects];
//        if (isWaiteHanle) {
//            [_tableView reloadData];
//        }else{
//            [_tableView2 reloadData];
//        }
        _searchTableView.hidden = YES;
//        isSeacher = NO;
        if (isWaiteHanle) {
            _tableView.hidden = NO;
            [_tableView reloadData];
        }else {
            _tableView2.hidden = NO;
            [_tableView2 reloadData];
        }
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, searchBar.maxY + 64, KSCreenW, KSCreenH - searchBar.maxY - 64)];
        _backView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_backView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [_backView addGestureRecognizer:tap];

        _searchfield.text = @"";
    }else{
        [self findPersonName:searchBar.text];
    }
}
- (void)handleTap:(UIGestureRecognizer *)tap
{
    UIView *view = tap.view;
    [view removeFromSuperview];
    [_searchBar resignFirstResponder];
}
- (void)findPersonName:(NSString *)nameStr{
//    NSLog(@"name%@",nameStr);
     isSeacher =YES;
   
    _searchTableView.hidden = NO;
    if (isWaiteHanle) {
        for (LeavingModel *model in _waiteArray) {
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {//ios8出来的方法
                
                if ([model.name.uppercaseString containsString:nameStr.uppercaseString]) {
                    [_searchArray addObject:model];
                }
                
            }else{
                NSRange range = [model.name.uppercaseString rangeOfString:nameStr.uppercaseString];
                if(range.length > 0)
                {
                    [_searchArray addObject:model];
                    
                }
            }
        }
        if (_searchArray.count != 0) {
            _tableView.hidden = YES;
            [_searchTableView reloadData];
        }
    }else
    {
        for (LeavingModel *model in _hadHandleArray) {
//              NSLog(@"model name %@,nameStr %@",model.name,nameStr);
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {//ios8出来的方法
              
                if ([model.name containsString:nameStr]) {
                    [_searchArray addObject:model];
                }
//                 NSLog(@"....%ld",_searchArray.count);
            }else{
                NSRange range = [model.name rangeOfString:nameStr];
                if(range.length > 0)
                {
                    [_searchArray addObject:model];
                    
                }
            }
//             NSLog(@"....%ld",_searchArray.count);
        }
//        if (_searchArray.count != 0) {
//            _tableView2.hidden = YES;
            [_searchTableView reloadData];
//        }
    }
//    NSLog(@"%ld",_searchArray.count);
}
- (void)cancelFind
{
    [_searchArray removeAllObjects];
    _searchTableView.hidden = YES;
    isSeacher = NO;
    if (isWaiteHanle) {
        _tableView.hidden = NO;
        [_tableView reloadData];
    }else {
        _tableView2.hidden = NO;
        [_tableView2 reloadData];
    }
    _searchfield.text = @"";
}

//- (void)text
#pragma mark --顶上按钮点击切换
- (void)changeNoticeView:(NSInteger)tag
{
    _searchfield.text = @" ";
    _searchTableView.hidden = YES;
    if (tag == 122) {//左边按钮
        [self setTopBtnAttributeStrWithClick:YES];
        [self.approvleBtnView.myNotice setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateNormal];
        self.approvleBtnView.redLine1.backgroundColor = darkOrangeColor;
        self.approvleBtnView.redLine2.backgroundColor = TabbarColor;
        isWaiteHanle = YES;
        _tableView.hidden = NO;
        _tableView2.hidden = YES;
//        isleftClick = YES;
        [self initWaiteAppro];
        
    }else if (tag == 123){
        [self setTopBtnAttributeStrWithClick:NO];
        [self.approvleBtnView.myNotice setTitleColor:darkOrangeColor forState:UIControlStateNormal];
        self.approvleBtnView.redLine1.backgroundColor = TabbarColor;
        self.approvleBtnView.redLine2.backgroundColor = darkOrangeColor;
        isWaiteHanle = NO;
        
        _tableView.hidden = YES;
        _tableView2.hidden = NO;
        [self initHadAppro];
    }
}
//键盘通知
- (void)keyboardWillShow1:(NSNotification *)noti
{
//    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, _searchBar.maxY + 64, KSCreenW, KSCreenH - _searchBar.maxY - 64)];
//    _backView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:_backView];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackView)];
//    [_backView addGestureRecognizer:tap];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
   
}
- (void)keyboardWillHide1:(NSNotification *)noti
{
    
}
- (void)tapBackView
{
    [_searchBar resignFirstResponder];
    [_searchArray removeAllObjects];
    _searchTableView.hidden = YES;
    isSeacher = NO;
    if (isWaiteHanle) {
        _tableView.hidden = NO;
        [_tableView reloadData];
    }else {
        _tableView2.hidden = NO;
        [_tableView2 reloadData];
    }
    _searchfield.text = @"";
    
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.hidesBottomBarWhenPushed = YES;
//    [self initWaiteAppro];
//    [self initHadAppro];
    
    if(isSeacher){
        [_searchTableView reloadData];
    }else{
        _searchTableView.hidden = YES;
        [_searchArray removeAllObjects];
        _tableView.hidden = NO;
        _tableView2.hidden = NO;
        if (isWaiteHanle) {
            [self changeNoticeView:122];
            
        }else{
            [self changeNoticeView:123];
        }
    }
    if([_searchBar isFirstResponder]){
        [_searchBar resignFirstResponder];
    }
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
