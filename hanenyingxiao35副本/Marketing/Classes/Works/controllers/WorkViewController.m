//
//  WorkViewController.m
//  移动营销
//
//  Created by Hanen 3G 01 on 16/2/23.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//工作主页面

#import "WorkViewController.h"
#import "NoticeViewController.h"
#import "DistributeNoticeController.h"
#import "SignViewController.h"
#import "DailyRecordController.h"
#import "ManagerCheckController.h"
#import "ApprovalController.h"
#import "myButton.h"
#import "LeavingController.h"
#import "StaffManagerViewController.h"
#import "CardScanViewController.h"
#import "MapClientViewController.h"
#import "ReportViewController.h"
#import "AttendanceVC.h"
#import "AttendContentVC.h"
#import "NewClientViewController.h"
#import "MoreController.h"

#define Space 15.0f

@interface WorkViewController ()<UIScrollViewDelegate>
{
    //页面承载
    UIScrollView  *_mainScrollView;
    
    UIImageView   *_topImageView;
    
    UIView      *_publicView;//公有的视图
    UIView      *_managerView;//管理者才有的视图
    
    BOOL  isManager;//是否为管理者
    
    NSArray     *_titleArr;
    NSArray     *_managerTitleArr;
    NSArray     *_ImageArray;
    NSArray     *_managerImageArray;
    
    CGFloat      _lastY;//记录上一个最低的y
    
}
@end

@implementation WorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    _titleArr = [NSArray arrayWithObjects:@"公告",@"签到签退",@"工作日志",@"请假",@"客户地图",@"名片扫描",@"更多",@"",nil];
    _managerTitleArr = [NSArray arrayWithObjects:@"发布公告",@"考勤统计",@"日志查看",@"审批",@"报表",@"人员管控",@"更多",@"", nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([TYPE isEqualToString:@"1"]) {
        isManager = 0;
    }else if ([TYPE isEqualToString:@"2"]){
        isManager = 1;
    }
    
    [self initScrollview];
    [self addTopImage];
    [self creatView];
}

-(void)viewDidAppear:(BOOL)animated
{
    //判断并接收返回的参数
    [super viewDidAppear:YES];
//    NSLog(@"12456789%@",_cardDictionary);
//    if(_cardDictionary != nil){
//        NSLog(@"12121212");
//        NewClientViewController *newClientViewController = [[NewClientViewController alloc] init];
//        newClientViewController.dictionary = _cardDictionary;
//        [self.navigationController pushViewController:newClientViewController animated:YES];
//    }
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    if(_cardDictionary != nil){
        NewClientViewController *newClientViewController = [[NewClientViewController alloc] init];
        newClientViewController.dictionary = _cardDictionary;
        [self.navigationController pushViewController:newClientViewController animated:YES];
        _cardDictionary = nil;
    }
}
- (void)initScrollview
{
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, KSCreenW, KSCreenH - 49)];
//    _mainScrollView.panGestureRecognizer.delaysTouchesBegan = YES;
//    _mainScrollView.userInteractionEnabled = NO;
    _mainScrollView.delegate = self;
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mainScrollView];
}

//顶上的图片
- (void)addTopImage
{
    //177
    _topImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, KSCreenW, [UIView getHeight:190])];
    _topImageView.image = [UIImage imageNamed:@"工作_01"];
    [_mainScrollView addSubview:_topImageView];
    
}
- (void)creatView
{
    [self creatPublicView];
    if(isManager){
        [self addManagerView];//添加管理者特有的视图
    }
}


- (void)creatPublicView
{
    
    CGFloat lineW = 0.8;
    //178
    CGFloat H;
    if (KSCreenW == 320) {
        H = 190;
    }else{
        H = [UIView getHeight:178];
    }
    _publicView = [[UIView alloc] initWithFrame:CGRectMake(0, _topImageView.maxY , KSCreenW, H)];
    _publicView.userInteractionEnabled = YES;
//    _publicView.exclusiveTouch = YES;
    _publicView.backgroundColor = graySectionColor;
    [_mainScrollView addSubview:_publicView];
    
    UIView *vie1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCreenW, SECTIONHEIGHT)];
    vie1.backgroundColor = graySectionColor;
    UIImageView * VI = [[UIImageView alloc] initWithFrame:CGRectMake(Space, 0.4 * Space, 5, vie1.height - 0.8 * Space)];
    VI.backgroundColor = purColor;
    
    UILabel * label= [[UILabel alloc] initWithFrame:CGRectMake(VI.maxX + 0.35 * Space, VI.y, 100, VI.height)];
    label.text = @"日常办公";
    label.textColor = blackFontColor;
    label.font = [UIFont systemFontOfSize:13.0f];
   
    [vie1 addSubview:VI];
    [vie1 addSubview:label];
    
    [_publicView addSubview:vie1];
    
    UILabel * lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, vie1.maxY, _publicView.width, lineW)];
    lineLabel.backgroundColor = [UIColor colorWithWhite:0.85 alpha:0.85];
    [_publicView addSubview:lineLabel];
//    UIButton  *btn = [[UIButton alloc] initWithFrame:CGRectMake(100,20, 50, 50)];
//    [btn addTarget:self action:@selector(handleBtn:) forControlEvents:UIControlEventTouchUpInside];
//    btn.backgroundColor = [UIColor redColor];
//    [_publicView addSubview:btn];
    
    for (int i = 0; i < _titleArr.count; i ++) {
        
        CGFloat row = i / 4;
        CGFloat col = i % 4;
        
        CGFloat btnWidth = (_publicView.width - lineW * 3) / 4;
        CGFloat btnHeight = (_publicView.height - lineW - lineLabel.maxY) / 2.0;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(col * (btnWidth + lineW), lineLabel.maxY  + row * (btnHeight + lineW), btnWidth, btnHeight)];
        btn.backgroundColor = [UIColor whiteColor];
        
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//        [btn addGestureRecognizer:tap];
//        [btn setTitle:_titleArr[i] forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont systemFontOfSize:11.0f];
//        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [btn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateNormal];
//        if (i != _titleArr.count - 1 || i != _titleArr.count - 2) {
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"1_%d",i]] forState:UIControlStateNormal];
        btn.tag = 200 + i;
//        }else if (i == _titleArr.count - 2){
//                    [btn setTitle:_titleArr[i] forState:UIControlStateNormal];
//                    btn.titleLabel.font = [UIFont systemFontOfSize:11.0f];
//                    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
//                    [btn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateNormal];
//        }
       
        [btn addTarget:self action:@selector(handleBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_publicView addSubview:btn];
        if (i == _titleArr.count - 1) {
            _lastY = btn.maxY;
        }
        
    }
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, _lastY, _publicView.width, lineW)];
    line2.backgroundColor  = [UIColor colorWithWhite:0.85 alpha:0.85];
    [_publicView addSubview:line2];
    
    
}

- (void)addManagerView
{
    
    CGFloat lineW = 0.8;
    CGFloat H;
    if (KSCreenW == 320) {
        H = 190;
    }else{
        H = [UIView getHeight:178];
    }
    _managerView = [[UIView alloc] initWithFrame:CGRectMake(0, _publicView.maxY , KSCreenW, H)];
    _managerView.userInteractionEnabled = YES;
    _managerView.backgroundColor = graySectionColor;
    [_mainScrollView addSubview:_managerView];
    
    UIView *vie1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCreenW, SECTIONHEIGHT)];
    UIImageView * VI = [[UIImageView alloc] initWithFrame:CGRectMake(Space, 0.4 * Space, 5, vie1.height - 0.8 * Space)];
    VI.backgroundColor = purColor;
    UILabel * label= [[UILabel alloc] initWithFrame:CGRectMake(VI.maxX + 0.5 * Space, VI.y, 100, VI.height)];
    label.text = @"工作管理";
    label.textColor = blackFontColor;
    label.font = [UIFont systemFontOfSize:13.0f];
    vie1.backgroundColor = graySectionColor;
    [vie1 addSubview:VI];
    [vie1 addSubview:label];
    
    [_managerView addSubview:vie1];
    
    UILabel * lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, vie1.maxY, _publicView.width, lineW)];
    lineLabel.backgroundColor = [UIColor colorWithWhite:0.85 alpha:0.85];
    [_managerView addSubview:lineLabel];
    
    
    for (int i = 0; i < _managerTitleArr.count; i ++) {
        
        CGFloat row = i / 4;
        CGFloat col = i % 4;
        
        CGFloat btnWidth = (_managerView.width - lineW * 3) / 4;
        CGFloat btnHeight = (_managerView.height - lineW - lineLabel.maxY) / 2.0;
        
        myButton *btn = [[myButton alloc] initWithFrame:CGRectMake(col * (btnWidth + lineW), lineLabel.maxY  + row * (btnHeight + lineW), btnWidth, btnHeight)];
        btn.backgroundColor = [UIColor whiteColor];
//        [btn setTitle:_managerTitleArr[i] forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont systemFontOfSize:11.0f];
//        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [btn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateNormal];
        
//        if (i != _managerTitleArr.count - 1 || i != _managerTitleArr.count - 2) {
//            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"2_%d",i]] forState:UIControlStateNormal];
        if (i == _titleArr.count - 2) {
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"1_%d",i]] forState:UIControlStateNormal];
        }else{
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"2_%d",i]] forState:UIControlStateNormal];
        }
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//        [btn addGestureRecognizer:tap];
        btn.tag = 300 + i;
//        }else if (i == _managerTitleArr.count - 2){
//            [btn setTitle:_managerTitleArr[i] forState:UIControlStateNormal];
//            btn.titleLabel.font = [UIFont systemFontOfSize:11.0f];
//            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
//            [btn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateNormal];
//        }
        [btn addTarget:self action:@selector(handleBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_managerView addSubview:btn];
        if (i == _managerTitleArr.count - 1) {
            _lastY = btn.maxY;
        }
        
    }
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, _lastY, _managerView.width, lineW)];
    line2.backgroundColor  = [UIColor colorWithWhite:0.85 alpha:0.85];
    [_managerView addSubview:line2];
    
    if (_managerView.maxY + 64 > KSCreenH - TabbarH) {
        _mainScrollView.contentSize = CGSizeMake(KSCreenW, _managerView.maxY + TabbarH);
    }else{
        _mainScrollView.contentSize = CGSizeMake(0, 0);
//        _mainScrollView.scrollEnabled = NO;
    }
}

//- (void)handleTap:(UITapGestureRecognizer *)tap
//{
//    NSInteger tag = tap.view.tag;
//    if (tag == 200) {
//        NoticeViewController *noticeControl = [[NoticeViewController alloc] init];
//        [self.navigationController pushViewController:noticeControl animated:YES];
//    }else if(tag == 201){
//        SignViewController *signVC = [[SignViewController alloc] init];
//        [self.navigationController pushViewController:signVC animated:YES];
//    }else if(tag == 202){
//        
//    }else if(tag == 203){
//        
//    }else if(tag == 204){
//        
//    }else if(tag == 205){
//        
//    }else if(tag == 206){
//        
//    }else if(tag == 300){
//        DistributeNoticeController * distributeVC = [[DistributeNoticeController alloc] init];
//        [self.navigationController pushViewController:distributeVC animated:YES];
//    }else if(tag == 301){
//        
//    }else if(tag == 302){
//        
//    }else if(tag == 303){
//        
//    }else if(tag == 304){
//        
//    }else if(tag == 305){
//        
//    }
//}
#pragma mark --处理按钮点击事件
- (void)handleBtn:(myButton *)btn
{
    NSInteger tag = btn.tag;
    if (tag == 200) {//公告
        NoticeViewController *noticeControl = [[NoticeViewController alloc] init];
        [self.navigationController pushViewController:noticeControl animated:YES];
    }else if(tag == 201){//签到
        SignViewController *signVC = [[SignViewController alloc] init];
        [self.navigationController pushViewController:signVC animated:YES];
    }else if(tag == 202){//日志
        DailyRecordController * dailVC = [[DailyRecordController alloc] init];
        [self.navigationController pushViewController:dailVC animated:YES];
        
    }else if(tag == 203){
        LeavingController *leavingVC = [[LeavingController alloc] init];
        [self.navigationController pushViewController:leavingVC animated:YES];
        
    }else if(tag == 204){
        MapClientViewController *mapVC = [[MapClientViewController alloc] init];
        [self.navigationController pushViewController:mapVC animated:YES];

    }else if(tag == 205){
        CardScanViewController *cardScanViewController = [[CardScanViewController alloc] init];
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
            
            self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            
        }
        [self.navigationController pushViewController:cardScanViewController animated:NO];
    }else if(tag == 206){
        MoreController *moreVC = [[MoreController alloc] init];
        [self.navigationController pushViewController:moreVC animated:YES];

    }else if(tag == 300){
        DistributeNoticeController * distributeVC = [[DistributeNoticeController alloc] init];
        [self.navigationController pushViewController:distributeVC animated:YES];
    }else if(tag == 301){
        AttendanceVC *vc = [[AttendanceVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(tag == 302){
        ManagerCheckController * manager = [[ManagerCheckController alloc] init];
        [self.navigationController pushViewController:manager animated:YES];
        
    }else if(tag == 303){
        ApprovalController *approVC = [[ApprovalController alloc] init];
        [self.navigationController pushViewController:approVC animated:YES];
        
    }else if(tag == 304){
        ReportViewController *reportVC = [[ReportViewController alloc] init];
        [self.navigationController pushViewController:reportVC animated:YES];
        
    }else if(tag == 305){
        StaffManagerViewController *staffManagerViewController = [[StaffManagerViewController alloc] init];
        [self.navigationController pushViewController:staffManagerViewController animated:YES];
        
    }if(tag == 306){
        MoreController *moreVC = [[MoreController alloc] init];
        [self.navigationController pushViewController:moreVC animated:YES];
    }

}
//- (void)jumpToOtherControllerWithBtn:(UIButton *)btn
//{
//    if([btn.currentTitle isEqualToString:@"公告"]){
//        
//        NoticeViewController *noticeControl = [[NoticeViewController alloc] init];
//        [self.navigationController pushViewController:noticeControl animated:YES];
//        
//        
//    }else if ([btn.currentTitle isEqualToString:@"签到签退"]){
//        SignViewController *signVC = [[SignViewController alloc] init];
//        [self.navigationController pushViewController:signVC animated:YES];
//        
//    }else if ([btn.currentTitle isEqualToString:@"工作日志"]){
//        
//    }else if ([btn.currentTitle isEqualToString:@"请假"]){
//        
//    }else if ([btn.currentTitle isEqualToString:@"客户地图"]){
//        
//    }else if ([btn.currentTitle isEqualToString:@"名片扫描"]){
//        
//    }else if ([btn.currentTitle isEqualToString:@"更多"]){
//        
//    }else if ([btn.currentTitle isEqualToString:@"发布公告"]){
//        DistributeNoticeController * distributeVC = [[DistributeNoticeController alloc] init];
//        [self.navigationController pushViewController:distributeVC animated:YES];
//    }else if ([btn.currentTitle isEqualToString:@"考勤统计"]){
//        
//    }else if([btn.currentTitle isEqualToString:@"日志查看"]){
//        
//    }else if([btn.currentTitle isEqualToString:@"审批"]){
//        
//    }else if([btn.currentTitle isEqualToString:@"报表"]){
//        
//    }else if([btn.currentTitle isEqualToString:@"人员管控"]){
//        
//    }else if([btn.currentTitle isEqualToString:@"更多"] && isManager){
//        
//    }
//}

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
