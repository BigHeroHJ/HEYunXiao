//
//  SettingViewController.m
//  Marketing
//
//  Created by HanenDev on 16/2/25.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "SettingViewController.h"
#import "MineCell.h"
#import "FirstViewController.h"


#define STARTX [UIView getWidth:10]
#define LINEW KSCreenW - 2*STARTX
#define ROWH 50.0f

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray *_titleArray;
}
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel: @"设置"];
    
    _titleArray = [NSMutableArray arrayWithArray:@[@[@"账号与安全"],@[@"版本更新",@"意见反馈",@"关于我们"]]];
    
    [self createUI];
}
- (void)createUI{
    
    self.navigationItem.leftBarButtonItem=[ViewTool getBarButtonItemWithTarget:self WithAction:@selector(goToBack)];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, KSCreenH) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    tableView.rowHeight = ROWH;
    [self.view addSubview:tableView];
    
    CGFloat outLoginH;
    if (KSCreenH == 480|KSCreenH == 568) {
        outLoginH = 120;
    }else{
        outLoginH = 240;
    }
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, KSCreenW, [UIView getHeight:50])];
    UIButton *outLoginBtn = [[UIButton alloc]initWithFrame:CGRectMake(2*STARTX, KSCreenH - outLoginH, KSCreenW - 4*STARTX, [UIView getHeight:40])];
    [outLoginBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    outLoginBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [outLoginBtn setBackgroundColor:mainOrangeColor];
    [outLoginBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [outLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    outLoginBtn.layer.cornerRadius = 4.0f;
    [outLoginBtn addTarget:self action:@selector(clickToOutLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:outLoginBtn];
    
    tableView.tableFooterView = footerView;
}

#pragma mark ---- tableview的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _titleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return 3;
    }
    return 0;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    MineCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell=[[MineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.headerImage.image = [UIImage imageNamed:_titleArray[indexPath.section][indexPath.row]];
        cell.titleLabel.text = _titleArray[indexPath.section][indexPath.row];
        [cell.lineView removeFromSuperview];
    }else if (indexPath.section == 1){
        cell.headerImage.image = [UIImage imageNamed:_titleArray[indexPath.section][indexPath.row]];
        cell.titleLabel.text = _titleArray[indexPath.section][indexPath.row];
    }
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *views= [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, 30)];
    views.backgroundColor = graySectionColor;
    
    return views;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
         //账号与安全
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            //版本更新
            [self alertWithString:@"当前已是最新版本"];
            
        }else if (indexPath.row == 1){
            //意见反馈
            [self alertWithString:@"感谢您提出的宝贵意见"];
        }else if (indexPath.row == 2){
            //关于我们
            [self alertWithString:@"南京汉恩数字互联文化有限公司"];

        }
    }
    
}
- (void)alertWithString:(NSString *)str{
    
    ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"" message:str];
    [alert addBtnTitle:@"OK" action:^{
        
    }];
    [alert showAlertWithSender:self];
    
}
- (void)goToBack{
    [self.navigationController popViewControllerAnimated:YES];
}
//退出登录
- (void)clickToOutLogin:(UIButton *)btn{

    
    ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"提示" message:@"是否退出登录"];
    [alert addBtnTitle:@"确定" action:^{
        //删除本地的token和uid;
        NSDictionary * dic =@{@"token":TOKEN,@"uid":@(UID)};
        [DataTool postWithUrl:LOGOUT_URL parameters:dic success:^(id data) {
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",jsonDic);
            
            int code = [[jsonDic objectForKey:@"code"] intValue];
            if (code == 100) {
                
                NSLog(@"退出成功");
            }else{
                NSLog(@"退出失败");
                //                    [self.view makeToast:@"网络连接失败"];
            }
        } fail:^(NSError *error) {
            NSLog(@"%@+++++++++",error);
        }];
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"token"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"uid"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSLog(@"%d======%@",UID,TOKEN);
        
        [self.navigationController pushViewController:[[FirstViewController alloc] init] animated:YES];
    }];
    [alert addBtnTitle:@"取消" action:^{
        
    }];
    [alert showAlertWithSender:self];
    
    

}
#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件

//
////AlertView已经消失时执行的事件
//-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    NSLog(@"didDismissWithButtonIndex");
//}
//
////ALertView即将消失时的事件
//-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    NSLog(@"willDismissWithButtonIndex");
//}

//AlertView的取消按钮的事件
-(void)alertViewCancel:(UIAlertView *)alertView
{
    NSLog(@"alertViewCancel");
}
//
////AlertView已经显示时的事件
//-(void)didPresentAlertView:(UIAlertView *)alertView
//{
//    NSLog(@"didPresentAlertView");
//}
//
////AlertView即将显示时
//-(void)willPresentAlertView:(UIAlertView *)alertView
//{
//    NSLog(@"willPresentAlertView");
//}


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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
