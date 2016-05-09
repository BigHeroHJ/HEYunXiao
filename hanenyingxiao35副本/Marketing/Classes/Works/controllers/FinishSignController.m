//
//  FinishSignController.m
//  Marketing
//
//  Created by Hanen 3G 01 on 16/2/26.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "FinishSignController.h"
#import "VisitedCell.h"
#import "PostSignInViewController.h"

@interface FinishSignController ()<UITableViewDelegate,UITableViewDataSource>
{
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
    
    CGFloat TopSpace;
    UITableView  *_VisitedTableview;
    
    NSMutableArray  *_dataArray;
    
    
    UIView        *_signBtnView;
    UIButton      *_signInBtn;
    UIButton      *_signOutBtn;
    
    int   signInCount;
    int   signOutCount;
}
@end

@implementation FinishSignController
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IPhone4S) {
        TopSpace = 5.0f;
    }else{
        TopSpace = [UIView getWidth:10.0f];
    }//
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"小花花";//换成用户的昵称
    self.navigationItem.leftBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithAction:@selector(popLastView)];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setTitle:@"统计" forState:UIControlStateNormal];
    [btn setTitleColor:darkOrangeColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(statisticalSign) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    [self getCrrentDate];
    [self creatInfoView];//加上个人签到签退 时间日期视图
    [self drawVisitedTableView];
    [self creatSignBtnView];
}

- (void)getCrrentDate
{
    NSString * str = [DateTool getCurrentDate];
    NSRange  range = [str rangeOfString:@" "];
    NSString * dateStr = [str substringWithRange:NSMakeRange(0, range.location - 1)];
    NSString * timeStr = [str substringFromIndex:range.location];
    _dateString = [NSString stringWithFormat:@"%@:%@",[DateTool getCurrentWeekDay],dateStr];
    _timeString = [NSString stringWithFormat:@"当前时间:%@",timeStr];
    _timeLabel.text = _timeString;
}


- (void)creatInfoView
{
    
    CGFloat imageW = 80;
    
    _userInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, KSCreenW, [UIView getHeight:133])];
    //    _userInfoView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:_userInfoView];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(TopSpace * 2,  TopSpace, imageW, imageW)];
    _imageView.backgroundColor = [UIColor blackColor];
    _imageView.layer.cornerRadius = imageW / 2.0;
    _imageView.layer.masksToBounds = YES;
    [_userInfoView addSubview:_imageView];
    
    //名字根据用户登录来获取
    _nameLabel = [ViewTool getLabelWith:CGRectMake(_imageView.maxX + 2 * TopSpace, TopSpace, 100, [UIView getHeight:20]) WithTitle:@"小花花" WithFontSize:15.0 WithTitleColor:blackFontColor WithTextAlignment:NSTextAlignmentLeft];
    //    _nameLabel.backgroundColor = [UIColor redColor];
    [_userInfoView addSubview:_nameLabel];
    
    //根据签到签退的情况来 改变label文字的状态
    _signInLable = [ViewTool getLabelWith:CGRectMake(_nameLabel.x, _nameLabel.maxY + 5, 100, [UIView getHeight:15]) WithTitle:nil WithFontSize:12.0f WithTitleColor:lightGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
    //    _signInLable.backgroundColor = [UIColor orangeColor];
    _signInLable.text = @"已签到";
    [_userInfoView addSubview:_signInLable];
    
    
    _signOutLabel = [ViewTool getLabelWith:CGRectMake(_nameLabel.x, _signInLable.maxY + 5, 100, [UIView getHeight:15]) WithTitle:nil WithFontSize:12.0f WithTitleColor:lightGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
    //    _signOutLabel.backgroundColor = [UIColor blueColor];
    _signOutLabel.text = @"已签退";
    [_userInfoView addSubview:_signOutLabel];
    
    //添加虚线
    UIView *line = [ViewTool getLineViewWith:CGRectMake(_imageView.x, _imageView.maxY + 5, KSCreenW - 4 * TopSpace, 0.8) withBackgroudColor:[UIColor colorWithWhite:0.7 alpha:0.8]];
    [_userInfoView addSubview:line];
    
    //添加 日期 时间
    
    UIImageView *dateImageView = [[UIImageView alloc] initWithFrame:CGRectMake( _imageView.x, line.maxY + 2 * TopSpace, 20, 20)];
    dateImageView.backgroundColor = [UIColor orangeColor];
    [_userInfoView addSubview:dateImageView];
    
    //
    NSMutableAttributedString * dateStr = [[NSMutableAttributedString alloc] initWithString:_dateString];
    [dateStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName : blackFontColor} range:NSMakeRange(0, _dateString.length)];
    [dateStr setAttributes:@{NSFontAttributeName : [UIView getFontWithSize:12.0f],NSForegroundColorAttributeName : lightGrayFontColor} range:NSMakeRange(4, _dateString.length - 4)];
    _dateLabel = [ViewTool getLabelWithFrame:CGRectMake(dateImageView.maxX + TopSpace, dateImageView.y, [UIView getWidth:110], dateImageView.height) WithAttrbuteString:dateStr];
//    _dateLabel.backgroundColor = [UIColor redColor];
    [_userInfoView addSubview:_dateLabel];
    
    
    UIImageView *timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake( self.view.width / 2.0 + TopSpace, dateImageView.y, 20, 20)];
    timeImageView.backgroundColor = [UIColor orangeColor];
    [_userInfoView addSubview:timeImageView];
    
    NSMutableAttributedString * timeStr = [[NSMutableAttributedString alloc] initWithString:_timeString];
    [timeStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName : blackFontColor} range:NSMakeRange(0, _timeString.length)];
    [timeStr setAttributes:@{NSFontAttributeName : [UIView getFontWithSize:12.0f],NSForegroundColorAttributeName : lightGrayFontColor} range:NSMakeRange(5, _timeString.length - 5)];
    _timeLabel = [ViewTool getLabelWithFrame:CGRectMake(timeImageView.maxX + TopSpace, timeImageView.y, [UIView getWidth:100], timeImageView.height)  WithAttrbuteString:timeStr];
    [_userInfoView addSubview:_timeLabel];
    
    UIView *line2 = [ViewTool getLineViewWith:CGRectMake(_imageView.x, _timeLabel.maxY + 2 * TopSpace, KSCreenW - 4 * TopSpace, 0.8) withBackgroudColor:[UIColor colorWithWhite:0.7 alpha:0.8]];
    [_userInfoView addSubview:line2];
    NSLog(@"%@",NSStringFromCGRect(line2.frame));
    _userInfoView.frame = CGRectMake(0, 64, KSCreenW, line2.maxY);
    
}

//绘制已拜访的记录视图
- (void)drawVisitedTableView
{
    _VisitedTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, _userInfoView.maxY, KSCreenW, [UIView getWidth:140]) style:UITableViewStylePlain];
    _VisitedTableview.delegate = self;
    _VisitedTableview.dataSource = self;
    _VisitedTableview.scrollEnabled = NO;
    _VisitedTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_VisitedTableview];
    
}

- (void)creatSignBtnView
{
    _signBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, _VisitedTableview.maxY, KSCreenW, KSCreenH - _VisitedTableview.maxY)];
    //    _signBtnView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_signBtnView];
    
    CGFloat btnW = [UIView getWidth:80];
    _signInBtn = [[UIButton alloc] initWithFrame:CGRectMake(_signBtnView.width / 2.0 - btnW - 3 * TopSpace, _signBtnView.height / 2.0 - btnW/2.0 - 2 * TopSpace, btnW, btnW)];
    _signInBtn.tag = 100;
    _signInBtn.layer.cornerRadius = btnW / 2.0;
    _signInBtn.layer.masksToBounds = YES;
    _signInBtn.backgroundColor = darkOrangeColor;
    [_signInBtn addTarget:self action:@selector(signInOrSignOut:) forControlEvents:UIControlEventTouchUpInside];
    [_signBtnView addSubview:_signInBtn];
    
    _signOutBtn = [[UIButton alloc] initWithFrame:CGRectMake(_signBtnView.width / 2.0  + 3 * TopSpace, _signBtnView.height / 2.0 - btnW/2.0 - 2 * TopSpace, btnW, btnW)];
    _signOutBtn.tag = 101;
    _signOutBtn.layer.cornerRadius = btnW / 2.0;
    _signOutBtn.layer.masksToBounds = YES;
    _signOutBtn.backgroundColor =  yellowBgColor;
    [_signBtnView addSubview:_signOutBtn];
}
#pragma mark --tableview的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VisitedCell *cell = [VisitedCell cellWithTableView:tableView];
    
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

#pragma mark --统计
- (void)statisticalSign
{
    
}

//签到 签退
- (void)signInOrSignOut:(UIButton *)sender
{
    if (sender.tag == 100) {
        PostSignInViewController *postSignVC = [[PostSignInViewController alloc] init];
        postSignVC.currentTime = [_timeString substringFromIndex:5];
        postSignVC.currentPlace = @"湖南路狮子桥美食街100000号烤的就是你";
        [self.navigationController pushViewController:postSignVC animated:YES];
    }
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
- (void)popLastView
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
