//
//  LeavingDetailController.m
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/4.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "LeavingDetailController.h"
#import "ApproSubVIew.h"


@interface LeavingDetailController ()
{
        UIScrollView    *_scrollView;
        
        CGFloat     topSpace;
    CGFloat labelW;
    CGFloat labelH;
        UIView    *_leavingView;//请假视图
        UIImageView     *_personLogo;
        UIImageView     *_waiteLoga;
        UILabel         *_nameLabel;
        UILabel         *_waiteLabel;
        UILabel         *_dateLabel;
        UILabel         *_timeLabel;
        
//        UIView          *_btnView;
//        UIButton        *_agreeBtn;
        UIButton        *_getLeavingBackBtn;
    
    NSDictionary   *_dataDict;
    NSMutableArray   *titleArray2;
    NSArray       *titleArray;
    
    ApproSubVIew * approView1;
    ApproSubVIew * approView2;
  
}
@end

@implementation LeavingDetailController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = lightGrayBackColor;
    self.navigationItem.leftBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithAction:@selector(popViewControll)];
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:[NSString stringWithFormat:@"%@的 请假",[[NSUserDefaults standardUserDefaults] objectForKey:@"name"]]];
    
    [self initScrollView];
    [self addLeavingView];
    [self getLeavingData];
//    [self addBtn];
    
}

- (void)getLeavingData
{
    NSDictionary *paramDict = [DataTool changeType:@{@"token" : TOKEN,@"uid" : @(UID),@"id" :@(self.leaveID)}];
    NSLog(@"参数%@",paramDict);
    [DataTool sendGetWithUrl:LEAVING_DETAIL_URL parameters:paramDict success:^(id data) {
        id backData = CRMJsonParserWithData(data);
        NSLog(@"backData %@",backData);
        
        _dataDict = [DataTool changeType:backData];
        //        NSLog(@"%@",_dataDict);
        titleArray2 = [NSMutableArray arrayWithArray:@[_dataDict[@"leave"][@"dealno"],_dataDict[@"department"],_dataDict[@"leave"][@"typename"],_dataDict[@"leave"][@"begintime"],_dataDict[@"leave"][@"endtime"],_dataDict[@"leave"][@"days"],_dataDict[@"leave"][@"reason"]]];
        
        [self useData];
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    

}
- (void)useData
{
    NSLog(@"开始时间%@",_dataDict[@"leave"][@"addtime"]);
    _dateLabel.text = [DateTool getYearmonthFromStr:_dataDict[@"leave"][@"addtime"]];
    NSString *timeStr = [[DateTool getDateFromStr:_dataDict[@"leave"][@"addtime"]] substringWithRange:NSMakeRange(0, 5)];
    _timeLabel.text = timeStr;
    int handleInt = [_dataDict[@"leave"][@"lstatus"] intValue];
    
    if (handleInt == 0) {//待审核
         _getLeavingBackBtn.hidden = NO;
        approView2.approvalState = 0;
        _waiteLabel.text = [NSString stringWithFormat:@"等待%@的审批",_dataDict[@"managername"]];
        _waiteLoga.hidden = NO;
        [self addCheXiaoBtn];
        approView2.handleLeavingLogo = _dataDict[@"managerlogo"];
        approView2.nameString = _dataDict[@"managername"];
        
        approView1.apptype = 0;//发起请假的人
        approView2.apptype = 1;//审批请假的人
    }else if (handleInt == 1){
        approView2.approvalState = 1;//通过审批
        _waiteLabel.text = [NSString stringWithFormat:@"已完成审批"];
        _waiteLoga.hidden = YES;
        approView2.handleLeavingLogo = _dataDict[@"managerlogo"];
        approView2.nameString = _dataDict[@"managername"];
        
        approView1.apptype = 0;//发起请假的人
        approView2.apptype = 1;//审批请假的人
    }else if(handleInt == 2){
//         _getLeavingBackBtn.hidden = YES;
        approView2.approvalState = 2;//未通过审批
        _waiteLabel.text = [NSString stringWithFormat:@"未通过审批"];
        _waiteLoga.hidden = YES;
        approView2.handleLeavingLogo = _dataDict[@"managerlogo"];
        approView2.nameString = _dataDict[@"managername"];
        
        approView1.apptype = 0;//发起请假的人
        approView2.apptype = 1;//审批请假的人
    }else if(handleInt == 3){
        _getLeavingBackBtn.hidden = YES;
        _waiteLabel.text = [NSString stringWithFormat:@"已撤销"];
        approView2.approvalState = 3;//已撤销
        approView2.nameString = [NSString stringWithFormat:@"我(%@)",[[NSUserDefaults standardUserDefaults] objectForKey:@"name"]];
        approView2.leavingPersonLogo = [[NSUserDefaults standardUserDefaults] objectForKey:@"logo"];
////        approView2.handleLeavingLogo = [[NSUserDefaults standardUserDefaults] objectForKey:@"logo"];
//        approView2.handleLeavingLogo = _dataDict[@"managerlogo"];
//        approView2.nameString = _dataDict[@"managername"];
    
        approView1.apptype = 0;//发起请假的人
        approView2.apptype = 1;//自己处理的请假
        _waiteLoga.hidden = YES;
    }
    
   
    
    for (int i = 0; i< titleArray2.count; i++) {
        
        //         NSLog(@"titleArray2 %@",titleArray2[i]);
        UILabel * label = [_leavingView viewWithTag:5566 + i];
        //给每个label 信息赋值  有一个请假天数不是字符串类型的 是int
        if ([titleArray2[i] isKindOfClass:[NSString class]]) {
            label.text = titleArray2[i];
        }else{
            label.text = [NSString stringWithFormat:@"%@",titleArray2[i]];
            //            label.backgroundColor = [UIColor redColor];
            //            NSLog(@"天数 ==%@",titleArray2[i]);
        }
        if (i == titleArray2.count -1) {
            label.numberOfLines = 0;
            //#warning 获得请假事由计算高度
            if (label.text != nil) {
                CGRect frame = label.frame;
                CGFloat h = [label.text boundingRectWithSize:CGSizeMake(label.width, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName : grayFontColor} context:nil].size.height;
                
                label.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, h);
            }
            _leavingView.frame = CGRectMake(0, 0, KSCreenW, label.maxY + topSpace);
        }
        
    }
    UIView *line1 = [ViewTool getLineViewWith:CGRectMake(0, _leavingView.maxY - 1, KSCreenW , 1) withBackgroudColor:lightGrayBackColor];
    [_leavingView addSubview:line1];
    
    approView1.frame = CGRectMake(3 * topSpace,_leavingView.maxY + 2 * topSpace, KSCreenW - 6 * topSpace, [UIView getWidth:60]);
    approView2.frame = CGRectMake(3 * topSpace, approView1.maxY + 2 * topSpace, KSCreenW - 6 * topSpace, [UIView getWidth:60]);
    
    UIView *linV = [ViewTool getLineViewWith:CGRectMake(approView2.x + approView1.approvalStateImage.width / 2.0f, _leavingView.maxY, 1, approView1.y - _leavingView.maxY) withBackgroudColor:grayLineColor];
    [_scrollView addSubview:linV];
    
    UIView *linV2 = [ViewTool getLineViewWith:CGRectMake(approView2.x + approView1.approvalStateImage.width / 2.0f, linV.maxY + approView1.approvalStateImage.height + 1, 1, approView2.y - linV.maxY - approView1.approvalStateImage.height) withBackgroudColor:grayLineColor];
    [_scrollView addSubview:linV2];
    
    if (approView2.maxY > KSCreenH - TabbarH -64) {
        _scrollView.contentSize = CGSizeMake(0, approView2.maxY + topSpace);
    }else{
        _scrollView.contentSize = CGSizeMake(0, 0);
    }
}
- (void)setLstatusType:(int)lstatusType
{
    _lstatusType = lstatusType;
    if (lstatusType != 0) {
        _waiteLoga.hidden = YES;
    }
}
//- (void)addinfo
//{
//    //请假类型要再处理一下
//    titleArray2 = [NSMutableArray arrayWithArray:@[_dataDict[@"dealno"],_dataDict[@"department"],_dataDict[@"type"],_dataDict[@"begintime"],_dataDict[@"endtime"],_dataDict[@"days"],_dataDict[@"reason"]]];
//    for (int i = 0; i< titleArray.count; i++) {
//        UILabel * label = [_leavingView viewWithTag:7788 + i];
//        label.text = titleArray2[i];
//        if (i == titleArray.count -1) {
//            label.numberOfLines = 0;
//#warning 获得请假事由计算高度
//    CGFloat h = [label.text boundingRectWithSize:CGSizeMake(label.width, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0f], NSForegroundColorAttributeName : grayFontColor} context:nil].size.height;
//     label.frame = CGRectMake(label.maxX + topSpace, topSpace + i * (labelH + 0.5 * topSpace), KSCreenW - label.maxX - 2 * topSpace, h);
//            _leavingView.frame = CGRectMake(0, 0, KSCreenW, label.maxY + topSpace);
//        }
//    }
//  
//
//    
//}
- (void)initScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, KSCreenH, KSCreenH - 64)];
    _scrollView.backgroundColor = lightGrayBackColor;
    [self.view addSubview:_scrollView];
    
}
- (void)addLeavingView
{
    
    if (IPhone4SInCell) {
        topSpace = 6.0f;
    }else{
        topSpace = [UIView getWidth:8.0f];
    }
    _leavingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCreenW, [UIView getWidth:300])];
    _leavingView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_leavingView];
    
    
    CGFloat logoW = [UIView getWidth:50];
    _personLogo = [[UIImageView alloc] initWithFrame:CGRectMake(2 * topSpace, topSpace, logoW, logoW)];
    [_personLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LoadImageUrl,[[NSUserDefaults standardUserDefaults] objectForKey:@"logo"]]] placeholderImage:nil];
    _personLogo.backgroundColor = blueFontColor;
    _personLogo.layer.cornerRadius = logoW / 2.0f;
    _personLogo.layer.masksToBounds = YES;
    [_leavingView addSubview:_personLogo];
    
    CGFloat waiteLogoW = [UIView getWidth:13.0f];
    _waiteLoga = [[UIImageView alloc] initWithFrame:CGRectMake(logoW , _personLogo.maxY - waiteLogoW, waiteLogoW , waiteLogoW)];
    //    _waiteLoga.backgroundColor = [UIColor redColor];
    _waiteLoga.image = [UIImage imageNamed:@"等待"];
    [ _leavingView addSubview:_waiteLoga];
    
    _nameLabel = [ViewTool getLabelWith:CGRectMake(_personLogo.maxX + 2 * topSpace, _personLogo.y, KSCreenW - _personLogo.maxX - 4 * topSpace, [UIView getHeight:20]) WithTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"name"] WithFontSize:16.0f WithTitleColor:blackFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_leavingView addSubview:_nameLabel];
    
    //这里 拿到请假发给的对象
    _waiteLabel = [ViewTool getLabelWith:CGRectMake(_nameLabel.x, _nameLabel.maxY + 1.5 * topSpace , [UIView getWidth:100], [UIView getHeight:15]) WithTitle:@"..." WithFontSize:14.0f WithTitleColor:grayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_leavingView addSubview:_waiteLabel];
    
    CGFloat dateW = [UIView getWidth:80];
    CGFloat dateX = KSCreenW - 2 * topSpace - dateW;
    _dateLabel = [ViewTool getLabelWith:CGRectMake(dateX , _nameLabel.maxY, dateW, [UIView getHeight:15]) WithTitle:@"..." WithFontSize:14.0f WithTitleColor:blueFontColor WithTextAlignment:NSTextAlignmentRight];
    //    _dateLabel.backgroundColor = [UIColor orangeColor];
    [_leavingView addSubview:_dateLabel];
    
    CGFloat timeW = [UIView getWidth:60];
    CGFloat timeX = KSCreenW - 2 * topSpace - timeW;
    _timeLabel = [ViewTool getLabelWith:CGRectMake(timeX, _waiteLabel.y,timeW, [UIView getHeight:15]) WithTitle:@"...." WithFontSize:14.0f WithTitleColor:blueFontColor WithTextAlignment:NSTextAlignmentRight];
    [_leavingView addSubview:_timeLabel];
    
    UIView *line = [ViewTool getLineViewWith:CGRectMake(2 * topSpace, _personLogo.maxY + topSpace , KSCreenW - 4 * topSpace, 1) withBackgroudColor:grayLineColor];
    [_leavingView addSubview:line];
    
   titleArray = @[@"审批编号",@"所在部门",@"请假类型",@"开始时间",@"结束时间",@"请假天数",@"请假事由"];
  
    for (int i = 0; i < titleArray.count ; i ++) {
        labelW = [UIView getWidth:60];
        labelH = [UIView getWidth:20.0];
        CGFloat contentLabelH = [UIView getWidth:20.0f];
        UILabel *label = [ViewTool getLabelWith:CGRectMake(line.x, line.maxY + topSpace + i * (labelH +  topSpace), labelW, labelH) WithTitle:titleArray[i] WithFontSize:14.0f WithTitleColor:grayFontColor WithTextAlignment:NSTextAlignmentLeft];
        [_leavingView addSubview:label];
        
        UILabel *contentLabel = [ViewTool getLabelWith:CGRectMake(label.maxX , label.y, KSCreenW - label.maxX - 2 * topSpace, contentLabelH) WithTitle:titleArray2[i] WithFontSize:14.0f WithTitleColor:blackFontColor WithTextAlignment:NSTextAlignmentLeft];
        contentLabel.tag = 5566 + i;
        //        contentLabel.backgroundColor = blueFontColor;
        [_leavingView addSubview:contentLabel];
        //最后一个请假事由可以根据字数来设定label的高度
        if (i == titleArray.count -1) {
            contentLabel.numberOfLines = 0;
//#warning 获得请假事由计算高度
            //            CGFloat h = [contentLabel.text boundingRectWithSize:CGSizeMake(contentLabel.width, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0f], NSForegroundColorAttributeName : grayFontColor} context:nil].size.height;
            //            contentLabel.frame = CGRectMake(label.maxX + topSpace, topSpace + i * (labelH + 0.5 * topSpace), KSCreenW - label.maxX - 2 * topSpace, h);
            _leavingView.frame = CGRectMake(0, 0, KSCreenW, contentLabel.maxY + topSpace);
        }
    }
    //    _leavingView.backgroundColor = [UIColor redColor];
//    UIView *line1 = [ViewTool getLineViewWith:CGRectMake(0, _leavingView.maxY - 1, KSCreenW , 1) withBackgroudColor:lightGrayBackColor];
//    [_leavingView addSubview:line1];
    
    [self addBottonView];
  
}
- (void)addBottonView
{
    
    approView1 = [[ApproSubVIew alloc] initWithFrame:CGRectMake(3 * topSpace,_leavingView.maxY + 2 * topSpace, KSCreenW - 6 * topSpace, [UIView getWidth:60])];
//        approView1.isHadApproval = NO;
   
    //
  
    
    approView2 = [[ApproSubVIew alloc] initWithFrame:CGRectMake(3 * topSpace, approView1.maxY + 2 * topSpace, KSCreenW - 6 * topSpace, [UIView getWidth:60])];
//        approView2.isHadApproval = NO;

    
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    NSLog(@"用户名字%@",username);
    approView1.nameString = [NSString stringWithFormat:@"我(%@)",username];
     approView1.leavingPersonLogo = [[NSUserDefaults standardUserDefaults] objectForKey:@"logo"];
//    NSLog(<#NSString * _Nonnull format, ...#>)
 
    //sdhfjsfksdfvgff
   


    
 
    
//    UIView *linV = [ViewTool getLineViewWith:CGRectMake(approView2.x + approView1.approvalStateImage.width / 2.0f, _leavingView.maxY, 0.5, approView2.y - _leavingView.maxY) withBackgroudColor:grayLineColor];
//    [_scrollView addSubview:linV];
    
    [_scrollView addSubview:approView1];
    [_scrollView addSubview:approView2];
    
    
    
    
 
}

#pragma mark --撤销
- (void)addCheXiaoBtn
{
    
    _scrollView.frame =  CGRectMake(0, 64, KSCreenH, KSCreenH - TabbarH- 64);
    _getLeavingBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, KSCreenH - TabbarH, KSCreenW, TabbarH)];
    [_getLeavingBackBtn setTitle:@"撤销" forState:UIControlStateNormal];
//    _getLeavingBackBtn.backgroundColor = [UIColor redColor];
    [_getLeavingBackBtn setTitleColor:darkOrangeColor forState:UIControlStateNormal];
    [_getLeavingBackBtn addTarget:self action:@selector(getBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_getLeavingBackBtn];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCreenW, 1)];
    line.backgroundColor =grayLineColor;
    [_getLeavingBackBtn addSubview:line];
}

- (void)getBack
{
    NSDictionary *dict = @{@"token" : TOKEN,@"uid" : @(UID),@"id" : @(self.leaveID),@"lstatus" :@(3)};
    [DataTool postWithUrl:HANDLE_LEAVING_URL parameters:dict success:^(id data) {
        id bacData = CRMJsonParserWithData(data);
        NSLog(@"%@",bacData);
        if ([bacData[@"code"] intValue]== 100) {
            [self.view makeToast:@"撤销成功"];
            [self getLeavingData];//撤销过后再重新请求下数据
            _getLeavingBackBtn.hidden = YES;
        }else{
            [self.view makeToast:@"撤销失败"];
        }
        
    } fail:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        
    }];
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

- (void)popViewControll
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
