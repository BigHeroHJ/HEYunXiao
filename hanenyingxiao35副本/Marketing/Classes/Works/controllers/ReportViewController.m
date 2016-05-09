//
//  ReportViewController.m
//  zhexian
//
//  Created by User on 16/3/11.
//  Copyright © 2016年 User. All rights reserved.
//

#import "ReportViewController.h"
#import "ChartView.h"
#import "AppDelegate.h"
#import "ChartTableViewCell.h"
#import "ChartModel.h"

#import "SectionView.h"
#import "RepostViewCell.h"

#define WIDTH KSCreenW/320.0
#define KIsExpand @"isExpand"
@interface ReportViewController ()<UITableViewDataSource,UITableViewDelegate,sectionViewDelegate>
{
    NSMutableArray *_Xarr;
    NSMutableArray *_Yarr;
    ChartView *zhe;
    UIScrollView *scrollview;
    ChartModel *model;
    NSDictionary *Dic;
    int today;
    int   isFirstUp;
    int   isSecendUp;
    int   isThirdUp;
//    NSMutableDictionary  *_allDataDict;//存每天拜访客户数
//    NSMutableDictionary  *_allNewClientDict;//存每天新增的客户数
//    NSMutableDictionary  *_allClientDict;//存每天的客户总量
//    NSDictionary         *_todayDataDict;
    NSMutableArray *_firstChartData;
    NSMutableArray *_secondChartData;
    NSMutableArray *_thirdChartData;
    NSDate  *tagDate;
    NSString  *_monthTag;
    UIButton *lastbtn;
    
    NSMutableDictionary *dict1;
    NSMutableDictionary *dict2;
    NSMutableDictionary *dict3;
    NSInteger index;
    SectionView *sectionView1;
    SectionView *sectionView2;
    SectionView *sectionView3;
}
@end


@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:@"报表"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _Xarr = [NSMutableArray array];
    _Yarr = [NSMutableArray array];
    _firstChartData = [NSMutableArray array];
    _secondChartData = [NSMutableArray array];
    _thirdChartData = [NSMutableArray array];
    
    self.navigationItem.leftBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithAction:@selector(back)];
    tagDate = [NSDate date];
    
    dict1  = [NSMutableDictionary dictionary];
      dict2  = [NSMutableDictionary dictionary];
      dict3  = [NSMutableDictionary dictionary];
//    _allDataDict = [[NSMutableDictionary alloc] init];
    [self initFirstLineDataWith:nil];
    [self initSecondLineDataWith:nil];
    [self initThirdLineDataWith:nil];
    
    [self getCurrentDayData];
    
    [self initTableview];
 
   

    
   
    
//    UIButton *butt = [[UIButton alloc] initWithFrame:CGRectMake1(30, 510, 40, 20)];
//    butt.backgroundColor = [UIColor redColor];
//    [butt addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:butt];
    
  
    

}
- (void)initFirstLineDataWith:(NSString *)dateStr
{
    dict1  = [NSMutableDictionary dictionary];
 
    [dict1 setObject:@(NO) forKey:KIsExpand];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"token" :TOKEN,@"uid" : @(UID)}];
    if(dateStr){
        [dict setObject:dateStr forKey:@"addtime"];
    }
    NSLog(@"第一张表的参数%@",dict);
    [DataTool sendGetWithUrl:REPORT_LIEN_ONE_URL parameters:dict success:^(id data) {
        id backData =CRMJsonParserWithData(data);
//        NSLog(@"第一张表数据%@",backData);
        NSMutableArray *firstAray = [NSMutableArray array];
        firstAray = backData[@"visitlist"];
        if(!firstAray){
    
//            [self.view makeToast:@"没有更多了哦"];
            return ;
        }
//        zhe.frame = CGRectMake1(0, 5, 30+50*firstAray.count+5, 200);
        NSString *currentDate = [DateTool getCurrentDate];
        NSString *currentday = [currentDate substringWithRange:NSMakeRange(8, 2)];
        int day = [currentday intValue];
        NSLog(@"今天几号%d",day);
        for (int i = 0; i< firstAray.count; i++) {
            NSDictionary *dICT = firstAray[i];
            int daya = [dICT[@"time"] intValue];
            if (daya <= day) {
                [_firstChartData addObject:firstAray[i]];
            }
        }
        if (_firstChartData.count >= 3) {
            NSDictionary *lastDcit = _firstChartData[_firstChartData.count - 2];
            NSDictionary *laseSecDcit = _firstChartData[_firstChartData.count - 3];
            NSLog(@"前面 一个 %f, 后面一个%f",[lastDcit[@"count"] doubleValue],[laseSecDcit[@"count"] doubleValue]);
            if ([lastDcit[@"count"] doubleValue]- [laseSecDcit[@"count"] doubleValue] >= 0){
                isFirstUp = 1;
            }else{
                isFirstUp = 0;
            }
            NSLog(@"第yi个 上升 还是下降%d",isFirstUp);
            sectionView1.isUp = isFirstUp;
        }else{
            isFirstUp = 1;
        }
       
//        if(_firstChartData){
//             [self creatLineView];
//        }

               [table reloadData];
       
     
    } fail:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}
- (void)initSecondLineDataWith:(NSString *)dateStr
{
        [dict2 setObject:@(NO) forKey:KIsExpand];
    dict2  = [NSMutableDictionary dictionary];


    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"token" :TOKEN,@"uid" : @(UID)}];
    if(dateStr){
        [dict setObject:dateStr forKey:@"addtime"];
    }
    [DataTool sendGetWithUrl:REPORT_LIEN_TWO_URL parameters:dict success:^(id data) {
        id backData =CRMJsonParserWithData(data);
        NSLog(@"第二张表数据%@",backData);
        NSMutableArray *secondArr = [NSMutableArray array];
        secondArr = backData[@"daylist"];
//        zhe.frame = CGRectMake1(0, 5, 30+50*_secondChartData.count+5, 200);
        
        NSString *currentDate = [DateTool getCurrentDate];
        NSString *currentday = [currentDate substringWithRange:NSMakeRange(8, 2)];
        int day = [currentday intValue];
        NSLog(@"今天几号%d",day);
        for (int i = 0; i< secondArr.count; i++) {
            NSDictionary *dICT = secondArr[i];
            int daya = [dICT[@"time"] intValue];
            if (daya <= day) {
                [_secondChartData addObject:secondArr[i]];
            }
        }
        if (_secondChartData.count >= 3) {
            NSDictionary *lastDcit = _secondChartData[_secondChartData.count - 2];
            NSDictionary *laseSecDcit = _secondChartData[_secondChartData.count -3];
            
            NSLog(@"前面 一个 %f, 后面一个%f",[lastDcit[@"count"] doubleValue],[laseSecDcit[@"count"] doubleValue]);
            if ([lastDcit[@"count"] doubleValue]- [laseSecDcit[@"count"] doubleValue] > 0){
                isSecendUp = 1;
            }else{
                isSecendUp = 0;
            }
            NSLog(@"第er 个 上升 还是下降%d",isSecendUp);
            sectionView2.isUp = isSecendUp;
        }else{
            isSecendUp = 1;
        }
            [table reloadData];
     
    } fail:^(NSError *error) {
         NSLog(@"%@",error.localizedDescription);
    }];
}
- (void)initThirdLineDataWith:(NSString *)dateStr
{
        dict3  = [NSMutableDictionary dictionary];
    [dict3 setObject:@(NO) forKey:KIsExpand];
    NSLog(@"%d",[dict3[KIsExpand] boolValue]);
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"token" :TOKEN,@"uid" : @(UID)}];
    if(dateStr){
        [dict setObject:dateStr forKey:@"addtime"];
    }
    [DataTool sendGetWithUrl:REPORT_LIEN_THREE_URL parameters:dict success:^(id data) {
        id backData =CRMJsonParserWithData(data);
//        NSLog(@"第三张表数据%@",backData);

//        zhe.frame = CGRectMake1(0, 5, 30+50*_thirdChartData.count+5, 200);
        
        
        
        NSMutableArray *thirdArr = [NSMutableArray array];
        thirdArr = backData[@"monthlist"];
        zhe.frame = CGRectMake1(0, 5, 30+50*_secondChartData.count+5, 200);
        
        NSString *currentDate = [DateTool getCurrentDate];
        NSString *currentday = [currentDate substringWithRange:NSMakeRange(8, 2)];
        int day = [currentday intValue];
        NSLog(@"今天几号%d",day);
        for (int i = 0; i< thirdArr.count; i++) {
            NSDictionary *dICT = thirdArr[i];
            int daya = [dICT[@"time"] intValue];
            if (daya <= day) {
                [_thirdChartData addObject:thirdArr[i]];
            }
        }
        if (_thirdChartData.count >= 3) {
            NSDictionary *lastDcit = _thirdChartData[_thirdChartData.count - 2];
            NSDictionary *laseSecDcit = _thirdChartData[_thirdChartData.count -3];
            NSLog(@"前面 一个 %f, 后面一个%f",[lastDcit[@"count"] doubleValue],[laseSecDcit[@"count"] doubleValue]);
            if ([lastDcit[@"count"] doubleValue]- [laseSecDcit[@"count"] doubleValue] >= 0){
                isThirdUp = 1;
            }else{
                isThirdUp = 0;
            }
            NSLog(@"第三个 上升 还是下降%d",isThirdUp);
            sectionView3.isUp = isThirdUp;
        }else{
            isThirdUp = 1;
        }
        
//        NSDictionary *lastDcit = _thirdChartData[_thirdChartData.count - 2];
//        NSDictionary *laseSecDcit = _thirdChartData[_thirdChartData.count -3];
//        NSLog(@"前面 一个 %f, 后面一个%f",[lastDcit[@"count"] doubleValue],[laseSecDcit[@"count"] doubleValue]);
//        if ([lastDcit[@"count"] doubleValue]- [laseSecDcit[@"count"] doubleValue] >= 0){
//            isThirdUp = 1;
//        }else{
//            isThirdUp = 0;
//        }
//        NSLog(@"第三个 上升 还是下降%d",isThirdUp);
//        sectionView3.isUp = isThirdUp;
  
            [table reloadData];
    
    } fail:^(NSError *error) {
         NSLog(@"%@",error.localizedDescription);
    }];
}


- (void)initTableview
{
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KSCreenW, KSCreenH - 64) style:UITableViewStylePlain];
    table.delegate = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.dataSource = self;
    table.bounces = NO;

    
    [self.view addSubview:table];
    
}
- (void)creatLineView
{
    [_Xarr removeAllObjects];
    [_Yarr removeAllObjects];
    NSMutableArray * dateArray = [NSMutableArray array];
//    _firstChartData = nil;
    for (int i = 0; i < _firstChartData.count; i++) {
        NSDictionary *dict = _firstChartData[i];
        [dateArray addObject:[NSString stringWithFormat:@"%@",dict[@"time"]]];
        [_Yarr addObject:[NSString stringWithFormat:@"%@",dict[@"count"]]];
//        _Yarr = [NSMutableArray arrayWithObjects:@"30",@"50",@"20",@"70",@"50",@"65",@"20",@"35", nil];
    }
//    _Xarr = [NSMutableArray arrayWithArray:dateArray];
//      _Yarr = [NSMutableArray arrayWithObjects:@"30",@"50",@"20",@"70",@"50",@"65",@"20",@"35", nil];
    NSDate *date = [NSDate date];
    NSString * currentMonth = [DateTool getMonth:date];
    NSString *currentday = [DateTool getDay:date];
    today = [currentday intValue];
    
    for (int i = 0; i < dateArray.count; i++) {
        NSString * dateS = [NSString stringWithFormat:@"%@/%@",currentMonth,dateArray[i]];
        [_Xarr addObject:dateS];
    }
        if (_Xarr.count == 0) {
        NSRange dayCount = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]];
        //            if (_Xarr.count == 0) {
        NSString *monthStr = [DateTool getMonth:[NSDate date]];
        for (int i = 0; i< dayCount.length; i++) {
            [_Xarr addObject:[NSString stringWithFormat:@"%@/%d",monthStr,i + 1]];
        }
        
    }
    zhe = [[ChartView alloc] initWithFrame:CGRectMake1(0, 5, 30+50*_Xarr.count+5, 200)];
    zhe.xarr = _Xarr;
    zhe.yarr = _Yarr;
    zhe.chooseType = 1;
    
    
    
    //    [table setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    //    zhe = [[ChartView alloc] initWithFrame:CGRectMake(0, 5, 30+50*8+5, 280)];
    
    scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0,64 + [UIView getHeight:195.0f] + 2, KSCreenW, zhe.height + 10)];
    scrollview.backgroundColor = graySectionColor;
    scrollview.delegate = self;
//    scrollview.bounces = NO;
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.contentSize = CGSizeMake(zhe.frame.size.width+5, 0);
    if(_Yarr.count != 0 ){
        scrollview.contentOffset = CGPointMake(30 * WIDTH + _Yarr.count*50 *WIDTH - KSCreenW , 0);
    }

//
    
    //  NSMutableDictionary *visitdcit = [[NSUserDefaults standardUserDefaults] objectForKey:@"todayVisitClientDict"];
    //    _Xarr = (NSMutableArray *)visitdcit.allKeys;
    //    for (int i = 0; i< _Xarr.count; i ++) {
    //        [_Yarr addObject:visitdcit[_Xarr[i]]];
    //    }
    //    NSLog(@"%ld,%d",_Xarr.count,_Yarr.count);
    
//    zhe.xarr = [_Xarr copy];
//    zhe.yarr = [_Yarr copy];
    [zhe setNeedsDisplay];
    [scrollview addSubview:zhe];
    
    [self.view addSubview:scrollview];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = NO;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:NO];
}

//- (void)button:(UIButton *)butt
//{
//    _Xarr = [NSMutableArray arrayWithObjects:@"80",@"130",@"180",@"230",@"280",@"330",@"380",@"430", nil];
//    _Yarr = [NSMutableArray arrayWithObjects:@"40",@"10",@"80",@"30",@"56",@"15",@"90",@"25", nil];
//    [zhe removeFromSuperview];
//    zhe = nil;
//    zhe = [[ChartView alloc] initWithFrame:CGRectMake1(0, 5, 30+50*8+5, 230)];
//    
//    zhe.xarr = [_Xarr copy];
//    zhe.yarr = [_Yarr copy];
//    
//    [scrollview addSubview:zhe];
//}

- (void)getCurrentDayData
{
     NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@(UID), @"uid", TOKEN, @"token", nil];
  [DataTool sendGetWithUrl:WORK_REPORT_URL parameters:param success:^(id data) {
      id backData = CRMJsonParserWithData(data);
    NSLog(@"报表数据%@",backData);
      if (backData) {
           Dic = backData;
//           [self initTableview];
          [table reloadData];
      }
      
      
  } fail:^(NSError *error) {
      
  }];
}




#pragma mark----------------------UITableview Delegate------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  [UIView getWidth:66];//高度统一
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
       sectionView1 = [[SectionView alloc] initWithFrame:CGRectMake(0, 0, KSCreenW, [UIView getWidth:66]) withIndex:section];
        sectionView1.backgroundColor = [UIColor whiteColor];
        sectionView1.visit.text = @"客户拜访分析";
        sectionView1.reportOne.text = @"本月人均拜访:";
        sectionView1.reportOneNum.text = [NSString stringWithFormat:@"%.1f",[Dic[@"visitMonthAvg"] doubleValue]];
        sectionView1.reportTwo.text = @"昨日总拜访:";
        sectionView1.reportTwoNum.text = [NSString stringWithFormat:@"%d",[Dic[@"yestVisitCount"] intValue]];
        sectionView1.Num.text = [NSString stringWithFormat:@"%.1f",[Dic[@"visitYesterdayAvg"] doubleValue]];
        sectionView1.Num.textColor = cyanFontColor;
        sectionView1.NumBottom.text = @"昨日人均拜访";
        NSLog(@"isFirstUp%d",isFirstUp);
        sectionView1.isUp = isFirstUp;
        sectionView1.delegate = self;
        return sectionView1;
    }else if(section == 1){
        sectionView2 = [[SectionView alloc] initWithFrame:CGRectMake(0, 0, KSCreenW, [UIView getWidth:65]) withIndex:section];
        sectionView2.backgroundColor = [UIColor whiteColor];
        sectionView2.visit.text = @"新增客户分析";
        sectionView2.reportOne.text = @"日均增长量";
        sectionView2.reportOneNum.text = [NSString stringWithFormat:@"%.1f",[Dic[@"custDayAvg"] doubleValue]];
        sectionView2.reportTwo.text = @"本月新增客户";
        sectionView2.reportTwoNum.text = [NSString stringWithFormat:@"%d",[Dic[@"custMonthCount"] intValue]];
        sectionView2.Num.text = [NSString stringWithFormat:@"%d",[Dic[@"custYesterDayCount"] intValue]];
        sectionView2.Num.textColor = mainOrangeColor;
        sectionView2.delegate = self;
        sectionView2.NumBottom.text = @"昨日新增客户";
        NSLog(@"isSecendUp%d",isSecendUp);
        sectionView2.isUp = isSecendUp;
        return sectionView2;
    }else if (section == 2){
         sectionView3 = [[SectionView alloc] initWithFrame:CGRectMake(0, 0, KSCreenW, [UIView getWidth:65]) withIndex:section];
        sectionView3.backgroundColor = [UIColor whiteColor];
        sectionView3.visit.text = @"客户总量分析";
        sectionView3.reportOne.text = @"昨日净增客户";
        sectionView3.reportOneNum.text = [NSString stringWithFormat:@"%d",[Dic[@"custYesterDayCount"] intValue]];
        sectionView3.reportTwo.text = @"本月净增客户";
        sectionView3.reportTwoNum.text = [NSString stringWithFormat:@"%d",[Dic[@"custMonthCount"] intValue]];
        sectionView3.Num.text = [NSString stringWithFormat:@"%d",[Dic[@"allCustCount"]  intValue]];
        sectionView3.delegate = self;
        sectionView3.Num.textColor = [UIColor colorWithRed:102.0f/255.0f green:.0f/255.0f blue:231.0f/255.0f alpha:1];
        sectionView3.NumBottom.text = @"总客户数";
                 NSLog(@"isThirdUp%d",isThirdUp);
        sectionView3.isUp = isThirdUp;
        
        return sectionView3;
    }
    
    return nil;
}
- (void)addBtnwithIndex:(UIButton*)btn
{
    if (btn != lastbtn) {
        lastbtn = btn;
    }
//    NSLog(@"点击的btn对应得section值%ld",btn.tag - 51);
//    if (btn.selected == NO) {
         index = btn.tag - 51;
    int isexpand;
    if (index == 0) {
       isexpand = [dict1[KIsExpand] boolValue];
//           NSLog(@"点击之前--%d",isexpand);
        if (isexpand == 0) {
               [dict1 setObject:@(YES) forKey:KIsExpand];
          
        }else{
            [dict1 setObject:@(NO) forKey:KIsExpand];
         
        }
     
//          NSLog(@"点完之后%d",isexpand);
    }else if (index == 1){
//           NSLog(@"1111 -- %d",isexpand);
        isexpand = [dict2[KIsExpand] boolValue];
        if (isexpand == 0) {
            [dict2 setObject:@(YES) forKey:KIsExpand];
            
        }else{
            [dict2 setObject:@(NO) forKey:KIsExpand];
        
        }
    }else if(index == 2){
//           NSLog(@"222  ---%d",isexpand);
        isexpand = [dict3[KIsExpand] boolValue];
        if (isexpand == 0) {
            [dict3 setObject:@(YES) forKey:KIsExpand];
           
        }else{
            [dict3 setObject:@(NO) forKey:KIsExpand];
        }
    }

    [table reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];

   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return[RepostViewCell cellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
        if (section == 0) {
//            NSLog(@"%d",[dict1[KIsExpand] boolValue]);
            if ([dict1[KIsExpand] boolValue] == 1) {//[dic[KIsExpand] boolValue]判断当前的section是否是展开的
                return 1;//dic[KDataArray]  是一个数据源数组
            }else {
                return 0;
            }
            return 1;
        }else if (section == 1){
//                 NSLog(@"%d",[dict2[KIsExpand] boolValue]);
            if ([dict2[KIsExpand] boolValue] == 1) {//[dic[KIsExpand] boolValue]判断当前的section是否是展开的
                return 1;//dic[KDataArray]  是一个数据源数组
            }else {
                return 0;
            }
        }else if(section == 2){
//                 NSLog(@" disange  %d",[dict3[KIsExpand] boolValue]);
            if ([dict3[KIsExpand] boolValue] == 1) {//[dic[KIsExpand] boolValue]判断当前的section是否是展开的
                return 1;//dic[KDataArray]  是一个数据源数组
            }else {
                return 0;
            }
        }
    
    return 0;
    }
    
    

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [_Xarr removeAllObjects];
//    [_Yarr removeAllObjects];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.row == 0) {
////        _firstChartData = nil;
//        [zhe removeFromSuperview];
//        zhe = nil;
//        NSString *monthStr = [DateTool getMonth:[NSDate date]];
//        for (int i = 0; i < _firstChartData.count; i++) {
//            NSDictionary *dict = _firstChartData[i];
//            [_Xarr addObject:[NSString stringWithFormat:@"%@/%d",monthStr,i + 1]];
//            [_Yarr addObject:[NSString stringWithFormat:@"%@",dict[@"count"]]];
//        }
//        if(_Yarr.count != 0 ){
//           scrollview.contentOffset = CGPointMake(30 * WIDTH + _Yarr.count*50 *WIDTH - KSCreenW , 0);
//        }
//        if (_Xarr.count == 0) {
//            NSRange dayCount = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]];
//            //            if (_Xarr.count == 0) {
//            NSString *monthStr = [DateTool getMonth:[NSDate date]];
//            for (int i = 0; i< dayCount.length; i++) {
//                [_Xarr addObject:[NSString stringWithFormat:@"%@/%d",monthStr,i + 1]];
//            }
//            
//        }
//        NSLog(@"点击第一张表x的数组个数是%ld",_Xarr.count);
////         _Yarr = [NSMutableArray arrayWithObjects:@"30",@"50",@"20",@"70",@"50",@"65",@"20",@"35",@"70",@"50",@"65",@"20", nil];
////        _Xarr = [NSMutableArray arrayWithObjects:@"80",@"130",@"180",@"230",@"280",@"330",@"380",@"430", nil];
////        _Yarr = [NSMutableArray arrayWithObjects:@"30",@"50",@"20",@"70",@"50",@"65",@"20",@"35", nil];
//       
//        
//        zhe = [[ChartView alloc] initWithFrame:CGRectMake1(0, 5, 30+50 * WIDTH*_Xarr.count +5, 200)];
//        zhe.chooseType = 1;
//        zhe.xarr = _Xarr;
//        zhe.yarr = _Yarr;
//        
//           [scrollview addSubview:zhe];
//  
//    }else if(indexPath.row == 1){
//        
//        [zhe removeFromSuperview];
//        zhe = nil;
//        //
//        for (int i = 0; i < _secondChartData.count; i++) {
//            NSDictionary *dict = _firstChartData[i];
//            [_Xarr addObject:[NSString stringWithFormat:@"%@",dict[@"time"]]];
//            [_Yarr addObject:[NSString stringWithFormat:@"%@",dict[@"count"]]];
//         
//        }
//        if(_Yarr.count != 0 ){
//            scrollview.contentOffset = CGPointMake(30 * WIDTH + _Yarr.count*50 *WIDTH - KSCreenW , 0);
//        }
//
////           _Yarr = [NSMutableArray arrayWithObjects:@"3",@"5",@"2",@"7",@"5",@"6.5",@"0",@"3.5",@"7.0",@"5.0",@"6.5",@"2.3", nil];
//        //        _Xarr = [NSMutableArray arrayWithObjects:@"80",@"130",@"180",@"230",@"280",@"330",@"380",@"430", nil];
//        //        _Yarr = [NSMutableArray arrayWithObjects:@"30",@"50",@"20",@"70",@"50",@"65",@"20",@"35", nil];
//        if(_Yarr.count != 0 ){
//            scrollview.contentOffset = CGPointMake(30 * WIDTH + _Yarr.count*50 *WIDTH - KSCreenW, 0);
//        }
//        if (_Xarr.count == 0) {
//            NSRange dayCount = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]];
//            //            if (_Xarr.count == 0) {
//            NSString *monthStr = [DateTool getMonth:[NSDate date]];
//            for (int i = 0; i< dayCount.length; i++) {
//                [_Xarr addObject:[NSString stringWithFormat:@"%@/%d",monthStr,i + 1]];
//            }
//            
//        }
//        zhe = [[ChartView alloc] initWithFrame:CGRectMake1(0, 5, 30+50 * WIDTH*_Xarr.count +5, 200)];
//        zhe.chooseType = 2;
//        zhe.xarr = _Xarr;
//        zhe.yarr = _Yarr;
//        
//        [scrollview addSubview:zhe];
//
//        [zhe setNeedsDisplay];
//    }else{
//        [zhe removeFromSuperview];
//        zhe = nil;
//        for (int i = 0; i < _thirdChartData.count; i++) {
//        NSDictionary *dict = _firstChartData[i];
//            [_Xarr addObject:[NSString stringWithFormat:@"%@",dict[@"time"]]];
//            [_Yarr addObject:[NSString stringWithFormat:@"%@",dict[@"count"]]];
//        }
////         _Yarr = [NSMutableArray arrayWithObjects:@"30",@"50",@"20",@"70",@"50",@"65",@"20",@"35",@"70",@"50",@"65",@"20", nil];
//        if(_Yarr.count != 0 ){
//         scrollview.contentOffset = CGPointMake(30 * WIDTH + _Yarr.count*50 *WIDTH - KSCreenW , 0);
//        }
//        if (_Xarr.count == 0) {
//            NSRange dayCount = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]];
//            //            if (_Xarr.count == 0) {
//            NSString *monthStr = [DateTool getMonth:[NSDate date]];
//            for (int i = 0; i< dayCount.length; i++) {
//                [_Xarr addObject:[NSString stringWithFormat:@"%@/%d",monthStr,i + 1]];
//            }
//            
//        }
//
//    zhe = [[ChartView alloc] initWithFrame:CGRectMake1(0, 5, 30+50 * WIDTH*_Xarr.count +5, 200)];
//    zhe.chooseType = 3; //设置了三种 y的标记
//    zhe.xarr = _Xarr;
//    zhe.yarr = _Yarr;
//    
//    [scrollview addSubview:zhe];
//       
//    [zhe setNeedsDisplay];
//    }
//    if (_Yarr.count != 0 ) {
////      scrollview.contentOffset = CGPointMake(30 * WIDTH + _Yarr.count *50 *WIDTH - KSCreenW / 2.0f, 0);
//    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepostViewCell *cell = [RepostViewCell cellWithTableView:tableView WithIndex:indexPath.section];
    if (indexPath.section ==0) {
        cell.indexssss = (int)indexPath.row;
        cell.dataArray = _firstChartData;
    }else if (indexPath.section ==1){
          cell.indexssss = (int)indexPath.row;
        cell.dataArray = _secondChartData;
        
    }else if (indexPath.section == 2){
          cell.indexssss = (int)indexPath.row;
        cell.dataArray = _thirdChartData;
    }
    //static NSString *ido = @"idofs";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ido];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ido];
//    }
//    cell.textLabel.text = @"sdfsdf";
    return cell;
//    
////    NSLog(@"%@",_todayDataDict);
//    ChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
//    if (cell == nil) {
//        cell = [[ChartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
//    }
//    if (indexPath.row == 0) {
//        cell.visit.text = @"客户拜访分析";
//        cell.reportOne.text = @"本月人均拜访:";
//        cell.reportOneNum.text = [NSString stringWithFormat:@"%.1f",[Dic[@"visitMonthAvg"] doubleValue]];
//        cell.reportTwo.text = @"昨日总拜访:";
//        cell.reportTwoNum.text = [NSString stringWithFormat:@"%d",[Dic[@"yestVisitCount"] intValue]];
//        cell.Num.text = [NSString stringWithFormat:@"%.1f",[Dic[@"visitYesterdayAvg"] doubleValue]];
//        cell.Num.textColor = blueFontColor;
//        cell.NumBottom.text = @"昨日人均拜访";
//        NSLog(@"isFirstUp%d",isFirstUp);
//        cell.isUp = isFirstUp;
//    }else if (indexPath.row == 1){
//        cell.visit.text = @"新增客户分析";
//        cell.reportOne.text = @"日均增长量";
//        cell.reportOneNum.text = [NSString stringWithFormat:@"%.1f",[Dic[@"custDayAvg"] doubleValue]];
//        cell.reportTwo.text = @"本月新增客户";
//        cell.reportTwoNum.text = [NSString stringWithFormat:@"%d",[Dic[@"custMonthCount"] intValue]];
//        cell.Num.text = [NSString stringWithFormat:@"%d",[Dic[@"custYesterDayCount"] intValue]];
//         cell.Num.textColor = mainOrangeColor;
//        
//    }else if (indexPath.section == 2){
//        cell.dataArray = _thirdChartData;
//    }
////static NSString *ido = @"idofs";
////    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ido];
////    if (!cell) {
////        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ido];
////    }
////    cell.textLabel.text = @"sdfsdf";
//    return cell;
//    static NSString *str = @"reportCEllID";
//    
////    NSLog(@"%@",_todayDataDict);
//    ChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
//    if (cell == nil) {
//        cell = [[ChartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
//    }
//    if (indexPath.row == 0) {
//        cell.visit.text = @"客户拜访分析";
//        cell.reportOne.text = @"本月人均拜访:";
//        cell.reportOneNum.text = [NSString stringWithFormat:@"%.1f",[Dic[@"visitMonthAvg"] doubleValue]];
//        cell.reportTwo.text = @"昨日总拜访:";
//        cell.reportTwoNum.text = [NSString stringWithFormat:@"%d",[Dic[@"yestVisitCount"] intValue]];
//        cell.Num.text = [NSString stringWithFormat:@"%.1f",[Dic[@"visitYesterdayAvg"] doubleValue]];
//        cell.Num.textColor = cyanFontColor;
//        cell.NumBottom.text = @"昨日人均拜访";
//        NSLog(@"isFirstUp%d",isFirstUp);
//        cell.isUp = isFirstUp;
//    }else if (indexPath.row == 1){
//        cell.visit.text = @"新增客户分析";
//        cell.reportOne.text = @"日均增长量";
//        cell.reportOneNum.text = [NSString stringWithFormat:@"%.1f",[Dic[@"custDayAvg"] doubleValue]];
//        cell.reportTwo.text = @"本月新增客户";
//        cell.reportTwoNum.text = [NSString stringWithFormat:@"%d",[Dic[@"custMonthCount"] intValue]];
//        cell.Num.text = [NSString stringWithFormat:@"%d",[Dic[@"custYesterDayCount"] intValue]];
//         cell.Num.textColor = mainOrangeColor;
//        
//        cell.NumBottom.text = @"昨日新增客户";
//         NSLog(@"isSecendUp%d",isSecendUp);
//        cell.isUp = isSecendUp;
//    }else{
//        cell.visit.text = @"客户总量分析";
//        cell.reportOne.text = @"昨日净增客户";
//        cell.reportOneNum.text = [NSString stringWithFormat:@"%d",[Dic[@"custYesterDayCount"] intValue]];
//        cell.reportTwo.text = @"本月净增客户";
//        cell.reportTwoNum.text = [NSString stringWithFormat:@"%d",[Dic[@"custMonthCount"] intValue]];
//        cell.Num.text = [NSString stringWithFormat:@"%d",[Dic[@"allCustCount"]  intValue]];
//         cell.Num.textColor = [UIColor colorWithRed:102.0f/255.0f green:.0f/255.0f blue:231.0f/255.0f alpha:1];
//        cell.NumBottom.text = @"总客户数";
////         NSLog(@"isThirdUp%d",isThirdUp);
//        cell.isUp = isThirdUp;
//       
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    return cell;
    
//    NSLog(@"**************************************%@",model.visitMonthAvg);
//    return nil;
}

CG_INLINE CGRect
CGRectMake1(CGFloat x,CGFloat y,CGFloat width,CGFloat height)
{
    //创建appDelegate 在这不会产生类的对象,(不存在引起循环引用的问题)
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    //计算返回
    return CGRectMake(x * app.autoSizeScaleX, y * app.autoSizeScaleY, width * app.autoSizeScaleX, height * app.autoSizeScaleY);
}

@end
