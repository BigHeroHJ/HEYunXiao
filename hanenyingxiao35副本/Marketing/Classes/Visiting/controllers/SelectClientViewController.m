//
//  SelectClientViewController.m
//  Marketing
//
//  Created by wmm on 16/3/6.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "SelectClientViewController.h"

@interface SelectClientViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSMutableArray *_searchArray;
    UIView  *_backView;
    BOOL  isSearch;
}
@property(nonatomic)       int customerCount;
@property(nonatomic,strong)NSMutableArray   *customerList;

@property(nonatomic,strong)NSMutableArray *companyList;
@property(nonatomic,strong)NSMutableArray *idList;
@property(nonatomic,strong)NSMutableArray *cnameList;
@property(nonatomic,strong)NSMutableArray *addressList;

//@property (strong, nonatomic) UISearchBar * searchBar;
@property(nonatomic,strong)UITableView         *clientTableView;
@property(nonatomic,strong) UISearchBar *searchBar;

@end

@implementation SelectClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isSearch = NO;
    self.view.backgroundColor =[UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:@"公司名称"];
    self.navigationItem.leftBarButtonItem=[ViewTool getBarButtonItemWithTarget:self WithAction:@selector(goToBack)];
    _searchArray = [NSMutableArray array];
    _companyList = [NSMutableArray array];
//    _idList = [NSMutableArray array];
//    _cnameList = [NSMutableArray array];
//    _addressList = [NSMutableArray array];

    [self addSearchBar];
    [self reloadData];

}
-(void)addSearchBar{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KSCreenW, 44)];
    view.backgroundColor  = graySectionColor;
    [self.view addSubview:view];
    
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
    [view addSubview:_searchBar];
    
//    self.tableView.tableHeaderView = _searchBar;
//    CGRect searchBarRect2=CGRectMake(0, 0, _alphaView.width, 44);
//    _searchBar2=[[UISearchBar alloc]initWithFrame:searchBarRect2];
//    _searchBar2.placeholder=@"搜索";
//    _searchBar2.showsCancelButton=YES;//显示取消按钮
//    //添加搜索框到页眉位置
//    _searchBar2.delegate=self;
//    
//    self.staffTableView.tableHeaderView = _searchBar2;
}
- (void)handleTap:(UIGestureRecognizer *)tap
{
    UIView *view = tap.view;
    [view removeFromSuperview];
    [_searchBar resignFirstResponder];
    [_searchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    isSearch = NO;
    [_searchArray removeAllObjects];
    [_clientTableView reloadData];
   
    
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    

//    NSArray * companyArray = [_customerList objectForKey:@"company"];
   
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [_backView removeFromSuperview];
    
     [_searchArray removeAllObjects];
    if(searchText != nil){
            isSearch = YES;
    }
    for (int i = 0; i < _companyList.count; i++) {
//        NSLog(@"%@",_companyList[i]);
        NSString *companyStr = _companyList[i];
        NSRange rang = [companyStr rangeOfString:searchText];
        if (rang.length != 0) {
            [_searchArray addObject:_companyList[i]];
            [_clientTableView reloadData];
        }
    }
    if ([searchText isEqualToString: @""]) {
        [_searchArray removeAllObjects];
        isSearch = NO;
        [_clientTableView reloadData];
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, searchBar.maxY + 64, KSCreenW, KSCreenH - searchBar.maxY - 64)];
                _backView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_backView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [_backView addGestureRecognizer:tap];
        [_backView addGestureRecognizer:pan];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchArray removeAllObjects];
    isSearch = YES;
    //    NSArray * companyArray = [_customerList objectForKey:@"company"];
      for (int i = 0; i < _companyList.count; i++) {
        NSLog(@"%@",_companyList[i]);
        NSString *companyStr = _companyList[i];
            NSRange rang = [companyStr rangeOfString:searchBar.text];
        if (rang.length != 0) {
            [_searchArray addObject:_companyList[i]];
            [_clientTableView reloadData];
        }
    }
    [_searchBar resignFirstResponder];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}
- (void)reloadData{
    
//    self.delegate = self.navigationController;
    NSNumber *sortNum = [NSNumber numberWithInt:3];
    NSNumber *sortwayNum = [NSNumber numberWithInt:2];
    NSNumber *pagesNum = [NSNumber numberWithInt:1];
    NSNumber *rowsNum = [NSNumber numberWithInt:20];
    NSDictionary * dic =@{@"token":TOKEN,@"uid":@(UID),@"sort":sortNum,@"sortWay":sortwayNum,@"pages":pagesNum,@"rows":rowsNum,};
    [DataTool sendGetWithUrl:MY_CLIENT_URL parameters:dic success:^(id data) {
        
//        int code = [[(NSDictionary *)data objectForKey:@"code"] intValue];
//        if(code != 100)//连接500和501
//        {
//            NSString * message = [(NSDictionary *)data objectForKey:@"message"];
//            [self.view makeToast:message];
//        }else{
//
//        }
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        _customerCount = [[(NSDictionary *)jsonDic objectForKey:@"customerCount"] intValue];
        _customerList = [(NSDictionary *)jsonDic objectForKey:@"customerList"];
        NSLog(@"%@-----",jsonDic);
        [self setCompanyName];
        
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)setCompanyName{
    [_companyList removeAllObjects];
//    NSMutableDictionary * mutableDictionary = [NSMutableDictionary dictionaryWithCapacity:_customerCount];
    for (NSMutableDictionary *client in _customerList) {
        NSLog(@"client:%@",client);
        NSLog(@"%@",[client objectForKey:@"id"]);
        [_idList addObject:[client objectForKey:@"id"]];
        [_companyList addObject:[client objectForKey:@"company"]];
        [_cnameList addObject:[client objectForKey:@"cname"] ];
        [_addressList addObject:[client objectForKey:@"address"] ];
        NSLog(@"%@",_cnameList);
    }
        [self addClientTable];
}
#pragma mark 添加搜索栏
//-(void)addSearchBar{
//    CGRect searchBarRect=CGRectMake(0, 0, self.view.width, 44);
//    _searchBar=[[UISearchBar alloc]initWithFrame:searchBarRect];
//    _searchBar.placeholder=@"搜索";
//    _searchBar.showsCancelButton=YES;//显示取消按钮
//    //添加搜索框到页眉位置
//    _searchBar.delegate=self;
//    _clientTableView.tableHeaderView = _searchBar;
//}

- (void)addClientTable{
//    NSLog(@"%f-----%f",self.view.width,self.view.height);
    _clientTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64 + 44, self.view.width, self.view.height-108)];
    _clientTableView.delegate = self;
    _clientTableView.dataSource = self;
    [self.view addSubview:_clientTableView];
    
    [self addSearchBar];
}

- (void)goToBack{
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isSearch) {
        return _searchArray.count;
    }else{
          return _companyList.count;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.textColor = blackFontColor;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f] ;
    if (isSearch) {
        cell.textLabel.text = _searchArray[indexPath.row];
    }else{
        cell.textLabel.text = [_customerList[indexPath.row] objectForKey:@"company"];

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (self.delegate && [self.delegate respondsToSelector:@selector(selectClient:)]) {
//        
//
//    }
    [self.delegate selectClient:[[_customerList[indexPath.row] objectForKey:@"id"] intValue] withName:[_customerList[indexPath.row] objectForKey:@"company"] withCname:[_customerList[indexPath.row] objectForKey:@"cname"] withAddress:[_customerList[indexPath.row] objectForKey:@"address"]];
    [self goToBack];
}

//#pragma mark - 搜索框代理
//#pragma mark  取消搜索
//-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
//    _isSearching=NO;
//    _searchBar.text=@"";
//    [self.tableView reloadData];
//    [self.staffTableView reloadData];
//    //    [self.view resetSearch]; //重新 加载分类数据
//    [_searchBar resignFirstResponder]; //退出键盘
//}
//
//#pragma mark 输入搜索关键字
//-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
//    if([_searchBar.text isEqual:@""]){
//        _isSearching=NO;
//        [self.tableView reloadData];
//        [self.staffTableView reloadData];
//        return;
//    }
//    [self searchDataWithKeyWord:_searchBar.text withSearchBar:searchBar];
//}
//
//#pragma mark 点击虚拟键盘上的搜索时
//-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    
//    [self searchDataWithKeyWord:_searchBar.text withSearchBar:searchBar];
//    
//    [searchBar resignFirstResponder];//放弃第一响应者对象，关闭虚拟键盘
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_searchBar resignFirstResponder];
}

@end
