//
//  AttendanceVC.m
//  Marketing
//
//  Created by User on 16/3/13.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "AttendanceVC.h"
#import "VisitTableViewCell.h"
#import "MyClientView.h"
#import "SelectViewController.h"
#import "MyTabBarController.h"
#import "VisitDetailViewController.h"
#import "DateTool.h"
#import "LoginViewController.h"
#import "Attendcell.h"
#import "AttendContentVC.h"
#import "StatisticCell.h"
#import "Managercheckcell.h"
#import "UserModel.h"
#import "ManagerCheckSignCell.h"
@interface AttendanceVC ()<MyClientViewDelegate,SelectStaffViewDelegate>{
    UITableView *_table;
    NSMutableArray *_dataArray;
    UILabel *Attend;
    UILabel *Signout;
    int calendarHei;
    
    NSString *workIds;
//    NSString *yearStr;
//    NSString *monthStr;
//    NSString * dayStr;
    NSDate   *_chooseDate;
    float lastContentOffset;
}
@property (nonatomic, strong) UISwipeGestureRecognizer *upSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *downSwipeGestureRecognizer;
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UILabel *monthLabel;

@property(nonatomic) BOOL isManager;
@property(nonatomic) BOOL isMyVisit;
@property(nonatomic, strong) MyClientView *topBtnView;
//@property (strong, nonatomic) UITableView *visitTableView;

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
@property (nonatomic, strong) NSMutableArray *timelist;
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

@end

@implementation AttendanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:@"考勤统计"];
    _dataArray = [NSMutableArray array];
    _timelist2 = [NSMutableArray array];
    self.navigationItem.leftBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithAction:@selector(back)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithString:@"筛选" WithAction:@selector(clickToselectUser)];
    [self addCalendarView];
    [self initDataWithYear:nil WithMonth:nil Withday:nil WithworkerId:nil];
    [self addStatistic];
    [self getMonthList];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.hidesBottomBarWhenPushed = YES;
}
- (void)viewDidAppear:(BOOL)animated
{
     [self.calendar reloadData]; // Must be call in viewDidAppear
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = NO;
}

- (void)back
{
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
            return [NSString stringWithFormat:@"%ld年%@月", comps.year, monthText];
        };
    }
    
    UILabel *Line = [[UILabel alloc] initWithFrame:CGRectMake(0, self.calendarMenuView.maxY-1, KSCreenW, 1)];
    Line.layer.borderColor = [grayLineColor CGColor];
    [self.view addSubview:Line];
    
    self.calendarMenuView.backgroundColor = [UIColor whiteColor];
    //    self.calendarContentViewHeight.constant = 200;
    self.calendarContentView = [[JTCalendarContentView alloc] initWithFrame:CGRectMake(0, self.calendarMenuView.maxY, KSCreenW, 300)];
    
    self.calendarContentView.backgroundColor = graySectionColor;
    self.calendarContentView.layer.borderWidth = 1.0;
    //    self.calendarContentView.layer.borderColor = [grayListColor CGColor];
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
                         self.calendarContentView.layer.opacity = 0.5;
                     }
                     completion:^(BOOL finished) {
                         [self.calendar reloadAppearance];
                         
                         [UIView animateWithDuration:.25
                                          animations:^{
                                              self.calendarContentView.layer.opacity = 1;
                                          }];
                     }];
    
    
    
    NSLog(@"%f",self.calendar.contentView.layer.position.y);
}
- (void)changeHeight{
//    _planNumView.frame = CGRectMake(0, 114+self.calendar.contentView.height+10, KSCreenW, 30);
//    _splitLine.frame = CGRectMake(20, _planNumView.maxY-1, KSCreenW-40, 1);
//    _table.frame = CGRectMake(0, _splitLine.maxY, KSCreenW, KSCreenH-_splitLine.maxY-10-TabbarH);
//    _otherVisitTableView.frame = CGRectMake(0, _splitLine.maxY, KSCreenW, KSCreenH-_splitLine.maxY-10-TabbarH);
    [UIView animateWithDuration:0.2 animations:^{
      Attend.frame = CGRectMake(20, self.calendarContentView.y+self.calendar.contentView.height+5, 130, 20);
        Signout.frame = CGRectMake(170 , self.calendarContentView.y+self.calendar.contentView.height+5, 130, 20);
        _splitLine.frame = CGRectMake(10, Attend.y+24, KSCreenW-20, 1);
        _table.frame = CGRectMake(0, _splitLine.maxY, KSCreenW, KSCreenH-Attend.maxY-10);
    }];
}
- (void)addStatistic
{
     Attend = [[UILabel alloc] initWithFrame:CGRectMake(20, self.calendarContentView.y+self.calendar.contentView.height+5, 130,20)];
        Attend.text = [NSString stringWithFormat:@"今日拜访签到:"];
        Attend.textColor = [UIColor lightGrayColor];
        Attend.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:Attend];
    
       Signout = [[UILabel alloc] initWithFrame:CGRectMake(170, self.calendarContentView.y+self.calendar.contentView.height+5, 130, 20)];
        Signout.text = [NSString stringWithFormat:@"今日拜访签退:"];
        Signout.textColor = [UIColor lightGrayColor];
        Signout.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:Signout];
    
    _splitLine = [[UILabel alloc] initWithFrame:CGRectMake(10, Attend.y+24, KSCreenW-20, 1)];
    _splitLine.layer.borderWidth = 10;
    _splitLine.layer.borderColor = [grayLineColor CGColor];
    [self.view addSubview:_splitLine];
    
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, _splitLine.maxY, KSCreenW, KSCreenH - Signout.maxY) style:UITableViewStylePlain];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.delegate = self;
        _table.dataSource = self;
        [_table setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [self.view addSubview:_table];
}


- (void)initDataWithYear:(NSString *)years WithMonth:(NSString *)month Withday:(NSString *)days WithworkerId:(NSString *)workerId
{
    [_dataArray removeAllObjects];
    NSMutableDictionary *dict = (NSMutableDictionary *)[NSMutableDictionary dictionaryWithDictionary:@{@"uid" : @(UID),@"token" : TOKEN}];
    
    if (years != nil) {
              [dict setObject:years forKey:@"year"];
    }
    if (month != nil) {
        [dict setObject:month forKey:@"month"];

    }
    if (days != nil) {
        [dict setObject:days forKey:@"day"];
    }
    
    if (workerId) {
        [dict setObject:workerId forKey:@"ids"];
    }
    
    [DataTool sendGetWithUrl:MANAGER_CHECK_SIGN_URL parameters:dict success:^(id data) {
        id backData = CRMJsonParserWithData(data);
        if (backData) {
            Attend.text = [NSString stringWithFormat:@"今日拜访签到:%d",[backData[@"checkinCount"] intValue]];
//            NSLog(@"签到数%@",backData[@"message"]);
//             NSLog(@"签到数%d",(int)backData[@"checkoutCount"]);
            Signout.text = [NSString stringWithFormat:@"今日拜访签退:%d",[backData[@"checkoutCount"] intValue]];
        NSLog(@"管理员查看的考勤数据 backData %@",backData);
        NSArray * listArr = backData [@"daylist"];
        for (int i = 0; i < listArr.count; i ++) {
            Managercheckcell * model = [[Managercheckcell alloc] init];
            [model setValuesForKeysWithDictionary:listArr[i]];
            [_dataArray addObject:model];
        }
        [_table reloadData];
        }
      
        
    } fail:^(NSError *error) {
        NSLog(@"error:%@",error.localizedDescription);
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UIView getWidth:70.0f];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ManagerCheckSignCell *cell = [ManagerCheckSignCell cellWithTableView:tableView];
    cell.model = _dataArray[indexPath.row];
//    cell.model = _dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AttendContentVC *vc = [[AttendContentVC alloc] init];
    Managercheckcell *model = _dataArray[indexPath.row];
    vc.name = model.name;
    vc.workId = model.uid;
        NSLog(@" 员工的uid %d",model.uid);
    vc.addTime = model.addtime;
    vc.logo = model.logo;
    [self.navigationController pushViewController:vc animated:YES];
    
}

//- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
//{
//    if (sender.direction == UISwipeGestureRecognizerDirectionUp) {
//        //        CGPoint labelPosition = CGPointMake(self.swipeLabel.frame.origin.x - 100.0, self.swipeLabel.frame.origin.y);
//        self.calendar.calendarAppearance.isWeekMode = YES;
//        [self transitionExample];
//    }
//    
//    if (sender.direction == UISwipeGestureRecognizerDirectionDown) {
//        //        CGPoint labelPosition = CGPointMake(self.swipeLabel.frame.origin.x + 100.0, self.swipeLabel.frame.origin.y);
//        self.calendar.calendarAppearance.isWeekMode = NO;
//        [self transitionExample];
//    }
//}

//#pragma mark --NewVisitView delagte
//- (void)refreshData{
//    if (_isManager & !_otherVisitTableView.hidden){
//        NSLog(@"%@222222222222",_daylist2);
//        _planbLab.text = [NSString stringWithFormat:@"今日计划:%d",_allcount2];
//        _completedLab.text = [NSString stringWithFormat:@"已完成:%d",_yicount2];
//        _notCompletedLab.text = [NSString stringWithFormat:@"未完成:%d",_daicount2];
//        [_otherVisitTableView reloadData];
//    }else{
//        NSLog(@"%@2222222222222222333333",_daylist2);
//        _planbLab.text = [NSString stringWithFormat:@"今日计划:%d",_allcount];
//        _completedLab.text = [NSString stringWithFormat:@"已完成:%d",_yicount];
//        _notCompletedLab.text = [NSString stringWithFormat:@"未完成:%d",_daicount];
//        [_visitTableView reloadData];
//    }
//}

//- (void)changeHeight{
//    _planNumView.frame = CGRectMake(0, 114+self.calendar.contentView.height+10, KSCreenW, 30);
//    _splitLine.frame = CGRectMake(20, _planNumView.maxY-1, KSCreenW-40, 1);
//    _visitTableView.frame = CGRectMake(0, _splitLine.maxY, KSCreenW, KSCreenH-_splitLine.maxY-10-TabbarH);
//    _otherVisitTableView.frame = CGRectMake(0, _splitLine.maxY, KSCreenW, KSCreenH-_splitLine.maxY-10-TabbarH);
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getMonthList{
//    NSDictionary * params1 = [NSDictionary dictionaryWithObjectsAndKeys:@(UID), @"uid", TOKEN, @"token",nil, @"year", nil, @"month", nil];
//    AFHTTPRequestOperationManager * manager1 = [AFHTTPRequestOperationManager manager];
//    manager1.requestSerializer.timeoutInterval = 20;
//    [manager1 POST:MANAGER_GET_MONTH_LIST_URL parameters:params1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [self.view hideToastActivity];
//        
//        NSLog(@"GET_MONTH_VISIT_URL:%@",responseObject);
//        int code = [[(NSDictionary *)responseObject objectForKey:@"code"] intValue];
//        if(code != 100)
//        {
//            NSString * message = [(NSDictionary *)responseObject objectForKey:@"message"];
//            [self.view makeToast:message];
//            NSLog(@"%@",message);
//            
//        }else{
//            _timelist = [(NSDictionary *)responseObject objectForKey:@"timelist"];
//            [self.calendar reloadData];//标记点
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",error);
//        [self.view hideToastActivity];
//    }];
//
//
        NSDictionary * params1 = [NSDictionary dictionaryWithObjectsAndKeys:@(UID), @"uid", TOKEN, @"token",nil, @"year", nil, @"month", nil];
        AFHTTPRequestOperationManager * manager1 = [AFHTTPRequestOperationManager manager];
        manager1.requestSerializer.timeoutInterval = 20;
        [manager1 POST:MANAGER_GET_MONTH_LIST_URL parameters:params1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.view hideToastActivity];
            NSLog(@"管理看看 有签到的日期 :%@",responseObject);
            int code = [[(NSDictionary *)responseObject objectForKey:@"code"] intValue];
            if(code != 100)
            {
                NSString * message = [(NSDictionary *)responseObject objectForKey:@"message"];
                [self.view makeToast:message];
                NSLog(@"%@",message);
                
            }else{
                _timelist2 = [(NSDictionary *)responseObject objectForKey:@"addtimeList"];
                [self.calendar reloadData];//标记点
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            [self.view hideToastActivity];
        }];
//    }
    
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
        NSLog(@"URL:%@",responseObject);
        int code = [[(NSDictionary *)responseObject objectForKey:@"code"] intValue];
        
        if(code != 100)
        {
            NSString * message = [(NSDictionary *)responseObject objectForKey:@"message"];
            [self.view makeToast:message];
            NSLog(@"%@",message);
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
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self.view hideToastActivity];
    }];
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
//    NSLog(@"%ld",_timelist2.count);
     for(NSString *dateStr in _timelist2){
            NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            [df setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"] ];
            NSDate *date1 =[[NSDate alloc]init];
            date1 =[df dateFromString:dateStr];
            
            if( [DateTool isSameDay:date date2:date1]){
                return YES;
            }
        }
    
    return NO;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    [_dataArray removeAllObjects];
    _chooseDate = date;
    [self initDataWithYear:[DateTool getYear:date] WithMonth:[DateTool getMonth:date] Withday:[DateTool getDay:date]WithworkerId:workIds];
    
//        [self getDaylist:date withURL:MANAGER_CHECK_SIGN_URL withArray:nil];
////
//        [self getDaylist:date withURL:GET_VISIT_URL withArray:nil];
//    
}

#pragma mark - Transition examples

//- (void)transitionExample
//{
//    CGFloat newHeight = 300;
//    if(self.calendar.calendarAppearance.isWeekMode){
//        newHeight = 75.;
//    }
//    
//    [UIView animateWithDuration:.5
//                     animations:^{
//                         self.calendarContentViewHeight.constant = newHeight;
//                         [self.view layoutIfNeeded];
//                         self.calendarContentView.frame = CGRectMake1(0, self.calendarMenuView.maxY, 320, 200);
//                         //[self changeHeight];
//                     }];
//    
//    [UIView animateWithDuration:.25
//                     animations:^{
//                         self.calendarContentView.layer.opacity = 0;
//                     }
//                     completion:^(BOOL finished) {
//                         [self.calendar reloadAppearance];
//                         
//                         [UIView animateWithDuration:.25
//                                          animations:^{
//                                              self.calendarContentView.layer.opacity = 1;
//                                          }];
//                     }];
//    
//    
//    
//    NSLog(@"%f",self.calendar.contentView.layer.position.y);
//}


- (void)clickToselectUser{
    //    self.navigationController.navigationBarHidden = YES;
    //    self.tabBarController.tabBar.hidden = YES;
    //    AppDelegate * appdelagte = [UIApplication sharedApplication].delegate;
    //    appdelagte.tabbarControl.bottomView.hidden = YES;
    
    //    self.navigationController.tabbarControl.tabBar.hidden = YES;
    
    //背影黑罩
    //    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, KSCreenH)];
    //    _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    //    [self.view insertSubview:_backView belowSubview:self.view];
    //
    //    _selectStaffView = [[SelectStaffView alloc]initWithFrame:CGRectMake( [UIView getWidth:50], 0, KSCreenW-[UIView getWidth:50], KSCreenH)];
    //    [self.view addSubview:_selectStaffView];
    
    
    SelectViewController *selectViewController = [[SelectViewController alloc]init];
    selectViewController.modalPresentationStyle =  UIModalPresentationPageSheet;
    selectViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    selectViewController.delegate = self;
    
    [self.navigationController pushViewController:selectViewController animated:YES];
}
//- (void)closeStaffView{
//    //    self.navigationController.navigationBarHidden = NO;
//    //    self.tabBarController.tabBar.hidden = NO;
//    //    AppDelegate * appdelagte = [UIApplication sharedApplication].delegate;
//    //    appdelagte.tabbarControl.bottomView.hidden = NO;
//    
//    //    _backView.hidden = YES;
//    //    _selectStaffView.hidden = YES;
//}
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    //    NSLog(@".....");
//    //    self.navigationController.navigationBarHidden = YES;
//    [self closeStaffView];
//}

#pragma mark --MyClientView delagte

- (void)changeNoticeView:(NSInteger)tag
{
    if (tag == 1111) {//下属拜访
        
        [_topBtnView.otherClient setTitleColor:darkOrangeColor forState:UIControlStateNormal];
        [_topBtnView.myClient setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateNormal];
        _topBtnView.redLine1.backgroundColor = darkOrangeColor;
        _topBtnView.redLine2.backgroundColor = grayLineColor;
        
        self.navigationItem.leftBarButtonItem  = [ViewTool getBarButtonItemWithTarget:self WithString:@"筛选" WithAction:@selector(clickToselectUser)];
        _visitTableView.hidden = YES;
        _otherVisitTableView.hidden = NO;
        
    }else if (tag == 2222){//我的拜访
        [_topBtnView.otherClient setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateNormal];
        [_topBtnView.myClient setTitleColor:darkOrangeColor forState:UIControlStateNormal];
        _topBtnView.redLine1.backgroundColor = grayLineColor;
        _topBtnView.redLine2.backgroundColor = darkOrangeColor;
        
        self.navigationItem.leftBarButtonItem  = nil;
        
        _visitTableView.hidden = NO;
        _otherVisitTableView.hidden = YES;
        
    }
}


//SelectStaffViewDelegate
- (void)getSelectedStaff:(NSArray *)array{
    
    NSLog(@"00000000000000000%@",array);
//    NSMutableArray *ids = [NSMutableArray array];
    NSString * usersId;
    for (UserModel *user in array) {
       usersId = [NSString stringWithFormat:@"%d,",user.uid];
    }
    workIds = [usersId substringToIndex:usersId.length - 1];
    NSLog(@"选择的人员 ids %@",workIds);
//    NSLog(@"%@",_chooseDate);
    if(_chooseDate == nil){
        _chooseDate = [NSDate date];
    }
    NSString *year = [DateTool getYear:_chooseDate];
    NSString *month = [DateTool getMonth:_chooseDate];
    NSString *day = [DateTool getDay:_chooseDate];
    if (year && month && day) {
      [self initDataWithYear:year WithMonth:month Withday:day WithworkerId:workIds];
    }else{
        [self.view makeToast:@"请重新选择日期哦"];
    }
    
    
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
