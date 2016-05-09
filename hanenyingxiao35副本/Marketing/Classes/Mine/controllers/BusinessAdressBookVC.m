//
//  BusinessAdressBookVC.m
//  Marketing
//
//  Created by HanenDev on 16/2/25.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "BusinessAdressBookVC.h"
#import "ChineseString.h"
#import "AddressBookCell.h"
#import "StuffDetailViewController.h"
#import "MyHomePageModel.h"

#define STARTX [UIView getWidth:10]
#define cellHeight 50.0f

@interface BusinessAdressBookVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate>
{
    NSMutableArray    *_nameArray;
    NSMutableArray    *_userArray;
    UITableView       *_tableView;
    NSString          *_phoneNum;
    BOOL              _isSearching;
    NSMutableArray   *_cellnameArray;//排序后的model数组
    UIView  *_backView;
}
@property(nonatomic,strong)NSMutableArray   *indexArray;
@property(nonatomic,strong)NSMutableArray   *resultArray;
@property(nonatomic,strong)UISearchBar      *searchBar;

@property(nonatomic,strong)NSMutableArray   *searchArray;

@end

@implementation BusinessAdressBookVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:@"企业通讯录"];
    _cellnameArray = [NSMutableArray array];
    _nameArray = [NSMutableArray array];
    _userArray = [NSMutableArray array];
    [self createUI];
    [self initData];
    
}
- (void)createUI{
    
    self.navigationItem.leftBarButtonItem=[ViewTool getBarButtonItemWithTarget:self WithAction:@selector(goToBack)];
    
//    self.navigationItem.rightBarButtonItem=[ViewTool getBarButtonItemWithTarget:self WithString:@"新建" WithAction:@selector(addNewPeople)];
//
//    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, KSCreenW, [UIView getHeight:40])];
// [_searchBar setBackgroundImage:[ViewTool getImageFromColor:graySectionColor WithRect:_searchBar.frame]];
//    _searchBar.placeholder = @"搜索";
//    _searchBar.delegate = self;
//    [self.view addSubview:_searchBar];

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
    
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KSCreenW, [UIView getHeight:40])];
//    view.backgroundColor = graySectionColor;
//    [self.view addSubview:view];
    
//    UITextField *searchTF = [[UITextField alloc]initWithFrame:CGRectMake(STARTX, [UIView getHeight:8], KSCreenW -2*STARTX , [UIView getHeight:40]-2*[UIView getHeight:8])];
//    searchTF.backgroundColor = [UIColor whiteColor];
//    searchTF.placeholder =@"搜索";
//    searchTF.textAlignment = NSTextAlignmentCenter;
//    searchTF.delegate = self;
//    [view addSubview:searchTF];
    
//    _nameArray = [[NSMutableArray alloc]initWithCapacity:0];
//    _userArray = [[NSMutableArray alloc]initWithCapacity:0];
    _searchArray=[NSMutableArray array];

    //_nameArray = @[@"张三",@"张三1",@"小王",@"李四",@"王二",@"蛮子",@"瞎子",@"刘流",@"提莫",@"光辉",@"烬",@"金克斯",@"贾克斯",@"流浪",@"劫",@"男刀",@"李四1",@"德玛",@"希维尔",@"蒙多",@"潘森",@"波比",@"瑞文",@"EZ",@"索拉卡",@"娑娜",@"鳄鱼",@"酒桶",@"厄运小姐",@"薇恩",@"老牛",@"大嘴",@"飞机"];
    
//    self.indexArray = [ChineseString IndexArray:_nameArray];
//    self.resultArray = [ChineseString LetterSortArray:_nameArray];
    
    //self.indexArray = [ChineseString IndexArray:_userArray];
    //self.resultArray = [ChineseString LetterSortArray:_userArray];
    
    [self initTableView];
    
    
}
- (void)initTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 + 44, KSCreenW, KSCreenH - 64 -44)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionIndexColor = blueFontColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}
#pragma mark
#pragma mark ------tableView的协议方法
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    return _indexArray;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isSearching) {
        return 1;
    }
    return _indexArray.count;
//    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSMutableArray *arr =_resultArray[section];
//    return arr.count;
    if (_isSearching) {
        return _searchArray.count;
    }else{
        NSMutableArray *arr =_resultArray[section];
            return arr.count;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    // 获取所点目录对应的indexPath值
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    
    // 让table滚动到对应的indexPath位置
    [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    AddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[AddressBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //NSString *string = [[self.resultArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    MyHomePageModel *model;
    if (_isSearching) {
        model = _searchArray[indexPath.row];
    }else{
        NSArray *arr = _cellnameArray[indexPath.section];
        model  = arr[indexPath.row];
//        model = _nameArray[indexPath.row];
    }
    NSString *imageStr = [NSString stringWithFormat:@"%@%@",LoadImageUrl,model.logo];
    
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]];
//    cell.headerImage.image = [UIImage imageWithData:data];
    if (_isSearching) {
        cell.phoneBtn.tag = indexPath.row;
    }else{
    for(int i = 0;i < _nameArray.count;i++){
        MyHomePageModel *instanModel = _nameArray[i];
        if (model.uid == instanModel.uid) {
              cell.phoneBtn.tag = 100 + i;
            NSLog(@"%d",cell.phoneBtn.tag);
        }
    }
    }
    [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:imageStr]];
    cell.nameLabel.text = model.name;
    [cell.phoneBtn addTarget:self action:@selector(clickToDirectCall:) forControlEvents:UIControlEventTouchUpInside];
    

    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, 25)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(STARTX + 10, 0, 100, 24)];
    lab.text = [self.indexArray objectAtIndex:section];
    lab.textColor = blueFontColor;
    [view addSubview:lab];
    
    UIView *lineView = [ViewTool getLineViewWith:CGRectMake(STARTX, 24, KSCreenW - 2*STARTX, 1) withBackgroudColor:[UIColor colorWithWhite:0.85 alpha:0.5]];
    [view addSubview:lineView];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_searchBar resignFirstResponder];
    
    MyHomePageModel *model;
    if (_isSearching) {
        model = _searchArray[indexPath.row];
    }else{
        NSArray *arr = _cellnameArray[indexPath.section];
        model = arr[indexPath.row];
    }
    StuffDetailViewController *vc = [[StuffDetailViewController alloc]init];
    vc.cID = model.uid;
    NSLog(@"%d",vc.cID);
    vc.name = model.name;
    vc.imag = model.img;
    vc.phone = model.username;
    vc.logo = model.logo;
    NSLog(@"%@.................",vc.logo);
    vc.positionName = model.positionname;
    vc.departmentName = model.departmentName;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addNewPeople{
    
}
//拨打电话
- (void)clickToDirectCall:(UIButton *)btn{
    
    MyHomePageModel *model;
    if (_isSearching) {
        model = _searchArray[btn.tag];
    }else{
        model = _nameArray[btn.tag - 100];
    }
    UIWebView *webview = [[UIWebView alloc] init];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",model.username]]]];
    [self.view addSubview:webview];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark 输入搜索关键字
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [_searchArray removeAllObjects];
    
    if([_searchBar.text isEqual:@""]){
        _isSearching=NO;
        [_tableView reloadData];
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, searchBar.maxY + 64, KSCreenW, KSCreenH - searchBar.maxY - 64)];
        _backView.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:_backView atIndex:1];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [_backView addGestureRecognizer:tap];
        return;
    }
    [self searchDataWithKeyWord:_searchBar.text withSearchBar:searchBar];
}
- (void)handleTap:(UIGestureRecognizer *)tap
{
    UIView *view3 = tap.view;
    [view3 removeFromSuperview];
    [_searchBar resignFirstResponder];
}
#pragma mark 点击虚拟键盘上的搜索时
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [_searchArray removeAllObjects];
    [self searchDataWithKeyWord:_searchBar.text withSearchBar:searchBar];
    
    [searchBar resignFirstResponder];
}
#pragma mark 搜索形成新数据
-(void)searchDataWithKeyWord:(NSString *)keyWord withSearchBar:(UISearchBar *)searchBar{
    _isSearching=YES;
//    _searchArray=[NSMutableArray array];
    
    
        for (MyHomePageModel *model in _nameArray) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
                if ([model.name.uppercaseString containsString:keyWord.uppercaseString]) {
                    [_searchArray addObject:model];
                }
                
            }else{
                
                NSRange range = [model.name.uppercaseString rangeOfString:keyWord.uppercaseString];
                if(range.length > 0)
                {
                    [_searchArray addObject:model];
                }
            }
        }
        //刷新表格
        [_tableView reloadData];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)eve{
    [_searchBar resignFirstResponder];
}
- (void)goToBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = YES;
}

- (void)initData{
    
    NSDictionary * dic =@{@"token":TOKEN,@"uid":@(UID)};
    [DataTool sendGetWithUrl:BUSINESS_ADDRESS_BOOK_URL parameters:dic success:^(id data) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@+++++--qiyetongxunlu",jsonDic);
        NSMutableArray *array = jsonDic[@"data"];
        for (int i =0; i<array.count; i++) {
            //sfsdf
            MyHomePageModel *pageModel = [[MyHomePageModel alloc]init];
            id dd = [DataTool changeType:array[i]];
            [pageModel setValuesForKeysWithDictionary:dd];
            [_nameArray addObject:pageModel];
            
            id name = [DataTool changeType:pageModel.name];
            [_userArray addObject:name];
            
        }
        NSLog(@"namearray的个数%ld",(unsigned long)_nameArray.count);
        _indexArray = [ChineseString IndexArray:_userArray];
        _resultArray = [ChineseString LetterSortArray:_userArray];
//        
        for(int i = 0; i< _indexArray.count;i ++){
            NSLog(@"_indexArray%@",_indexArray[i]);
        }
        for(int i = 0; i< _resultArray.count;i ++){
//            NSLog(@"%@",_resultArray[i]);
        }
        for (int i = 0; i< _resultArray.count; i++) {
            NSArray *findarr = _resultArray[i];
//            NSLog(@"要找的名字%@",findarr);
            NSMutableArray *arrarname = [NSMutableArray array];
            for (int i = 0; i< findarr.count; i++) {
                
                NSString *nameStr = findarr[i];
                id nameS = [DataTool changeType:nameStr];
//                NSLog(@"nameStr%@",nameStr);
                for (int j = 0; j < _nameArray.count; j++) {
//                     NSLog(@"nameArray的个数%ld",_nameArray.count);
                    //id ddd = [DataTool changeType:_nameArray[j]];
                    MyHomePageModel *model = _nameArray[j];
                    id name = [DataTool changeType:model.name];
//                    NSLog(@"%@",model.name);
                    if([name isEqualToString:nameS]){
                        [arrarname addObject:model];
//                        NSLog(@"匹配的名字%@",model.name);
                    }
                }
//                NSLog(@"CellNameArray个数%d",_cellnameArray.count);
            }
             [_cellnameArray addObject:arrarname];
        }
//        NSLog(@"_cellnameArray个数%ld",_cellnameArray.count);
        for (int i = 0; i< _cellnameArray.count; i++) {
            NSArray *arr = _cellnameArray[i];
//            for (MyHomePageModel *model in arr) {
//                NSLog(@"%@,%@",model.name,model.positionname);
//            }
            NSLog(@"%@",arr.description);
        }
        
        
        [_tableView reloadData];
        
        
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
