//
//  FirstViewController.m
//  移动营销
//
//  Created by wmm on 16/2/24.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "FirstViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AFNetworking.h"
#import "UIWindow+YUBottomPoper.h"
#import "AppDelegate.h"
#import "MyTabBarController.h"
#import "ExperienceViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    NSLog(@"%f-%f",KSCreenW,KSCreenH);
    NSLog(@"%f-%f",self.view.frame.size.height,self.view.frame.size.width);//736-414
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, KSCreenW, KSCreenH)];
    bg.image = [UIImage imageNamed:@"firstbg.png"];
    [self.view addSubview:bg];
    
    UILabel *expLbl = [[UILabel alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-160, self.view.frame.size.width, 30)];
    expLbl.text = @"快速体验";
    expLbl.font = [UIFont systemFontOfSize:26];
    expLbl.textColor = mainOrangeColor;
    expLbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:expLbl];
    
    UIImageView *expImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2+65, self.view.frame.size.height-155, 20, 20)];
    expImg.image = [UIImage imageNamed:@"enter2.png"];
    [self.view addSubview:expImg];
    UIButton *expBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-160, self.view.frame.size.width, 30)];
    [expBtn addTarget:self action:@selector(toExperence) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:expBtn];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [loginBtn setTitle:NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [loginBtn setBackgroundColor:mainOrangeColor];
    loginBtn.layer.cornerRadius = 4.0;//圆角
    loginBtn.frame = CGRectMake(20, self.view.frame.size.height-90, (self.view.frame.size.width - 60)/2, 50);
    [loginBtn addTarget:self action:@selector(toLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [registerBtn setTitle:NSLocalizedString(@"注册", nil) forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [registerBtn setBackgroundColor:yellowBgColor];
    registerBtn.layer.cornerRadius = 4.0;
    registerBtn.frame = CGRectMake(self.view.frame.size.width -20-(self.view.frame.size.width - 60)/2, self.view.frame.size.height-90, (self.view.frame.size.width - 60)/2, 50);
    [registerBtn addTarget:self action:@selector(toRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.hidesBottomBarWhenPushed = YES;
}
//- (void)viewDidAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

//- (void)viewDidDisappear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = NO;
//}
- (void)toExperence{
    ExperienceViewController *experienceViewController = [[ExperienceViewController alloc] init];
    [self.navigationController pushViewController:experienceViewController animated:YES];

    
}

- (void)toLogin{
//    if (UID != 0 & TOKEN != nil) {
//        MyTabBarController *myTabBarController = [[MyTabBarController alloc] init];
//        [self presentViewController:myTabBarController animated:YES completion:nil];
//    }else{
    _loginViewController = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:_loginViewController animated:YES];
//    }
}

- (void)toRegister{
    [self.view.window  showPopWithButtonTitles:@[@"创建一个新企业",@"企业管理员给我开通账号，我加入"] styles:@[CustomerStyle2,CustomerStyle] whenButtonTouchUpInSideCallBack:^(int index  ) {
        NSLog(@"%d",index);
        if(index == 2) return ;
        RegisterViewController *registerViewController = [[RegisterViewController alloc]init];
        if(index == 0)
        registerViewController.userType = 0;//0企业管理者1员工
        if(index == 1)
        registerViewController.userType = 1;//0企业管理者1员工
//        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
//        [[UINavigationBar appearance] setTintColor:mainOrangeColor];
//        [self.navigationItem setBackBarButtonItem:backItem];
        
//        self.navigationController.navigationBar.barTintColor = mainOrangeColor;
//        self.navigationController.navigationBar.tintColor = mainOrangeColor;
//        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController pushViewController:registerViewController animated:YES];
//        [self presentViewController:registerViewController animated:YES completion:nil];
//      [self.navigationController pushViewController:registerViewController animated:YES];
        
    }];

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
