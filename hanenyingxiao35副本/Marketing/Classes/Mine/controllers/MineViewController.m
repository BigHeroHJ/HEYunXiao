//
//  MineViewController.m
//  移动营销
//
//  Created by Hanen 3G 01 on 16/2/23.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "MineViewController.h"
#import "MineCell.h"
#import "BusinessAdressBookVC.h"
#import "InviteViewController.h"
#import "SettingViewController.h"
#import "InformationViewController.h"
#import "QRCodeGenerator.h"
#import "FXBlurView.h"

#define cellHeight 50.0f

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray     *_imageArray;
    UIImageView *_bgImage1;
    UILabel     *qrNameLabel;
}
@property(nonatomic,strong)NSDictionary   *dictionary;
@property(nonatomic,strong)UIView         *qrView;
@property(nonatomic,strong)UIImageView    *qrImageView;
@property(nonatomic,strong)UIImageView    *bgImage;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    _dictionary = [[NSDictionary alloc]init];
    
    
    [self createUI];
    
    [self createQRview];
    
    //[self initData];
    
}
- (void)initData{
    
    NSDictionary * dic =@{@"token":TOKEN,@"uid":@(UID)};
    [DataTool sendGetWithUrl:MY_HOMEPAGE_URL parameters:dic success:^(id data) {
        NSDictionary *jsonDic = [DataTool changeType:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]];
        NSLog(@"%@+++++--wodezhuye",jsonDic);
        if(jsonDic){
            
            _dictionary = jsonDic;
            NSLog(@"%@  dic+++++",self.dictionary);
            NSString *namString = jsonDic[@"name"];
            if(namString != nil){
            _nameLabel.text = namString;
            }else{
                _nameLabel.text = @"";
            }
            NSString  *imageStr =[NSString stringWithFormat:@"%@%@",LoadImageUrl,jsonDic[@"logo"]];
            //[_headerBtn sd_setImageWithURL:[NSURL URLWithString:imageStr] forState:UIControlStateNormal];
            [_headerBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:imageStr] forState:UIControlStateNormal];
            
            //NSData *data1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]];
            //[_headerBtn setBackgroundImage:[UIImage imageWithData:data1] forState:UIControlStateNormal];
            //_bgImage1.image = [UIImage imageWithData:data1];
            [_bgImage1 sd_setImageWithURL:[NSURL URLWithString:imageStr]];
            
            _phoneLabel.text = [NSString stringWithFormat:@"手机号:%@",jsonDic[@"username"]];
            
            NSString  *qrImageStr =[NSString stringWithFormat:@"%@%@",LoadImageUrl,jsonDic[@"img"]];
            _qrImageView.image = [QRCodeGenerator qrImageForString:qrImageStr imageSize:300];
            
//            _qrImageView.layer.cornerRadius = 130;
//            _qrImageView.layer.masksToBounds = YES;//圆形
            NSString *namString2 = jsonDic[@"name"];
            if(namString2 != nil){
                qrNameLabel.text = namString2;
            }else{
                qrNameLabel.text = @"";
            }
     
            
        }
       
        [_tableView reloadData];
    } fail:^(NSError *error) {
        NSLog(@"%@+++++++++",error);
    }];
}

- (void)createUI{
    
    _imageArray = [[NSArray alloc]initWithObjects:@"企业通讯录",@"邀请",@"设置", nil];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, KSCreenH - 49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled =NO;
    
    _tableView.rowHeight = cellHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    CGFloat bgImageH     = [UIView getHeight:260];//背景图片的高度
    CGFloat headerImageW  = [UIView getWidth:100];//头像尺寸
    CGFloat qrSpace      = 15;
    CGFloat qrW          = [UIView getWidth:40];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, bgImageH)];
    headerView.backgroundColor = [UIColor lightGrayColor];
    
    _bgImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, bgImageH)];
    //_bgImage1.image = [UIImage imageNamed:@""];
    
    [headerView addSubview:_bgImage1];
    //毛玻璃效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = CGRectMake(0, 0, KSCreenW, bgImageH);
    [_bgImage1 addSubview:effectview];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, [UIView getHeight:30], KSCreenW, [UIView getHeight:40])];
    NSLog(@"%@   名字",_dictionary);
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:_nameLabel];
    
    _headerBtn = [[UIButton alloc]initWithFrame:CGRectMake((KSCreenW-headerImageW)/2, _nameLabel.maxY + 10, [UIView getHeight:100], [UIView getHeight:100])];
    _headerBtn.backgroundColor = [UIColor cyanColor];
    _headerBtn.layer.cornerRadius = [UIView getHeight:100]/2;
    _headerBtn.layer.masksToBounds = YES;
    _headerBtn.layer.borderWidth = 0.1;
    
    //[_headerBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_headerBtn addTarget:self action:@selector(clickToMyInformation:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_headerBtn];
    
    UIImageView *photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_headerBtn.maxX - [UIView getWidth:20], _headerBtn.maxY -[UIView getHeight:20] , [UIView getWidth:20], [UIView getHeight:20])];
    photoImageView.image =[UIImage imageNamed:@"相机"];
    [headerView addSubview:photoImageView];
    
    
    _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _headerBtn.maxY + 10, KSCreenW, [UIView getHeight:40])];
//    _phoneLabel.text = @"";
    _phoneLabel.textColor=[UIColor whiteColor];
    _phoneLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:_phoneLabel];
    
    _qrBtn = [[UIButton alloc]initWithFrame:CGRectMake(KSCreenW - qrW - qrSpace, qrSpace, qrW, qrW)];
    [_qrBtn setImage:[UIImage imageNamed:@"二维码"] forState:UIControlStateNormal];
    [_qrBtn addTarget:self action:@selector(getQRcode:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_qrBtn];
    
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
//    qrNameLabel.text = @"";
    qrNameLabel.textColor = [UIColor whiteColor];
    qrNameLabel.textAlignment = NSTextAlignmentCenter;
    [_bgImage addSubview:qrNameLabel];
    
//    UIView *imgbgView = [[UIView alloc] initWithFrame:CGRectMake((KSCreenW - 2*[UIView getWidth:40] - [UIView getWidth:140])/2, qrNameLabel.maxY + [UIView getHeight:10], [UIView getWidth:140], [UIView getWidth:140])];
//    imgbgView.backgroundColor = [UIColor whiteColor];
//    imgbgView.layer.cornerRadius = [UIView getWidth:120]/2;
//    imgbgView.layer.masksToBounds = YES;
//    [_bgImage addSubview:imgbgView];
    
    _qrImageView = [[UIImageView alloc]initWithFrame:CGRectMake((KSCreenW - 2*[UIView getWidth:40] - [UIView getWidth:120])/2, qrNameLabel.maxY + [UIView getHeight:10], [UIView getWidth:120], [UIView getWidth:120])];
//    _qrImageView.backgroundColor = [UIColor whiteColor];
//    _qrImageView.layer.cornerRadius = [UIView getWidth:120]/2;
    //_qrImageView.image = [QRCodeGenerator qrImageForString:@"" imageSize:300];
    [_bgImage addSubview:_qrImageView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toHiddenQRView:)];
    [_qrView addGestureRecognizer:tapGesture];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initData];
    
    self.navigationController.navigationBarHidden = YES;
    
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
    InformationViewController *vc = [[InformationViewController alloc]init];
    
    vc.name = [DataTool changeType:_dictionary[@"name"]];
    vc.imag = [DataTool changeType:_dictionary[@"img"]];
    vc.phone = [DataTool changeType:_dictionary[@"username"]];
    vc.logo = [DataTool changeType:_dictionary[@"logo"]];
    vc.department = [DataTool changeType:_dictionary[@"departmentName"]];
    vc.position = [DataTool changeType:_dictionary[@"positionname"]];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark
#pragma mark---------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _imageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    MineCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell=[[MineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.headerImage.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    cell.titleLabel.text = _imageArray[indexPath.row];
    [ViewTool setLableFont14:cell.titleLabel];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {BusinessAdressBookVC *vc = [[BusinessAdressBookVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];}
            break;
        case 1:
        { InviteViewController *vc = [[InviteViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];}
            break;
        case 2:
        {SettingViewController *vc = [[SettingViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];}
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
