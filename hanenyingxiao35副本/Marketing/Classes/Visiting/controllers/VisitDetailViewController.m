//
//  VisitDetailViewController.m
//  Marketing
//
//  Created by wmm on 16/3/4.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "VisitDetailViewController.h"
#import "VisitModel.h"
#import "Toast+UIView.h"
#import "MapClientViewController.h"
//动画时间
#define kAnimationDuration 0.2
//键盘
#define kViewHeight 56

@interface VisitDetailViewController ()
{
    NSArray    *_basicArray;
    NSArray    *_dataArray;
    UIScrollView * scrollView;
    CGFloat  diff;
    NSInteger number;
    BOOL canEdit;
    
    CGFloat lon;
    CGFloat lat;
}

@property(nonatomic,strong)UILabel    *visitDateLbl;
@property(nonatomic,strong)UILabel    *companyLbl;
@property(nonatomic,strong)UILabel    *visitObjectLbl;
@property(nonatomic,strong)UILabel    *visitTypeLbl;
@property(nonatomic,strong)UIButton   *visitAddressLbl;
@property(nonatomic,strong)UITextView *visitRecordTV;
@property(nonatomic,strong)UIButton   *saveBtn;

@property(nonatomic,strong)VisitModel * model;


@end

@implementation VisitDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:@"拜访纪要"];
      [self registerForKeyboardNotifications];
    self.navigationItem.leftBarButtonItem=[ViewTool getBarButtonItemWithTarget:self WithAction:@selector(goToBack)];
    _basicArray = @[@"拜访日期",@"公司名称",@"访问对象",@"拜访类型",@"预约地址",@"访谈纪要"];
    
    _model = [[VisitModel alloc] init];
    _model.visitId = _visitId;
    [self.view makeToastActivity];

    [self createUI];
}

- (void)createUI{
    
    //    CGRect *rect = self.view.frame;
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, KSCreenW, KSCreenH - 64)];
    scrollView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:scrollView];
    
    _saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, KSCreenH - TabbarH, KSCreenW, TabbarH)];
    _saveBtn.backgroundColor = graySectionColor;
    [_saveBtn setTitle:@"确认保存" forState:UIControlStateNormal];
    [_saveBtn setTitleColor:darkOrangeColor forState:UIControlStateNormal];
    _saveBtn.hidden = YES;
    [_saveBtn addTarget:self action:@selector(saveRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveBtn];
    UIView *linev = [ViewTool getLineViewWith:CGRectMake(0, 0, KSCreenW, 1) withBackgroudColor:grayLineColor];
    [_saveBtn addSubview:linev];
    
    [self initListView];
}
- (void)initListView{
    CGFloat labelH = 20;
    CGFloat tfH    = 20;
    CGFloat tfY    = 20+ labelH;
    CGFloat tfW    = KSCreenW - 2*LEFTWIDTH - 30;
    
    for (int i = 0; i<_basicArray.count; i++) {
        UILabel *label = [ViewTool getLabelWith:CGRectMake(LEFTWIDTH, 5+CELLHEIGHT2*i, KSCreenW, labelH) WithTitle:_basicArray[i] WithFontSize:13.0f WithTitleColor:lightGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
        [ViewTool setLableFont13:label];
        [scrollView addSubview:label];
        
        if (i < _basicArray.count-1) {
            UIView *line = [ViewTool getLineViewWith:CGRectMake(LEFTWIDTH, (CELLHEIGHT2)*(i+1)-1 , KSCreenW - 2*LEFTWIDTH, 1) withBackgroudColor:grayLineColor];
            [scrollView addSubview:line];
        }
    }
    
    _visitDateLbl = [self addLableWithFrame:CGRectMake(LEFTWIDTH, 30, tfW, tfH) AndStr:@""  AndTextColor:blackFontColor];
    
    _companyLbl = [self addLableWithFrame:CGRectMake(LEFTWIDTH, _visitDateLbl.maxY + tfY, tfW, tfH) AndStr:@""  AndTextColor:blackFontColor];
    
    _visitObjectLbl = [self addLableWithFrame:CGRectMake(LEFTWIDTH, _companyLbl.maxY + tfY, tfW, tfH) AndStr:@""  AndTextColor:blackFontColor];
    
    _visitTypeLbl = [self addLableWithFrame:CGRectMake(LEFTWIDTH, _visitObjectLbl.maxY + tfY, tfW, tfH) AndStr:@""  AndTextColor:blackFontColor];
    
    _visitAddressLbl = [[UIButton alloc] initWithFrame:CGRectMake(LEFTWIDTH, _visitTypeLbl.maxY + tfY, tfW, tfH)];
    _visitAddressLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _visitAddressLbl.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [_visitAddressLbl setTitleColor:blackFontColor forState:UIControlStateNormal];
    _visitAddressLbl.titleLabel.font = [ViewTool getFont14];
    [_visitAddressLbl addTarget:self action:@selector(jumpToMap) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton  *btn = [[UIButton alloc] initWithFrame:CGRectMake(KSCreenW - LEFTWIDTH - 30, _visitAddressLbl.y, 23, 23)];
    [btn setBackgroundImage:[UIImage imageNamed:@"定位蓝色"] forState:UIControlStateNormal];
    [scrollView addSubview:btn];
    [btn addTarget:self action:@selector(jumpToMap) forControlEvents:UIControlEventTouchUpInside];
    
    _visitRecordTV = [[UITextView alloc] initWithFrame:CGRectMake(LEFTWIDTH-5, _visitAddressLbl.maxY +tfY, KSCreenW - 2*LEFTWIDTH, tfH*2)];
    _visitRecordTV.textColor = blackFontColor;
    _visitRecordTV.returnKeyType = UIReturnKeyDefault;
    _visitRecordTV.delegate = self;
//    if (!_canChangeText) {
//        _visitRecordTV.userInteractionEnabled = NO;
//    }
    
    _visitRecordTV.userInteractionEnabled = YES;
    _visitRecordTV.font = [ViewTool getFont14];
    
    if(_model.visittime == nil){
        _visitDateLbl.text = [self cutTimeString:_model.ordertime];
    }else{
        _visitDateLbl.text = [self cutTimeString:_model.visittime];
    }
    _companyLbl.text = _model.company;
    _visitObjectLbl.text = _model.cname;
    
    _visitTypeLbl.text = _model.visittype;
    [_visitAddressLbl setTitle:_model.address forState:UIControlStateNormal];
    _visitRecordTV.text = _model.content;
    
    [scrollView addSubview:_visitDateLbl];
    [scrollView addSubview:_companyLbl];
    [scrollView addSubview:_visitObjectLbl];
    [scrollView addSubview:_visitTypeLbl];
    [scrollView addSubview:_visitAddressLbl];
    [scrollView addSubview:_visitRecordTV];

    [self reloadData];
}
- (void)refreshData{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *dateStr;
    
    if(_model.visittime == nil){
        _visitDateLbl.text = [self cutTimeString:_model.ordertime];
        dateStr = _model.ordertime;
    }else{
        NSDate *orderDate = [dateFormatter dateFromString:_model.ordertime];
        NSDate *visitDate = [dateFormatter dateFromString:_model.visittime];
        
        int d = [DateTool compareOneDay:orderDate withAnotherDay:visitDate];

        if (d == 1) {
            
            _visitDateLbl.text = [self cutTimeString:_model.ordertime];
            dateStr = _model.ordertime;
        }else{
            _visitDateLbl.text = [self cutTimeString:_model.visittime];
            dateStr = _model.visittime;
        }
    }
    
    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    int d = [DateTool compareOneDay:date withAnotherDay:[NSDate date]];
    NSLog(@"%d*-*-*-*-*-*-*-*-*-",d);
    if (d == 1) {
        _visitRecordTV.editable = NO;//不可编辑
        canEdit = NO;
        
    }else{
        _visitRecordTV.editable = YES;
        canEdit = YES;
        [self initFeedText];
    }
    
    _companyLbl.text = _model.company;
    _visitObjectLbl.text = _model.cname;
    _visitTypeLbl.text = _model.visittype;
    [_visitAddressLbl setTitle:_model.address forState:UIControlStateNormal];
    _visitRecordTV.text = _model.content;
    
//    CGSize size = [@"Hello" boundingRectWithSize:CGSizeMake(KSCreenW - 2*LEFTWIDTH, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [ViewTool getFont14],NSForegroundColorAttributeName : blackFontColor} context:nil].size;
//    CGFloat height = size.height;
//    
//    CGSize size1 = [_model.content boundingRectWithSize:CGSizeMake(KSCreenW - 2*LEFTWIDTH, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [ViewTool getFont14],NSForegroundColorAttributeName : blackFontColor} context:nil].size;
//    if (size1.height < height) {
//        _visitRecordTV.height = height;
//    }else{
//        _visitRecordTV.height = size1.height;
//    }
    
    
    lon = [[DataTool changeType:_model.lon] floatValue];
    lat = [[DataTool changeType:_model.lat] floatValue];
}

- (void)reloadData{
    [self.view makeToastActivity];
    
    NSDictionary * params1 = [NSDictionary dictionaryWithObjectsAndKeys:@(UID), @"uid", TOKEN, @"token",@(_visitId), @"id", nil];
    NSLog(@"%@",params1);
    AFHTTPRequestOperationManager * manager1 = [AFHTTPRequestOperationManager manager];
    manager1.requestSerializer.timeoutInterval = 20;
    [manager1 POST:GET_VISIT_DETAIL_URL parameters:params1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.view hideToastActivity];
        NSLog(@"GET_VISIT_DETAIL_URL:%@",responseObject);
        int code = [[(NSDictionary *)responseObject objectForKey:@"code"] intValue];
        if(code != 100)
        {
            NSString * message = [(NSDictionary *)responseObject objectForKey:@"message"];
            [self.view makeToast:message];
        }else{
            
            NSDictionary * visitMap = [(NSDictionary *)responseObject objectForKey:@"visitMap"];
            [_model setValuesForKeysWithDictionary:visitMap];
            NSLog(@"%@",_model);
            [self refreshData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self.view hideToastActivity];
        //            [self.view makeToast:@"失败"];
    }];
}

- (void) initFeedText{
    //在弹出的键盘上面加一个view来放置退出键盘的Done按钮
    UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, KSCreenW, 40)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
    doneButton.tintColor = [UIColor blackColor];
    
    [topView setItems:buttonsArray];
    [_visitRecordTV setInputAccessoryView:topView];
}

//关闭键盘
-(void) dismissKeyBoard{
    [_visitRecordTV resignFirstResponder];
//    if(_model.content.length < _visitRecordTV.text.length){
    if (_model.content.length < _visitRecordTV.text.length) {
        _saveBtn.hidden = NO;
    }else{
        _saveBtn.hidden = YES;
    }
}


- (void)jumpToMap
{
    
    MapClientViewController * mapVC = [[MapClientViewController alloc] init];
    if (lon == 0&&lat == 0) {
        mapVC.result = 1;
    }else{
        mapVC.locationLongide = [NSString stringWithFormat:@"%f",lon];
        mapVC.locationLatitude =  [NSString stringWithFormat:@"%f",lat];
    }
    
    [self.navigationController pushViewController:mapVC animated:YES];

//    mapVC.locationLatitude = _model.lat;
//    mapVC.locationLongide = _model.lon;
    [self.navigationController pushViewController:mapVC animated:YES];
    NSLog(@"%@++++++-------",mapVC.locationLatitude);
    
    
    
}
- (NSString *)cutTimeString:(NSString *)dateString
{
//    NSRange range = [dateString rangeOfString:@":" options:NSBackwardsSearch];
//    if (dateString.length > range.location) {
//        NSString *timeS = [dateString substringToIndex:range.location];
//    }
    NSString   *timeS;
    if (dateString.length>15) {
        timeS = [dateString substringToIndex:16];
    }
   
    return timeS;
}
//提交按钮
- (void)saveRecord:(UIButton *)btn{
    
    if(_model.content.length >= _visitRecordTV.text.length){
        [self.view makeToast:@"请增加访谈纪要"];
        return;
    }
    
    NSDictionary * params1 = [NSDictionary dictionaryWithObjectsAndKeys:@(UID), @"uid", TOKEN, @"token",@(_visitId), @"id", _visitRecordTV.text,@"content", nil];
//    NSLog(@"%@",params1);
    AFHTTPRequestOperationManager * manager1 = [AFHTTPRequestOperationManager manager];
    manager1.requestSerializer.timeoutInterval = 20;
    [manager1 POST:UPDATE_VISIT_CONTENT_URL parameters:params1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.view hideToastActivity];
        NSLog(@"GET_VISIT_DETAIL_URL:%@",responseObject);
        int code = [[(NSDictionary *)responseObject objectForKey:@"code"] intValue];
        if(code != 100)
        {
            NSString * message = [(NSDictionary *)responseObject objectForKey:@"message"];
            [self.view makeToast:message];
            NSLog(@"%@",message);
        }else{
            [self.view makeToast:@"增加成功"];
            _saveBtn.hidden = YES;
            [self goToBack];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self.view hideToastActivity];
    }];
}

-(UILabel *)addLableWithFrame:(CGRect)frame AndStr:(NSString *)placeholder AndTextColor:(UIColor *)color
{
    UILabel *textL=[[UILabel alloc]initWithFrame:frame];
    textL.userInteractionEnabled = YES;
    textL.textColor = color;
    [ViewTool setLableFont14:textL];
    return textL;
}

- (void)goToBack{
    if(!_saveBtn.hidden){
        NSString *str = [NSString stringWithFormat:@"访谈纪要未保存是否退出？"];
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleActionSheet];
        //添加Button
        [alertController addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            [[self navigationController] popViewControllerAnimated:YES];

        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        [[self navigationController] popViewControllerAnimated:YES];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = NO;
}
- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//监听事件
- (void)handleKeyboardDidShow:(NSNotification*)paramNotification
{

    NSDictionary *usrInfoDict = paramNotification.userInfo;
    CGRect keyRect = [usrInfoDict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat showtime = [usrInfoDict[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSLog(@"%f",keyRect.origin.y );
//    scrollView.contentInset=UIEdgeInsetsMake(0, 0,keyRect.size.height, 0);
    if(_visitRecordTV.isFirstResponder){

        diff = fabs( keyRect.origin.y - CGRectGetMaxY(_visitRecordTV.frame) - 64);
        NSLog(@"%f",CGRectGetMaxY(_visitRecordTV.frame));
        
        if (keyRect.origin.y < (CGRectGetMaxY(_visitRecordTV.frame) + 64)) {
            [UIView animateWithDuration:showtime animations:^{
                //                self.view.transform = CGAffineTransformMakeTranslation(0, -diff);
                scrollView.frame = CGRectMake(0, -diff + 64, KSCreenW, KSCreenH - 64);
//                scrollView.transform = CGAffineTransformMakeTranslation(0, -diff);
                if(!_saveBtn.hidden){
                    
                    scrollView.transform = CGAffineTransformMakeTranslation(0, -diff);
//                    scrollView.frame = CGRectMake(0, -diff + 64, KSCreenW, KSCreenH - 64-TabbarH);
                }
            }];
        }
    }

}

- (void)handleKeyboardDidHidden:(NSNotification *)noti
{
    NSDictionary *usrInfoDict = noti.userInfo;
    CGFloat showtime = [usrInfoDict[UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    scrollView.contentInset=UIEdgeInsetsZero;
    [UIView animateWithDuration:showtime animations:^{
        //                self.view.transform = CGAffineTransformMakeTranslation(0, -diff);
//        scrollView.transform = CGAffineTransformMakeTranslation(0, -diff);
        scrollView.frame = CGRectMake(0, 64, KSCreenW, KSCreenH -64);
        if(!_saveBtn.hidden){
            scrollView.frame = CGRectMake(0, 64, KSCreenW, KSCreenH -64-TabbarH);
        }
    }];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardDidHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)textViewDidChange:(UITextView *)textView{
    
    CGSize size = [textView.text boundingRectWithSize:CGSizeMake(KSCreenW - 2*LEFTWIDTH, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [ViewTool getFont14],NSForegroundColorAttributeName : blackFontColor} context:nil].size;
    //获取一行的高度
    CGSize size1 = [@"Hello" boundingRectWithSize:CGSizeMake(KSCreenW - 2*LEFTWIDTH, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [ViewTool getFont14],NSForegroundColorAttributeName : blackFontColor} context:nil].size;
    
    
    NSInteger i = size.height/size1.height;
    NSLog(@"%f",(size.height - size1.height*i));
    
    if (i==1) {
        //设置全局的变量存储数字如果换行就改变这个全局变量
        number = i;
    }
    if (number!=i) {
        number = i;
        NSLog(@"selfnum = %ld",number);

        scrollView.y -= (size.height - textView.height);
        textView.height = size.height;
        
    }
    
//    
//    CGRect line = [textView caretRectForPosition:textView.selectedTextRange.start];
//    
//    CGFloat overflow = line.origin.y + line.size.height-( textView.contentOffset.y + textView.bounds.size.height-textView.contentInset.bottom - textView.contentInset.top );
//    
//    if(overflow > 0 ) {
//        
//        CGPoint offset = textView.contentOffset;
//        
//        offset.y+= overflow + 7;
//        [UIView animateWithDuration:.2 animations:^{
//             
//             [textView setContentOffset:offset];
//         }];
//        
//    }

}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    
    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//        if(_model.content.length < _visitRecordTV.text.length){
//            _saveBtn.hidden = NO;
//        }else{
//            _saveBtn.hidden = YES;
//            return NO;
//        }
    }else{
        NSLog(@"12121:%@",text);
        
        if ([text length] == 0) {
            if(_model.content.length < _visitRecordTV.text.length){
                _saveBtn.hidden = NO;
            }else{
                _saveBtn.hidden = YES;
                return NO;
            }
        }

    }
    
    return YES;
    
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (!canEdit) {
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"12121");
    [_visitRecordTV resignFirstResponder];
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end