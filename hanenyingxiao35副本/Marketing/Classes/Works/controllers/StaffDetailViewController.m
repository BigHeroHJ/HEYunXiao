//
//  StaffDetailViewController.m
//  Marketing
//
//  Created by wmm on 16/3/11.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "StaffDetailViewController.h"

@interface StaffDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSArray     *_titleArray;
    UIImageView *_bgImage1;
    UILabel     *qrNameLabel;
}

@property(nonatomic,strong)NSDictionary   *dictionary;
@property(nonatomic,strong)UIView         *qrView;
@property(nonatomic,strong)UIImageView    *qrImageView;
@property(nonatomic,strong)UIImageView    *bgImage;

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation StaffDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:@"员工详情"];
    self.navigationItem.leftBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithAction:@selector(popViewController)];
    
    //    _dictionary = [[NSDictionary alloc]init];
    
    //    [self initData];
    
    [self createUI];
    
    [self createQRview];
}

- (void)initData{
    
    //    NSDictionary * dic =@{@"token":TOKEN,@"uid":@(UID),@"userid":@(_userId)};
    //    [DataTool sendGetWithUrl:GET_USER_BY_USERID_URL parameters:dic success:^(id data) {
    //        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //
    //
    //
    //        NSLog(@"%@+++++--wodezhuye",jsonDic);
    //
    //        _dictionary = jsonDic ;
    //        NSLog(@"%@  dic+++++",self.dictionary);
    //
    //        _nameLabel.text = _dictionary[@"name"];
    //
    //        NSString  *imageStr =[NSString stringWithFormat:@"%@%@",IMAGEURL,_dictionary[@"img"]];
    //        [_headerBtn sd_setImageWithURL:[NSURL URLWithString:imageStr] forState:UIControlStateNormal];
    //
    //        NSData *data1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]];
    //        _bgImage1.image = [UIImage imageWithData:data1];
    //
    //        _phoneLabel.text = [NSString stringWithFormat:@"手机号:%@",_dictionary[@"username"]];
    //
    //
    //        NSString  *qrImageStr =[NSString stringWithFormat:@"%@%@",IMAGEURL,_dictionary[@"logo"]];
    //        _qrImageView.image = [QRCodeGenerator qrImageForString:qrImageStr imageSize:300];
    //
    //        qrNameLabel.text = _dictionary[@"name"];
    //
    //    } fail:^(NSError *error) {
    //        NSLog(@"%@",error);
    //    }];
}

- (void)createUI{
    _titleArray = [[NSArray alloc]initWithObjects:@"所属部门",@"职位", nil];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, KSCreenH - 49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled =NO;
    
    _tableView.rowHeight = [UIView getHeight:50.0f];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    CGFloat bgImageH     = [UIView getHeight:260];//背景图片的高度
    CGFloat headerImageW  = [UIView getWidth:100];//头像尺寸
    CGFloat qrSpace      = 15;
    CGFloat qrW          = [UIView getWidth:40];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/crm%@",HEAD_URL,_user.img];
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
    
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, bgImageH)];
    headerView.backgroundColor = [UIColor lightGrayColor];
    
    _bgImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, bgImageH)];
    _bgImage1.image = [UIImage imageWithData:data];
    [headerView addSubview:_bgImage1];
    //毛玻璃效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    
    effectview.frame = CGRectMake(0, 0, KSCreenW, bgImageH);
    
    [_bgImage1 addSubview:effectview];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, [UIView getHeight:30], KSCreenW, [UIView getHeight:40])];
    nameLabel.text = _user.name;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:nameLabel];
    
    UIButton *headerBtn = [[UIButton alloc]initWithFrame:CGRectMake((KSCreenW-headerImageW)/2, nameLabel.maxY + 10, headerImageW, [UIView getHeight:100])];
    headerBtn.backgroundColor = [UIColor cyanColor];
    headerBtn.layer.cornerRadius = headerImageW/2;
    headerBtn.layer.masksToBounds = YES;
    
    [headerBtn setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
    
    [headerBtn addTarget:self action:@selector(clickToMyInformation:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:headerBtn];
    
    UIImageView *photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(headerBtn.maxX - [UIView getWidth:20], headerBtn.maxY -[UIView getHeight:20] , [UIView getWidth:20], [UIView getHeight:20])];
    photoImageView.image =[UIImage imageNamed:@"相机"];
    [headerView addSubview:photoImageView];
    
    
    UIImageView *phoneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(KSCreenW/3, headerBtn.maxY + 10, [UIView getHeight:20], [UIView getHeight:20])];
    phoneImageView.image =[UIImage imageNamed:@"电话2.png"];
    [headerView addSubview:phoneImageView];
    
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(KSCreenW/3+[UIView getHeight:20]+10, headerBtn.maxY + 10, KSCreenW/3*2, [UIView getHeight:20])];
    phoneLabel.text = _user.username;
    phoneLabel.textColor=[UIColor whiteColor];
    //    phoneLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:phoneLabel];
    
    UIButton *qrBtn = [[UIButton alloc]initWithFrame:CGRectMake(KSCreenW - qrW - qrSpace, qrSpace, qrW, qrW)];
    [qrBtn setImage:[UIImage imageNamed:@"二维码"] forState:UIControlStateNormal];
    [qrBtn addTarget:self action:@selector(getQRcode:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:qrBtn];
    
    _tableView.tableHeaderView = headerView;
}
- (void)createQRview{
    _qrView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, KSCreenH)];
    _qrView.backgroundColor = [UIColor colorWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
    _qrView.hidden = YES;
    [self.view addSubview:_qrView];
    
    _bgImage = [[UIImageView alloc]initWithFrame:CGRectMake([UIView getWidth:40], [UIView getHeight:120], KSCreenW - 2*[UIView getWidth:40], KSCreenW - 2*[UIView getWidth:40])];
    _bgImage.image = [UIImage imageNamed:@"二维码bg"];
    _bgImage.hidden = YES;
    [self.view addSubview:_bgImage];
    
    qrNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, [UIView getHeight:20], KSCreenW - 2*[UIView getWidth:40], [UIView getHeight:30])];
    qrNameLabel.text = @"";
    qrNameLabel.textColor = [UIColor whiteColor];
    qrNameLabel.textAlignment = NSTextAlignmentCenter;
    [_bgImage addSubview:qrNameLabel];
    
    _qrImageView = [[UIImageView alloc]initWithFrame:CGRectMake((KSCreenW - 2*[UIView getWidth:40] - [UIView getWidth:120])/2, qrNameLabel.maxY + [UIView getHeight:10], [UIView getWidth:120], [UIView getWidth:120])];
    
    //_qrImageView.image = [QRCodeGenerator qrImageForString:@"" imageSize:300];
    [_bgImage addSubview:_qrImageView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toHiddenQRView:)];
    [_qrView addGestureRecognizer:tapGesture];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.hidesBottomBarWhenPushed = YES;
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

//生成二维码
- (void)getQRcode:(UIButton *)btn{
    [UIView animateWithDuration:0.25 animations:^{
        _qrView.hidden = NO;
        _qrView.alpha = 0.7;
        _bgImage.hidden = NO;
    }];
    
}
- (void)toHiddenQRView:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:0.25 animations:^{
        _qrView.hidden = YES;
        _bgImage.hidden = YES;
    }];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.25 animations:^{
        _qrView.hidden = YES;
        _bgImage.hidden = YES;
    }];
}
//进入我的资料
- (void)clickToMyInformation:(UIButton *)btn{
    //    InformationViewController *vc = [[InformationViewController alloc]init];
    //    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark
#pragma mark---------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, KSCreenW, 20)];
    title.text = _titleArray[indexPath.row];
    title.font = [UIFont systemFontOfSize:14];
    title.textColor = grayFontColor;
    [cell addSubview:title];
    
    UILabel *value = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, KSCreenW, 20)];
    value.font = [UIFont systemFontOfSize:14];
    value.textColor = blackFontColor;
    
    if (indexPath.row == 0) {
        value.text = _user.departmentName;
    }else{
        value.text = _user.positionname;
    }
    [cell addSubview:value];
    
    [cell addSubview:[ViewTool getLineViewWith:CGRectMake(10, 59, KSCreenW-20, 1) withBackgroudColor:grayListColor]];
    
    return cell;
    
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    switch (indexPath.row) {
//        case 0:
//        {BusinessAdressBookVC *vc = [[BusinessAdressBookVC alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];}
//            break;
//        case 1:
//        { InviteViewController *vc = [[InviteViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];}
//            break;
//        case 2:
//        {SettingViewController *vc = [[SettingViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];}
//            break;
//        default:
//            break;
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
