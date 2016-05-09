//
//  AttendContentVC.m
//  Marketing
//
//  Created by User on 16/3/13.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "AttendContentVC.h"
#import "PostSignInViewController.h"
#import "Person StatisticsController.h"
#import "SignModel.h"
#import "VisitedCell.h"
#import "SubSignModel.h"

@interface AttendContentVC ()<UITableViewDataSource,UITableViewDelegate>
{
SignModel *model;
CGFloat  TopSpace;
UIView  *_userInfoView;//承载个人信息的view
UIImageView *_imageView;//头像
UILabel     *_nameLabel;//名字
UILabel     *_signInLable;//签到状态
UILabel     *_signOutLabel;//签退状态
UILabel     *_dateLabel;//日期
UILabel     *_timeLabel;//当前时间
    
    //今天的日期信息
    NSString    *_dateString;
    NSString    *_timeString;
    NSString    *_weekDayString;
    
    NSTimer     *_timer;
    UITableView  *_VisitedTableview;
    NSMutableArray *_dataArray;

    
    
}
@end

@implementation AttendContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:self.name];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray array];
    if (IPhone4S) {
        TopSpace =5.0f;
    }else{
        TopSpace =[UIView getWidth: 10.0f];
    }
    [self getCrrentDate];
    
    [self creatInfoView];
    
    [self initWorkerData];
    
    self.navigationItem.leftBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithAction:@selector(popLastView1)];
   
    UIBarButtonItem *negativeSeperator;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        negativeSeperator   = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -25;
    }
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 20, 80, 44)];
    [btn setTitle:@"统计" forState:UIControlStateNormal];
    [btn setTitleColor:darkOrangeColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [btn addTarget:self action:@selector(handleSatistic:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItems = @[negativeSeperator,rightBarItem];

    
//    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 20, 80, 44)];
//    [btn setTitle:@"统计" forState:UIControlStateNormal];
//    [btn setTitleColor:darkOrangeColor forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIView getFontWithSize:12.0f];
//    [btn addTarget:self action:@selector(handleSatistic:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    self.navigationItem.rightBarButtonItem = rightBarItem;

}


- (void)drawVisitedTableView
{
    _VisitedTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, _userInfoView.maxY, KSCreenW, [UIView getWidth:140]) style:UITableViewStylePlain];
    _VisitedTableview.delegate = self;
    _VisitedTableview.dataSource = self;
    //    _VisitedTableview.scrollEnabled = NO;
    _VisitedTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_VisitedTableview];
}
- (void)handleSatistic:(UIButton * )btn
{
    //    NSLog(@"统计");
    Person_StatisticsController * statisticVC = [[Person_StatisticsController alloc] init];
    statisticVC.mansId = self.workId;
    statisticVC.isManagerCheckSign = YES;
    statisticVC.nameString = self.name;
    [self.navigationController pushViewController:statisticVC animated:YES];
    
}
//获取数据
//- (void)getSignInfo
//{
//    int userID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue];
//    
//    NSString *backToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
//    
//    NSLog(@"%d, %@",userID,backToken);
//    
//    NSDictionary *dict = @{@"uid" : @(userID), @"token" :  backToken,@"ids":self.workId};
//    [DataTool sendGetWithUrl:SIGN_IN_OUT_DETAIL_URL parameters:dict success:^(id data) {
//        NSDictionary * backData = CRMJsonParserWithData(data);
//        NSLog(@"%@",backData);
//        model = [[SignModel alloc] init];
//        [model setValuesForKeysWithDictionary:backData];
//        //        (NSMutableArray *)model.list;
//        //        NSLog(@"请求数据中国打印%d",model.checkinCount);
//        for (int i =0 ; i< model.list.count; i ++) {
//            SubSignModel * subModel = [[SubSignModel alloc] init];
//            //            [subModel setValuesForKeysWithDictionary:model.list[i]];
//            //            [subModel setValue:model.list[i][@"addtime"] forKey:@"addtime"];
//            //            [subModel setValue:model.list[i][@"remark"] forKey:@"remark"];
//            //            [subModel setValue:model.list[i][@"company"] forKey:@"company"];
//            //            [subModel setValue:model.list[i][@"address"] forKey:@"address"];
//            //            [subModel setValue:model.list[i][@"img"] forKey:@"img"];
//            //            [subModel setValue:model.list[i][@"type"] forKey:@"type"];
//            [subModel setValuesForKeysWithDictionary:model.list[i]];
//            //                if ((i + 1) % 2 == 0) {//奇数位
//            //                    [subModel setValue:@(1) forKey:@"signState"];//已签退
//            //                }else{
//            //                    [subModel setValue:@(0) forKey:@"signState"];//已签到
//            //                }
//            [_dataArray addObject:subModel];
//            
//        }
//         [self drawVisitedTableView];//拜访的一些信息
//        //        NSLog(@"dataArray.count %ld",_dataArray.count);
//        
//       
//        [self useData];
//        
//    } fail:^(NSError *error) {
//        NSLog(@"%@",error.localizedDescription);
//    }];
//    
//}

- (void)useData
{
    //    [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LoadImageUrl,model.logo]] placeholderImage:nil];
    int checkInCount = (int )model.checkinCount;
    int checkOutCount = (int)model.checkoutCount;
    if (checkInCount != 0 ) {
        NSString * coungStr = [NSString stringWithFormat:@"%d",checkInCount];
        NSMutableAttributedString *checkInAttributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"今日已成功签到%d次",checkInCount]];
        [checkInAttributeStr setAttributes:@{NSFontAttributeName : [UIView getFontWithSize:12],NSForegroundColorAttributeName : darkOrangeColor} range:NSMakeRange(checkInAttributeStr.length - coungStr.length - 1 , coungStr.length)];
        _signInLable.attributedText = checkInAttributeStr;
    }else{
        _signInLable.text = @"今日还未签到";
    }
    if (checkOutCount != 0 ) {
        NSString * countStr = [NSString stringWithFormat:@"%d",checkOutCount];
        NSMutableAttributedString *checkOutAttributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"今日已成功签退%d次",checkOutCount]];
        [checkOutAttributeStr setAttributes:@{NSFontAttributeName : [UIView getFontWithSize:12],NSForegroundColorAttributeName : darkOrangeColor} range:NSMakeRange(checkOutAttributeStr.length -countStr.length - 1, countStr.length)];
        _signOutLabel.attributedText = checkOutAttributeStr;
    }else{
        _signOutLabel.text = @"今日还未签退";
    }
    
}

//个人信息
- (void)creatInfoView
{
    
    CGFloat imageW = 70;
    
    _userInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, KSCreenW, [UIView getHeight:133])];
    //    _userInfoView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:_userInfoView];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(TopSpace ,  TopSpace, imageW, imageW)];
    //    _imageView.backgroundColor = [UIColor blackColor];
    //    [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LoadImageUrl,model.logo]] placeholderImage:nil];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LoadImageUrl,self.logo]] placeholderImage:nil];
    _imageView.layer.cornerRadius = imageW / 2.0;
    _imageView.layer.masksToBounds = YES;
    [_userInfoView addSubview:_imageView];
    
    //名字根据用户登录来获取
//    [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    
    _nameLabel = [ViewTool getLabelWith:CGRectMake(_imageView.maxX + 2 * TopSpace, TopSpace, 100, [UIView getHeight:20]) WithTitle:self.name WithFontSize:17.0 WithTitleColor:blackFontColor WithTextAlignment:NSTextAlignmentLeft];
    //    _nameLabel.backgroundColor = [UIColor redColor];
    [_userInfoView addSubview:_nameLabel];
    
    //根据签到签退的情况来 改变label文字的状态
    
    
    _signInLable = [ViewTool getLabelWith:CGRectMake(_nameLabel.x, _nameLabel.maxY + 5, 200, [UIView getHeight:15]) WithTitle:nil WithFontSize:14.0f WithTitleColor:lightGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
    //    _signInLable.backgroundColor = [UIColor orangeColor];
    
    [_userInfoView addSubview:_signInLable];
    
    
    _signOutLabel = [ViewTool getLabelWith:CGRectMake(_nameLabel.x, _signInLable.maxY + 5, 200, [UIView getHeight:15]) WithTitle:nil WithFontSize:14.0f WithTitleColor:lightGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_userInfoView addSubview:_signOutLabel];
    
    //添加虚线
    UIView *line = [ViewTool getLineViewWith:CGRectMake(_imageView.x, _imageView.maxY + TopSpace, KSCreenW - 2* TopSpace, 0.8) withBackgroudColor:grayLineColor];
    [_userInfoView addSubview:line];
    
    //添加 日期 时间
    
    UIImageView *dateImageView = [[UIImageView alloc] initWithFrame:CGRectMake( _imageView.x, line.maxY + 2 * TopSpace, 20, 20)];
//    dateImageView.backgroundColor = [UIColor orangeColor];
    dateImageView.image = [UIImage imageNamed:@"时间"];
    [_userInfoView addSubview:dateImageView];
    
    //
    NSMutableAttributedString * dateStr = [[NSMutableAttributedString alloc] initWithString:_dateString];
    [dateStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName : blackFontColor} range:NSMakeRange(0, _dateString.length)];
    [dateStr setAttributes:@{NSFontAttributeName : [UIView getFontWithSize:12.0f],NSForegroundColorAttributeName : lightGrayFontColor} range:NSMakeRange(4, _dateString.length - 4)];
    _dateLabel = [ViewTool getLabelWithFrame:CGRectMake(dateImageView.maxX + TopSpace, dateImageView.y, [UIView getWidth:120], dateImageView.height) WithAttrbuteString:dateStr];
    //    _dateLabel.backgroundColor = [UIColor redColor];
    [_userInfoView addSubview:_dateLabel];
    
    
    UIImageView *timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake( self.view.width / 2.0 + TopSpace, dateImageView.y, 20, 20)];
//    timeImageView.backgroundColor = [UIColor orangeColor];
    timeImageView.image = [UIImage imageNamed:@"当前时间"];
    [_userInfoView addSubview:timeImageView];
    
    NSMutableAttributedString * timeStr = [[NSMutableAttributedString alloc] initWithString:_timeString];
    [timeStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName : blackFontColor} range:NSMakeRange(0, _timeString.length)];
    [timeStr setAttributes:@{NSFontAttributeName : [UIView getFontWithSize:12.0f],NSForegroundColorAttributeName : lightGrayFontColor } range:NSMakeRange(5, _timeString.length - 5)];
    _timeLabel = [ViewTool getLabelWithFrame:CGRectMake(timeImageView.maxX + TopSpace, timeImageView.y, [UIView getWidth:100], timeImageView.height)  WithAttrbuteString:timeStr];
    [_userInfoView addSubview:_timeLabel];
    
    UIView *line2 = [ViewTool getLineViewWith:CGRectMake(_imageView.x, _timeLabel.maxY + 2 * TopSpace, KSCreenW - 2 * TopSpace, 0.8) withBackgroudColor:grayLineColor];
    [_userInfoView addSubview:line2];
    //    NSLog(@"%@",NSStringFromCGRect(line2.frame));
    _userInfoView.frame = CGRectMake(0, 64, KSCreenW, line2.maxY);
    
      [self drawVisitedTableView];//拜访的一些信息
    
}
#pragma mark --员工数据
- (void)initWorkerData
{
    //    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    //    [formate setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    //    NSDate *signTime = [formate dateFromString:self.addTime];
    //       NSLog(@"查看时间 %@,date%@",self.addTime,signTime);
    NSString *yearStr =  [self.addTime substringWithRange:NSMakeRange(0, 4)];
    NSString *monthStr =  [self.addTime substringWithRange:NSMakeRange(5, 2)];
    NSString *dayStr =  [self.addTime substringWithRange:NSMakeRange(8, 2)];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"token" :TOKEN,@"uid" : @(UID),@"id" : @(self.workId)}];
//    if (yearStr) {
//        [dict setValue:yearStr forKey:@"year"];
//    }
//    if (monthStr) {
//        [dict setValue:monthStr forKey:@"month"];
//    }
//    if(dayStr){
//        [dict setValue:dayStr forKey:@"day"];
//    }
    
    NSLog(@"参数 %@",dict);
//    [DataTool sendGetWithUrl:MANAGER_CHECK_SIGN_URL parameters:dict success:^(id data) {
//        NSDictionary * backData = CRMJsonParserWithData(data);
//        NSLog(@"%@",backData);
//        model = [[SignModel alloc] init];
//        [model setValuesForKeysWithDictionary:backData[@"daylist"]];
//        //        (NSMutableArray *)model.list;
//        //        NSLog(@"请求数据中国打印%d",model.checkinCount);
//        for (int i =0 ; i< model.list.count; i ++) {
//            SubSignModel * subModel = [[SubSignModel alloc] init];
//            [subModel setValuesForKeysWithDictionary:model.list[i]];
//            [_dataArray addObject:subModel];
//            
//        }
//        [self drawVisitedTableView];//拜访的一些信息
//        //        NSLog(@"dataArray.count %ld",_dataArray.count);
//        
//        
//        [self useData];
//    } fail:^(NSError *error) {
//        NSLog(@"%@",error.localizedDescription);
//    }];
    
    [DataTool postWithUrl:MANAGER_GET_CHECK_ONE_SIGN_URL parameters:dict success:^(id data) {
        NSDictionary * backData = CRMJsonParserWithData(data);
        NSLog(@"%@",backData);
        model = [[SignModel alloc] init];
        NSDictionary * dateDict = [DataTool changeType:backData];
        [model setValuesForKeysWithDictionary:dateDict];
        //        (NSMutableArray *)model.list;
        //        NSLog(@"请求数据中国打印%d",model.checkinCount);
        for (int i =0 ; i< model.list.count; i ++) {
            SubSignModel * subModel = [[SubSignModel alloc] init];
            [subModel setValuesForKeysWithDictionary:model.list[i]];
            [_dataArray addObject:subModel];
            
        }
      
        //        NSLog(@"dataArray.count %ld",_dataArray.count);
        
        [_VisitedTableview reloadData];
        [self useData];
    } fail:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

#pragma mark --代理
#pragma mark --tableview的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    NSLog(@"tableview zhong --%ld",/_dataArray.count);
//    NSLog(@"_dataArray.count %ld",_dataArray.count);
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VisitedCell *cell = [VisitedCell cellWithTableView:tableView];
    cell.model = _dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [VisitedCell cellHeight];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma mark --刷新时间
- (void)freshTime
{
    [self getCrrentDate];
    NSMutableAttributedString * timeStr = [[NSMutableAttributedString alloc] initWithString:_timeString];
    [timeStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName : blackFontColor} range:NSMakeRange(0, _timeString.length)];
    [timeStr setAttributes:@{NSFontAttributeName : [UIView getFontWithSize:12.0f],NSForegroundColorAttributeName : lightGrayFontColor } range:NSMakeRange(5, _timeString.length - 5)];
    _timeLabel.attributedText = timeStr;
    
}
- (void)getCrrentDate
{
    NSString * str = [DateTool getCurrentDate];
    //    NSRange  range = [str rangeOfString:@" "];
    //    NSLog(@"%@",NSStringFromRange(range));
    //    NSString * dateStr = [str substringWithRange:NSMakeRange(0, range.location - 1)];
    NSString * dateStr = [DateTool getYearmonthFromStr:str];
    //    NSString * timeStr = [str substringFromIndex:range.location];
    NSString *timeStr = [DateTool getDateFromStr:str];
    _dateString = [NSString stringWithFormat:@"%@:%@",[DateTool getCurrentWeekDay],dateStr];
    _timeString = [NSString stringWithFormat:@"当前时间:%@",timeStr];
    //    NSLog(@"%@,%@",_dateString,_timeString);
    
    _timeLabel.text = _timeString;
    
    
    //    [timeStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName : [UIColor colorWithWhite:0.4 alpha:0.85]} range:NSMakeRange(0, _timeString.length)];
    //    [timeStr setAttributes:@{NSFontAttributeName : [UIView getFontWithSize:12.0f],NSForegroundColorAttributeName : [UIColor colorWithWhite:0.7 alpha:0.85]} range:NSMakeRange(5, _timeString.length - 5)];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)popLastView1
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
