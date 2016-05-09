//
//  CreatLeavingController.m
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/3.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "CreatLeavingController.h"
#import "QBImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SelectViewController.h"
#import "UserModel.h"
#import "PictureSelectView.h"
#import "UIWindow+YUBottomPoper.h"

#define SectionbackHeight 23.0f

@interface CreatLeavingController ()<UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,QBImagePickerControllerDelegate,SelectStaffViewDelegate>
{
    UIScrollView      *_scrollView;
    CGFloat             topSpace;
    CGFloat         btnW;
    
    //类型
    UIView        *_typeView;
    UILabel       *_typeLable;
    NSString *typeStr;
    int      _typeNum;
    BOOL     isCameraFirst;
    UILabel       *_chooseTypeLabel;
    UIButton      *_chooseBtn;
    
    //选择时间
    UIView        *_timeView;
    UILabel       *_startTime;
    UILabel       *_startTimeContent;
    UILabel       *_endTime;
    UILabel       *_endTimeContent;
    UIButton      *_chooseStartTime;
    UIButton      *_chooseEndTime;
    
    //请假天数
    UIView        *_dayCount;
    UILabel       *_titlabel;
    UITextField   *_dayCountField;
    
    //请假事由
    UIView        *_reasonLeavingView;
    UILabel       *_leavingLabel;
    UITextView    *_textView;
    UILabel       *_placeHolder;
    
    //图片
    UIView        *_picView;
    UILabel       *_picTitle;
    UIButton      *_takePicBtn;
    NSMutableArray *_choosePicDataArray;//所有图片的数组
    NSMutableArray *_cameraArray;
    NSMutableArray *_photosArray;
    PictureSelectView *picSele;
    int   picCount;//拿来命名
    //
    UIView      *_bottomView;
    UILabel     *_titleLabel;
    UIButton    *_addPersonsBtn;
    
    //
    UIButton    *_postBtn;
    
    CGFloat diff;
    
    ////选择日期视图
    UIView       *_dateView;
    UIDatePicker * datePicker;
    //点击选择 开始结束时间
    NSDate      *_starDate;
    NSDate      *_endDate;
    
    UIButton    *_lastClickBtn;
    
    NSMutableArray *_typeArray;
    NSInteger count ;//计算图片数组的个数
    UserModel  *_usermodel;
    
    NSMutableDictionary  *_lastPostDict;
    NSString  *startTimeStr;
    NSString * endTimeStr;
    
    
}
@end

@implementation CreatLeavingController
- (void)viewDidLoad
{
    [super viewDidLoad];
    picCount = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:@"新建请假"];
    if (IPhone4S) {
        topSpace = 5.0f;
    }else{
        topSpace = [UIView getWidth:10.0f];
    }
      isCameraFirst = NO;
    btnW = 20.0f;
     _choosePicDataArray = [NSMutableArray array];
    _photosArray = [NSMutableArray array];
    
    _cameraArray = [NSMutableArray array];
    self.navigationItem.leftBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithAction:@selector(popViewController)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self creatScrollView];
    [self creatTypeView];
    [self creatTimeView];
    [self creatDayView];
    [self creatReaonView];
    [self creatPicView];
    [self drawBottomView];
    [self addBtn];
    [self creatDatePick];
    [self initType];
}

//获取类型的数字字典
- (void)initType
{
    NSDictionary *dict = @{@"token" : TOKEN,@"uid" : @(UID),@"type" : @(4)};
    [DataTool sendGetWithUrl:GET_DICTIONARY_URL parameters:dict success:^(id data) {
        id backData = CRMJsonParserWithData(data);
        _typeArray = [NSMutableArray arrayWithArray:backData[@"list"]];
//        for (int i = 0; i< _typeArray.count; i++) {
//            
//        }
        NSLog(@"%@",_typeArray);
        
    } fail:^(NSError *error) {
        
    }];
}
- (void)creatScrollView
{
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, KSCreenW, KSCreenH - TabbarH -64)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleScrolltap:)];
    [_scrollView addGestureRecognizer:tap];
    
    //    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 50, KSCreenW, 200)];
    //    [_scrollView addSubview:vi];
    //    vi.backgroundColor = [UIColor orangeColor];
    
    NSLog(@"%@",NSStringFromCGRect(_scrollView.frame));
    //    _scrollView.contentSize = CGSizeMake(0, 700);
    //    _scrollView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:_scrollView];
    
    
}

- (void)creatTypeView
{
    
    _typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCreenW, [UIView getWidth:70])];
//    NSLog(@"%@",NSStringFromCGRect(_typeView.frame));
//        _typeView.backgroundColor = [UIColor cyanColor];
    [_scrollView addSubview:_typeView];
    
    
    _typeLable = [ViewTool getLabelWith:CGRectMake( topSpace, topSpace, 100, 15) WithTitle:@"请假类型" WithFontSize:14.0f WithTitleColor:lightGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_typeView addSubview:_typeLable];
    
    _chooseTypeLabel = [ViewTool getLabelWith:CGRectMake(_typeLable.x, _typeLable.maxY + topSpace, 100, 15) WithTitle:@"请选择(必填)" WithFontSize:16.0f WithTitleColor:placeholderGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_typeView addSubview:_chooseTypeLabel];
    
    
    _chooseBtn = [[UIButton alloc] initWithFrame:CGRectMake(KSCreenW -  topSpace - btnW, _chooseTypeLabel.y, btnW, btnW)];
    [_chooseBtn setBackgroundImage:[UIImage imageNamed:@"类型"] forState:UIControlStateNormal];
    [_chooseBtn addTarget:self action:@selector(chooseType) forControlEvents:UIControlEventTouchUpInside];
//    _chooseBtn.backgroundColor = blueFontColor;
    [_typeView addSubview:_chooseBtn];
    
  
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, _chooseTypeLabel.maxY + topSpace, KSCreenW, SectionbackHeight)];
    grayView.backgroundColor = graySectionColor;
    [_typeView addSubview:grayView];
    
    _typeView.frame = CGRectMake(0, 0,KSCreenW, grayView.maxY);
    
}

- (void)creatTimeView
{
//    NSLog(@"hfghfghfg%f",_typeView.maxY);
    _timeView = [[UIView alloc] initWithFrame:CGRectMake(0, _typeView.maxY, KSCreenW, 100)];
//    _timeView.backgroundColor = [UIColor redColor];
    [_scrollView addSubview:_timeView];
    
    _startTime = [ViewTool getLabelWith:CGRectMake( topSpace, topSpace, 100, 15) WithTitle:@"开始时间" WithFontSize:14.0f WithTitleColor:lightGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_timeView addSubview:_startTime];
    
    _startTimeContent = [ViewTool getLabelWith:CGRectMake(_startTime.x, _startTime.maxY+ topSpace, 150, 15) WithTitle:@"请选择(必填)" WithFontSize:16.0f WithTitleColor:placeholderGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_timeView addSubview:_startTimeContent];
    _chooseStartTime = [[UIButton alloc] initWithFrame:CGRectMake(KSCreenW -  topSpace - btnW, _startTimeContent.y, btnW, btnW)];
    [_chooseStartTime setBackgroundImage:[UIImage imageNamed:@"时间"] forState:UIControlStateNormal];
    _chooseStartTime.selected = NO;
    _chooseStartTime.tag = 1999;
    [_chooseStartTime addTarget:self action:@selector(chooseTime:) forControlEvents:UIControlEventTouchUpInside];
//    _chooseStartTime.backgroundColor = blueFontColor;
    [_timeView addSubview:_chooseStartTime];
    
    UIView *line1 = [ViewTool getLineViewWith:CGRectMake(_startTime.x, _startTimeContent.maxY + topSpace, KSCreenW - 2 * topSpace, 1) withBackgroudColor:grayLineColor];
    [_timeView addSubview:line1];
    
    
    _endTime = [ViewTool getLabelWith:CGRectMake( topSpace, line1.maxY + topSpace, 100, 15) WithTitle:@"结束时间" WithFontSize:14.0f WithTitleColor:lightGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_timeView addSubview:_endTime];
    
    _endTimeContent = [ViewTool getLabelWith:CGRectMake( topSpace, _endTime.maxY + topSpace, 150, 15) WithTitle:@"请选择(必填)" WithFontSize:16.0f WithTitleColor:placeholderGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_timeView addSubview:_endTimeContent];
    
    _chooseEndTime = [[UIButton alloc] initWithFrame:CGRectMake(KSCreenW -  topSpace - btnW, _endTimeContent.y, btnW, btnW)];
//    _chooseEndTime.backgroundColor = blueFontColor;
    _chooseEndTime.selected = NO;
    [_chooseEndTime setBackgroundImage:[UIImage imageNamed:@"时间"] forState:UIControlStateNormal];
    _chooseEndTime.tag = 1998;
    [_chooseEndTime addTarget:self action:@selector(chooseTime:) forControlEvents:UIControlEventTouchUpInside];
    [_timeView addSubview:_chooseEndTime];
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, _endTimeContent.maxY + topSpace, KSCreenW, SectionbackHeight)];
    grayView.backgroundColor = graySectionColor;
    [_timeView addSubview:grayView];
    _timeView.frame = CGRectMake(0, _typeView.maxY,KSCreenW, grayView.maxY);
    
}

- (void)creatDayView
{
    _dayCount = [[UIView alloc] initWithFrame:CGRectMake(0, _timeView.maxY, KSCreenW, [UIView getWidth:100])];
//    _dayCount.backgroundColor = [UIColor cyanColor];
    [_scrollView addSubview:_dayCount];
    
    
    _titlabel = [ViewTool getLabelWith:CGRectMake(_endTimeContent.x, topSpace, 100, 15) WithTitle:@"请假天数" WithFontSize:14.0f WithTitleColor:lightGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_dayCount addSubview:_titlabel];
    
    _dayCountField = [[UITextField alloc] initWithFrame:CGRectMake(_titlabel.x, _titlabel.maxY + topSpace, 200, 20)];
    _dayCountField.delegate = self;
    _dayCountField.keyboardType = UIKeyboardTypeDecimalPad;

    _dayCountField.textColor = blackFontColor;
    _dayCountField.font = [UIFont systemFontOfSize:15.0f];
    _dayCountField.placeholder = @"请输入请假天数(必填)";
    [_dayCountField setValue:placeholderGrayFontColor forKeyPath:@"_placeholderLabel.textColor"];
    [_dayCountField setValue:[UIFont systemFontOfSize:16.0f] forKeyPath:@"_placeholderLabel.font"];
    
//    [ViewTool getLabelWith:CGRectMake(_titlabel.x, _titlabel.maxY + topSpace, 150, 15) WithTitle:@"请输入请假天数(必填)" WithFontSize:13.0f WithTitleColor:blackFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_dayCount addSubview:_dayCountField];

    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, _dayCountField.maxY + topSpace, KSCreenW, SectionbackHeight)];
    grayView.backgroundColor = graySectionColor;
    [_dayCount addSubview:grayView];
    
    _dayCount.frame = CGRectMake(0, _timeView.maxY,KSCreenW, grayView.maxY);
}

- (void)creatReaonView
{
    _reasonLeavingView = [[UIView alloc] initWithFrame:CGRectMake(0, _dayCount.maxY, KSCreenW, 100)];
    _reasonLeavingView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_reasonLeavingView];
    
    _leavingLabel = [ViewTool getLabelWith:CGRectMake( topSpace, topSpace, 100, 15.0f) WithTitle:@"请假事由" WithFontSize:14.0f WithTitleColor:lightGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_reasonLeavingView addSubview:_leavingLabel];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(_leavingLabel.x, _leavingLabel.maxY + topSpace, KSCreenW - 4 * topSpace, [UIView getWidth:70])];
//    _textView.backgroundColor = blueFontColor;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.autoresizingMask =  UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _textView.textColor = blackFontColor;
    _placeHolder = [ViewTool getLabelWith:CGRectMake(0, 5, _textView.width, [UIView getWidth:15.0f]) WithTitle:@"请填写请假事由(必填)" WithFontSize:16.0f WithTitleColor:[UIColor blackColor] WithTextAlignment:NSTextAlignmentLeft];
    _textView.font = [UIFont systemFontOfSize: 16.0f];
    _textView.textColor = [UIColor blackColor];
    _placeHolder.enabled = NO;
    
//    _placeHolder.backgroundColor = [UIColor whiteColor];
    [_textView addSubview:_placeHolder];
    _textView.hidden = NO;
    _textView.delegate = self;
    [_reasonLeavingView addSubview:_textView];
    
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, _textView.maxY + topSpace, KSCreenW, SectionbackHeight)];
    grayView.backgroundColor = graySectionColor;
    [_reasonLeavingView addSubview:grayView];
    
    _reasonLeavingView.frame = CGRectMake(0, _dayCount.maxY,KSCreenW, grayView.maxY);

}

- (void)creatPicView
{
    _picView = [[UIView alloc] initWithFrame:CGRectMake(0, _reasonLeavingView.maxY, KSCreenW, 100)];
    _picView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_picView];
    
    _picTitle = [ViewTool getLabelWith:CGRectMake( topSpace, topSpace, 100, [UIView getWidth:15.0f]) WithTitle:@"图片" WithFontSize:14.0f WithTitleColor:lightGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_picView addSubview:_picTitle];
    
    CGFloat imagew = [UIView getWidth:40];
//    _showPicImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(_picTitle.x, _picTitle.maxY + topSpace, imagew, imagew)];
//    _showPicImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(_showPicImage1.maxX + topSpace, _showPicImage1.y, imagew, imagew)];
//    _showPicImage1.backgroundColor = blueFontColor;
//    _showPicImage2.backgroundColor = blueFontColor;
//    [_picView addSubview:_showPicImage1];
//    [_picView addSubview:_showPicImage2];
    
//    for (int i = 0; i< 5;  i ++) {
//        UIButton *imagview = [[UIButton alloc] initWithFrame:CGRectMake(_picTitle.x + i * (imagew + topSpace), _picTitle.maxY + topSpace, imagew, imagew)];
//        imagview.tag = 667766 + i;
//        [imagview addTarget:self action:@selector(clickToDelete:) forControlEvents:UIControlEventTouchUpInside];
////        imagview.backgroundColor = [UIColor cyanColor];
//        
//        [_picView addSubview:imagview];
//    }
    picSele = [[PictureSelectView alloc] initWithFrame:CGRectMake(_picTitle.x, _picTitle.maxY + topSpace, KSCreenW -2 * topSpace - imagew - 5 - _picTitle.x, imagew)];
    picSele.backgroundColor = [UIColor whiteColor];
    [_picView addSubview:picSele];
    
    _takePicBtn = [[UIButton alloc] initWithFrame:CGRectMake(KSCreenW -2 * topSpace - imagew+ 5, _picTitle.maxY + topSpace , imagew, imagew)];
    [_takePicBtn setImage:[UIImage imageNamed:@"相机star"] forState:UIControlStateNormal];
    [_picView addSubview:_takePicBtn];
    [_takePicBtn addTarget:self action:@selector(takePicture6) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, _takePicBtn.maxY + topSpace, KSCreenW, SectionbackHeight)];
    grayView.backgroundColor = graySectionColor;
    [_picView addSubview:grayView];
    
    _picView.frame = CGRectMake(0, _reasonLeavingView.maxY,KSCreenW, grayView.maxY);
 
}

- (void)drawBottomView
{
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _picView.maxY, KSCreenW, [UIView getHeight:50])];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_bottomView];
    
    _titleLabel = [ViewTool getLabelWith:CGRectMake( topSpace, topSpace, 100, 15.0f) WithTitle:@"选择审批人" WithFontSize:14.0 WithTitleColor:lightGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_bottomView addSubview:_titleLabel];
    
    _addPersonsBtn = [[UIButton alloc] initWithFrame:[UIView getRectWithX:_titleLabel.x Y:_titleLabel.maxY + topSpace width:[UIView getWidth:30] andHeight:[UIView getWidth:30]]];
    [_addPersonsBtn setImage:[UIImage imageNamed:@"添加人员"] forState:UIControlStateNormal];
    _addPersonsBtn.layer.cornerRadius = _addPersonsBtn.width / 2.0;
    _addPersonsBtn.layer.masksToBounds = YES;
    _addPersonsBtn.backgroundColor = [UIColor lightGrayColor];
    [_addPersonsBtn addTarget:self action:@selector(addPerson1:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_addPersonsBtn];
    _bottomView.frame = CGRectMake(0, _picView.maxY, KSCreenW, _addPersonsBtn.maxY +  topSpace);
//if 
    if (_bottomView.maxY + 64 > KSCreenH - TabbarH) {
        _scrollView.contentSize = CGSizeMake(0, _bottomView.maxY);
    }else{
        _scrollView.contentSize = CGSizeMake(0, 0);
    }
    
}

- (void)addBtn
{
   
        _postBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, KSCreenH - TabbarH, KSCreenW, TabbarH)];
        [_postBtn addTarget:self action:@selector(postLeaving:) forControlEvents:UIControlEventTouchUpInside];
        [_postBtn setTitle:@"确定提交" forState:UIControlStateNormal];
        [_postBtn setTitleColor:darkOrangeColor forState:UIControlStateNormal];
        [self.view addSubview:_postBtn];
        UIView *line3 = [ViewTool getLineViewWith:CGRectMake(0, 0, KSCreenW, 1) withBackgroudColor:grayLineColor];
        [_postBtn addSubview:line3];
  
}
//选择类型
- (void)chooseType
{
    NSMutableArray *titles = [NSMutableArray array];
    NSMutableArray *typeId = [NSMutableArray array];
    
    for (int i = 0; i<_typeArray.count; i++) {
        
        NSString *title = [_typeArray[i] objectForKey:@"level"];
        [titles addObject:title];
        int value = [[_typeArray[i] objectForKey:@"value"] intValue];
        [typeId addObject:[NSNumber numberWithInt:value]];
    }
    
    NSMutableArray *styles = [NSMutableArray array];
    
    for (int i = 0; i < _typeArray.count; i ++) {
        [styles addObject:CustomerStyle3];
    }
    [self.view.window showPopWithButtonTitles:titles styles:styles whenButtonTouchUpInSideCallBack:^(int index){
        NSLog(@"%d",index);
        if(index == _typeArray.count) return ;
        _typeNum = [typeId[index] intValue];
        _chooseTypeLabel.text = titles[index];
        _chooseTypeLabel.textColor = blackFontColor;
        typeStr = titles[index];
        
    }];
}

- (void)addPerson1:(UIButton *)btn
{
    SelectViewController *selectViewController = [[SelectViewController alloc]init];
    selectViewController.modalPresentationStyle =  UIModalPresentationPageSheet;
    selectViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    selectViewController.delegate = self;
    
    [self.navigationController pushViewController:selectViewController animated:YES];
}
 - (void)getSelectedStaff:(NSArray *)array
{
//    for (UserModel * model1 in array) {
//        model = model1;
//    }
    _usermodel = array[0];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LoadImageUrl,_usermodel.logo]]]];
    [_addPersonsBtn setImage:image forState:UIControlStateNormal];
}
- (void)creatDatePick
{
    _dateView = [[UIView alloc] initWithFrame:CGRectMake(0, KSCreenH, KSCreenW, [UIView getHeight:200.0f])];
    _dateView.backgroundColor = graySectionColor;
    [self.view addSubview:_dateView];
    CGFloat buttonW = [UIView getWidth:30.0f];
    CGFloat buttonH = [UIView getWidth:35.0f];
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(_dateView.width - buttonW -topSpace, 0, buttonW, buttonH)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:grayFontColor forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(clickSure:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.titleLabel.font= [UIFont systemFontOfSize:14.0f];
    [_dateView addSubview:sureBtn];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(topSpace, 0, buttonW, buttonH)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:grayFontColor forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickSure:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font= [UIFont systemFontOfSize:14.0f];
    [_dateView addSubview:cancelBtn];
    
    UIView *line = [ViewTool getLineViewWith:CGRectMake(0, 0, KSCreenW, 0.8) withBackgroudColor:grayLineColor];
    [_dateView addSubview:line];
    UIView *line1 = [ViewTool getLineViewWith:CGRectMake(0, cancelBtn.maxY, KSCreenW, 0.8) withBackgroudColor:grayLineColor];
    [_dateView addSubview:line1];

    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, line1.maxY + 3, _dateView.width, _dateView.height)];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    datePicker.locale = local;
    //   NSString * yearStr =  [DateTool getCurrentYears];
    //    int  moreyear = [yearStr intValue] + 1; //当前时间往后一年
    //    int  lessyear = [yearStr intValue] - 1;//当前时间之前一年
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm"];//HH 大写就是24小时制 小写就是12小时制

    NSTimeInterval time = 365 * 30 * 24 * 60 * 60;
    NSDate * lastYearDate = [currentDate dateByAddingTimeInterval:-time];
    NSDate * moreYearDate = [currentDate dateByAddingTimeInterval:time];
    
    datePicker.minimumDate = lastYearDate;//如果其中一个未设置 则默认用户可以选择 之前或未来的任何日期
    datePicker.maximumDate = moreYearDate;
    [datePicker setDate:currentDate animated:YES];
    [datePicker addTarget:self action:@selector(dateChoose:) forControlEvents:UIControlEventValueChanged];
    [_dateView addSubview:datePicker];

    
}

- (void)clickSure:(UIButton *)btn
{
    if ([btn.currentTitle isEqualToString:@"确定"]) {
        NSDateFormatter *formate = [[NSDateFormatter alloc]init];
        [formate setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString * dateStr = [formate stringFromDate:datePicker.date];
        if (_chooseStartTime.selected) {
            _startTimeContent.text = dateStr;
            startTimeStr = dateStr;
            _startTimeContent.textColor = blackFontColor;
        }else if(_chooseEndTime.selected){
            _endTimeContent.text = dateStr;
               _endTimeContent.textColor = blackFontColor;
            endTimeStr = dateStr;
        }
        
        CGRect frame = _dateView.frame;
        [UIView animateWithDuration:0.5 animations:^{
            _dateView.frame = CGRectMake(0, KSCreenH , KSCreenW, frame.size.height);
        }];
        
    }else{
        CGRect frame = _dateView.frame;
        [UIView animateWithDuration:0.5 animations:^{
            _dateView.frame = CGRectMake(0, KSCreenH , KSCreenW, frame.size.height);
        }];
        
    }
    
    if (_chooseStartTime.selected) {
        _chooseStartTime.selected = NO;
    }
    if (_chooseEndTime.selected ) {
        _chooseEndTime.selected = NO;
    }
}
#pragma mark --选择时间
- (void)dateChoose:(UIDatePicker *)picker
{
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * dateStr = [formate stringFromDate:picker.date];
    
    if (_chooseStartTime.selected) {
        if(endTimeStr){
            picker.maximumDate = [formate dateFromString:endTimeStr];
        }else{
            _startTimeContent.text = dateStr;
            startTimeStr = dateStr;
            _startTimeContent.textColor = blackFontColor;
        }
       
    }else if(_chooseEndTime.selected){
        if (startTimeStr) {
            picker.minimumDate = [formate dateFromString:startTimeStr];
        }else{
        _endTimeContent.text = dateStr;
        endTimeStr = dateStr;
        _endTimeContent.textColor = blackFontColor;
        }
    }
}
- (void)chooseTime:(UIButton *)btn
{
    [_textView resignFirstResponder];
    [_dayCountField resignFirstResponder];
    
//    endTimeStr = nil;
//    startTimeStr = nil;
    
//    NSLog(@"点击之前 %d,%d",_chooseStartTime.selected,_chooseEndTime.selected);
    if (btn.tag == 1999) {//开始时间
        
//        if (endTimeStr) {
            startTimeStr = nil;
        datePicker.minimumDate = nil;
//        }
        if (_dateView.y + 5<KSCreenH && btn.selected == NO) {
            CGRect frame = _dateView.frame;
            [UIView animateWithDuration:0.5 animations:^{
                _dateView.frame = CGRectMake(0, KSCreenH , KSCreenW, frame.size.height);
            }];
//            _textView.editable = YES;
//            _dayCountField.enabled = YES;
            _chooseEndTime.selected = NO;
        }else{
            if (!btn.selected) {
                CGRect frame = _dateView.frame;
                [UIView animateWithDuration:0.5 animations:^{
                    _dateView.frame = CGRectMake(0, KSCreenH - frame.size.height, KSCreenW, frame.size.height);
                }];
//                _textView.editable = NO;
//                _dayCountField.enabled = NO;
////               _chooseStartTime.selected = YES;
            }else{
                CGRect frame = _dateView.frame;
                [UIView animateWithDuration:0.5 animations:^{
                    _dateView.frame = CGRectMake(0, KSCreenH , KSCreenW, frame.size.height);
                }];
//                _textView.editable = YES;
//                _dayCountField.enabled = YES;
//                _chooseStartTime.selected = NO;
            }
            btn.selected = !btn.selected;
        }
    }else if(btn.tag == 1998){//结束时间
//        if (startTimeStr) {
            endTimeStr = nil;
        datePicker.maximumDate = nil;
//        }
        if (_dateView.y + 5<KSCreenH && btn.selected == NO) {
            CGRect frame = _dateView.frame;
            [UIView animateWithDuration:0.5 animations:^{
                _dateView.frame = CGRectMake(0, KSCreenH , KSCreenW, frame.size.height);
            }];
//            _textView.editable = YES;
//            _dayCountField.enabled = YES;
            _chooseStartTime.selected = NO;
        }else{
            if (!btn.selected) {
                CGRect frame = _dateView.frame;
                [UIView animateWithDuration:0.5 animations:^{
                    _dateView.frame = CGRectMake(0, KSCreenH - frame.size.height, KSCreenW, frame.size.height);
                }];
//                _dayCountField.enabled = NO;
//                _textView.editable = NO;
            }else{
                CGRect frame = _dateView.frame;
                [UIView animateWithDuration:0.5 animations:^{
                    _dateView.frame = CGRectMake(0, KSCreenH , KSCreenW, frame.size.height);
                }];
//                _textView.editable = YES;
//                _dayCountField.enabled = YES;
            }
            btn.selected = !btn.selected;
        }
        
    }
//    NSLog(@"之后 %d,%d",_chooseStartTime.selected,_chooseEndTime.selected);
}
#pragma mark -- 相册
- (void)takePictureInPhone1
{
//    UIImagePickerController *imagePick = [[UIImagePickerController alloc] init];
//    imagePick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    imagePick.delegate = self;//遵循两个代理方法
//    imagePick.allowsEditing = YES;
//    [self presentViewController:imagePick animated:YES completion:nil];
    if (![QBImagePickerController isAccessible]) {
        NSLog(@"不可用");
    }
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.maximumNumberOfSelection = 10;//最大上传5张
   
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}
- (void)dismissImagePickerController
{
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}
#pragma mark - QBImagePickerControllerDelegate
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    [_photosArray removeAllObjects];
    NSLog(@"*** imagePickerController:didSelectAssets:");
//    NSLog(@"%@", assets);
      [self dismissImagePickerController];
    
        for(int i = 0;i < assets.count ;i++){
            //        UIImage *iage = [UIImage imageWithContentsOfFile:assets[i]];
            //        NSData *data = UIImageJPEGRepresentation(iage, 0.45);
            //        NSLog(@"%@",data);
//            if (_choosePicDataArray.count <= 5) {
            
            ALAssetRepresentation *rep = [assets[i] defaultRepresentation];
            UIImage *ima = [UIImage imageWithCGImage:[rep fullResolutionImage]];
            NSData *data = UIImageJPEGRepresentation(ima, 0.5);
            
            
//            UIButton *imav = [_picView viewWithTag:667766  + _cameraArray.count + _photosArray.count ];
//                [imav setBackgroundImage:ima forState:UIControlStateNormal];
            [_photosArray addObject:data];
             
//            if (_choosePicDataArray.count <= 4) {
//                  [_choosePicDataArray addObject:data];
//            }
          
//    }
                       }
    picSele.images = _photosArray;

    NSLog(@"_choosePicDataArray count %ld",(unsigned long)_choosePicDataArray.count);
    NSLog(@"_photosArray %ld",(unsigned long)_photosArray.count);
    
}
- (void)imagePickerControllerDidCancel1:(QBImagePickerController *)imagePickerController
{
//    NSLog(@"*** imagePickerControllerDidCancel:");
    
    [self dismissImagePickerController];
}
#pragma mark -- 只为照相机选择照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [_cameraArray removeAllObjects];
    [picker dismissViewControllerAnimated:YES completion:nil];
    //    NSString *type = [info objectForKey:UIImagePickerControllerOriginalImage];
    //    NSLog(@"%@",type);
    //当选择类型是图片的时候
    //    if ([type isEqualToString:@"public.image"]) {
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.4);
//    if (_choosePicDataArray.count <= 4) {
//         [_choosePicDataArray addObject:imageData];
    
        [_cameraArray addObject:imageData];
        picSele.images = _cameraArray;
        NSLog(@"_cameraArray.count %ld",(unsigned long)_cameraArray.count);
//        NSInteger nu = _photosArray.count  + _cameraArray.count;
//        if (nu != 0) {
//            UIImageView *iamgeV = [_picView viewWithTag:667766 + nu -1];
//            UIImage *ia = [UIImage imageWithData:imageData];
//            iamgeV.image = ia;
//        }else{
//            UIButton *iamgeV = [_picView viewWithTag:667766 + nu -1];
//            UIImage *ia = [UIImage imageWithData:imageData];
//        [iamgeV setBackgroundImage:ia forState:UIControlStateNormal];
        //        }
        //    for (int i = 0; i< 5 - _cameraArray.count - _photosArray.count; i++) {
       
    
//    }
   
    
//    NSLog(@"_choosePicDataArray count %ld",(unsigned long)_choosePicDataArray.count);
//    NSLog(@"_photosArray %ld",(unsigned long)_photosArray.count);
//    }
//    [self saveImage:image WithName:[NSString stringWithFormat:@"%d",picCount++]];
    //需要将 data 存入数组啊  如果有多张的 情况下
    //    _showPicView.image = image;
    //    }
}
//-(void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName{
    ////    if (_isChangeBG) {
    //        //自定义裁剪图片
    //        //        UIGraphicsBeginImageContext(CGSizeMake(YPQScreenW, 194));
    //        //        [tempImage drawInRect:CGRectMake(0, 0, YPQScreenW, 194)];
    //        //        UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    //        //        UIGraphicsEndImageContext();
    //        UIImage *scaleImage = [self cutImage:tempImage];
    //        NSData *imageData = UIImageJPEGRepresentation(scaleImage, 0.5);
    //        for (int i = 1; i < 5; i ++) {
    //            if (imageData.length > 50 * 1024) {//封面 50k
    //                imageData = UIImageJPEGRepresentation(scaleImage, 0.5 - i * 0.1);
    //            } else {
    //                break;
    //            }
    //        }
    
//    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//    NSString *totalPath = [documentPath stringByAppendingPathComponent:imageName];
//    [imageData writeToFile:totalPath atomically:YES];
    //        [[NSUserDefaults standardUserDefaults] setObject:totalPath forKey:@"newBG"];
    //        [[NSUserDefaults standardUserDefaults] synchronize];
    //        UIImage *image = [UIImage imageWithContentsOfFile:totalPath];
    ////        [_bgIV setBackgroundImage:image forState:UIControlStateNormal];
    //
    //        [self uploadCoverImage:totalPath];
    //    } else {
    //
    //        for (int i = 1; i < 5; i ++) {
    //            if (imageData.length > 100 * 1024) {//头像 20k
    //                imageData = UIImageJPEGRepresentation(tempImage, 0.5 - i * 0.1);
    //            } else {
    //                break;
    //            }
    //        }
    //        NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    //        NSString *totalPath = [documentPath stringByAppendingPathComponent:imageName];
    //        [imageData writeToFile:totalPath atomically:YES];
//    [[NSUserDefaults standardUserDefaults] setObject:totalPath forKey:@"temImagePath"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //        [self uploadUserImage:totalPath];
    //    }
//}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 相机
- (void)takePictureWithCamera
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        if (_choosePicDataArray.count > 5) {
            return;
        }
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后可编辑图片
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"无法打开摄像机" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertVC animated:YES completion:nil];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:action];
    }
    
    
}

#pragma mark --actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self takePictureInPhone1];
    }else if (buttonIndex == 1){
        [self takePictureWithCamera];
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    [actionSheet dismissWithClickedButtonIndex:2 animated:YES];
}

- (void)clickToDelete:(UIButton *)btn
{
    btn.hidden = YES;
    [_choosePicDataArray removeObjectAtIndex:btn.tag - 667766];
}
#pragma mark --提交请假
- (void)postLeaving:(UIButton *)btn
{
    
 
    NSString * picStr;
    for (int i = 0; i< picSele.allPicArray.count; i++) {
        NSString * base64 = [picSele.allPicArray[i] base64Encoding];
       picStr = [NSString stringWithFormat:@"%@,",base64];
    }
    NSString * str =  [picStr substringToIndex:picStr.length-1];
//    NSLog(@"str %@",str);
    
    
    //        if (k>2) {
    //            [self.view makeToast:@"请假天数输入错误哦"];
    //    }else
    if (typeStr.length == 0) {
         [self.view makeToast:@"请选择类型哦"];
    }else if (startTimeStr.length == 0) {
        [self.view makeToast:@"请选择开始时间哦"];
    }else if(endTimeStr.length == 0 ){
        [self.view makeToast:@"请选择结束时间哦"];
    }else if(_dayCountField.text.length == 0){
        [self.view makeToast:@"请填写请假天数哦"];
    }else if(_textView.text.length == 0){
        [self.view makeToast:@"请填写请假缘由哦"];
    }else{
         _postBtn .enabled = NO;
            [self.view makeToastActivity];
    NSMutableDictionary *dict = [DataTool changeType:@{@"token" : TOKEN,@"uid" : @(UID),@"type":@(_typeNum),@"begintime" : _startTimeContent.text,@"endtime" :_endTimeContent.text,@"reason" :_textView.text,@"days" : _dayCountField.text ,@"dealuser" : @(_usermodel.uid)}];
    
    if (str) {
        [dict setObject:str forKey:@"img"];
    }
   
//    NSLog(@"请假参数 %@",dict);
    [DataTool postWithUrl:CREAT_LEAVING_URL parameters:dict success:^(id data) {
        id backData = CRMJsonParserWithData(data);
        NSLog(@"%@",backData);
        if([backData[@"code"] intValue] == 100){
              [self.view hideToastActivity];
            [self.view makeToast:@"提交成功"];
         
            [self performSelector:@selector(popViewController) withObject:nil afterDelay:1.0f];
//            [self popViewController];
        }else{
               [self.view hideToastActivity];
            [self.view makeToast:@"提交失败"];
          
        }
    } fail:^(NSError *error) {
        NSLog(@"error %@",error.localizedDescription);
             [self.view hideToastActivity];
    }];
    }
}
//拍照
- (void)takePicture6
{
//    [_choosePicDataArray removeAllObjects];
    if(IOS7){
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开手机相册",@"手机相机拍摄", nil];
        [actionSheet showInView:self.view];
    }else{
        UIAlertController * alertionControll = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"打开手机相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self takePictureInPhone1];
        }];
        UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"手机相机拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self takePictureWithCamera];
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
//#warning 根据高度差滚动scrollView
- (void)keyboardWillShow:(NSNotification *)noti
{
    
    NSDictionary *usrInfoDict = noti.userInfo;
    //    NSLog(@"%@",usrInfoDict);
    CGRect keyRect = [usrInfoDict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat showtime = [usrInfoDict[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if(_textView.isFirstResponder){
        //        NSDictionary *usrInfoDict = noti.userInfo;
        //        NSLog(@"%@",usrInfoDict);
        //        CGRect keyRect = [usrInfoDict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        //        CGFloat showtime = [usrInfoDict[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGRect rect = [_textView convertRect:_textView.frame toView:self.view ];
        diff = fabs( keyRect.origin.y - CGRectGetMaxY(rect)) + [UIView getHeight:20];
        
        if (keyRect.origin.y < CGRectGetMaxY(rect)) {
            [UIView animateWithDuration:showtime animations:^{
                //                self.view.transform = CGAffineTransformMakeTranslation(0, -diff);
                self.view.frame = CGRectMake(0, -diff, KSCreenW, KSCreenH - 64);
            }];
        }
    }else if(_dayCountField.isFirstResponder){
        //        NSDictionary *usrInfoDict1 = noti.userInfo;
        //
        //        CGRect keyRect1 = [usrInfoDict1[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        //        CGFloat showtime1 = [usrInfoDict1[UIKeyboardAnimationDurationUserInfoKey] floatValue];
#warning 这里转换坐标系 怎么会不对呢
        CGRect rect = [_dayCountField convertRect:_dayCountField.frame toView:self.view ];
        //              NSLog(@"%f,%f",keyRect.origin.y, CGRectGetMaxY(rect));
        //        NSLog(@"%f,%f,%f,%f",KSCreenH,KSCreenH - 271, CGRectGetMaxY(rect),CGRectGetMaxY(_noticeConten.frame) + 64);
        diff = fabs( keyRect.origin.y - (_dayCountField.maxY + 64)) + [UIView getHeight:20];
        //        NSLog(@"%f,%f",keyRect1.origin.y, CGRectGetMaxY(rect));
        if (keyRect.origin.y < (_dayCountField.maxY + 64)) {
            [UIView animateWithDuration:showtime animations:^{
                //                self.view.transform = CGAffineTransformMakeTranslation(0, -diff);
                self.view.frame = CGRectMake(0, -diff, KSCreenW, KSCreenH - 64);
            }];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    if (self.view.y < 0) {
        NSDictionary *InfoDict = noti.userInfo;
        
        CGFloat Hidetime = [InfoDict[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        [UIView animateWithDuration:Hidetime animations:^{
            self.view.frame = CGRectMake(0, 0, KSCreenW, KSCreenH);
        }];
    }
    //    NSDictionary *InfoDict = noti.userInfo;
    //
    //    CGFloat Hidetime = [InfoDict[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //  [UIView animateWithDuration:Hidetime animations:^{
    //      self.view.transform = CGAffineTransformMakeTranslation(0,- diff);
    //  }];
    
}

- (void)handleScrolltap:(UITapGestureRecognizer *)tap
{
    if (![_dayCountField isExclusiveTouch] || ![_textView isExclusiveTouch]) {
        [_dayCountField resignFirstResponder];
        [_textView resignFirstResponder];
    }
    
//    if (_dateView.y<KSCreenH) {
//        CGRect frame = _dateView.frame;
//        [UIView animateWithDuration:1.0 animations:^{
//            _dateView.frame = CGRectMake(0, KSCreenH, KSCreenW, frame.size.height);
//        }];
//        _textView.editable = YES;
//        
//        if (_chooseStartTime.selected) {
//            _chooseStartTime.selected = NO;
//        }else if (_chooseEndTime.selected){
//            _chooseEndTime.selected = NO;
//        }
//    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _textView.hidden = NO;
    _placeHolder.hidden = YES;
    CGRect frame = _dateView.frame;
    [UIView animateWithDuration:0.5 animations:^{
        _dateView.frame = CGRectMake(0, KSCreenH , KSCreenW, frame.size.height);
    }];
    _chooseStartTime.selected = NO;
    _chooseEndTime.selected = NO;
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _dayCountField) {
        int k = 0;
        if(![_dayCountField.text isEqualToString:@""]){
            for (int i = 0; i< _dayCountField.text.length; i++) {
                
                if ( [[_dayCountField.text  substringWithRange:NSMakeRange(i,1)] isEqualToString:@"."]) {
                    k ++;
                }
            }
        }
        NSLog(@"有几个点%d",k);
        if (k >= 2) {
            [self.view makeToast:@"请假天数输入有误哦"];
            [_dayCountField becomeFirstResponder];
        }
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length != 0) {
        _placeHolder.hidden = YES;
    }else{
        _placeHolder.hidden = NO;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        _placeHolder.hidden = NO;
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    _postBtn.enabled = YES;
//    [_choosePicDataArray removeAllObjects];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = NO;
//    [_choosePicDataArray removeAllObjects];
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
