//
//  LoginViewController.m
//  移动营销
//
//  Created by wmm on 16/2/24.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "JudgeNumber.h"
#import "MyTabBarController.h"
#import "ForgetPassViewController.h"
#import "UserModel.h"

@interface LoginViewController (){
    
}

@property (nonatomic, strong) UITextField *phoneFld;
@property (nonatomic, strong) UITextField *passFld;

@property (nonatomic, strong) UIButton *remPassBtn;
@property (readonly, nonatomic) int isRemPass;//1记住2不记住

@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat statusBarHeight = 0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        statusBarHeight = 20;
    }
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:@"登录"] ;
    self.navigationItem.leftBarButtonItem=[ViewTool getBarButtonItemWithTarget:self WithAction:@selector(goToBack)];
    
    UIImageView *phoneImg = [[UIImageView alloc] initWithFrame:CGRectMake(20,statusBarHeight+44+20, 22, 24)];
    phoneImg.image = [UIImage imageNamed:@"phone.png"];
    [self.view addSubview:phoneImg];
    
    UILabel *phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(50,phoneImg.y, 80, 22)];
    phoneLab.text = @"手机号";
    phoneLab.textColor = blackFontColor;
    phoneLab.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:phoneLab];
    _phoneFld = [[UITextField alloc] initWithFrame:CGRectMake(130,phoneImg.y+2, KSCreenW-150, 22)];
    _phoneFld.placeholder = @"请输入手机号";
    _phoneFld.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneFld.keyboardType = UIKeyboardTypePhonePad;//电话键盘
    [_phoneFld setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    _phoneFld.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_phoneFld];
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10,phoneLab.y+37, KSCreenW-20, 1)];
    line.layer.borderWidth = 18;
    line.layer.borderColor = [grayLineColor CGColor];
    [self.view addSubview:line];
    
    
    UIImageView *checkImg = [[UIImageView alloc] initWithFrame:CGRectMake(20,phoneImg.y+57, 22, 24)];
    checkImg.image = [UIImage imageNamed:@"pass2.png"];
    [self.view addSubview:checkImg];
    UILabel *checkLab = [[UILabel alloc] initWithFrame:CGRectMake(50,phoneImg.y+57, 80, 22)];
    checkLab.text = @"登录密码";
    checkLab.textColor = blackFontColor;
    checkLab.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:checkLab];
    _passFld = [[UITextField alloc] initWithFrame:CGRectMake(130,phoneImg.y+57, KSCreenW-150, 22)];
    _passFld.placeholder = @"请输入密码";
    _passFld.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passFld.returnKeyType =UIReturnKeyGo;//return键
    _passFld.secureTextEntry = YES;//密码
    [_passFld setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    _passFld.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_passFld];
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(10,phoneImg.y+57+37, KSCreenW-20, 1)];
    line2.layer.borderWidth = 1;
    line2.layer.borderColor = [grayLineColor CGColor];
    [self.view addSubview:line2];
    
    
    _remPassBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_remPassBtn setBackgroundImage:[UIImage imageNamed:@"rempass.png"] forState:UIControlStateNormal];
    _remPassBtn.frame = CGRectMake(20,checkImg.y+45, 22, 24);
    [_remPassBtn addTarget:self action:@selector(changeRemPass) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_remPassBtn];
    
    UILabel *remPassLab = [[UILabel alloc] initWithFrame:CGRectMake(50,checkImg.y+47, 80, 22)];
    remPassLab.text = @"记住密码";
    remPassLab.textColor = blackFontColor;
    remPassLab.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:remPassLab];
    
    UIButton *forgetPassBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [forgetPassBtn setTitle:NSLocalizedString(@"忘记密码？", nil) forState:UIControlStateNormal];
    [forgetPassBtn setTitleColor:yellowBgColor forState:UIControlStateNormal];
    [forgetPassBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    forgetPassBtn.frame = CGRectMake(KSCreenW-100, checkImg.y+47, 80, 22);
    [forgetPassBtn addTarget:self action:@selector(forgetPass) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetPassBtn];
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_loginBtn setTitle:NSLocalizedString(@"确认登录", nil) forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [_loginBtn setBackgroundColor:mainOrangeColor];
    _loginBtn.layer.cornerRadius = 4.0;//圆角
    _loginBtn.frame = CGRectMake(20, forgetPassBtn.maxY+100, KSCreenW-40, 50);
    _loginBtn.userInteractionEnabled=NO;//不可点击
    _loginBtn.alpha=0.4;//变灰
    [_loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_loginBtn];
    
    _phoneFld.delegate = self;
    _passFld.delegate = self;
    
    [_phoneFld addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [_passFld addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _isRemPass = [[userDefaults objectForKey:@"isRemPass"] intValue];
    if(_isRemPass == 1){
        _phoneFld.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        _passFld.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        [_remPassBtn setBackgroundImage:[UIImage imageNamed:@"rempass.png"] forState:UIControlStateNormal];
        
        _loginBtn.userInteractionEnabled=YES;//不可点击
        _loginBtn.alpha=1;//变灰
        
    }else if(_isRemPass == 2){
        [_remPassBtn setBackgroundImage:[UIImage imageNamed:@"norempass.png"] forState:UIControlStateNormal];
    }else{
        
        _isRemPass = 1;
        [_remPassBtn setBackgroundImage:[UIImage imageNamed:@"rempass.png"] forState:UIControlStateNormal];
        [userDefaults setInteger:_isRemPass forKey:@"isRemPass"];
        [userDefaults synchronize];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}
//- (void)viewDidAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)goToBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)changeRemPass{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(_isRemPass == 1){
        [_remPassBtn setBackgroundImage:[UIImage imageNamed:@"norempass.png"] forState:UIControlStateNormal];
        _isRemPass = 2;
        [userDefaults setInteger:_isRemPass forKey:@"isRemPass"];
        
    }else if(_isRemPass == 2){
        [_remPassBtn setBackgroundImage:[UIImage imageNamed:@"rempass.png"] forState:UIControlStateNormal];
        _isRemPass = 1;
        [userDefaults setInteger:_isRemPass forKey:@"isRemPass"];
    }
    [userDefaults synchronize];
}

- (void)forgetPass{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [[UINavigationBar appearance] setTintColor:mainOrangeColor];
    [self.navigationItem setBackBarButtonItem:backItem];
    ForgetPassViewController *forgetPassViewController = [[ForgetPassViewController alloc] init];
    [self.navigationController pushViewController:forgetPassViewController animated:YES];
}

- (void)login{
    if (_phoneFld.text == nil | [_phoneFld.text length] == 0 ){
        [self.view makeToast:@"请输入手机号"];
        return;
    }else if (![JudgeNumber boolenPhone:_phoneFld.text]){
        [self.view makeToast:@"请输入正确的手机号"];
        return;
    }else if (_passFld.text == nil | [_passFld.text length] == 0 ){
        [self.view makeToast:@"请输入密码"];
        return;
    }else if ([_passFld.text length] < 6 ){
        [self.view makeToast:@"密码不小于6位"];
        return;
    }
    [_phoneFld resignFirstResponder];
    [_passFld resignFirstResponder];
    
    //    [DataTool login:_phoneFld.text withPass:_passFld.text fromView:self];
//       _myTabBarController = [[MyTabBarController alloc] init];
    //    [self presentViewController:_myTabBarController animated:YES completion:nil];
    //
    //
//        MyNavigationController *myNavigationController = self.navigationController;
    
//        [self.navigationController presentViewController:_myTabBarController animated:YES completion:nil];
    //
//        return;
    
    [self toLogin];
}

- (void)toLogin{
    [self.view makeToastActivity];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:_phoneFld.text, @"username", _passFld.text, @"password", nil];

    [DataTool postWithUrl:LOGIN_URL parameters:params success:^(id data) {
    id backdata = CRMJsonParserWithData(data);
    int code = [[backdata objectForKey:@"code"] intValue];
    if(code != 100){
        
        NSString * message = [(NSDictionary *)backdata objectForKey:@"message"];
        [self.view makeToast:message];
        [self.view hideToastActivity];
        
    }else{
        
        NSString * token = [(NSDictionary *)backdata objectForKey:@"token"];
        NSDictionary *user = [(NSDictionary *)backdata objectForKey:@"user"];
        
        NSDictionary *dict = [DataTool changeType:user];
        
        UserModel *loginer = [[UserModel alloc] init];
        [loginer setValuesForKeysWithDictionary:dict];
        //            [userDefaults setObject:loginer forKey:@"user"];
        
        NSString * userid = (NSString *)[dict objectForKey:@"uid"];
        NSString * username = (NSString *)[dict objectForKey:@"username"];
        NSString * department = (NSString *)[dict objectForKey:@"department"];
        NSString * departmentName = (NSString *)[dict objectForKey:@"departmentName"];
        NSString * img = (NSString *)[dict objectForKey:@"img"];
        NSString * logo = (NSString *)[dict objectForKey:@"logo"];
        NSString * name = (NSString *)[dict objectForKey:@"name"];
        NSString * type = (NSString *)[dict objectForKey:@"type"];
        //          NSString *type = [[[NSUserDefaults standardUserDefaults] objectForKey:@"type"] stringValue];//取值
        
        NSLog(@"%@",type);
        
        [userDefaults setObject:token forKey:@"token"];
        [userDefaults setObject:userid forKey:@"uid"];
        [userDefaults setObject:username forKey:@"username"];
        [userDefaults setObject:department forKey:@"department"];
        [userDefaults setObject:type forKey:@"type"];
        [userDefaults setObject:img forKey:@"img"];
        [userDefaults setObject:logo forKey:@"logo"];
        [userDefaults setObject:name forKey:@"name"];
        [userDefaults setObject:departmentName forKey:@"departmentName"];
        
        [userDefaults setObject:_passFld.text forKey:@"password"];
        
        [userDefaults synchronize];
        
        _myTabBarController = [[MyTabBarController alloc] init];
        [self presentViewController:_myTabBarController animated:YES completion:nil];
    }
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
        [self.view hideToastActivity];
        [self.view makeToast:@"登录失败"];
    }];
}

- (void)textFieldChanged:(UITextField *)textField{
    if (textField == _phoneFld) {
        if ([_phoneFld.text length] > 20) {
            _phoneFld.text = [_phoneFld.text substringToIndex:20];
        }
    }
    if (textField == _passFld) {
        if ([_passFld.text length] > 20) {
            _passFld.text = [_passFld.text substringToIndex:20];
        }
    }
    if(_phoneFld.text != nil & [_phoneFld.text length] != 0 & _passFld.text != nil & [_passFld.text length] != 0 ){
        _loginBtn.userInteractionEnabled=YES;//可点击
        _loginBtn.alpha=1;
    }else{
        _loginBtn.userInteractionEnabled=NO;
        _loginBtn.alpha=0.4;
    }
}

//关闭虚拟键盘。
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField == _passFld){
        [_phoneFld resignFirstResponder];
        [_passFld resignFirstResponder];
        [self login];
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_phoneFld resignFirstResponder];
    [_passFld resignFirstResponder];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
