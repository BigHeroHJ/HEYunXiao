//
//  VisitingViewController.m
//  移动营销
//
//  Created by Hanen 3G 01 on 16/2/23.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "VisitingViewController.h"
#import "VisitTableViewCell.h"
#import "MyClientView.h"

#import "SelectViewController.h"
#import "MyTabBarController.h"
#import "NewVisitViewController.h"
#import "VisitDetailViewController.h"
#import "LoginViewController.h"
#import "MapClientViewController.h"
#import <QuartzCore/QuartzCore.h>

#define NAVHEI 44


@interface VisitingViewController ()<MyClientViewDelegate,NewVisitViewDelegate,SelectStaffViewDelegate,VisitTableViewCellDelegate>{
    
    int calendarHei;
    float lastContentOffset;
}
@property (nonatomic, strong) UISwipeGestureRecognizer *upSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *downSwipeGestureRecognizer;
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UILabel *monthLabel;

@property(nonatomic) BOOL isManager;
@property(nonatomic) BOOL isMyVisit;
@property(nonatomic, strong) MyClientView *topBtnView;

@property (strong, nonatomic) UIView *backView;

/**
 *  我的拜访
 */
@property(nonatomic,strong)UITableView     *visitTableView;
@property(nonatomic,strong)UIView          *myVisitView;

@property(nonatomic,strong)NSArray *myVisitArray;

/**
 *  下属拜访
 */
@property(nonatomic,strong)UITableView     *otherVisitTableView;
@property(nonatomic,strong)UIView          *otherVisitView;

@property(nonatomic,strong)NSArray *otherVisitArray;

@property(nonatomic,strong) UILabel *splitLine;

@property(nonatomic,strong) UIView *planNumView;


//data
@property (nonatomic, strong) NSMutableArray *timelist1;
@property (nonatomic, strong) NSMutableArray *timelist2;

@property (nonatomic, assign) int allcount;
@property (nonatomic, assign) int daicount;
@property (nonatomic, assign) int yicount;
@property (nonatomic, strong) NSArray *daylist;

@property (nonatomic, assign) int allcount2;
@property (nonatomic, assign) int daicount2;
@property (nonatomic, assign) int yicount2;
@property (nonatomic, strong) NSArray *daylist2;//2--other

@property (nonatomic, assign) int i;

@property (nonatomic, strong) UILabel *planbLab;
@property (nonatomic, strong) UILabel *completedLab;
@property (nonatomic, strong) UILabel *notCompletedLab;

@property (nonatomic, strong) NSString *month;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSDate   *date;

@end

@implementation VisitingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton =YES;
    self.navigationItem.rightBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithString:@"新建" WithAction:@selector(clickToNewVisit)];
    NSString *type = [[[NSUserDefaults standardUserDefaults] objectForKey:@"type"] stringValue];
    
    if ([type isEqualToString:@"2"]) {
        _isManager = YES;
        self.navigationItem.title = @"";
        
        _topBtnView = [[MyClientView alloc] initWithFrame:CGRectMake(0, 0, [UIView getWidth:200], 44) withLeftTitle:@"下属拜访" andRightTitle:@"我的拜访"];
        _topBtnView.delegate = self;
        self.navigationItem.titleView = _topBtnView;
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 43, KSCreenW, 0.5)];
        lineLabel.backgroundColor = grayLineColor;
        [_topBtnView addSubview:lineLabel];
        
    }else{
        _isManager = NO;
        self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:@"我的拜访"];
    }

    _month = [DateTool getMonth:[NSDate date]];
    _year = [DateTool getYear:[NSDate date]];
    _date = [NSDate date];
    _timelist1 = [NSMutableArray array];
    _timelist2 = [NSMutableArray array];
    [self addCalendarView];
    [self addPlanView];
    [self addTableView];
    [self reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = NO;
    [super viewDidAppear:animated];
    [self.calendar reloadData]; // Must be call in viewDidAppear
}
- (void)viewWillAppear:(BOOL)animated
{
        [self reloadData];
    
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.hidesBottomBarWhenPushed = NO;
}
- (void)goToBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addCalendarView{
    //日历
    self.calendar = [JTCalendar new];
    self.calendarMenuView = [[JTCalendarMenuView alloc] initWithFrame:CGRectMake(0, 64, KSCreenW, 40)];
    
    {
        self.calendar.calendarAppearance.calendar.firstWeekday = 2; // Sunday == 1, Saturday == 7
        self.calendar.calendarAppearance.dayCircleRatio = 9. / 10.;
        self.calendar.calendarAppearance.ratioContentMenu = 2.;
        self.calendar.calendarAppearance.focusSelectedDayChangeMode = YES;
        
        self.calendar.calendarAppearance.menuMonthTextColor = lightGrayFontColor;
        self.calendar.calendarAppearance.dayCircleColorSelected = blueFontColor;
        
        // Customize the text for each month
        self.calendar.calendarAppearance.monthBlock = ^NSString *(NSDate *date, JTCalendar *jt_calendar){
            NSCalendar *calendar = jt_calendar.calendarAppearance.calendar;
            NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
            NSInteger currentMonthIndex = comps.month;
            
            static NSDateFormatter *dateFormatter;
            if(!dateFormatter){
                dateFormatter = [NSDateFormatter new];
                dateFormatter.timeZone = jt_calendar.calendarAppearance.calendar.timeZone;
            }
            
            while(currentMonthIndex <= 0){
                currentMonthIndex += 12;
            }
            
//            NSString *monthText = [[dateFormatter standaloneMonthSymbols][currentMonthIndex - 1] capitalizedString];
            NSString *monthText = [dateFormatter veryShortMonthSymbols][currentMonthIndex - 1];
            return [NSString stringWithFormat:@"%ld年%@月", (long)comps.year, monthText];
        };
    }
    
    UILabel *Line = [[UILabel alloc] initWithFrame:CGRectMake(0, self.calendarMenuView.maxY-1, KSCreenW, 1)];
    Line.layer.borderColor = [grayLineColor CGColor];
    [self.view addSubview:Line];
    
    self.calendarMenuView.backgroundColor = [UIColor whiteColor];
    self.calendarContentView = [[JTCalendarContentView alloc] initWithFrame:CGRectMake(0, self.calendarMenuView.maxY, KSCreenW, 300)];
    
    self.calendarContentView.backgroundColor = graySectionColor;
    self.calendarContentView.layer.borderWidth = 1.0;
    self.calendarContentView.layer.borderColor = grayLineColor.CGColor;
    
    // All modifications on calendarAppearance have to be done before setMenuMonthsView and setContentView
    // Or you will have to call reloadAppearance
    
    self.calendar.calendarAppearance.calendar.firstWeekday = 1; // Sunday == 1, Saturday == 7
    self.calendar.calendarAppearance.dayCircleRatio = 9. / 10.;
    self.calendar.calendarAppearance.ratioContentMenu = 1.;
    
    [self.calendar setMenuMonthsView:self.calendarMenuView];
    [self.calendar setContentView:self.calendarContentView];
    [self.calendar setDataSource:self];
    
    [self.view addSubview:self.calendarMenuView];
    [self.view addSubview:self.calendarContentView];
    
    self.upSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.downSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    self.upSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    self.downSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:self.upSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.downSwipeGestureRecognizer];
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionUp) {
        //        CGPoint labelPosition = CGPointMake(self.swipeLabel.frame.origin.x - 100.0, self.swipeLabel.frame.origin.y);
        self.calendar.calendarAppearance.isWeekMode = YES;
        [self transitionExample];
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionDown) {
        //        CGPoint labelPosition = CGPointMake(self.swipeLabel.frame.origin.x + 100.0, self.swipeLabel.frame.origin.y);
        self.calendar.calendarAppearance.isWeekMode = NO;
        [self transitionExample];
    }
}

- (void)addPlanView{
    _planNumView = [[UIView alloc] initWithFrame:CGRectMake(0, self.calendarContentView.y+self.calendar.contentView.height, KSCreenW, SECTIONHEIGHT)];
    _planbLab = [[UILabel alloc] initWithFrame:CGRectMake(0,5, KSCreenW/3, 20)];
    _planbLab.text = [NSString stringWithFormat:@"今日计划:%d",_allcount];
    _planbLab.textColor = grayFontColor;
    [ViewTool setLableFont14:_planbLab];
    _planbLab.textAlignment = NSTextAlignmentCenter;
    [_planNumView addSubview:_planbLab];
    _completedLab = [[UILabel alloc] initWithFrame:CGRectMake(KSCreenW/3,_planbLab.y, KSCreenW/3, 20)];
    _completedLab.text = [NSString stringWithFormat:@"已完成:%d",_yicount];
    _completedLab.textColor = grayFontColor;
    [ViewTool setLableFont14:_completedLab];
    _completedLab.textAlignment = NSTextAlignmentCenter;
    [_planNumView addSubview:_completedLab];
    _notCompletedLab = [[UILabel alloc] initWithFrame:CGRectMake(KSCreenW/3*2,_planbLab.y, KSCreenW/3, 20)];
    _notCompletedLab.text = [NSString stringWithFormat:@"未完成:%d",_daicount];
    _notCompletedLab.textColor = darkOrangeColor;
    [ViewTool setLableFont14:_notCompletedLab];
    _notCompletedLab.textAlignment = NSTextAlignmentCenter;
    [_planNumView addSubview:_notCompletedLab];
    
    [self.view addSubview:_planNumView];
    
    _splitLine = [[UILabel alloc] initWithFrame:CGRectMake(LEFTWIDTH, _planNumView.maxY-1, KSCreenW-LEFTWIDTH*2, 1)];
    _splitLine.layer.borderWidth = 10;
    _splitLine.layer.borderColor = [grayLineColor CGColor];
    [self.view addSubview:_splitLine];
}
- (void)addTableView{
    _visitTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, _splitLine.maxY, KSCreenW, KSCreenH- _splitLine.maxY-TabbarH) style:UITableViewStylePlain];
    _visitTableView.delegate=self;
    _visitTableView.dataSource=self;
    _visitTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_visitTableView];
    
    if (_isManager) {
        _otherVisitTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, _splitLine.maxY, KSCreenW, KSCreenH-20-44-340-TabbarH) style:UITableViewStylePlain];
        _otherVisitTableView.delegate=self;
        _otherVisitTableView.dataSource=self;
        _otherVisitTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_otherVisitTableView];
        _otherVisitTableView.hidden = YES;
    }
}

//#pragma mark --NewVisitView delagte
- (void)refreshData{
    if (_isManager & !_otherVisitTableView.hidden){
        _planbLab.text = [NSString stringWithFormat:@"今日计划:%d",_allcount2];
        _completedLab.text = [NSString stringWithFormat:@"已完成:%d",_yicount2];
        _notCompletedLab.text = [NSString stringWithFormat:@"未完成:%d",_daicount2];
        if (_allcount2 == 0){
            [self.view makeToast:@"无拜访记录"];
        }
        [_otherVisitTableView reloadData];
    }else{
        _planbLab.text = [NSString stringWithFormat:@"今日计划:%d",_allcount];
        _completedLab.text = [NSString stringWithFormat:@"已完成:%d",_yicount];
        _notCompletedLab.text = [NSString stringWithFormat:@"未完成:%d",_daicount];
        if (_allcount == 0){
            [self.view makeToast:@"无拜访记录"];
        }
        [_visitTableView reloadData];
    }
}

- (void)changeHeight{
    _planNumView.frame = CGRectMake(0, self.calendarContentView.y+self.calendar.contentView.height, KSCreenW, 30);
    _splitLine.frame = CGRectMake(LEFTWIDTH, _planNumView.maxY-1, KSCreenW-LEFTWIDTH*2, 1);
    _visitTableView.frame = CGRectMake(0, _splitLine.maxY, KSCreenW, KSCreenH-_splitLine.maxY-10-TabbarH);
    _otherVisitTableView.frame = CGRectMake(0, _splitLine.maxY, KSCreenW, KSCreenH-_splitLine.maxY-10-TabbarH);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData{

    if (_isManager & !_otherVisitTableView.hidden){
        [self getDaylist:_date withURL:GET_SUB_VISIT_URL withArray:nil];
    }else{
        [self getDaylist:_date withURL:GET_VISIT_URL withArray:nil];
    }
    if (_isManager & !_otherVisitTableView.hidden){
        [self getMonthListWithURL:GET_MONTH_SUB_VISIT_URL withYear:_year withMon:_month];
    }else{
        [self getMonthListWithURL:GET_MONTH_VISIT_URL withYear:_year withMon:_month];
    }
}

- (void)getMonthListWithURL:(NSString *)url withYear:(NSString *)year withMon:(NSString *)month{
    
    //GET_MONTH_VISIT_URL  GET_MONTH_SUB_VISIT_URL
    NSDictionary * params1 = [NSDictionary dictionaryWithObjectsAndKeys:@(UID), @"uid", TOKEN, @"token",year, @"year", month, @"month", nil];
    AFHTTPRequestOperationManager * manager1 = [AFHTTPRequestOperationManager manager];
    manager1.requestSerializer.timeoutInterval = 20;
    [manager1 POST:url parameters:params1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        [self.view hideToastActivity];
        
        NSLog(@"%@:%@",url,responseObject);
        int code = [[(NSDictionary *)responseObject objectForKey:@"code"] intValue];
        if(code != 100)
        {
            NSString * message = [(NSDictionary *)responseObject objectForKey:@"message"];

            NSLog(@"%@",message);
            if ([message isEqualToString:@"没有数据"]) {
//                _timelist = nil;
            }else{
                [self.view makeToast:message];
            }
        }else{
            NSArray *times = [(NSDictionary *)responseObject objectForKey:@"timelist"];
            if ([url isEqualToString:GET_MONTH_VISIT_URL]) {
                [self addMonTimeList:times toTimeList:_timelist1];
                
            }else{
                [self addMonTimeList:times toTimeList:_timelist2];
            }
        }
        [self.calendar reloadData];//标记点
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        //        [self.view hideToastActivity];
    }];
}

- (void)getDaylist:(NSDate *)date withURL:(NSString *)url withArray:(NSArray *)array{
    
    NSDictionary * params;
    if (array != nil) {
        NSString *ids = [array componentsJoinedByString:@","];
        params = [NSDictionary dictionaryWithObjectsAndKeys:@(UID), @"uid", TOKEN, @"token", [DateTool getYear:date], @"year", [DateTool getMonth:date], @"month",[DateTool getDay:date], @"day", ids, @"ids", nil];
    }else{
        params = [NSDictionary dictionaryWithObjectsAndKeys:@(UID), @"uid", TOKEN, @"token", [DateTool getYear:date], @"year", [DateTool getMonth:date], @"month",[DateTool getDay:date], @"day", nil];
    }
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.view hideToastActivity];
        NSLog(@"%@:%@",url,responseObject);
        int code = [[(NSDictionary *)responseObject objectForKey:@"code"] intValue];
        
        if(code != 100)
        {
            NSString * message = [(NSDictionary *)responseObject objectForKey:@"message"];
            if ([message isEqualToString:@"没有数据"]) {
                if ([url isEqualToString:GET_VISIT_URL]) {
                    _allcount = 0;
                    _yicount = 0;
                    _daicount = 0;
                    _daylist = nil;
                }else{
                    _allcount2 = 0;
                    _yicount2 = 0;
                    _daicount2 = 0;
                    _daylist2 = nil;
                }
            }
        }else{
            if ([url isEqualToString:GET_VISIT_URL]) {
                _allcount = [[(NSDictionary *)responseObject objectForKey:@"allcount"] intValue];
                _yicount = [[(NSDictionary *)responseObject objectForKey:@"yicount"] intValue];
                _daicount = [[(NSDictionary *)responseObject objectForKey:@"daicount"] intValue];
                _daylist = [(NSDictionary *)responseObject objectForKey:@"daylist"];
            }else{
                _allcount2 = [[(NSDictionary *)responseObject objectForKey:@"allcount"] intValue];
                _yicount2 = [[(NSDictionary *)responseObject objectForKey:@"yicount"] intValue];
                _daicount2 = [[(NSDictionary *)responseObject objectForKey:@"daicount"] intValue];
                _daylist2 = [(NSDictionary *)responseObject objectForKey:@"daylist"];
            }
        }
        [self refreshData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self.view hideToastActivity];
    }];
}

- (void)addMonTimeList:(NSArray *)array toTimeList:(NSMutableArray *)timeList{
    for (NSString *time in array) {
        if (![timeList containsObject:time]) {
            [timeList addObject:time];
        }
    }
    
    NSLog(@"%@*-*-*-*-*",timeList);
}

#pragma mark - Buttons callback

//- (IBAction)didGoTodayTouch
//{
//    [self.calendar setCurrentDate:[NSDate date]];
//}
//
//- (IBAction)didChangeModeTouch
//{
//    self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
//
//    [self transitionExample];
//}

#pragma mark - JTCalendarDataSource

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [df setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"] ];
    NSDate *date1 =[[NSDate alloc]init];
    if (_isManager & !_otherVisitTableView.hidden) {
        for(NSString *dateStr in _timelist2){
            date1 =[df dateFromString:dateStr];
            if( [DateTool isSameDay:date date2:date1]){
                return YES;
            }
        }
    }else{
        for(NSString *dateStr in _timelist1){
            date1 =[df dateFromString:dateStr];
            if( [DateTool isSameDay:date date2:date1]){
                return YES;
            }
        }
    }
    return NO;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    _date = date;
    [self reloadData];
}

//上个月
- (void)calendarDidLoadPreviousPage
{
    NSLog(@"Previous page loaded");
    int mon;
    if ([_month intValue] == 1) {
        mon = 12;
        _year = [NSString stringWithFormat:@"%d",[_year intValue]-1];
    }else{
        mon = [_month intValue]-1;
    }

    if (mon < 10) {
        _month = [NSString stringWithFormat:@"0%d",mon];
    }else{
        _month = [NSString stringWithFormat:@"%d",mon];
    }
    NSLog(@"%@",_month);
    
    if (_isManager & !_otherVisitTableView.hidden){
        [self getMonthListWithURL:GET_MONTH_SUB_VISIT_URL withYear:_year withMon:_month];
    }else{
        [self getMonthListWithURL:GET_MONTH_VISIT_URL withYear:_year withMon:_month];
    }
}

//下个月
- (void)calendarDidLoadNextPage
{
    NSLog(@"Next page loaded");
    int mon;
    if ([_month intValue] == 12) {
        mon = 1;
        _year = [NSString stringWithFormat:@"%d",[_year intValue]+1];
    }else{
        mon = [_month intValue]+1;
    }
    if (mon < 10) {
        _month = [NSString stringWithFormat:@"0%d",mon];
    }else{
        _month = [NSString stringWithFormat:@"%d",mon];
    }
    
    if (_isManager & !_otherVisitTableView.hidden){
        [self getMonthListWithURL:GET_MONTH_SUB_VISIT_URL withYear:_year withMon:_month];
    }else{
        [self getMonthListWithURL:GET_MONTH_VISIT_URL withYear:_year withMon:_month];
    }

}

#pragma mark - Transition examples

- (void)transitionExample
{
    CGFloat newHeight = 300;
    if(self.calendar.calendarAppearance.isWeekMode){
        newHeight = 75.;
    }
    
    [UIView animateWithDuration:.5
                     animations:^{
                         self.calendarContentViewHeight.constant = newHeight;
                         [self.view layoutIfNeeded];
                         self.calendarContentView.frame = CGRectMake(0, self.calendarMenuView.maxY, KSCreenW, newHeight);
                         [self changeHeight];
                         [self.calendar reloadAppearance];
                     }];
    
    [UIView animateWithDuration:.25
                     animations:^{
                         self.calendarContentView.layer.opacity = 1;
                     }
                     completion:^(BOOL finished) {

                         
                         [UIView animateWithDuration:.25
                                          animations:^{
                                              self.calendarContentView.layer.opacity = 1;
                                          }];
                     }];
    NSLog(@"%f",self.calendar.contentView.layer.position.y);
}

- (void)clickToNewVisit{
    NSLog(@"clickToNewVisit");
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;//可更改为其他方式
    transition.subtype = kCATransitionFromTop;//可更改为其他方式
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    NewVisitViewController *newVisitViewController = [[NewVisitViewController alloc] init];
    newVisitViewController.delegate = self;
    [self.navigationController pushViewController:newVisitViewController animated:NO];
    
}

- (void)clickToselectUser{
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;//可更改为其他方式
    transition.subtype = kCATransitionFromRight;//可更改为其他方式
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    SelectViewController *selectViewController = [[SelectViewController alloc]init];
//    selectViewController.modalPresentationStyle =  UIModalPresentationPageSheet;
//    selectViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    selectViewController.delegate = self;
    
    [self.navigationController pushViewController:selectViewController animated:NO];
}

#pragma mark --MyClientView delagte

- (void)changeNoticeView:(NSInteger)tag
{
    if (tag == 1111) {//下属拜访
        
        [_topBtnView.otherClient setTitleColor:darkOrangeColor forState:UIControlStateNormal];
        [_topBtnView.myClient setTitleColor:blackFontColor forState:UIControlStateNormal];
        _topBtnView.redLine1.backgroundColor = darkOrangeColor;
        _topBtnView.redLine2.backgroundColor = TabbarColor;
        
        self.navigationItem.leftBarButtonItem  = [ViewTool getBarButtonItemWithTarget:self WithString:@"筛选" WithAction:@selector(clickToselectUser)];
        self.navigationItem.rightBarButtonItem = nil;
        _visitTableView.hidden = YES;
        _otherVisitTableView.hidden = NO;
        [self getDaylist:_date withURL:GET_SUB_VISIT_URL withArray:nil];
        [self getMonthListWithURL:GET_MONTH_SUB_VISIT_URL withYear:_year withMon:_month];
        
    }else if (tag == 2222){//我的拜访
        [_topBtnView.otherClient setTitleColor:blackFontColor forState:UIControlStateNormal];
        [_topBtnView.myClient setTitleColor:darkOrangeColor forState:UIControlStateNormal];
        _topBtnView.redLine1.backgroundColor = TabbarColor;
        _topBtnView.redLine2.backgroundColor = darkOrangeColor;
        self.navigationItem.rightBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithString:@"新建" WithAction:@selector(clickToNewVisit)];
        self.navigationItem.leftBarButtonItem  = nil;
        _visitTableView.hidden = NO;
        _otherVisitTableView.hidden = YES;
        [self getDaylist:_date withURL:GET_VISIT_URL withArray:nil];
        [self getMonthListWithURL:GET_MONTH_VISIT_URL withYear:_year withMon:_month];
        
    }
}
 

//SelectStaffViewDelegate
- (void)getSelectedStaff:(NSArray *)array{
    NSMutableArray *ids = [NSMutableArray array];
    NSLog(@"%@************",array);
    for (UserModel *user in array) {
        NSString *uid = [NSString stringWithFormat:@"%d",user.uid];
        [ids addObject:uid];
    }
    [self getDaylist:_date withURL:GET_SUB_VISIT_URL withArray:ids];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _visitTableView){
        return _allcount;
    }else{
        return _allcount2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELLHEIGHT2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"CellIdentifier";
    VisitTableViewCell *cell = (VisitTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    cell.delegate = self;//位置写错了。。
    if (cell == nil) {
        cell = [[VisitTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (tableView == _visitTableView) {
        cell.companyLab.text = [_daylist[indexPath.row] objectForKey:@"company"];
        CGFloat W = [cell.companyLab.text boundingRectWithSize:CGSizeMake(MAXFLOAT, cell.companyLab.height) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : cell.companyLab.font,NSForegroundColorAttributeName : blackFontColor} context:nil].size.width;
//        CGRect frame = cell.companyLevelImage.frame;
        cell.companyLevelImage.frame = CGRectMake(W + 10, cell.companyLab.y, 20, 20);
        cell.addressLab.text = [_daylist[indexPath.row] objectForKey:@"address"];
        if ([[_daylist[indexPath.row] objectForKey:@"clevel"] intValue] == 1) {
            cell.companyLevelImage.image = [UIImage imageNamed:@"vip"];
        }else{
            cell.companyLevelImage.image = [UIImage imageNamed:@"普通客户图标"];
        }
        int visitStaus = [[_daylist[indexPath.row] objectForKey:@"status"] intValue];
        
        if (visitStaus == 1) {
            cell.visitStausLab2.text = @"已拜访";
            cell.visitStausLab.text = @"";
            cell.visitTimeLab.text = @"";
        }else{
            cell.visitStausLab2.text = @"";
            if (visitStaus == 0){
                cell.visitStausLab.text = @"待拜访";
            }else{
                cell.visitStausLab.text = @"未拜访";
            }
            NSString *time = [_daylist[indexPath.row] objectForKey:@"ordertime"];
            NSArray * arr = [time componentsSeparatedByString:@" "];
            NSLog(@"%@",arr);
            if(arr.count > 1){
                time = [arr.lastObject substringToIndex:5];
            }else{
                time = @"";
            }
            cell.visitTimeLab.text = time;
//            cell.visitStausLab.textColor = blueFontColor;

            
        }
        cell.delegate = self;
    }else{
        cell.companyLab.text = [_daylist2[indexPath.row] objectForKey:@"company"];
        
        CGFloat W = [cell.companyLab.text boundingRectWithSize:CGSizeMake(MAXFLOAT, cell.companyLab.height) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : cell.companyLab.font,NSForegroundColorAttributeName : blackFontColor} context:nil].size.width;
//        CGRect frame = cell.companyLevelImage.frame;
        cell.companyLevelImage.frame = CGRectMake(W + 10, cell.companyLab.y, 20, 20);
        
//        CGRect rect = cell.addressbtn.frame;
        
//        CGFloat btnw = [(NSString *)[_daylist2[indexPath.row] objectForKey:@"address"] boundingRectWithSize:CGSizeMake(MAXFLOAT, rect.size.height) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName : grayFontColor, NSFontAttributeName :[UIFont systemFontOfSize:13.0f]} context:nil].size.width;
//        rect.size.width = btnw + 20;
//        
//        cell.addressbtn.frame = rect;
//        
//        [cell.addressbtn setTitle:[_daylist2[indexPath.row] objectForKey:@"address"] forState:UIControlStateNormal];
        cell.addressLab.text = [_daylist[indexPath.row] objectForKey:@"address"];
        if ([[_daylist2[indexPath.row] objectForKey:@"clevel"] intValue] == 1) {
            cell.companyLevelImage.image = [UIImage imageNamed:@"vip"];
        }else{
            cell.companyLevelImage.image = [UIImage imageNamed:@"普通客户图标"];
        }
        int visitStaus = [[_daylist2[indexPath.row] objectForKey:@"status"] intValue];
        if (visitStaus == 1) {
            cell.visitStausLab2.text = @"已拜访";
            cell.visitStausLab.text = @"";
            cell.visitTimeLab.text = @"";
        }else{
            cell.visitStausLab2.text = @"";
            cell.visitStausLab.text = @"待拜访";
            NSString *time = [_daylist2[indexPath.row] objectForKey:@"ordertime"];
            NSArray * arr = [time componentsSeparatedByString:@" "];
            if(arr.count > 1){
                time = [arr.lastObject substringToIndex:5];//截取下标5之前的字符串
            }else{
                time = @"";
            }
            cell.visitTimeLab.text = time;
        }
        cell.delegate = self;
    }
    
    return cell;
}
- (void)jumpControllerToMap:(NSString *)btnTitle
{
    MapClientViewController *mapClient = [[MapClientViewController alloc] init];
    [self.navigationController pushViewController:mapClient animated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _visitTableView) {
        VisitDetailViewController *visitDetailViewController = [[VisitDetailViewController alloc] init];
        visitDetailViewController.visitId = [[_daylist[indexPath.row] objectForKey:@"id"] intValue];
        visitDetailViewController.canChangeText = YES;
        [self.navigationController pushViewController:visitDetailViewController animated:YES];
    }else{
        VisitDetailViewController *visitDetailViewController = [[VisitDetailViewController alloc] init];
        visitDetailViewController.visitId = [[_daylist2[indexPath.row] objectForKey:@"id"] intValue];
        visitDetailViewController.canChangeText = NO;
        [self.navigationController pushViewController:visitDetailViewController animated:YES];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y > _planNumView.y) {//如果当前位移大于缓存位移，说明scrollView向上滑动
        
    }
    
//    _oldOffset = scrollView.contentOffset.y;//将当前位移变成缓存位移
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    lastContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{

    if (!self.calendar.calendarAppearance.isWeekMode) {
        self.calendar.calendarAppearance.isWeekMode = YES;
        [self transitionExample];
    }

    if (lastContentOffset < scrollView.contentOffset.y) {
        NSLog(@"向上滚动");
    }else{
        NSLog(@"向下滚动");
    }
}

@end
