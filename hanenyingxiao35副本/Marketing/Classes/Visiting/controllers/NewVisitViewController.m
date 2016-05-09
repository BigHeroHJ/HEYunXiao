//
//  NewVisitViewController.m
//  Marketing
//
//  Created by wmm on 16/3/3.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "NewVisitViewController.h"
#import "SelectClientViewController.h"
#import "MapClientViewController.h"
#import "UIWindow+YUBottomPoper.h"

@interface NewVisitViewController ()<UITextFieldDelegate,SelectClientViewDelegate,UIActionSheetDelegate,MapClientViewControllerDelegate>
{
    NSArray    *_basicArray;
    NSArray    *_placeholderArray;
    UIScrollView * scrollView;
    
    UIView       *_dateView;
    UIDatePicker * datePicker;
    //点击选择 开始结束时间
    NSDate      *_starDate;
    UIButton *dateBtn;
    
    CLLocationCoordinate2D coordinate;
}

@property(nonatomic,strong)NSString    *visitDateStr;

@property(nonatomic,strong)UITextField    *visitDateFld;
@property(nonatomic,strong)UITextField    *companyFld;
@property(nonatomic,strong)UITextField    *visitObjectFld;
@property(nonatomic,strong)UITextField    *visitTypeFld;
@property(nonatomic,strong)UITextField    *visitAddressFld;
@property(nonatomic)BOOL    isRemind;

@property(nonatomic,strong)UISwitch       *switchBtn;

@property(nonatomic,strong)UIButton       *submitBtn;

@property(nonatomic)int       cid;
@property(nonatomic,strong)NSMutableArray   *typeListArray;
@property(nonatomic)int       type;



@end

@implementation NewVisitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:@"新建拜访"];
    
    self.navigationItem.leftBarButtonItem=[ViewTool getBarButtonItemWithTarget:self WithAction:@selector(goToBack)];
    _basicArray = @[@"拜访日期",@"公司名称",@"访问对象",@"拜访类型",@"预约地址"];
    _placeholderArray = @[@"请选择日期",@"请选择公司",@"请添加人员",@"请选择类型",@"请输入拜访地址"];
    
    [self reloadData];
    [self createUI];
//    [self creatDatePick];
    [UIView getHeight:60];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
}

- (void)reloadData{
    NSDictionary * paramesdictionary = @{@"token": TOKEN,@"uid" : @(UID),@"type":@5};
    [DataTool sendGetWithUrl:GET_DICTIONARY_URL parameters:paramesdictionary success:^(id data) {
        NSLog(@"%@",data);
        NSDictionary * backData = CRMJsonParserWithData(data);
        int code = [[(NSDictionary *)backData objectForKey:@"code"] intValue];
        if(code != 100)//连接500和501
        {
            NSString * message = [(NSDictionary *)backData objectForKey:@"message"];
            [self.view makeToast:message];
        }else{
            _typeListArray = [(NSDictionary *)backData objectForKey:@"list"];
            self.type = [[_typeListArray[0] objectForKey:@"value"] intValue];
        }
        
    } fail:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
}
- (void)createUI{
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, KSCreenH - [UIView getHeight:50])];
    scrollView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:scrollView];
    
    _submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, KSCreenH - TabbarH, KSCreenW, TabbarH)];
    _submitBtn.layer.borderWidth = 0.5;
    _submitBtn.layer.borderColor = grayLineColor.CGColor;
    _submitBtn.backgroundColor = graySectionColor;
    [_submitBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:darkOrangeColor forState:UIControlStateNormal];
    [_submitBtn addTarget:self action:@selector(submitNewVisit) forControlEvents:UIControlEventTouchUpInside];
    _submitBtn.hidden = YES;
    [self.view addSubview:_submitBtn];

    [self initListView];
    [self creatDatePick];
    
}
- (void)initListView{
    CGFloat labelH = 20;
    CGFloat tfH    = 20;
    CGFloat tfY    = 20+ labelH;
    CGFloat tfW    = [UIView getWidth:220];
    CGFloat btnW = 23.0f;
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = grayLineColor;
    [scrollView addSubview:lineView];
    
    for (int i = 0; i<_basicArray.count; i++) {
        UILabel *label = [ViewTool getLabelWith:CGRectMake(LEFTWIDTH, 5+CELLHEIGHT2*i, KSCreenW, labelH) WithTitle:_basicArray[i] WithFontSize:13.0f WithTitleColor:lightGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
        [ViewTool setLableFont13:label];
        [scrollView addSubview:label];
        
        UIView *line = [ViewTool getLineViewWith:CGRectMake(LEFTWIDTH, (CELLHEIGHT2)*(i+1)-1 , KSCreenW - 2*LEFTWIDTH, 1) withBackgroudColor:grayLineColor];
        [scrollView addSubview:line];
    }
    
    _visitDateFld = [self addTextFieldWithFrame:CGRectMake(LEFTWIDTH, 15+labelH, tfW, tfH) AndStr:@"请选择日期"  AndTextColor:blackFontColor];
    _visitDateFld.userInteractionEnabled = NO;
    
    dateBtn = [self createButtonWithFrame:CGRectMake(KSCreenW-LEFTWIDTH-30, 10+labelH, btnW, btnW) WithImage:@"calendar.png" WithTag:0];
    
    _companyFld = [self addTextFieldWithFrame:CGRectMake(LEFTWIDTH, _visitDateFld.maxY + tfY, tfW, tfH) AndStr:@"请选择公司"  AndTextColor:blackFontColor];
    
    _companyFld.userInteractionEnabled = NO;
    UIButton *companyBtn = [self createButtonWithFrame:CGRectMake(KSCreenW-LEFTWIDTH-30, _visitDateFld.maxY + tfY, btnW, btnW) WithImage:@"company.png" WithTag:1];
    
    _visitObjectFld = [self addTextFieldWithFrame:CGRectMake(LEFTWIDTH, _companyFld.maxY + tfY, tfW, tfH) AndStr:@"请添加人员"  AndTextColor:blackFontColor];
        _visitObjectFld.userInteractionEnabled = NO;

    _visitTypeFld = [self addTextFieldWithFrame:CGRectMake(LEFTWIDTH, _visitObjectFld.maxY + tfY, tfW, tfH) AndStr:@"请选择类型"  AndTextColor:blackFontColor];
    
    _visitTypeFld.userInteractionEnabled = NO;
    
    UIButton *typeBtn = [self createButtonWithFrame:CGRectMake(KSCreenW-LEFTWIDTH-30, _visitObjectFld.maxY + tfY, btnW, btnW) WithImage:@"type.png" WithTag:2];
    
    _visitAddressFld = [self addTextFieldWithFrame:CGRectMake(LEFTWIDTH, _visitTypeFld.maxY + tfY, tfW, tfH) AndStr:@"请输入拜访地址"  AndTextColor:blackFontColor];
    _visitAddressFld.userInteractionEnabled = NO;
    _visitAddressFld.returnKeyType =UIReturnKeyGo;//return键

    UIButton *addressBtn = [self createButtonWithFrame:CGRectMake(KSCreenW-LEFTWIDTH-30, _visitTypeFld.maxY + tfY, btnW, btnW) WithImage:@"定位蓝色.png" WithTag:334343];
    
    UILabel *remindLabel = [ViewTool getLabelWith:CGRectMake(LEFTWIDTH, _visitAddressFld.maxY + 22, KSCreenW - 2 * LEFTWIDTH, labelH) WithTitle:@"预约提醒" WithFontSize:13.0f WithTitleColor:lightGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [ViewTool setLableFont13:remindLabel];
    
    
    _switchBtn =[[UISwitch alloc]init];
    _switchBtn.frame=CGRectMake(KSCreenW-LEFTWIDTH-50, _visitAddressFld.maxY + 20, 25, 10);
    _switchBtn.onTintColor=blueFontColor;
    [_switchBtn setOn:YES animated:YES];
    
    [_switchBtn addTarget:self action:@selector(getValue1:) forControlEvents:UIControlEventValueChanged];
    
    if (_switchBtn.isOn) {
        NSLog(@"It is On");
        _isRemind = YES;
    }else{
        _isRemind = NO;
    }
    
    UIView *line = [ViewTool getLineViewWith:CGRectMake(LEFTWIDTH, _visitAddressFld.maxY + 59 , KSCreenW - 2*LEFTWIDTH, 1) withBackgroudColor:grayLineColor];
    
    if(line.maxY > KSCreenH - TabbarH - 64){
        scrollView.contentSize = CGSizeMake(0, line.maxY + 10);
    }else{
        scrollView.contentSize = CGSizeMake(0, 0);
    }
    _companyFld.delegate = self;
    _visitAddressFld.delegate = self;
    _visitObjectFld.delegate = self;
    _visitTypeFld.delegate = self;
    
    [scrollView addSubview:_visitDateFld];
    [scrollView addSubview:dateBtn];
    [scrollView addSubview:_companyFld];
    [scrollView addSubview:companyBtn];
    [scrollView addSubview:_visitObjectFld];
    [scrollView addSubview:_visitTypeFld];
    [scrollView addSubview:typeBtn];
    [scrollView addSubview:_visitAddressFld];
    [scrollView addSubview:addressBtn];
    [scrollView addSubview:remindLabel];
    [scrollView addSubview:line];
    [scrollView addSubview:_switchBtn];
    
    if (_clientModel != nil) {
        _companyFld.text = _clientModel.company;
        _visitObjectFld.text = _clientModel.cname;
        _visitAddressFld.text = _clientModel.address;
        companyBtn.userInteractionEnabled = NO;
        _cid = _clientModel.clientId;
    }
    
}

- (void)getValue1:(UISwitch *)switchBtn{
    if (_isRemind) {
        _isRemind = NO;

//        _switchBtn.onTintColor=grayListColor;
//        _switchBtn.thumbTintColor=UIColorFromRGB(0xf6f6f6);
        
    }else{
        _isRemind = YES;
//        _switchBtn.onTintColor=blueFontColor;
//        _switchBtn.thumbTintColor=[UIColor whiteColor];
    }
    
}

- (void)creatDatePick
{
    _dateView = [[UIView alloc] initWithFrame:CGRectMake(0, KSCreenH, KSCreenW, [UIView getHeight:200.0f])];
    _dateView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_dateView];
    
    CGFloat buttonW = [UIView getWidth:30.0f];
    CGFloat buttonH = [UIView getWidth:35.0f];
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(_dateView.width - buttonW, 0, buttonW, buttonH)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:grayFontColor forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(clickSure:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.titleLabel.font= [UIFont systemFontOfSize:14.0f];
    [_dateView addSubview:sureBtn];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonW, buttonH)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:grayFontColor forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickSure:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font= [UIFont systemFontOfSize:14.0f];
    [_dateView addSubview:cancelBtn];
    
 
    UIView *line1 = [ViewTool getLineViewWith:CGRectMake(0, cancelBtn.maxY, KSCreenW, 0.8) withBackgroudColor:grayLineColor];
    [_dateView addSubview:line1];
    UIView *line = [ViewTool getLineViewWith:CGRectMake(0, 0, KSCreenW, 0.8) withBackgroudColor:grayLineColor];
    [_dateView addSubview:line];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, line1.maxY, _dateView.width, _dateView.height)];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    datePicker.locale = local;
    //   NSString * yearStr =  [DateTool getCurrentYears];
    //    int  moreyear = [yearStr intValue] + 1; //当前时间往后一年
    //    int  lessyear = [yearStr intValue] - 1;//当前时间之前一年
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy.MM.dd HH:mm"];//HH 大写就是24小时制 小写就是12小时制
    
    NSTimeInterval time = 365 * 30 * 24 * 60 * 60;
//    NSDate * lastYearDate = [currentDate dateByAddingTimeInterval:-time];
    NSDate * moreYearDate = [currentDate dateByAddingTimeInterval:time];
    
    datePicker.minimumDate = currentDate;//如果其中一个未设置 则默认用户可以选择 之前或未来的任何日期
    datePicker.maximumDate = moreYearDate;
    [datePicker setDate:currentDate animated:YES];
    [datePicker addTarget:self action:@selector(dateChoose:) forControlEvents:UIControlEventValueChanged];
    [_dateView addSubview:datePicker];
    
    
}
- (void)clickSure:(UIButton *)btn
{
    if ([btn.currentTitle isEqualToString:@"确定"]) {
        NSDateFormatter *formate = [[NSDateFormatter alloc]init];
        [formate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString * dateStr = [formate stringFromDate:datePicker.date];
        CGRect frame = _dateView.frame;
        [UIView animateWithDuration:0.5 animations:^{
            _dateView.frame = CGRectMake(0, KSCreenH , KSCreenW, frame.size.height);
        }];
        _visitDateFld.text = [DateTool getStringFormDate:datePicker.date] ;
        _visitDateStr = dateStr;
    }else{
        CGRect frame = _dateView.frame;
        [UIView animateWithDuration:0.5 animations:^{
            _dateView.frame = CGRectMake(0, KSCreenH, KSCreenW, frame.size.height);
        }];
        _visitAddressFld.text = @"";
        _visitDateStr = @"";
    }
    
    if(dateBtn.selected == YES){
        dateBtn.selected = NO;
    }
}

- (void)dateChoose:(UIDatePicker *)picker
{
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    [formate setDateFormat:@"yyyy:MM:dd HH:mm:ss"];
    NSString * dateStr = [formate stringFromDate:picker.date];
    NSLog(@"%@",dateStr);
    _visitDateStr = dateStr;
    _visitDateFld.text = [DateTool getStringFormDate:picker.date];
}

- (void)clickToSelect:(UIButton *)btn{
    if (btn.tag == 0) {
        NSLog(@"date");
        if(btn.selected == NO){
            CGRect frame = _dateView.frame;
            [UIView animateWithDuration:0.5 animations:^{
                _dateView.frame = CGRectMake(0, KSCreenH - frame.size.height, KSCreenW, frame.size.height);
            }];
        }else{
            CGRect frame = _dateView.frame;
            [UIView animateWithDuration:0.5 animations:^{
                _dateView.frame = CGRectMake(0, KSCreenH, KSCreenW, frame.size.height);
            }];
        }
        btn.selected = !btn.selected;
        
        
    }else if (btn.tag == 1){
        NSLog(@"company");
        SelectClientViewController *selectClientViewController = [[SelectClientViewController alloc] init];
        selectClientViewController.delegate = self;//设置代理
        [self.navigationController pushViewController:selectClientViewController animated:YES];
    }else if(btn.tag == 2){
        
        NSLog(@"type");
        NSMutableArray *titles = [NSMutableArray array];
        NSMutableArray *typeId = [NSMutableArray array];
        
        for (int i = 0; i<_typeListArray.count; i++) {
            
            NSString *title = [_typeListArray[i] objectForKey:@"level"];
            [titles addObject:title];
            int value = [[_typeListArray[i] objectForKey:@"value"] intValue];
            [typeId addObject:[NSNumber numberWithInt:value]];
        }
        NSMutableArray *styles = [NSMutableArray array];

        for (int i = 0; i < titles.count; i ++) {
            [styles addObject:CustomerStyle3];
        }
        [self.view.window showPopWithButtonTitles:titles styles:styles whenButtonTouchUpInSideCallBack:^(int index){
            NSLog(@"%d",index);
            if(index == 4) return ;
            self.type = [typeId[index] intValue];
            _visitTypeFld.text = titles[index];
            
        }];
        
    }else if(btn.tag == 334343){
        MapClientViewController *mapVC = [[MapClientViewController alloc] init];
        mapVC.result = 1;
        mapVC.delegate = self;
        [self.navigationController pushViewController:mapVC animated:YES];
    }
    if(_submitBtn.hidden == YES){
        _submitBtn.hidden = NO;
    }
}


//提交按钮
- (void)submitNewVisit{
    NSLog(@"submitNewVisit");
    if (_visitDateFld.text == nil | [_visitDateFld.text length] == 0 ){
        [self.view makeToast:@"请选择拜访日期"];
        return;
    }
    if (_companyFld.text == nil | [_companyFld.text length] == 0 ){
        [self.view makeToast:@"请添加公司"];
        return;
    }else if (_visitObjectFld.text == nil | [_visitObjectFld.text length] == 0 ){
        [self.view makeToast:@"请添加人员"];
        return;
    }else if (_visitTypeFld.text == nil | [_visitTypeFld.text length] == 0 ){
        [self.view makeToast:@"请选择拜访类型"];
        return;
    }else if (_visitAddressFld.text == nil | [_visitAddressFld.text length] == 0 ){
        [self.view makeToast:@"请输入拜访地址"];
        return;
    }
    NSLog(@"------");
    [self.view makeToastActivity];
    
    int isclock;
    if (_isRemind) {
        isclock = 1;
    }else{
        isclock = 0;
    }
    
    NSMutableDictionary * paramesdictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"token": TOKEN,@"uid" : @(UID),@"cid":@(_cid),@"ordertime":_visitDateStr,@"type":@(_type),@"isclock":@(isclock),@"address":_visitAddressFld.text}];
    
    if (coordinate.longitude && coordinate.latitude) {
        [paramesdictionary setObject:@(coordinate.longitude) forKey:@"lon"];
        [paramesdictionary setObject:@(coordinate.latitude) forKey:@"lat"];
    }
    
    NSLog(@"%@",paramesdictionary);
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:NEW_VISIT_URL parameters:paramesdictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.view hideToastActivity];
        NSLog(@"NEW_VISIT_URL:%@",responseObject);
        int code = [[(NSDictionary *)responseObject objectForKey:@"code"] intValue];
        if(code != 100)
        {
            NSString * message = [(NSDictionary *)responseObject objectForKey:@"message"];
            [self.view makeToast:message];
        }else{
            [self.view makeToast:@"新建成功"];
            [self.delegate refreshData];
            [self goToBack];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self.view hideToastActivity];
        [self.view makeToast:@"新建失败"];
    }];
}

-(UITextField *)addTextFieldWithFrame:(CGRect)frame AndStr:(NSString *)placeholder AndTextColor:(UIColor *)color
{
    UITextField *textF=[[UITextField alloc]initWithFrame:frame];
    textF.userInteractionEnabled = YES;
    textF.textColor = color;
    textF.placeholder=placeholder;
    [textF setValue:placeholderGrayFontColor forKeyPath:@"_placeholderLabel.textColor"];
    textF.delegate = self;
    [ViewTool setTFPlaceholderFont14:textF];
    return textF;
}

-(UILabel *)addLableWithFrame:(CGRect)frame AndStr:(NSString *)text AndTextColor:(UIColor *)color
{
    UILabel *textL=[[UILabel alloc]initWithFrame:frame];
    textL.userInteractionEnabled = YES;
    textL.textColor = color;
    textL.text = text;
    return textL;
}
//
//- (UIButton *)createButtonWithFrame:(CGRect)frame WithTitle:(NSString *)string WithFont:(CGFloat)font WithTag:(CGFloat)tag WithColor:(UIColor *)color
//{
//    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
//    [btn setTitle:string forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIFont systemFontOfSize:font];
//    [btn setTitleColor:color forState:UIControlStateNormal];
//    btn.tag = tag;
//    [btn addTarget:self action:@selector(clickToSelect:) forControlEvents:UIControlEventTouchUpInside];
//    return btn;
//}

- (UIButton *)createButtonWithFrame:(CGRect)frame WithImage:(NSString *)imgName WithTag:(CGFloat)tag
{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    [btn setImage:[UIImage imageNamed:imgName ] forState:UIControlStateNormal];
    btn.tag = tag;
    btn.selected = NO;
    [btn addTarget:self action:@selector(clickToSelect:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)goToBack{
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;//可更改为其他方式
    transition.subtype = kCATransitionFromBottom;//可更改为其他方式
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = NO;
}
- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = YES;
//    [_visitAddressFld resignFirstResponder];
}

//SelectClientViewDelegate
- (void)selectClient:(int)tag withName:(NSString *)companyName withCname:(NSString *)cName withAddress:(NSString *)address{
    
    _cid = tag;
    _companyFld.text = companyName;
    _visitObjectFld.text = cName;
    _visitAddressFld.text = address;
}

//键盘
- (void)textFieldChanged:(UITextField *)textField{
    if(_companyFld.text != nil & [_companyFld.text length] !=0 & _visitObjectFld.text != nil & [_visitObjectFld.text length] != 0 & _visitTypeFld.text != nil & [_visitTypeFld.text length] != 0 & _visitAddressFld.text != nil & [_visitAddressFld.text length] != 0 ){
        _submitBtn.userInteractionEnabled=YES;//可点击
        
        _submitBtn.alpha=1;
    }else{
        _submitBtn.userInteractionEnabled=NO;//不可点击
        _submitBtn.alpha=0.55;
     
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (_submitBtn.hidden == YES) {
        _submitBtn.hidden = NO;
    }
//    if(textField == _visitAddressFld){
//        MapClientViewController *mapVC = [[MapClientViewController alloc] init];
//           mapVC.delegate = self;
//        [self.navigationController pushViewController:mapVC animated:YES];
//     
//    }
}

- (void)keyboardWillShow:(NSNotification *)noti
{
   
}
- (void)getClickPlaceName:(NSString *)PlaceString withCoordinat2D:(CLLocationCoordinate2D)pt
{
    _visitAddressFld.text = PlaceString;
//    _visitAddressFld.enabled = NO;
    [_visitAddressFld resignFirstResponder];
    coordinate = pt;
}
//关闭虚拟键盘。
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    textField.enabled = YES;
    if(textField == _visitAddressFld){
        [self submitNewVisit];
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_companyFld resignFirstResponder];
    [_visitObjectFld resignFirstResponder];
    [_visitTypeFld resignFirstResponder];
    [_visitAddressFld resignFirstResponder];
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