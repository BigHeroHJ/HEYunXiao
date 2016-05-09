//
//  SatusSelectViewController.m
//  Marketing
//
//  Created by HanenDev on 16/3/7.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "SatusSelectViewController.h"
#import "LevelCell.h"

#define STARTX [UIView getWidth:10]

@interface SatusSelectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray   *_selectArr;
    BOOL _isSelect[12];
    NSInteger _selecteRow;
    UITableView *_tableView;
}

@end

@implementation SatusSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:self.itemTitle];
    self.navigationItem.leftBarButtonItem=[ViewTool getBarButtonItemWithTarget:self WithAction:@selector(goToBack)];
    
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIView getWidth:40], [UIView getWidth:20])];
//    [btn setTitle:@"完成" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIView getFontWithSize:15.0f];
//    [btn addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    self.navigationItem.rightBarButtonItem = item;
    
    [self initViews];
}
- (void)initViews{
    NSFileManager *manager=[NSFileManager defaultManager];
    NSString *filePath=[NSHomeDirectory() stringByAppendingString:@"/Documents/file"];
    if ([manager fileExistsAtPath:filePath]) {
        _selectArr=[[NSArray alloc]initWithContentsOfFile:filePath];
        for (int i=0; i<12; i++) {
            _isSelect[i]=[_selectArr[i] boolValue];
        }
    }else{
        _selectArr=[NSArray array];
    }
    
    _selecteRow=-1;
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView = [[UIView alloc]init];
    //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, 40)];
//    UIImageView *imageVi = [[UIImageView alloc]initWithFrame:CGRectMake(STARTX, 5, 30, 30)];
//    imageVi.image = [UIImage imageNamed:@"rempass"];
//    [view addSubview:imageVi];
    
    UILabel *selectLabel = [[UILabel alloc]initWithFrame:CGRectMake(STARTX, 5, 100, 30)];
    selectLabel.textColor = blackFontColor;
    selectLabel.text = @"请选择";
    [ViewTool setLableFont12:selectLabel];
    [view addSubview:selectLabel];
    
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(STARTX, 40 - 1, KSCreenW -2*STARTX, 1)];
    lineView.backgroundColor = grayLineColor;
    [view addSubview:lineView];
    
    //_tableView.tableHeaderView = view;
}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, 40)];
//    UIImageView *imageVi = [[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 20, 20)];
//    imageVi.image = [UIImage imageNamed:@"vip"];
//    [view addSubview:imageVi];
//    
//    UILabel *selectLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageVi.maxX + 10, 5, 100, 30)];
//    selectLabel.textColor = blackFontColor;
//    selectLabel.text = @"请选择";
//    [view addSubview:selectLabel];
//    
//    return view;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _ar.count;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 40;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
//    LevelCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (cell == nil) {
//        cell = [[LevelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    if (indexPath.row==_selecteRow) {
//        cell.headerImage.image = [UIImage imageNamed:@"rempass"];
//    }else{
//        cell.headerImage.image = [UIImage imageNamed:@"norempass"];
//    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text=_ar[indexPath.row];
    cell.textLabel.textColor = blackFontColor;
    
//    if ([_valuetTitle isEqualToString:cell.textLabel.text] ) {
//        cell.contentView.backgroundColor = [UIColor lightGrayColor];
//    }
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSIndexPath * index=[NSIndexPath indexPathForRow:_selecteRow inSection:0];
//    LevelCell *lastCell=[tableView cellForRowAtIndexPath:index];
//    lastCell.headerImage.image = [UIImage imageNamed:@"norempass"];
//    
//    LevelCell *cell=[tableView cellForRowAtIndexPath:indexPath];
//    cell.headerImage.image = [UIImage imageNamed:@"rempass"];
//    
//    _selecteRow=indexPath.row;
    
    
    if ([self.delegate respondsToSelector:@selector(selectStatusWith:withNum:withInt:)]) {
        [self.delegate selectStatusWith:_ar[indexPath.row]withNum:self.num withInt:(int)indexPath.row + 1];
    }
    //[self performSelector:@selector(clickToVC) withObject:nil afterDelay:0.3];
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)clickToVC{
     [self.navigationController popViewControllerAnimated:NO];

}
- (void)saveClick:(UIButton *)btn{
    
    NSIndexPath * index=[NSIndexPath indexPathForRow:_selecteRow inSection:0];
    
    if ([self.delegate respondsToSelector:@selector(selectStatusWith:withNum:withInt:)]) {
        [self.delegate selectStatusWith:_ar[index.row]withNum:self.num withInt:(int)index.row + 1];
    }
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)goToBack{
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = NO;
}
- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
