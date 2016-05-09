//
//  ResetPassViewController.m
//  Marketing
//
//  Created by wmm on 16/2/28.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "ResetPassViewController.h"
#import "AFNetworking.h"
#import "JudgeNumber.h"
#import "MyTabBarController.h"
#import "DataTool.h"

@interface ResetPassViewController ()

@property (nonatomic, strong) UITextField *passFld;
@property (nonatomic, strong) UITextField *passFld2;

@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation ResetPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat statusBarHeight = 0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        statusBarHeight = 20;
    }
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:@"重置密码"];
    self.navigationItem.leftBarButtonItem=[ViewTool getBarButtonItemWithTarget:self WithAction:@selector(goToBack)];
    UIImageView *passImg = [[UIImageView alloc] initWithFrame:CGRectMake(20,statusBarHeight+44+20, 22, 24)];
    passImg.image = [UIImage imageNamed:@"pass.png"];
    [self.view addSubview:passImg];
    UILabel *passLab = [[UILabel alloc] initWithFrame:CGRectMake(50,passImg.y, 80, 22)];
    passLab.text = @"新密码";
    passLab.textColor = blackFontColor;
    passLab.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:passLab];
    _passFld = [[UITextField alloc] initWithFrame:CGRectMake(130,passImg.y, KSCreenW-150, 22)];
    _passFld.placeholder = @"请输入新密码";
    _passFld.secureTextEntry = YES;//密码
    [_passFld setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    _passFld.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_passFld];
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10,passImg.y+37, KSCreenW-20, 1)];
    line.layer.borderWidth = 18;
    line.layer.borderColor = [grayLineColor CGColor];
    [self.view addSubview:line];
    
    UIImageView *passImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(20,passImg.y+57, 22, 24)];
    passImg2.image = [UIImage imageNamed:@"pass2.png"];
    [self.view addSubview:passImg2];
    UILabel *passLab2 = [[UILabel alloc] initWithFrame:CGRectMake(50,passImg.y+57, 80, 22)];
    passLab2.text = @"确认密码";
    passLab2.textColor = blackFontColor;
    passLab2.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:passLab2];
    _passFld2 = [[UITextField alloc] initWithFrame:CGRectMake(130,passImg.y+57, KSCreenW-150, 22)];
    _passFld2.placeholder = @"请再输入一遍密码";
    _passFld2.secureTextEntry = YES;//密码
    _passFld2.returnKeyType =UIReturnKeyGo;//return键
    [_passFld2 setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    _passFld2.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_passFld2];
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(10,passImg.y+57+37, KSCreenW-20, 1)];
    line2.layer.borderWidth = 18;
    line2.layer.borderColor = [grayLineColor CGColor];
    [self.view addSubview:line2];
    
    _submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_submitBtn setTitle:NSLocalizedString(@"确认提交", nil) forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn.titleLabel setFont:[UIFont systemFontOfSize:24]];
    [_submitBtn setBackgroundColor:mainOrangeColor];
    _submitBtn.layer.cornerRadius = 4.0;//圆角
    _submitBtn.frame = CGRectMake(20, line2.y+100, KSCreenW-40, 50);
    _submitBtn.userInteractionEnabled=NO;//不可点击
    _submitBtn.alpha=0.4;//变灰
    [_submitBtn addTarget:self action:@selector(sumitPass) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_submitBtn];
    
    _passFld.delegate = self;
    _passFld2.delegate = self;
    
    [_passFld addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [_passFld2 addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)goToBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sumitPass{
    NSLog(@"sumitPass");
    
    if (_passFld.text == nil | [_passFld.text length] == 0 ){
        [self.view makeToast:@"请输入密码"];
        return;
    }else if (_passFld2.text == nil | [_passFld2.text length] == 0 ){
        [self.view makeToast:@"请再次输入密码"];
        return;
    }else if ([_passFld.text length] < 6 | [_passFld2.text length] < 6){
        [self.view makeToast:@"密码不小于6位"];
        return;
    }
    if (![_passFld.text isEqualToString:_passFld2.text]) {
        [self.view makeToast:@"两次密码不一致，请重新输入"];
        return;
    }

    [self.view makeToastActivity];
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:username, @"username",_passFld.text, @"password",_fwdKey,@"fwdKey", nil];
    NSLog(@"%@",params);
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:MODIFY_PASS_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.view hideToastActivity];
        NSLog(@"%@",responseObject);
        int code = [[(NSDictionary *)responseObject objectForKey:@"code"] intValue];
        NSString * message = [(NSDictionary *)responseObject objectForKey:@"message"];
        [self.view makeToast:message];
        NSLog(@"%@",message);
        if(code != 100)
        {
            NSString * message = [(NSDictionary *)responseObject objectForKey:@"message"];
            [self.view makeToast:message];
        }else{
            [self.view makeToast:@"修改成功"];
//            [self modifyToLogin:username withPass:_passFld.text];
            [DataTool login:username withPass:_passFld.text fromView:self];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self.view hideToastActivity];
        [self.view makeToast:@"修改失败"];
    }];
}

- (void)textFieldChanged:(UITextField *)textField{
    if (textField == _passFld) {
        if ([_passFld.text length] > 20) {
            _passFld.text = [_passFld.text substringToIndex:20];
        }
    }
    if (textField == _passFld2) {
        if ([_passFld2.text length] > 20) {
            _passFld2.text = [_passFld2.text substringToIndex:20];
        }
    }
    if(_passFld.text != nil & [_passFld.text length] != 0 & _passFld2.text != nil & [_passFld2.text length] != 0 ){
        _submitBtn.userInteractionEnabled=YES;//可点击
        _submitBtn.alpha=1;
    }else{
        _submitBtn.userInteractionEnabled=NO;
        _submitBtn.alpha=0.4;
    }
}

//关闭虚拟键盘。
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField == _passFld2){
        [_passFld resignFirstResponder];
        [_passFld2 resignFirstResponder];
        [self sumitPass];
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_passFld resignFirstResponder];
    [_passFld2 resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
