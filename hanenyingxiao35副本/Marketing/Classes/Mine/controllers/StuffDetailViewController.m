//
//  StuffDetailViewController.m
//  Marketing
//
//  Created by HanenDev on 16/2/26.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "StuffDetailViewController.h"
#import "InformationCell.h"
#import "QRCodeGenerator.h"

#define cellHeight 60.0f

@interface StuffDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray      *_titleArray;
    UITableView  *_tableView;
    UILabel      *qrNameLabel;
    UIImageView  *_bgImage1;
}
@property(nonatomic,strong)UIView         *qrView;
@property(nonatomic,strong)UIImageView    *qrImageView;
@property(nonatomic,strong)UIImageView    *bgImage;

@end

@implementation StuffDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.leftBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithAction:@selector(goToBack)];
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:@"员工详情"];
    _titleArray = @[@"所属部门",@"职位"];
    
    [self createUI];
    [self createQRView];
    //[self initData];
       
}
- (void)initData{
    NSNumber *cidNum = [NSNumber numberWithInt:_cID];
    NSDictionary * dic =@{@"token":TOKEN,@"uid":@(UID),@"userid":cidNum};
    [DataTool postWithUrl:STUFF_DETAIL_URL parameters:dic success:^(id data) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@+++++--wodexiangqing",jsonDic);
        _nameLabel.text = jsonDic[@"name"];
        
        NSString  *imageStr =[NSString stringWithFormat:@"%@%@",LoadImageUrl,jsonDic[@"logo"]];
        //NSData *data1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]];
//        _headerImageView.image = [UIImage imageWithData:data1];
//        _bgImage1.image = [UIImage imageWithData:data1];
        [_headerImageView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
        [_bgImage1 sd_setImageWithURL:[NSURL URLWithString:imageStr]];
        
        _phoneLabel.text = jsonDic[@"username"];
        
        
        NSString  *qrImageStr =[NSString stringWithFormat:@"%@%@",LoadImageUrl,jsonDic[@"img"]];
        _qrImageView.image = [QRCodeGenerator qrImageForString:qrImageStr imageSize:300];
        
        qrNameLabel.text = jsonDic[@"name"];
        
        [_tableView reloadData];

        
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)createUI{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, KSCreenH ) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.rowHeight = cellHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    
    CGFloat bgImageH     = [UIView getHeight:260.0f];//背景图片的高度
    CGFloat headerImageW  = [UIView getWidth:100];//头像尺寸
    CGFloat qrSpace      = 15;
    CGFloat qrW          = [UIView getWidth:40];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, bgImageH)];
    headerView.backgroundColor = [UIColor grayColor];
    
    NSString  *imageStr =[NSString stringWithFormat:@"%@%@",LoadImageUrl,_logo];
    //NSData *data1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]];
    
    _bgImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, bgImageH)];
    //背景图
    //_bgImage1.image = [UIImage imageWithData:data1];
    [_bgImage1 sd_setImageWithURL:[NSURL URLWithString:imageStr]];
    [headerView addSubview:_bgImage1];
    
    //毛玻璃效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = CGRectMake(0, 0, KSCreenW, bgImageH);
    
    [_bgImage1 addSubview:effectview];

    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, KSCreenW, [UIView getHeight:40])];
    //姓名
    _nameLabel.text = _name;
    _nameLabel.font = [UIView getFontWithSize:16.0f];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:_nameLabel];
    
    _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake((KSCreenW-headerImageW)/2, _nameLabel.maxY + 10, headerImageW, headerImageW)];
    _headerImageView.layer.cornerRadius = headerImageW/2;
    _headerImageView.layer.masksToBounds = YES;
    
    //头像
    //_headerImageView.image = [UIImage imageWithData:data1];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
    
    [headerView addSubview:_headerImageView];
    
    UIImageView *photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_headerImageView.maxX - [UIView getWidth:20], _headerImageView.maxY -[UIView getHeight:20] , [UIView getWidth:20], [UIView getHeight:20])];
    photoImageView.image =[UIImage imageNamed:@"相机"];
    [headerView addSubview:photoImageView];
    
    //拨打电话按钮
    UIButton *phoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(_headerImageView.x - [UIView getWidth:25], _headerImageView.maxY + [UIView getHeight:20], [UIView getWidth:18], [UIView getHeight:18])];
    [phoneBtn setImage:[UIImage imageNamed:@"电话2"] forState:UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(directCall:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:phoneBtn];
    
    _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(phoneBtn.maxX + [UIView getWidth:10], phoneBtn.y - [UIView getHeight:10], KSCreenW, [UIView getHeight:40])];
    //手机号
    _phoneLabel.text = _phone;
    _phoneLabel.font = [UIView getFontWithSize:16.0f];
    _phoneLabel.textColor=[UIColor whiteColor];
    //_phoneLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:_phoneLabel];
    
    _qrBtn = [[UIButton alloc]initWithFrame:CGRectMake(KSCreenW - qrW - qrSpace, qrSpace, qrW, qrW)];
    [_qrBtn setImage:[UIImage imageNamed:@"二维码"] forState:UIControlStateNormal];
    [_qrBtn addTarget:self action:@selector(getQRcode:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_qrBtn];
    
    _tableView.tableHeaderView = headerView;
}
- (void)createQRView{
    _qrView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, KSCreenH)];
    _qrView.backgroundColor = [UIColor colorWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
    _qrView.hidden = YES;
    [self.view addSubview:_qrView];
    
    _bgImage = [[UIImageView alloc]initWithFrame:CGRectMake([UIView getWidth:40], [UIView getHeight:120], KSCreenW - 2*[UIView getWidth:40], KSCreenW - 2*[UIView getWidth:40])];
    _bgImage.image = [UIImage imageNamed:@"二维码bg"];
    _bgImage.hidden = YES;
    [self.view addSubview:_bgImage];
    
    qrNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, [UIView getHeight:20], KSCreenW - 2*[UIView getWidth:40], [UIView getHeight:30])];
    //名字
    qrNameLabel.text = _name;
    qrNameLabel.textColor = [UIColor whiteColor];
    qrNameLabel.textAlignment = NSTextAlignmentCenter;
    [_bgImage addSubview:qrNameLabel];
    
    _qrImageView = [[UIImageView alloc]initWithFrame:CGRectMake((KSCreenW - 2*[UIView getWidth:40] - [UIView getWidth:120])/2, qrNameLabel.maxY + [UIView getHeight:10], [UIView getWidth:120], [UIView getWidth:120])];
    //二维码
    NSString  *qrImageStr =[NSString stringWithFormat:@"%@%@",LoadImageUrl,_imag];
    _qrImageView.image = [QRCodeGenerator qrImageForString:qrImageStr imageSize:300];
    [_bgImage addSubview:_qrImageView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toHiddenQRView:)];
    [_qrView addGestureRecognizer:tapGesture];
}
//二维码扫描
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

- (void)directCall:(UIButton *)sender{
    
    UIWebView *webview = [[UIWebView alloc] init];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_phoneLabel.text]]]];
    [self.view addSubview:webview];
}
#pragma mark
#pragma mark---------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    InformationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell=[[InformationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = _titleArray[indexPath.row];
    if (indexPath.row == 0) {
         cell.subLabel.text =_departmentName;
    }else if (indexPath.row == 1){
        cell.subLabel.text =_positionName;
    }
    
    return cell;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
