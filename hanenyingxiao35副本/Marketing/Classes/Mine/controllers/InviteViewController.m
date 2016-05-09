//
//  InviteViewController.m
//  Marketing
//
//  Created by HanenDev on 16/2/25.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "InviteViewController.h"
#import "JudgeNumber.h"

#define STARTX [UIView getWidth:10]
#define LINEW KSCreenW - 2*STARTX
@interface InviteViewController ()<UITextFieldDelegate>
{
    UITextField *_phoneTF;
    UITextField *_nameTF;
    UISwitch    *swit;
    BOOL   isInvite;
}
@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.titleView =  [ViewTool getNavigitionTitleLabel:@"邀请"];
    
    [self createUI];
}
- (void)createUI{
    self.navigationItem.leftBarButtonItem=[ViewTool getBarButtonItemWithTarget:self WithAction:@selector(goToBack)];
    
    CGFloat labelH =20;
    CGFloat tfHeight =30;
    //员工号码
    UILabel *phoneLabel = [ViewTool getLabelWith:CGRectMake(STARTX, 64 +5, LINEW, labelH) WithTitle:@"员工号码" WithFontSize:13.0f WithTitleColor:grayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [ViewTool setLableFont13:phoneLabel];
    [self.view addSubview:phoneLabel];
    
    _phoneTF = [self addTextFieldWithFrame:CGRectMake(STARTX, phoneLabel.maxY, LINEW, tfHeight) AndStr:@"请填写手机号(必填)" AndFont:14.0f AndTextColor:blackFontColor];
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    [_phoneTF setValue:placeholderGrayFontColor forKeyPath:@"_placeholderLabel.textColor"];
    [_phoneTF setValue:[UIFont systemFontOfSize:14.0f] forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:_phoneTF];
    
    UIView *lineView1 = [ViewTool getLineViewWith:CGRectMake(STARTX, _phoneTF.maxY + 4, LINEW, 1) withBackgroudColor:grayLineColor];
    [self.view addSubview:lineView1];
    //员工姓名
    UILabel *nameLabel = [ViewTool getLabelWith:CGRectMake(STARTX, _phoneTF.maxY + 10, LINEW, labelH) WithTitle:@"员工姓名" WithFontSize:13.0f WithTitleColor:grayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [ViewTool setLableFont13:nameLabel];
    [self.view addSubview:nameLabel];
    
    _nameTF = [self addTextFieldWithFrame:CGRectMake(STARTX, nameLabel.maxY, LINEW, tfHeight) AndStr:@"请填写姓名(必填)" AndFont:14.0f AndTextColor:blackFontColor];
    [_nameTF setValue:placeholderGrayFontColor forKeyPath:@"_placeholderLabel.textColor"];
    [_nameTF setValue:[UIFont systemFontOfSize:14.0f] forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:_nameTF];
    
    UIView *lineView2 = [ViewTool getLineViewWith:CGRectMake(STARTX, _nameTF.maxY + 4, LINEW, 1) withBackgroudColor:grayLineColor];
    [self.view addSubview:lineView2];
    
    //是否短信通知
    UILabel *inviteLabel = [ViewTool getLabelWith:CGRectMake(STARTX, _nameTF.maxY + 10 + 5, LINEW, labelH) WithTitle:@"短信通知ta加入企业应用" WithFontSize:13.0f WithTitleColor:blueFontColor WithTextAlignment:NSTextAlignmentLeft];
    
    [self.view addSubview:inviteLabel];
    
//    UIButton *inviteBtn = [[UIButton alloc]initWithFrame:CGRectMake(KSCreenW - 50 -STARTX, inviteLabel.y, 50, 30)];
//    [inviteBtn setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];
//    [inviteBtn setImage:[UIImage imageNamed:@"open"] forState:UIControlStateSelected];
//    [self.view addSubview:inviteBtn];
    
    swit = [[UISwitch alloc]initWithFrame:CGRectMake(KSCreenW - 50 -STARTX, inviteLabel.y, 30, 20)];
    [swit addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
    swit.onTintColor=blueFontColor;
    [swit setOn:NO animated:YES];
    [self.view addSubview:swit];
    if (swit.isOn) {
        isInvite = YES;
    }else{
        isInvite = NO;
    }
    
    UILabel *explainLabel = [[UILabel alloc]initWithFrame:CGRectMake(STARTX, inviteLabel.maxY + 15, KSCreenW/2 + 50, labelH*2)];
    explainLabel.text = @"如勾选此项,系统将自动发短信,邀请对方加入";
    explainLabel.textColor = grayFontColor;
    explainLabel.font = [UIFont systemFontOfSize:14.0f];
    explainLabel.numberOfLines = 0;
    [self.view addSubview:explainLabel];
    
    UIButton *referBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, KSCreenH - [UIView getHeight:50.0f], KSCreenW, [UIView getHeight:50.0f])];
    referBtn.layer.borderWidth = 0.5;
    referBtn.layer.borderColor = grayLineColor.CGColor;
    referBtn.backgroundColor = graySectionColor;
    [referBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    [referBtn setTitleColor:mainOrangeColor forState:UIControlStateNormal];
    [referBtn addTarget:self action:@selector(referInvitation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:referBtn];
}


//提交邀请
- (void)referInvitation:(UIButton *)btn{
    NSLog(@"yaoqingllllllll");
    if (_nameTF.text == nil | [_nameTF.text length] == 0 ){
        [self.view makeToast:@"请填写姓名"];
        return;
    }else if (_phoneTF.text == nil | [_phoneTF.text length] == 0 ){
        [self.view makeToast:@"请输入手机号码"];
        return;
    }else if (![JudgeNumber boolenPhone:_phoneTF.text]){
        [self.view makeToast:@"请输入正确手机号"];
        return;
    }
    NSString *doMessage;
    if (isInvite) {
        doMessage = @"true";
    }else{
        doMessage = @"false";
    }
    NSNumber *departmentID = [NSNumber numberWithInt:1];
    NSDictionary * dic =@{@"token":TOKEN,@"uid":@(UID),@"username":_phoneTF.text,@"name":_nameTF.text,@"department":departmentID,@"doMessage":doMessage};
    [DataTool postWithUrl:INVITE_STUFF_URL parameters:dic success:^(id data) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",jsonDic);
       int code = [jsonDic[@"code"] intValue];
        if (code == 100) {
            [self.view makeToast:@"邀请成功"];
            
            [self performSelector:@selector(tipToInvite) withObject:nil afterDelay:1];
            
        }else{
            NSString *message = jsonDic[@"message"];
            [self.view makeToast:message];
            
        }
        
    } fail:^(NSError *error) {
        NSLog(@"%@+++++++++",error);
    }];

}
- (void)tipToInvite{
    [self.navigationController popViewControllerAnimated:YES];
}
//开关
- (void)switchIsChanged:(UISwitch *)swit{
    if (isInvite) {
        isInvite = NO;
    }else{
        isInvite = YES;
    }
    
}

-(UITextField *)addTextFieldWithFrame:(CGRect)frame AndStr:(NSString *)placeholder AndFont:(CGFloat)font AndTextColor:(UIColor *)color
{
    UITextField *textF=[[UITextField alloc]initWithFrame:frame];
    textF.userInteractionEnabled = YES;
    textF.textColor = color;
    textF.font =[UIFont systemFontOfSize:font];
    textF.placeholder=placeholder;
    textF.delegate = self;
    [ViewTool setTFPlaceholderFont14:textF];
    return textF;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_nameTF resignFirstResponder];
    [_phoneTF resignFirstResponder];
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
