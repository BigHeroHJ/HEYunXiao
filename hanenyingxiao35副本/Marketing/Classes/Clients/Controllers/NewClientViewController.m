//
//  NewClientViewController.m
//  Marketing
//
//  Created by HanenDev on 16/3/2.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "NewClientViewController.h"
#import "DetailClientCell.h"
#import "SatusSelectViewController.h"
#import "JudgeNumber.h"
#import "MapClientViewController.h"
#import "ClientsViewController.h"
#import "SVProgressHUD.h"

#define STARTX [UIView getWidth:10]
#define MYCELLHEIGHT 60

@interface NewClientViewController ()<UITextFieldDelegate,StatusSelectDelegate,MapClientViewControllerDelegate>
{
    NSArray      *_basicArray;
    NSArray      *_contactArray;
    
    UIScrollView * scrollView;
    
    CLLocationCoordinate2D coordinate;
    
}
@property(nonatomic,strong)UITextField    *companyTF;
@property(nonatomic,strong)UITextField    *nameTF;
@property(nonatomic,strong)UITextField    *numberTF;
@property(nonatomic,strong)UITextField    *departmentTF;
@property(nonatomic,strong)UITextField    *businessTF;
@property(nonatomic,strong)UITextField    *levelTF;
@property(nonatomic,strong)UITextField    *fromTF;
@property(nonatomic,strong)UITextField    *statusTF;

@property(nonatomic,strong)UIButton       *levelBtn;
@property(nonatomic,strong)UIButton       *formBtn;
@property(nonatomic,strong)UIButton       *statusBtn;

@property(nonatomic,strong)UIButton       *locationBtn;

@property(nonatomic,strong)UITextField    *phoneTF;
@property(nonatomic,strong)UITextField    *mobileTF;
@property(nonatomic,strong)UITextField    *emailTF;
@property(nonatomic,strong)UITextField    *addressTF;
@property(nonatomic,strong)UITextField    *remarkTF;
@property(nonatomic,strong)UITextField    *postalTF;
@property(nonatomic,strong)UITextField    *faxTF;
@property(nonatomic,strong)UITextField    *webTF;

@end

@implementation NewClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:@"新建客户"];
    
    
    self.navigationItem.leftBarButtonItem=[ViewTool getBarButtonItemWithTarget:self WithAction:@selector(goToBack)];
    _basicArray = @[@"公司",@"姓名",@"编号",@"级别",@"部门",@"职务",@"来源",@"状态"];
    _contactArray = @[@"电话",@"手机",@"邮箱",@"地址",@"备注",@"邮编",@"传真",@"公司网址"];
    
    [self createUI];
    
    [self initCardDictionary];
}

- (void)createUI{
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, KSCreenH - [UIView getHeight:50])];
    scrollView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:scrollView];
    
    UIButton *referBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, KSCreenH - [UIView getHeight:50.0f], KSCreenW, [UIView getHeight:50.0f])];
    referBtn.layer.borderWidth = 0.5;
    referBtn.layer.borderColor = grayLineColor.CGColor;
    referBtn.backgroundColor = graySectionColor;
    [referBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    [referBtn setTitleColor:darkOrangeColor forState:UIControlStateNormal];
    [referBtn addTarget:self action:@selector(referNewClient:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:referBtn];
    
    
    [self initSectionOne];
    [self initSectionTwo];

}
- (void)initCardDictionary{
    
    NSLog(@"%@",_dictionary);
    
    NSArray *array;
    if (_dictionary.count>0) {
        
        array = [_dictionary objectForKey:@"comp"];
        if (array.count > 0) {
            _companyTF.text = array[0];
        }
        
        array = [_dictionary objectForKey:@"name"];
        if (array.count > 0) {
            _nameTF.text = array[0];
        }
        
        array = [_dictionary objectForKey:@"dept"];
        if (array.count > 0) {
            _departmentTF.text = array[0];
        }
        
        array = [_dictionary objectForKey:@"title"];
        if (array.count > 0) {
            _businessTF.text = array[0];
        }
        
        array = [_dictionary objectForKey:@"tel"];
        if (array.count > 0) {
            _phoneTF.text = array[0];
        }
        
        array = [_dictionary objectForKey:@"mobile"];
        if (array.count > 0) {
            _mobileTF.text = array[0];
        }
        
        array = [_dictionary objectForKey:@"email"];
        if (array.count > 0) {
            _emailTF.text = array[0];
        }
        
        array = [_dictionary objectForKey:@"addr"];
        if (array.count > 0) {
            _addressTF.text = array[0];
        }
        
        array = [_dictionary objectForKey:@"post"];
        if (array.count > 0) {
            _postalTF.text = array[0];
        }
        
        array = [_dictionary objectForKey:@"fax"];
        if (array.count > 0) {
            _faxTF.text = array[0];
        }
        
        array = [_dictionary objectForKey:@"web"];
        if (array.count > 0) {
            _webTF.text = array[0];
        }
        
    }else{
        
    }
    
}
- (void)initSectionOne{
    CGFloat labelH = 20;
    CGFloat tfH    = 30;
    CGFloat tfY    = 5+ labelH;
    CGFloat tfW    = [UIView getWidth:200];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, 30)];
    view.backgroundColor = graySectionColor;
    [scrollView addSubview:view];
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(STARTX, 8, 5, view.height - 16)];
    imageView1.image = [UIImage imageNamed:@"lanse"];
    [view addSubview:imageView1];
    
    UILabel *basicLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView1.maxX + 5, 5, 200, 20)];
    basicLabel.text = @"基本信息";
    [ViewTool setLableFont12:basicLabel];
    basicLabel.textColor = blackFontColor;
    [view addSubview:basicLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STARTX, 30 - 1, KSCreenW , 1)];
    lineView.backgroundColor = grayLineColor;
    [view addSubview:lineView];
    
    for (int i = 0; i<_basicArray.count; i++) {
        UILabel *label = [ViewTool getLabelWith:CGRectMake(STARTX, view.maxY + 5+ MYCELLHEIGHT*i, KSCreenW, labelH) WithTitle:_basicArray[i] WithFontSize:13.0f WithTitleColor:lightGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
        [ViewTool setLableFont13:label];
        [scrollView addSubview:label];
        
        UIView *line = [ViewTool getLineViewWith:CGRectMake(STARTX, view.maxY +(MYCELLHEIGHT -1)*(i+1) , KSCreenW - 2*STARTX, 1) withBackgroudColor:grayLineColor];
        [scrollView addSubview:line];
        
        if (i == _basicArray.count - 1) {
            [line removeFromSuperview];
        }
    }
    
    _companyTF = [self addTextFieldWithFrame:CGRectMake(STARTX, view.maxY + tfY, tfW +100, tfH) AndStr:@"请添加公司(必填)"];
    [scrollView addSubview:_companyTF];
    
    _nameTF = [self addTextFieldWithFrame:CGRectMake(STARTX, _companyTF.maxY + tfY+5, tfW, tfH) AndStr:@"请填写人员(必填)" ];
    [scrollView addSubview:_nameTF];
    
    _numberTF = [self addTextFieldWithFrame:CGRectMake(STARTX, _nameTF.maxY + tfY+5, tfW, tfH) AndStr:@"请填写编号" ];
    [scrollView addSubview:_numberTF];
    
    _levelTF = [self addTextFieldWithFrame:CGRectMake(STARTX, _numberTF.maxY + tfY+5, tfW, tfH) AndStr:@"请选择级别(必填)"];
    _levelTF.enabled = NO;
    [scrollView addSubview:_levelTF];
    
    _levelBtn = [[UIButton alloc]initWithFrame:CGRectMake(KSCreenW - STARTX - 30, _levelTF.y, 20, 20)];
    [_levelBtn addTarget:self action:@selector(clickToSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_levelBtn setImage:[UIImage imageNamed:@"级别"] forState:UIControlStateNormal];
    _levelBtn.tag = 1000;
    [scrollView addSubview:_levelBtn];
    
    _departmentTF = [self addTextFieldWithFrame:CGRectMake(STARTX, _levelTF.maxY + tfY+5, tfW, tfH) AndStr:@"请填写部门" ];
    [scrollView addSubview:_departmentTF];
    
    _businessTF = [self addTextFieldWithFrame:CGRectMake(STARTX, _departmentTF.maxY + tfY+5, tfW, tfH) AndStr:@"请填写职务" ];
    [scrollView addSubview:_businessTF];
    
    _fromTF = [self addTextFieldWithFrame:CGRectMake(STARTX, _businessTF.maxY + tfY+5, tfW, tfH) AndStr:@"请选择来源(必填)"];
    _fromTF.enabled = NO;
    [scrollView addSubview:_fromTF];
    
    _formBtn = [[UIButton alloc]initWithFrame:CGRectMake(KSCreenW - STARTX - 30, _fromTF.y, 20, 20)];
    [_formBtn addTarget:self action:@selector(clickToSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_formBtn setImage:[UIImage imageNamed:@"来源"] forState:UIControlStateNormal];
    _formBtn.tag = 2000;
    [scrollView addSubview:_formBtn];
    
    _statusTF = [self addTextFieldWithFrame:CGRectMake(STARTX, _fromTF.maxY + tfY+5, tfW, tfH) AndStr:@"请选择状态(必填)"];
    _statusTF.enabled = NO;
    [scrollView addSubview:_statusTF];
    
    _statusBtn = [[UIButton alloc]initWithFrame:CGRectMake(KSCreenW - STARTX - 30, _statusTF.y, 20, 20)];
    [_statusBtn addTarget:self action:@selector(clickToSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_statusBtn setImage:[UIImage imageNamed:@"状态"] forState:UIControlStateNormal];
    _statusBtn.tag = 3000;
    [scrollView addSubview:_statusBtn];
    
}
- (void)initSectionTwo{
    CGFloat labelH = 20;
    CGFloat tfH    = 30;
    CGFloat tfY    = 5+ labelH;
    CGFloat tfW    = [UIView getWidth:200];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, _statusTF.maxY - 1  , KSCreenW, 30)];
    view.backgroundColor = graySectionColor;
    [scrollView addSubview:view];
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(STARTX,  8, 5, view.height - 16)];
    imageView1.image = [UIImage imageNamed:@"lanse"];
    [view addSubview:imageView1];
    
    UILabel *basicLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView1.maxX + 5,  5, 200, 20)];
    basicLabel.text = @"联系方式";
    [ViewTool setLableFont12:basicLabel];
    basicLabel.textColor = blackFontColor;
    [view addSubview:basicLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STARTX, 30 - 1, KSCreenW , 1)];
    lineView.backgroundColor = grayLineColor;
    [view addSubview:lineView];
    
    for (int i = 0; i<_contactArray.count; i++) {
        UILabel *label = [ViewTool getLabelWith:CGRectMake(STARTX, view.maxY + 5+ MYCELLHEIGHT*i, KSCreenW, labelH) WithTitle:_contactArray[i] WithFontSize:13.0f WithTitleColor:lightGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
        [ViewTool setLableFont13:label];
        [scrollView addSubview:label];
        
        UIView *line = [ViewTool getLineViewWith:CGRectMake(STARTX, view.maxY +(MYCELLHEIGHT -1)*(i+1) , KSCreenW - 2*STARTX, 1) withBackgroudColor:grayLineColor];
        [scrollView addSubview:line];
        
        if (i == _contactArray.count - 1) {
            [line removeFromSuperview];
        }
    }
    
    _phoneTF = [self addTextFieldWithFrame:CGRectMake(STARTX, view.maxY + tfY, tfW, tfH) AndStr:@"请填写电话"];
    [scrollView addSubview:_phoneTF];
    
    _mobileTF = [self addTextFieldWithFrame:CGRectMake(STARTX, _phoneTF.maxY + tfY+5, tfW, tfH) AndStr:@"请填写手机(必填)"];
    [scrollView addSubview:_mobileTF];
    
    _emailTF = [self addTextFieldWithFrame:CGRectMake(STARTX, _mobileTF.maxY + tfY+5, tfW, tfH) AndStr:@"请填写邮箱"];
    [scrollView addSubview:_emailTF];
    
    _addressTF = [self addTextFieldWithFrame:CGRectMake(STARTX, _emailTF.maxY + tfY+5, tfW + 100, tfH) AndStr:@"请填写地址(必填)" ];
    [scrollView addSubview:_addressTF];
    
    _locationBtn = [[UIButton alloc]initWithFrame:CGRectMake(KSCreenW - STARTX - 30, _addressTF.y, 25, 25)];
    [_locationBtn addTarget:self action:@selector(clickToLoaction:) forControlEvents:UIControlEventTouchUpInside];
    [_locationBtn setImage:[UIImage imageNamed:@"定位蓝色"] forState:UIControlStateNormal];
    [scrollView addSubview:_locationBtn];
    
    _remarkTF = [self addTextFieldWithFrame:CGRectMake(STARTX, _addressTF.maxY + tfY+5, tfW, tfH) AndStr:@"请填写备注" ];
    [scrollView addSubview:_remarkTF];
    
    _postalTF = [self addTextFieldWithFrame:CGRectMake(STARTX, _remarkTF.maxY + tfY+5, tfW, tfH) AndStr:@"请填写邮编" ];
    [scrollView addSubview:_postalTF];
    
    _faxTF = [self addTextFieldWithFrame:CGRectMake(STARTX, _postalTF.maxY + tfY+5, tfW, tfH) AndStr:@"请填写传真"];
    [scrollView addSubview:_faxTF];
    
    _webTF = [self addTextFieldWithFrame:CGRectMake(STARTX, _faxTF.maxY + tfY+5, tfW, tfH) AndStr:@"请填写公司网址" ];
    [scrollView addSubview:_webTF];
    
    scrollView.contentSize = CGSizeMake(KSCreenW, _webTF.maxY);
    
}
- (void)clickToSelect:(UIButton *)btn{
    SatusSelectViewController *vc = [[SatusSelectViewController alloc]init];
    vc.delegate =self;
    vc.num = btn.tag;
    [self.navigationController pushViewController:vc animated:NO];
    
    
    
    switch (btn.tag) {
        case 1000:
        {
            vc.ar = _levelArray;
            vc.itemTitle = @"等级";
            if (_levelTF.text) {
                vc.valuetTitle = _levelTF.text;
            }
        }
            break;
        case 2000:
        {
            vc.itemTitle = @"来源";
            vc.ar = _fromArray;
            if (_fromTF.text) {
                vc.valuetTitle = _fromTF.text;
            }
        }
            break;
        case 3000:
        {
            vc.itemTitle = @"客户状态";
            vc.ar = _statusArray;
            if (_statusTF.text) {
                vc.valuetTitle = _statusTF.text;
            }
        }
            break;
        default:
            break;
    }
    
}
#pragma mark --跳转地图
- (void)clickToLoaction:(UIButton *)btn{
    
    MapClientViewController *mapVC = [[MapClientViewController alloc]init];
    mapVC.result = 1;
    mapVC.delegate = self;
    [self.navigationController pushViewController:mapVC animated:YES];
    
}
#pragma mark --地图代理返回值
- (void)getClickPlaceName:(NSString *)PlaceString withCoordinat2D:(CLLocationCoordinate2D)pt{
    
    _addressTF.text = PlaceString;
    coordinate = pt;
}
- (void)getToAddress:(NSString *)str{
    _addressTF.text = str;
}
- (void)selectStatusWith:(NSString *)string withNum:(NSInteger)count withInt:(int)number{
    if (count == 1000) {
        _levelTF.text = string;
    }else if (count == 2000){
        _fromTF.text = string;
    }else if(count == 3000){
        _statusTF.text = string;
    }
    
}
//提交按钮
- (void)referNewClient:(UIButton *)btn{
    if (_companyTF.text == nil | [_companyTF.text length] == 0 ){
        [self.view makeToast:@"请添加公司"];
        return;
    }else if (_nameTF.text == nil | [_nameTF.text length] == 0 ){
        [self.view makeToast:@"请添加人员"];
        return;
    }else if (_levelTF.text == nil | [_levelTF.text length] == 0 ){
        [self.view makeToast:@"请选择级别"];
        return;
    }else if (_fromTF.text == nil | [_fromTF.text length] == 0 ){
        [self.view makeToast:@"请选择来源"];
        return;
    }else if (_statusTF.text == nil | [_statusTF.text length] == 0 ){
        [self.view makeToast:@"请选择状态"];
        return;
    }else if (_mobileTF.text == nil | [_mobileTF.text length] == 0 ){
        [self.view makeToast:@"请输入手机号"];
        return;
    }else if (_addressTF.text == nil | [_addressTF.text length] == 0 ){
        [self.view makeToast:@"请填写地址"];
        return;
    }else if (![JudgeNumber boolenPhone:_mobileTF.text]){
        [self.view makeToast:@"请输入正确的手机号"];
        return;
    }
    
    [self getNewClientDetail];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{    
    [self.view endEditing:YES];
}
-(UITextField *)addTextFieldWithFrame:(CGRect)frame AndStr:(NSString *)placeholder
{
    UITextField *textF=[[UITextField alloc]initWithFrame:frame];
    textF.userInteractionEnabled = YES;
    textF.textColor = blackFontColor;
    textF.placeholder=placeholder;
    textF.delegate = self;
    [textF setValue:placeholderGrayFontColor forKeyPath:@"_placeholderLabel.textColor"];
    [ViewTool setTFPlaceholderFont14:textF];
    return textF;
}
- (void)goToBack{
    [self.navigationController popViewControllerAnimated:NO];
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
- (void)getNewClientDetail{
    
//    [SVProgressHUD show];
    int a1;
    int b1;
    int c1;
    
    a1 = [_levelArray indexOfObject:_levelTF.text] + 1;
    b1 = [_fromArray indexOfObject:_fromTF.text] + 1;
    c1 = [_statusArray indexOfObject:_statusTF.text] + 1;
    
    NSLog(@"%d%d%d",a1,b1,c1);
    NSNumber *levelNum =[NSNumber numberWithInt:a1];
    NSNumber *fromNum =[NSNumber numberWithInt:b1];
    NSNumber *statusNum =[NSNumber numberWithInt:c1];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{@"token":TOKEN,@"uid":@(UID),@"company":_companyTF.text,@"cname":_nameTF.text,@"cno":_numberTF.text,@"clevel":levelNum,@"department":_departmentTF.text,@"position":_businessTF.text,@"cfrom":fromNum,@"cstatus":statusNum,@"phone":_mobileTF.text,@"telephone":_phoneTF.text,@"email":_emailTF.text,@"address":_addressTF.text,@"remark":_remarkTF.text,@"zip":_postalTF.text,@"fax":_faxTF.text,@"website":_webTF.text}];
    if (coordinate.longitude && coordinate.latitude) {
        [dic setObject:@(coordinate.longitude) forKey:@"lon"];
        [dic setObject:@(coordinate.latitude) forKey:@"lat"];
    }
    
    NSLog(@"%@   dic++++++++  %@------",dic,ADD_CLIENT_URL);
    
    [DataTool postWithUrl:ADD_CLIENT_URL parameters:dic success:^(id data) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@++++++++",jsonDic);
        int code = [jsonDic[@"code"]intValue];
        if (code == 100) {
            
//            [SVProgressHUD dismiss];
            //[self.navigationController popToViewController:[[ClientsViewController alloc]init] animated:YES];
            
            //[self.navigationController popViewControllerAnimated:YES];
            
            if (_dictionary!=nil) {

                ClientsViewController *vc = [[ClientsViewController alloc]init];
                vc.tabBarController.hidesBottomBarWhenPushed = NO;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
}

@end
