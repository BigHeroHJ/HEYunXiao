//
//  InformationViewController.m
//  Marketing
//
//  Created by HanenDev on 16/2/25.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "InformationViewController.h"
#import "InformationCell.h"
#import "QRCodeGenerator.h"

#define ROWH 60.0f

@interface InformationViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray     *_titleArray;
    NSArray     *_dataArray;
    UILabel     *qrNameLabel;
    UITableView *_tableView;
}
@property(nonatomic,strong)UIView         *qrView;
@property(nonatomic,strong)UIImageView    *qrImageView;
@property(nonatomic,strong)UIImageView    *bgImage;

@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel: @"我的资料"];
    
    _titleArray = @[@"头像",@"姓名",@"电话",@"二维码名片",@"所属部门",@"职位"];
    
    [self createUI];
    //[self initData];
    
    [self createQRView];
}

- (void)createUI{
    self.navigationItem.leftBarButtonItem=[ViewTool getBarButtonItemWithTarget:self WithAction:@selector(goToBack)];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, KSCreenH) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.rowHeight = ROWH;
    [self.view addSubview:_tableView];
    
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
    qrNameLabel.text = _name;
    qrNameLabel.textColor = [UIColor whiteColor];
    qrNameLabel.textAlignment = NSTextAlignmentCenter;
    [_bgImage addSubview:qrNameLabel];
    
    _qrImageView = [[UIImageView alloc]initWithFrame:CGRectMake((KSCreenW - 2*[UIView getWidth:40] - [UIView getWidth:120])/2, qrNameLabel.maxY + [UIView getHeight:10], [UIView getWidth:120], [UIView getWidth:120])];
    NSString  *qrImageStr =[NSString stringWithFormat:@"%@%@",LoadImageUrl,_imag];
    _qrImageView.image = [QRCodeGenerator qrImageForString:qrImageStr imageSize:300];
    [_bgImage addSubview:_qrImageView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toHiddenQRView:)];
    [_qrView addGestureRecognizer:tapGesture];
    
}
#pragma mark
#pragma mark ----
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
        cell.subLabel.text = nil;
        cell.qrBtn.frame = CGRectMake(KSCreenW - [UIView getWidth:10] - 40 -5, 10, 40, 40);
        NSString  *imageStr =[NSString stringWithFormat:@"%@%@",LoadImageUrl,_logo];
//        NSData *data1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]];
//        [cell.qrBtn setImage:[UIImage imageWithData:data1] forState:UIControlStateNormal];
        [cell.qrBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:imageStr] forState:UIControlStateNormal];
        
        cell.qrBtn.layer.cornerRadius = 40/2;
        cell.qrBtn.layer.masksToBounds = YES;
        
        [cell.qrBtn addTarget:self action:@selector(clickToChangeHeaderImage:) forControlEvents:UIControlEventTouchUpInside];
        cell.qrBtn.tag = 1000;
        
    }else if (indexPath.row == 1) {
        cell.subLabel.text = _name;
    }else if (indexPath.row == 2) {
        cell.subLabel.text = _phone;
    }else if (indexPath.row == 3) {
        cell.subLabel.text = nil;
        cell.qrBtn.frame = CGRectMake(KSCreenW - [UIView getWidth:10] - 30 -5, 15, 30, 30);
        [cell.qrBtn setImage:[UIImage imageNamed:@"二维码名片"] forState:UIControlStateNormal];
        [cell.qrBtn addTarget:self action:@selector(getQRCode:) forControlEvents:UIControlEventTouchUpInside];
    }else if (indexPath.row == 4) {
            cell.subLabel.text = _department;
        
    }else if (indexPath.row == 5) {
        cell.subLabel.text = _position;
    }
    
    return cell;
}
- (void)getQRCode:(UIButton *)btn{
    
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
    [DataTool postWithUrl:MY_HOMEPAGE_URL parameters:dic success:^(id data) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@+++++--wodexiangqing",jsonDic);
        
        
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark
#pragma mark------修改头像
- (void)clickToChangeHeaderImage:(UIButton *)btn{
    if(IOS7){
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"打开相机", nil];
        [actionSheet showInView:self.view];
    }else{
        UIAlertController * alertionControll = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self takePhotoFromLibrary];
        }];
        UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self takePhotoFromCamera];
        }];
        UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertionControll addAction:action1];
        [alertionControll addAction:action2];
        [alertionControll addAction:action3];
        if(alertionControll != nil){
        [self presentViewController:alertionControll animated:YES completion:nil];
        }
    }
    

}
#pragma mark
#pragma mark --actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self takePhotoFromLibrary];
    }else if (buttonIndex == 1){
        [self takePhotoFromCamera];
    }
}
- (void)takePhotoFromLibrary{
    UIImagePickerController *imagePick = [[UIImagePickerController alloc] init];
    imagePick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePick.delegate = self;
    imagePick.allowsEditing = YES;
    [self presentViewController:imagePick animated:YES completion:nil];
}
- (void)takePhotoFromCamera{
    UIImagePickerController *imagePic = [[UIImagePickerController alloc]init];
    imagePic.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePic.delegate = self;
    imagePic.allowsEditing = YES;
    [self presentViewController:imagePic animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    UIButton *btn = (UIButton *)[_tableView viewWithTag:1000];
    [btn setImage:image forState:UIControlStateNormal];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString *str = [imageData base64Encoding];
    
    NSDictionary * dic =@{@"token":TOKEN,@"uid":@(UID),@"logo":str};
    [DataTool postWithUrl:UPDATE_USER_LOGO_URL parameters:dic success:^(id data) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@+++++--",jsonDic);
        [[NSUserDefaults standardUserDefaults] setObject:jsonDic[@"logourl"] forKey:@"logo"];
        
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];

}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    [actionSheet dismissWithClickedButtonIndex:2 animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
