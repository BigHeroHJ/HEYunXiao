//
//  RegisterViewController.m
//  移动营销
//
//  Created by wmm on 16/2/24.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "RegisterViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "JudgeNumber.h"
#import "MyTabBarController.h"
#import "UIView+ViewFrame.h"

@interface RegisterViewController ()

@property (nonatomic, strong) UITextField *phoneFld;
@property (nonatomic, strong) UITextField *checkFld;
@property (nonatomic, strong) UITextField *checkFld2;
@property (nonatomic, strong) UITextField *passFld;
@property (nonatomic, strong) UITextField *passFld2;

@property (nonatomic, strong) UIImageView *checkPic;
@property (nonatomic, strong) NSString *imgKey;

@property (nonatomic, strong) UIButton *submitBtn;

@property (nonatomic, strong) UIButton *getCodeBtn;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat statusBarHeight = 0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        statusBarHeight = 20;
    }
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:@"注册"];
    self.navigationItem.leftBarButtonItem=[ViewTool getBarButtonItemWithTarget:self WithAction:@selector(goToBack)];
    [self getCodeImg];
    
    if(_userType == 1){
        UILabel *registerLab = [[UILabel alloc] initWithFrame:CGRectMake(0,statusBarHeight+44, self.view.width, 50)];
        registerLab.backgroundColor = graySectionColor;
        registerLab.text = @"请根据管理员发送的短信，找到账号信息并填写到下面的区域";
        //自动折行设置
        registerLab.lineBreakMode = NSLineBreakByWordWrapping;
        registerLab.numberOfLines = 0;
        registerLab.textAlignment = NSTextAlignmentCenter;
        registerLab.textColor = blackFontColor;
        registerLab.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:registerLab];
        
        statusBarHeight = statusBarHeight + 50;
    }
    
    NSArray *imgNameArray = @[@"phone.png",@"checkpic.png",@"checkcode.png",@"pass.png",@"pass2.png"];
    NSArray *titleArray = @[@"手机号",@"图形验证",@"验证码",@"密码",@"确认密码"];

    for (int i = 0; i < 5; i++) {
        [self createImgViewWithName:imgNameArray[i] withFrame:CGRectMake(20, statusBarHeight+62+CELLHEIGHT2*i, 22, 24)];
        [self createImgViewWithText:titleArray[i] withFrame:CGRectMake(50, statusBarHeight+62+CELLHEIGHT2*i, 80, 22)];
        [self createLineWithFrame:CGRectMake(10, statusBarHeight+62+CELLHEIGHT2*(i+1)-21, self.view.width-20, 1)];
    }
    
    _phoneFld = [self createFieldWithFrame:CGRectMake(130,statusBarHeight+62, KSCreenW-150, 22) withPlaceholder:@"请输入手机号"];
    _phoneFld.keyboardType = UIKeyboardTypePhonePad;//电话键盘
    [self.view addSubview:_phoneFld];
    
    _checkFld = [self createFieldWithFrame:CGRectMake(130,_phoneFld.y+CELLHEIGHT2, 100, 22) withPlaceholder:@"请输入图中字符"];
    [self.view addSubview:_checkFld];

    _checkFld2 = [self createFieldWithFrame:CGRectMake(130,_phoneFld.y+CELLHEIGHT2*2, 100, 22) withPlaceholder:@"请输入验证码"];
    [self.view addSubview:_checkFld2];
    
    _passFld = [self createFieldWithFrame:CGRectMake(130,_phoneFld.y+CELLHEIGHT2*3, KSCreenW-150, 22) withPlaceholder:@"请输入6~20位密码"];
    _passFld.secureTextEntry = YES;//密码
    [self.view addSubview:_passFld];
    
    _passFld2 = [self createFieldWithFrame:CGRectMake(130,_phoneFld.y+CELLHEIGHT2*4, KSCreenW-150, 22) withPlaceholder:@"再次输入密码"];
    _passFld2.secureTextEntry = YES;//密码
    _passFld2.returnKeyType =UIReturnKeyGo;//return键
    [self.view addSubview:_passFld2];

    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    changeBtn.frame = CGRectMake(KSCreenW-70,_checkFld.y-15, 80, 48);
    [changeBtn addTarget:self action:@selector(getCodeImg) forControlEvents:UIControlEventTouchUpInside];
//    changeBtn.backgroundColor = grayLineColor;
    [self.view addSubview:changeBtn];
    
    self.checkPic = [[UIImageView alloc] initWithFrame:CGRectMake(KSCreenW-80,_checkFld.y-15, 60, 35)];
    [self.view addSubview:self.checkPic];
    
    UILabel *changeLab = [[UILabel alloc] initWithFrame:CGRectMake(KSCreenW-80,self.checkPic.maxY+3, 60, 10)];
    changeLab.text = @"换一张";
    changeLab.textAlignment = NSTextAlignmentCenter;
    changeLab.font = [UIFont systemFontOfSize:11];
    changeLab.textColor = grayFontColor;
    [self.view addSubview:changeLab];

    _getCodeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_getCodeBtn setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
    [_getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_getCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
    _getCodeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _getCodeBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_getCodeBtn setBackgroundColor:yellowBgColor];
    _getCodeBtn.layer.cornerRadius = 2.0;//圆角
    _getCodeBtn.userInteractionEnabled=NO;//不可点击
    _getCodeBtn.alpha=0.4;//变灰
    _getCodeBtn.frame = CGRectMake(KSCreenW-80, _checkFld2.y-8, 62, 35);
    [_getCodeBtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_getCodeBtn];

    _submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_submitBtn setTitle:NSLocalizedString(@"确认提交", nil) forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [_submitBtn setBackgroundColor:mainOrangeColor];
    _submitBtn.layer.cornerRadius = 4.0;//圆角
    _submitBtn.frame = CGRectMake(20, _passFld2.maxY+100, KSCreenW-40, 50);
    _submitBtn.userInteractionEnabled=NO;//不可点击
    _submitBtn.alpha=0.4;//变灰
    [_submitBtn addTarget:self action:@selector(sumitReg) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_submitBtn];
    
    _phoneFld.delegate = self;
    _checkFld.delegate = self;
    _checkFld2.delegate = self;
    _passFld.delegate = self;
    _passFld2.delegate = self;
    
    [_phoneFld addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [_checkFld addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [_checkFld2 addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [_passFld addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [_passFld2 addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
//
//    _seconds = 60;
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}

- (void)createImgViewWithName:(NSString *)name withFrame:(CGRect)frame{
    UIImageView *imeView = [[UIImageView alloc] initWithFrame:frame];
    imeView.image = [UIImage imageNamed:name];
    [self.view addSubview:imeView];
    
}

- (void)createImgViewWithText:(NSString *)text withFrame:(CGRect)frame{
    UILabel *lable = [[UILabel alloc] initWithFrame:frame];
    lable.text = text;
    lable.textColor = blackFontColor;
    lable.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:lable];
    
}
- (void)createLineWithFrame:(CGRect)frame{
    UIView *line = [ViewTool getLineViewWith:frame withBackgroudColor:grayLineColor];
    [self.view addSubview:line];
}

- (UITextField *)createFieldWithFrame:(CGRect)frame withPlaceholder:(NSString *)placeholder{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.placeholder = placeholder;
//    _passFld.secureTextEntry = YES;//密码
    [textField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    textField.font = [UIFont systemFontOfSize:14];
    return textField;
}

- (void)goToBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getCodeImg{    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:GET_IMGCODE_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _imgKey = [(NSDictionary *)responseObject objectForKey:@"imgKey"];
        NSString *str= [(NSDictionary *)responseObject objectForKey:@"data"];
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *image =[[UIImage alloc] initWithData:imageData];
        [self.checkPic setImage:image];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
//    NSString * str;
////  str =   [GET_IMGCODE_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [DataTool sendGetWithUrl:GET_IMGCODE_URL parameters:nil success:^(id data) {
////        id backData = CRMJsonParserWithData(data);
////        NSLog(@"%@",backData[@"imgKey"]);
////        NSLog(@"%@",backData[@"data"]);
//        NSLog(@"%@",data);
//        NSString *shabi =  [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",shabi);
//        UIImage *image =[[UIImage alloc] initWithData:data];
//        [self.checkPic setImage:image];
//        
//        
//    } fail:^(NSError *error) {
//        NSLog(@"%@",error.localizedDescription);
//    }];
}

- (void)getCode{

    if (_phoneFld.text == nil | [_phoneFld.text length] == 0 | ![JudgeNumber boolenPhone:_phoneFld.text]){
        [self.view makeToast:@"请输入正确的手机号"];
        return;
    }else if (_checkFld.text == nil | [_checkFld.text length] == 0 ){
        [self.view makeToast:@"请输入图形验证码"];
        return;
    }else{
        NSString *isManager = @"true";
        if(_userType != 0){
            isManager = @"false";
        }
        NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:_phoneFld.text, @"username", _imgKey, @"imgKey",  _checkFld.text, @"code", isManager, @"isManager", nil];
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer.timeoutInterval = 20;
//        [manager.securityPolicy setAllowInvalidCertificates:YES];
        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        //是否允许CA不信任的证书通过
        policy.allowInvalidCertificates = YES;
        //是否验证主机名
        policy.validatesDomainName = NO;
        manager.securityPolicy = policy;
        
        [manager POST:GET_PHONECODE_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            int code = [[(NSDictionary *)responseObject objectForKey:@"code"] intValue];
            if(code != 100)//连接500和501
            {
                NSString * message = [(NSDictionary *)responseObject objectForKey:@"message"];
                [self.view makeToast:message];
            }else{
                [DateTool startTime:_getCodeBtn];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
        
        
    }
}

- (void)sumitReg{
    NSLog(@"sumitReg");
    
    if (_phoneFld.text == nil | [_phoneFld.text length] == 0 ){
        [self.view makeToast:@"请输入手机号"];
        return;
    }else if (![JudgeNumber boolenPhone:_phoneFld.text]){
        [self.view makeToast:@"请输入正确的手机号"];
        return;
    }else if (_checkFld.text == nil | [_checkFld.text length] == 0 ){
        [self.view makeToast:@"请输入图形验证码"];
        return;
    }else if (_checkFld2.text == nil | [_checkFld2.text length] == 0 ){
        [self.view makeToast:@"请输入验证码"];
        return;
    }else if (_passFld.text == nil | [_passFld.text length] == 0 ){
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
    NSString *isManager = @"true";
    if(_userType != 0){
        isManager = @"false";
    }
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:_phoneFld.text, @"username", _checkFld2.text, @"phoneCode",  _passFld.text, @"password",_passFld2.text, @"repassword",isManager,@"isManager", nil];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:REGISTER_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.view hideToastActivity];
        NSLog(@"%@",responseObject);
        int code = [[(NSDictionary *)responseObject objectForKey:@"code"] intValue];
        if(code != 100)
        {
            NSString * message = [(NSDictionary *)responseObject objectForKey:@"message"];
            [self.view makeToast:message];
        }else{
            [self.view makeToast:@"注册成功"];
            [DataTool login:_phoneFld.text withPass:_passFld.text fromView:self];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self.view hideToastActivity];
        [self.view makeToast:@"注册失败"];
    }];
}

- (void)textFieldChanged:(UITextField *)textField{
    if (textField == _phoneFld) {
        if ([_phoneFld.text length] > 20) {
            _phoneFld.text = [_phoneFld.text substringToIndex:20];
        }
    }
    if (textField == _checkFld) {
        if ([_checkFld.text length] > 10) {
            _checkFld.text = [_checkFld.text substringToIndex:10];
        }
    }
    if (textField == _checkFld2) {
        if ([_checkFld2.text length] > 10) {
            _checkFld2.text = [_checkFld2.text substringToIndex:10];
        }
    }
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
    if(_phoneFld.text != nil & [_phoneFld.text length] !=0 & _checkFld.text != nil & [_checkFld.text length] != 0 ){
        _getCodeBtn.userInteractionEnabled=YES;//可点击
        _getCodeBtn.alpha=1;
    }else{
        _getCodeBtn.userInteractionEnabled=NO;//不可点击
        _getCodeBtn.alpha=0.4;
    }
    if(_phoneFld.text != nil & [_phoneFld.text length] != 0 &  _checkFld.text != nil & [_checkFld.text length] != 0 &  _checkFld2.text != nil & [_checkFld2.text length] != 0  & _passFld.text != nil & [_passFld.text length] != 0 & _passFld2.text != nil & [_passFld2.text length] != 0 ){
        _submitBtn.userInteractionEnabled=YES;//可点击
        _submitBtn.alpha=1;
    }else{
        _submitBtn.userInteractionEnabled=NO;
        _submitBtn.alpha=0.4;
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{

}

//关闭虚拟键盘。
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField == _passFld2){
        [_phoneFld resignFirstResponder];
        [_checkFld resignFirstResponder];
        [_checkFld2 resignFirstResponder];
        [_passFld resignFirstResponder];
        [_passFld2 resignFirstResponder];
        [self sumitReg];
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_phoneFld resignFirstResponder];
    [_checkFld resignFirstResponder];
    [_checkFld2 resignFirstResponder];
    [_passFld resignFirstResponder];
    [_passFld2 resignFirstResponder];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
