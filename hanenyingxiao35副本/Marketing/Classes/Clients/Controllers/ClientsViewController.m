//
//  ClientsViewController.m
//  移动营销
//
//  Created by Hanen 3G 01 on 16/2/23.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "ClientsViewController.h"
#import "MyClientButton.h"
#import "MyClientView.h"
#import "MyClientCell.h"
#import "DetailClientViewController.h"
#import "NewClientViewController.h"
#import "ClientModel.h"
#import "MyTabBarController.h"
#import "SelectViewController.h"


#define STARTX [UIView getWidth:10]
#define MYCELLHEIGHT 60.0f
#define OTHERCELLHEIGHT 85.0f


@interface ClientsViewController ()<MyClientViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate,SelectStaffViewDelegate,MyClientCellDelegate>
{
    UIView          *view;
    UIView          *pxView;
    BOOL            isMyClient;
    NSArray         *_titleArray;
    UISearchBar     *_searchBar;
    UISearchBar     *_pxSearchBar;
    
    NSMutableArray  *_myDataArr;
    NSMutableArray  *_otherDataArr;
    
    UILabel         *_myBasicLabel;
    UILabel         *_otherBasicLabel;
    UIView   *_backView;
    
}
@property(nonatomic,assign)BOOL  isManager;

@property(nonatomic,strong)MyClientView    *topBtnView;
@property(nonatomic,strong)MyClientButton  *taxisBtn;
@property(nonatomic,strong)MyClientButton  *paixuBtn;

@property (strong, nonatomic) UIView *backView;

/**
 *  排序界面
 */
@property(nonatomic,strong)UITableView     *taxisTableView;
@property(nonatomic,strong)UIView          *taxisView;

@property(nonatomic,strong)UITableView     *paixuTableView;
@property(nonatomic,strong)UIView          *paixuView;
/**
 *  我的客户
 */
@property(nonatomic,strong)UITableView     *myClientTableView;
@property(nonatomic,strong)UIView          *myClientView;

/**
 *  下属客户
 */
@property(nonatomic,strong)UITableView     *otherClientTableView;
@property(nonatomic,strong)UIView          *otherClientView;

@property(nonatomic,strong)NSMutableArray        *levelArr;
@property(nonatomic,strong)NSMutableArray        *fromArr;
@property(nonatomic,strong)NSMutableArray        *statusArr;

@end

@implementation ClientsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton =YES;
    isMyClient =YES;
    _myDataArr = [NSMutableArray array];
    _otherDataArr = [NSMutableArray array];
    
    _levelArr = [NSMutableArray array];
    _fromArr = [NSMutableArray array];
    _statusArr = [NSMutableArray array];
    
    _titleArray = @[@"按拜访时间排序",@"按创建时间排序",@"按名称排序",@"按级别排序"];
    NSString *type = [[[NSUserDefaults standardUserDefaults]objectForKey:@"type"] stringValue];
    if ([type isEqualToString:@"2"]) {
        _isManager = YES;
        _topBtnView = [[MyClientView alloc] initWithFrame:CGRectMake(0, 0, [UIView getWidth:200], 44) withLeftTitle:nil andRightTitle:nil];
        _topBtnView.delegate = self;
        self.navigationItem.titleView = _topBtnView;
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 43, KSCreenW, 0.5)];
        lineLabel.backgroundColor = grayLineColor;
        [_topBtnView addSubview:lineLabel];
        if (isMyClient == YES) {
            //[self getTestData:1 WithSearch:@""];
            
        }else{
            int mydata;
                mydata = (int)[_titleArray indexOfObject:_paixuBtn.currentTitle] +1;

            [self initOtherData:mydata WithSearch:@""];
           
        }
    }else{
        _isManager = NO;
        self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:@"我的客户"];
        //[self getTestData:1 WithSearch:@""];
        
    }
    
    self.navigationItem.rightBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithString:@"新建" WithAction:@selector(clickToNewClient:)];
    
    [self initViews];
    [self addViews];
    
    //获取数据字典
    [self getDictWith:1];//等级
    [self getDictWith:2];//状态
    [self getDictWith:3];//来源
    
}
#pragma mark
#pragma mark------数据字典
- (void)getDictWith:(int)number{
    
    NSNumber *num =[NSNumber numberWithInt:number];
    NSDictionary * dic =@{@"token":TOKEN,@"uid":@(UID),@"type":num };
    [DataTool postWithUrl:GET_DICTIONARY_URL parameters:dic success:^(id data) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *mutArray = [(NSDictionary *)jsonDic objectForKey:@"list"];
        NSLog(@"%@opopopopooopooppo",jsonDic);
                if (number == 1) {
                    for (int i=0; i<mutArray.count; i++) {
                        NSDictionary *dicc = mutArray[i];
                    [_levelArr addObject:dicc[@"level"]];
                    }
                }else if (number == 2){
                    for (int i=0; i<mutArray.count; i++) {
                        NSString *level = [mutArray[i] objectForKey:@"level"];
                    [_statusArr addObject:level];
                    }
                }else if (number == 3){
                    for (int i=0; i<mutArray.count; i++) {
                        NSString *level1 = [mutArray[i] objectForKey:@"level"];
                    [_fromArr addObject:level1];
                    }
                }
                NSLog(@"%@%@%@",_levelArr,_statusArr,_fromArr);
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)initViews{
    
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KSCreenW, 44)];
    view.backgroundColor  = graySectionColor;
    [self.view addSubview:view];
    //排序旋钮
    _taxisBtn = [[MyClientButton alloc]initWithFrame:CGRectMake([UIView getWidth:10], 0, 120.0f, 44)];
    [_taxisBtn setTitle:@"按拜访时间排序" forState:UIControlStateNormal];
//    _taxisBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    _taxisBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    _taxisBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_taxisBtn setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateNormal];
    [_taxisBtn setTitleColor:grayFontColor forState:UIControlStateNormal];
    [_taxisBtn addTarget:self action:@selector(btnClickToGetTaxisList:) forControlEvents:UIControlEventTouchUpInside];
    _taxisBtn.isSelected = NO;
    [view addSubview:_taxisBtn];
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(_taxisBtn.maxX + [UIView getWidth:10], [UIView getHeight:10], 1, view.height - 2*[UIView getHeight:10])];
    lineView1.backgroundColor = grayLineColor;
    [view addSubview:lineView1];
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(lineView1.maxX + [UIView getWidth:5], 0, KSCreenW -lineView1.maxX - [UIView getWidth:5] , 44)];
    [_searchBar setBackgroundImage:[ViewTool getImageFromColor:graySectionColor WithRect:_searchBar.frame]];
//       _searchBar.showsCancelButton = YES;
    _searchBar.placeholder =@"搜索";
    _searchBar.delegate   = self;
    [view addSubview:_searchBar];
    
    
    [self initMyClientView];
    
    [self createTaxisView];
}
- (void)addViews{
    pxView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KSCreenW, 44)];
    pxView.backgroundColor  = graySectionColor;
    pxView.hidden = YES;
    [self.view addSubview:pxView];
    //排序旋钮
    _paixuBtn = [[MyClientButton alloc]initWithFrame:CGRectMake([UIView getWidth:10], 0, 120.0f, 44)];
    [_paixuBtn setTitle:@"按拜访时间排序" forState:UIControlStateNormal];
    //    _taxisBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    _paixuBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    _paixuBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_paixuBtn setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateNormal];
    [_paixuBtn setTitleColor:grayFontColor forState:UIControlStateNormal];
    [_paixuBtn addTarget:self action:@selector(btnClickToGetTaxisList:) forControlEvents:UIControlEventTouchUpInside];
    _paixuBtn.isSelected = NO;
    [pxView addSubview:_paixuBtn];
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(_paixuBtn.maxX + [UIView getWidth:10], [UIView getHeight:10], 1, pxView.height - 2*[UIView getHeight:10])];
    lineView1.backgroundColor = grayLineColor;
    [pxView addSubview:lineView1];
    
    _pxSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(lineView1.maxX + [UIView getWidth:5], 0, KSCreenW -lineView1.maxX - [UIView getWidth:5] , 44)];
    [_pxSearchBar setBackgroundImage:[ViewTool getImageFromColor:graySectionColor WithRect:_pxSearchBar.frame]];
    //       _searchBar.showsCancelButton = YES;
    _pxSearchBar.placeholder =@"搜索";
    _pxSearchBar.delegate   = self;
    [pxView addSubview:_pxSearchBar];
    
    [self initOtherClientView];
    
    [self createPaixuView];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
    _searchBar.text = @"";
    if (isMyClient == YES) {
        int mydata;
            mydata = (int)[_titleArray indexOfObject:_taxisBtn.currentTitle] +1;;
        [self getTestData:mydata WithSearch:@""];
    }else{
        int mydata;
            mydata = (int)[_titleArray indexOfObject:_paixuBtn.currentTitle] +1;
        [self initOtherData:mydata WithSearch:@""];
    }
}
/**
 *  创建排序界面
 */
- (void)createTaxisView{
    
    _taxisTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, view.maxY, KSCreenW, _titleArray.count*40) style:UITableViewStylePlain];
    _taxisTableView.alpha = 0;
    _taxisTableView.delegate = self;
    _taxisTableView.dataSource = self;
    _taxisTableView.scrollEnabled = NO;
    _taxisTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_taxisTableView];
    
    _taxisView = [[UIView alloc]initWithFrame:CGRectMake(0, _taxisTableView.maxY, KSCreenW, KSCreenH)];
    _taxisView.backgroundColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1];
    _taxisView.alpha = 0;
    [self.view addSubview:_taxisView];
    //加个手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToHideTaxisView:)];
    [_taxisView addGestureRecognizer:tapGesture];
}
- (void)createPaixuView{
    _paixuTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, pxView.maxY, KSCreenW, _titleArray.count*40) style:UITableViewStylePlain];
    _paixuTableView.alpha = 0;
    _paixuTableView.delegate = self;
    _paixuTableView.dataSource = self;
    _paixuTableView.scrollEnabled = NO;
    _paixuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_paixuTableView];
    
    _paixuView = [[UIView alloc]initWithFrame:CGRectMake(0, _paixuTableView.maxY, KSCreenW, KSCreenH)];
    _paixuView.backgroundColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1];
    _paixuView.alpha = 0;
    [self.view addSubview:_paixuView];
    //加个手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToHideTaxisView:)];
    [_paixuView addGestureRecognizer:tapGesture];

}
- (void)tapToHideTaxisView:(UITapGestureRecognizer *)tapGesture{
    [UIView animateWithDuration:0.25 animations:^{
        if (isMyClient) {
            _taxisTableView.alpha = 0;
            _taxisView.alpha      = 0;
            [_taxisBtn setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateNormal];
        }else{
            _paixuTableView.alpha = 0;
            _paixuView.alpha      = 0;
            [_paixuBtn setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateNormal];
        }
        
    }];
}

- (void)btnClickToGetTaxisList:(MyClientButton *)btn{
    if (isMyClient) {
        if (btn.isSelected == NO) {
            [UIView animateWithDuration:0.25 animations:^{
                _taxisTableView.alpha = 1;
                _taxisView.alpha      = 0.7;
                [btn setImage:[UIImage imageNamed:@"下拉收回"] forState:UIControlStateNormal];
            }];
            btn.isSelected = YES;
            
        }else{
            [UIView animateWithDuration:0.25 animations:^{
                _taxisTableView.alpha = 0;
                _taxisView.alpha      = 0;
                [btn setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateNormal];
            }];
            btn.isSelected = NO;
        }

    }else{
        if (btn.isSelected == NO) {
            [UIView animateWithDuration:0.25 animations:^{
                _paixuTableView.alpha = 1;
                _paixuView.alpha      = 0.7;
                [btn setImage:[UIImage imageNamed:@"下拉收回"] forState:UIControlStateNormal];
            }];
            btn.isSelected = YES;
            
        }else{
            [UIView animateWithDuration:0.25 animations:^{
                _paixuTableView.alpha = 0;
                _paixuView.alpha      = 0;
                [btn setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateNormal];
            }];
            btn.isSelected = NO;
        }

    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_searchBar resignFirstResponder];
    [_pxSearchBar resignFirstResponder];
    self.tabBarController.hidesBottomBarWhenPushed = NO;
    self.navigationController.navigationBarHidden = NO;
    
    int mydata;
        mydata = (int)[_titleArray indexOfObject:_taxisBtn.currentTitle] +1;

    [self getTestData:mydata WithSearch:@""];
 
}
- (void)viewDidAppear:(BOOL)animated
{
    [_searchBar resignFirstResponder];
    [_pxSearchBar resignFirstResponder];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [_searchBar resignFirstResponder];
    [_pxSearchBar resignFirstResponder];
    
//       self.tabBarController.hidesBottomBarWhenPushed = NO;
    
    
    if (isMyClient) {
        _taxisTableView.alpha = 0;
        _taxisView.alpha      = 0;
        [_taxisBtn setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateNormal];
        _taxisBtn.isSelected = NO;
    }else{
        _paixuTableView.alpha = 0;
        _paixuView.alpha      = 0;
        [_paixuBtn setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateNormal];
        _paixuBtn.isSelected = NO;
    }
}

/**
 *  我的客户
 */
- (void)initMyClientView{
    _myClientView = [[UIView alloc]initWithFrame:CGRectMake(0, view.maxY, KSCreenW, KSCreenH-view.maxY )];
    //_myClientView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_myClientView];
    
    _myClientTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, KSCreenH - view.maxY - TabbarH) style:UITableViewStylePlain];
    _myClientTableView.delegate   = self;
    _myClientTableView.dataSource =self;
    _myClientTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //_myClientTableView.tableFooterView = [[UIView alloc]init];
    
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW - 2*STARTX, [UIView getHeight:30])];
    //客户总数
    _myBasicLabel = [[UILabel alloc]initWithFrame:CGRectMake(STARTX, [UIView getHeight:5], 200, [UIView getHeight:20])];
    //_myBasicLabel.text = [NSString stringWithFormat:@"共有%@位客户",_customerCount];
    _myBasicLabel.textColor = grayFontColor;
    _myBasicLabel.font = [UIFont systemFontOfSize:14.0f];
    [headerView addSubview:_myBasicLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STARTX, [UIView getHeight:30] - 1, KSCreenW - 2*STARTX, 1)];
    lineView.backgroundColor = grayLineColor;
    [headerView addSubview:lineView];
    
    _myClientTableView.tableHeaderView = headerView;
    
    [_myClientView addSubview:_myClientTableView];
}
/**
 *  下属客户
 */
- (void)initOtherClientView{
    _otherClientView = [[UIView alloc]initWithFrame:CGRectMake(0, pxView.maxY, KSCreenW, KSCreenH-pxView.maxY)];
    _otherClientView.hidden = YES;
    //_otherClientView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_otherClientView];
    
    _otherClientTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, KSCreenH - pxView.maxY -TabbarH) style:UITableViewStylePlain];
    _otherClientTableView.delegate   = self;
    _otherClientTableView.dataSource =self;
    _otherClientTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //_otherClientTableView.tableFooterView = [[UIView alloc]init];
    [_otherClientView addSubview:_otherClientTableView];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW - 2*STARTX, [UIView getHeight:30])];
    //客户总数
    _otherBasicLabel = [[UILabel alloc]initWithFrame:CGRectMake(STARTX, [UIView getHeight:5], 200, [UIView getHeight:20])];
    //_otherBasicLabel.text = [NSString stringWithFormat:@"共有%@位客户",_customerCount];
    _otherBasicLabel.font = [UIFont systemFontOfSize:14.0f];
    _otherBasicLabel.textColor = grayFontColor;
    [headerView addSubview:_otherBasicLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STARTX, [UIView getHeight:30] - 1, KSCreenW - 2*STARTX, 1)];
    lineView.backgroundColor = grayLineColor;
    [headerView addSubview:lineView];
    
    _otherClientTableView.tableHeaderView = headerView;
}
#pragma mark --MyClientView delagte

- (void)changeNoticeView:(NSInteger)tag
{
    if (tag == 1111) {//下属客户
        int mydata;
            mydata = (int)[_titleArray indexOfObject:_paixuBtn.currentTitle] +1;

        [self initOtherData:mydata WithSearch:@""];
        
        isMyClient = NO;
        _myClientView.hidden = YES;
        _otherClientView.hidden = NO;
        view.hidden = YES;
        pxView.hidden = NO;
        
        [_topBtnView.otherClient setTitleColor:darkOrangeColor forState:UIControlStateNormal];
        [_topBtnView.myClient setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateNormal];
        _topBtnView.redLine1.backgroundColor = darkOrangeColor;
        _topBtnView.redLine2.backgroundColor = TabbarColor;
        
        self.navigationItem.leftBarButtonItem  = [ViewTool getBarButtonItemWithTarget:self WithString:@"筛选" WithAction:@selector(clickToselectClient:)];
        self.navigationItem.rightBarButtonItem = nil;
        
        [_searchBar resignFirstResponder];
        [_pxSearchBar resignFirstResponder];
        
    }else if (tag == 2222){//我的客户
        
        isMyClient =YES;
        _myClientView.hidden = NO;
        _otherClientView.hidden = YES;
        view.hidden = NO;
        pxView.hidden = YES;
        
        
        [_topBtnView.otherClient setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateNormal];
        [_topBtnView.myClient setTitleColor:darkOrangeColor forState:UIControlStateNormal];
        _topBtnView.redLine1.backgroundColor = TabbarColor;
        _topBtnView.redLine2.backgroundColor = darkOrangeColor;
        
        self.navigationItem.leftBarButtonItem  = nil;
        self.navigationItem.rightBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithString:@"新建" WithAction:@selector(clickToNewClient:)];
        //
        int mydata;
            mydata = (int)[_titleArray indexOfObject:_taxisBtn.currentTitle] +1;

        [self getTestData:mydata WithSearch:@""];
        
        [_searchBar resignFirstResponder];
        [_pxSearchBar resignFirstResponder];
    }
}
//新建客户
- (void)clickToNewClient:(UIButton *)sender{
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;//可更改为其他方式
    transition.subtype = kCATransitionFromTop;//可更改为其他方式
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    NewClientViewController * vc  = [[NewClientViewController alloc]init];
    vc.levelArray = _levelArr;
    vc.fromArray = _fromArr;
    vc.statusArray = _statusArr;
    
    [self.navigationController pushViewController:vc animated:NO];
}
//选择下属客户
- (void)clickToselectClient:(UIButton *)sender{
    
    SelectViewController *selectViewController = [[SelectViewController alloc]init];
    selectViewController.modalPresentationStyle =  UIModalPresentationPageSheet;
    selectViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    selectViewController.delegate = self;
    [self.navigationController pushViewController:selectViewController animated:YES];
    
//    [self presentViewController:selectViewController animated:YES completion:^{
//        selectViewController.view.superview.frame = CGRectMake(0, 0, KSCreenW, KSCreenH);
//        //        lagerPicVC.view.superview.center = CGPointMake(1024/2, 748/2);
//    }];
}
- (void)closeStaffView{
    NSLog(@"sssssssssssssss");
}

//SelectStaffViewDelegate
- (void)getSelectedStaff:(NSArray *)array{
    
    NSMutableArray *ids = [NSMutableArray array];
    for (UserModel *user in array) {
        NSString *uid = [NSString stringWithFormat:@"%d",user.uid];
        [ids addObject:uid];
    }
    
    [self OtherData:1 withArray:ids];
}

#pragma mark
#pragma mark ------tableView的协议方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_taxisTableView) {
        return 40;
    }else if (tableView == _paixuTableView){
        return 40;
    }else if (tableView == _myClientTableView){
        return MYCELLHEIGHT;
    }else if (tableView == _otherClientTableView){
        return OTHERCELLHEIGHT;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_taxisTableView) {
        return _titleArray.count;
    }else if (tableView == _paixuTableView){
        return _titleArray.count;
    }else if (tableView == _myClientTableView){
        return _myDataArr.count;
    }else if (tableView == _otherClientTableView){
        return _otherDataArr.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _taxisTableView) {
         static NSString *identifier =@"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40-1, KSCreenW, 1)];
            lineView.backgroundColor = grayLineColor;
            [cell.contentView addSubview:lineView];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = _titleArray[indexPath.row];
        cell.textLabel.textColor = grayFontColor;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        
        return cell;
    }else if (tableView == _paixuTableView) {
        static NSString *identifier =@"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40-1, KSCreenW, 1)];
            lineView.backgroundColor = grayLineColor;
            [cell.contentView addSubview:lineView];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = _titleArray[indexPath.row];
        cell.textLabel.textColor = grayFontColor;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        
        return cell;
    }else if (tableView == _myClientTableView){
        
        static NSString *identifier =@"identifiercell";
        MyClientCell *cell1 = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell1 == nil) {
            cell1 = [[MyClientCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(STARTX, MYCELLHEIGHT - 1, KSCreenW -2*STARTX, 1)];
            lineView.backgroundColor = grayLineColor;
            [cell1.contentView addSubview:lineView];
        }
        //cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ClientModel *client = _myDataArr[indexPath.row];
        cell1.companyLabel.text = client.company;
//        cell1.addressLabel.text = client.address;
//        cell1.addressLabel.tag = 1212;
//        CGRect rect = cell1.addressbtn.frame;
//        CGFloat btnw = [(NSString *)client.address boundingRectWithSize:CGSizeMake(MAXFLOAT, rect.size.height) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName : grayFontColor, NSFontAttributeName :[UIFont systemFontOfSize:14.0f]} context:nil].size.width;
        //        NSLog(@"%f",btnw);
//        rect.size.width = btnw + 20;
        
//        cell1.addressbtn.frame = rect;
        
//        [cell1.addressbtn setTitle:client.address forState:UIControlStateNormal];
        cell1.addressLabel.text = client.address;

        if (client.status == 1 ) {
            //cell1.timeLabel.text = @"";
            if (client.visittime != nil) {
                NSString *hadVisitTime = client.visittime;
                NSDate *date = [NSDate date];
                NSDateFormatter *dateformate = [[NSDateFormatter alloc] init];
                [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *visitDate = [dateformate dateFromString:hadVisitTime];
                NSTimeInterval times = [date timeIntervalSinceDate:visitDate];
                int days = ABS((int)times / (3600 * 24));
                 if (days == 0 ) {
                    cell1.timeLabel.text = @"今日已拜访";
                }else if (days == 1){
                    cell1.timeLabel.text = @"昨日已拜访";
                }else{
                    cell1.timeLabel.text = [NSString stringWithFormat:@"%d天前拜访",days];
                }
            }else{
                cell1.timeLabel.text = @"未拜访";
            }
           
        }else{
            NSString*  sttt = [DataTool changeType:client.ordertime];
            NSString *orderTime = client.ordertime;
            if (![sttt isEqualToString:@""] && [sttt length] != 0) {
                    NSDate *date = [NSDate date];
                    NSDateFormatter *dateformate = [[NSDateFormatter alloc] init];
                    [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSDate *orderDate = [dateformate dateFromString:orderTime];
                    NSTimeInterval times = [date timeIntervalSinceDate:orderDate];
                    int days = ABS((int)times / (3600 * 24));
                    if (days == 0 ) {
                        cell1.timeLabel.text = @"今日未拜访";
                    }else{
                        cell1.timeLabel.text = [NSString stringWithFormat:@"%d天前未拜访",days];
                        
                    }
            }else{
                    cell1.timeLabel.text = @"未拜访";
            }
        }
    
//        cell1.statusLabel.textColor = blueFontColor;
        
        if ([client.clevelname isEqualToString:@"VIP客户"]) {
            cell1.levelImageView.image = [UIImage imageNamed:@"vip"];
        }else{
            cell1.levelImageView.image = [UIImage imageNamed:@"普通客户图标"];
        }

        CGSize size = [cell1.companyLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, [UIView getHeight:30]) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:cell1.companyLabel.font} context:nil].size;
        CGFloat imageX;
        if (size.width > [UIView getWidth:200]) {
            imageX = STARTX + [UIView getWidth:200];
        }else{
            imageX = STARTX + size.width;
        }
        cell1.levelImageView.frame = CGRectMake(imageX , 7.5, 20, 20);
        
//        [cell1.locationBtn addTarget:self action:@selector(clickToLocation:) forControlEvents:UIControlEventTouchUpInside];
        cell1.delegate = self;
        
        return cell1;
    }else if (tableView == _otherClientTableView){
        static NSString *identifier =@"cell";
        MyClientCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyClientCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(STARTX, OTHERCELLHEIGHT - 1, KSCreenW -2*STARTX, 1)];
            lineView.backgroundColor = grayLineColor;
            [cell.contentView addSubview:lineView];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ClientModel *client = _otherDataArr[indexPath.row];
        cell.companyLabel.text = client.company;
        
//        CGRect rect = cell.addressbtn.frame;
//        CGFloat btnw = [(NSString *)client.address boundingRectWithSize:CGSizeMake(MAXFLOAT, rect.size.height) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName : grayFontColor, NSFontAttributeName :[UIFont systemFontOfSize:14.0f]} context:nil].size.width;
        //        NSLog(@"%f",btnw);
//        rect.size.width = btnw + 20;
        
//        cell.addressbtn.frame = rect;
        
//        [cell.addressbtn setTitle:client.address forState:UIControlStateNormal];
        
        cell.addressLabel.text = client.address;
        cell.principalLabel.text = [NSString stringWithFormat:@"负责人>%@",client.cname];
        
        if (client.status == 1 ) {
            //cell.timeLabel.text = @" ";
            if (client.visittime && ![client.visittime isEqualToString:@""]) {
                NSString *hadVisitTime = client.visittime;
                NSDate *date = [NSDate date];
                NSDateFormatter *dateformate = [[NSDateFormatter alloc] init];
                [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *visitDate = [dateformate dateFromString:hadVisitTime];
                NSTimeInterval times = [date timeIntervalSinceDate:visitDate];
                int days = ABS((int)times / (3600 * 24));
                if (days == 0 ) {
                    cell.statusCenterLabel.text = @"今日已拜访";
                }else if (days == 1){
                    cell.statusCenterLabel.text = @"昨日已拜访";
                }else{
                    cell.statusCenterLabel.text = [NSString stringWithFormat:@"%d天前拜访",days];
                }
            }else{
                cell.statusCenterLabel.text = @"未拜访";
            }
            
        }else{
            //            NSLog(@"lient.order %@",client.ordertime);
            
            NSString*  sttt = [DataTool changeType:client.ordertime];

            if (![sttt isEqualToString:@""] && sttt.length !=0 ) {
                NSString *hadVisitTime = client.ordertime;
                NSDate *date = [NSDate date];
                NSDateFormatter *dateformate = [[NSDateFormatter alloc] init];
                [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *visitDate = [dateformate dateFromString:hadVisitTime];
                NSTimeInterval times = [date timeIntervalSinceDate:visitDate];
                int days = ABS((int)times / (3600 * 24));
                if (days == 0 ) {
                    cell.statusCenterLabel.text = @"今日未拜访";
                }else{
                    cell.statusCenterLabel.text = [NSString stringWithFormat:@"%d天前未拜访",days];
                }
            }else{
                cell.statusCenterLabel.text = @"未拜访";
            }
        }

//        cell.statusLabel.textColor = blueFontColor;
        
        
        
        CGSize size = [cell.companyLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, [UIView getHeight:30]) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:cell.companyLabel.font} context:nil].size;
        CGFloat imageX;
        if (size.width > [UIView getWidth:200]) {
            imageX = STARTX + [UIView getWidth:200];
        }else{
            imageX = STARTX + size.width;
        }
        cell.levelImageView.frame = CGRectMake(imageX , 7.5, 20, 20);
         cell.delegate = self;
        return cell;
       
    }
    return nil;
    
}
//跳转到我的客户详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _taxisTableView) {
        
        [_taxisBtn setTitle:_titleArray[indexPath.row] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.25 animations:^{
                _taxisTableView.alpha = 0;
                _taxisView.alpha      = 0;
            }];
        _taxisBtn.isSelected = NO;
        [_taxisBtn setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateNormal];
        [self getTestData:(int)indexPath.row+1 WithSearch:@""];
        
    }else if (tableView == _paixuTableView){
        [_paixuBtn setTitle:_titleArray[indexPath.row] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.25 animations:^{
            _paixuTableView.alpha = 0;
            _paixuView.alpha      = 0;
        }];
        _paixuBtn.isSelected = NO;
        [_paixuBtn setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateNormal];
        [self initOtherData:(int)indexPath.row+1 WithSearch:@""];
        
    } else if (tableView == _myClientTableView){
        ClientModel  *client = _myDataArr[indexPath.row];
        DetailClientViewController *vc = [[DetailClientViewController alloc]init];
        vc.cID = client.clientId;
        vc.model = client;
        vc.titleStr = client.company;
        
        vc.levelArray = _levelArr;
        vc.fromArray = _fromArr;
        vc.statusArray = _statusArr;
        
        NSLog(@"%d   clientID++++++ ",vc.cID);
        [self.navigationController pushViewController:vc animated:NO];
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (isMyClient) {
        [_searchBar resignFirstResponder];
    }else{
        [_pxSearchBar resignFirstResponder];
    }
    
    
}
//
//- (void)clickToLocation:(UIButton *)btn{
//    UILabel *label = [[btn superview] viewWithTag:1212];
//    NSLog(@"%@",label.text);
//    
//    if (self.delegate && [self.delegate respondsToSelector:@selector(getLocationOnMap:)]) {
//        [self.delegate getLocationOnMap:label.text];
//    }
//    
//    MapClientViewController *vc = [[MapClientViewController alloc]init];
//    
//    //[self.navigationController pushViewController:vc animated:NO];
//}
//
- (void)jumpControllerToMap:(NSString *)btnTitle
{
    MapClientViewController *mapClient = [[MapClientViewController alloc] init];
    [self.navigationController pushViewController:mapClient animated:YES];
}

#pragma mark
#pragma mark -----searchBar协议方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if (isMyClient == YES) {
        int mydata;
        mydata = (int)[_titleArray indexOfObject:_taxisBtn.currentTitle] +1;
        [self getTestData:mydata WithSearch:searchBar.text];
    }else{
        int mydata;
        mydata = (int)[_titleArray indexOfObject:_paixuBtn.currentTitle] +1;
        [self initOtherData:mydata WithSearch:searchBar.text];
    }
    
    if (isMyClient) {
        [_searchBar resignFirstResponder];
    }else{
        [_pxSearchBar resignFirstResponder];
    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
//        if ([searchBar.text isEqualToString:@""]) {
//            _backView = [[UIView alloc] initWithFrame:CGRectMake(0, searchBar.maxY + 64, KSCreenW, KSCreenH - searchBar.maxY - 64)];
//            _backView.backgroundColor = [UIColor clearColor];
//            [self.view addSubview:_backView];
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//            [_backView addGestureRecognizer:tap];
//        }else{
//    jkkljkjlkljkljkljkjlkljkjlkjlkjlk
//        }
    if (isMyClient == YES) {
        int mydata;
        mydata = (int)[_titleArray indexOfObject:_taxisBtn.currentTitle] +1;
        
        [self getTestData:mydata WithSearch:searchBar.text];
    }else{
        int mydata;
        mydata = (int)[_titleArray indexOfObject:_paixuBtn.currentTitle] +1;
        [self initOtherData:mydata WithSearch:searchBar.text];
    }
    if (isMyClient) {
        [_searchBar resignFirstResponder];
    }else{
        [_pxSearchBar resignFirstResponder];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)eve{
    
    if (isMyClient) {
        [_searchBar resignFirstResponder];
    }else{
        [_pxSearchBar resignFirstResponder];
    }
    //[self.view endEditing:YES];
}

#pragma mark
#pragma mark -----加载数据

- (void)getTestData:(int)count WithSearch:(NSString *)str{
    
    [_myDataArr removeAllObjects];
    
    NSNumber *sortNum = [NSNumber numberWithInt:count];
    NSNumber *sortwayNum = [NSNumber numberWithInt:2];
    if (count == 4) {
        sortwayNum = [NSNumber numberWithInt:1];
    }
    NSNumber *pagesNum = [NSNumber numberWithInt:1];
    NSNumber *rowsNum = [NSNumber numberWithInt:20];
    
    NSDictionary * dic =@{@"token":TOKEN,@"uid":@(UID),@"sort":sortNum,@"sortWay":sortwayNum,@"pages":pagesNum,@"rows":rowsNum,@"company":str};
    
    NSLog(@"%@",dic);
    [DataTool postWithUrl:MY_CLIENT_URL parameters:dic success:^(id data) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@-----",jsonDic);
        //NSString *customerCount = jsonDic[@"customerCount"];
        //_myBasicLabel.text = [NSString stringWithFormat:@"共有%@位客户",customerCount];
//        NSLog(@"%@paixushuju------------",jsonDic);
        NSMutableArray *array = [DataTool changeType:jsonDic[@"customerList"]];
        if (array) {
            _myBasicLabel.text = [NSString stringWithFormat:@"共有%lu位客户",(unsigned long)array.count];
        }
        
        for (int i= 0; i<array.count; i++) {
            ClientModel *client = [[ClientModel alloc]init];
//            NSLog(@"数组%@",array[i]);
            id dd = [DataTool changeType:array[i]];
            [client setValuesForKeysWithDictionary:dd];
            [_myDataArr addObject:client];
            
        }
        
            [_myClientTableView reloadData];
         
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)initOtherData:(int)count WithSearch:(NSString *)str{
    
    [_otherDataArr removeAllObjects];
    
    NSNumber *sortNum = [NSNumber numberWithInt:count];
    NSNumber *sortwayNum = [NSNumber numberWithInt:2];
    if (count == 4) {
        NSLog(@"klklkl6565656");
        sortwayNum = [NSNumber numberWithInt:1];
    }
    NSNumber *pagesNum = [NSNumber numberWithInt:1];
    NSNumber *rowsNum = [NSNumber numberWithInt:20];
    
    NSDictionary * dic =@{@"token":TOKEN,@"uid":@(UID),@"sort":sortNum,@"sortWay":sortwayNum,@"pages":pagesNum,@"rows":rowsNum,@"userid":str};
    [DataTool postWithUrl:OTHER_CLIENT_URL parameters:dic success:^(id data) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@-----",jsonDic);
        //NSString *customerCount = jsonDic[@"customerCount"];
        NSMutableArray *array = [DataTool changeType:jsonDic[@"customerList"]];
        if (array) {
            _otherBasicLabel.text = [NSString stringWithFormat:@"共有%lu位客户",(unsigned long)array.count];
        }
        
        for (int i= 0; i<array.count; i++) {
            ClientModel *client = [[ClientModel alloc]init];
            id dd = [DataTool changeType:array[i]];
            [client setValuesForKeysWithDictionary:dd];
            [_otherDataArr addObject:client];
        }
        
        [_otherClientTableView reloadData];
        
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)OtherData:(int)count withArray:(NSArray *)array{
    
    //[_otherDataArr removeAllObjects];
    
    NSNumber *sortNum = [NSNumber numberWithInt:count];
    NSNumber *sortwayNum = [NSNumber numberWithInt:2];
    if (count == 4) {
        NSLog(@"klklkl");
        sortwayNum = [NSNumber numberWithInt:1];
    }

    NSNumber *pagesNum = [NSNumber numberWithInt:1];
    NSNumber *rowsNum = [NSNumber numberWithInt:20];
    NSString *str = [array componentsJoinedByString:@","];
    
    NSDictionary * dic =@{@"token":TOKEN,@"uid":@(UID),@"sort":sortNum,@"sortWay":sortwayNum,@"pages":pagesNum,@"rows":rowsNum,@"userid":str};
    [DataTool postWithUrl:OTHER_CLIENT_URL parameters:dic success:^(id data) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@-----",jsonDic);
        //NSString *customerCount = jsonDic[@"customerCount"];
        //_otherBasicLabel.text = [NSString stringWithFormat:@"共有%@位客户",customerCount];
        NSMutableArray *array = jsonDic[@"customerList"];
        if (array) {
            _otherBasicLabel.text = [NSString stringWithFormat:@"共有%lu位客户",(unsigned long)array.count];
        }
        
        for (int i= 0; i<array.count; i++) {
            ClientModel *client = [[ClientModel alloc]init];
            id dd = [DataTool changeType:array[i]];
            [client setValuesForKeysWithDictionary:dd];
            [_otherDataArr addObject:client];
        }
        [_otherClientTableView reloadData];
        
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}
@end
