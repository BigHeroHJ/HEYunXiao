//
//  ApprovalDetailController.m
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/3.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//审批详情

#import "ApprovalDetailController.h"
#import "ApproSubVIew.h"
#import "myButton.h"

@interface ApprovalDetailController ()
{
    UIScrollView    *_scrollView;
    CGFloat labelW;
    CGFloat labelH;
    CGFloat     topSpace;
    UIView    *_leavingView;//请假视图
    UIImageView     *_personLogo;
    UIImageView     *_waiteLoga;
    UILabel         *_nameLabel;
    UILabel         *_waiteLabel;
    UILabel         *_dateLabel;
    UILabel         *_timeLabel;
    
    UIView          *_btnView;
    UIButton        *_agreeBtn;
    UIButton        *_rejectBtn;
    
    NSDictionary    *_dataDict;
    NSMutableArray * titleArray2;
    NSArray * titleArray;
    ApproSubVIew * approView1;
    ApproSubVIew * approView2;
    
}
@end

@implementation ApprovalDetailController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = lightGrayBackColor;
    titleArray2 = [NSMutableArray arrayWithCapacity:0];
    self.navigationItem.leftBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithAction:@selector(popViewControll)];
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:[NSString stringWithFormat:@"%@的请假",self.leavingPersonName]];
    
    [self initScrollView];
    [self addLeavingView];
    if (_lstatus == 0) {//未审批的时候 才添加button
        [self addBtn];
    }
    
    [self initData];
    
}
- (void)initData
{
  
    
    NSDictionary *paramDict = [DataTool changeType:@{@"token" : TOKEN,@"uid" : @(UID),@"id" :@(self.approID)}];
    NSLog(@"%@",paramDict);
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
    NSLog(@"开始时间%@",_dataDict[@"leave"][@"begintime"]);
    _dateLabel.text = [DateTool getYearmonthFromStr:_dataDict[@"leave"][@"addtime"]];
    _timeLabel.text = [DateTool getDateFromStr:_dataDict[@"leave"][@"addtime"]];
   
    approView2.handleLeavingLogo = [[NSUserDefaults standardUserDefaults] objectForKey:@"logo"];
//    approView2.nameString = [[NSUserDefaults standardUserDefaults] ]
    for (int i = 0; i< titleArray2.count; i++) {
        
//         NSLog(@"titleArray2 %@",titleArray2[i]);
        UILabel * label = [_leavingView viewWithTag:7788 + i];
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
    }

}
- (void)initScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, KSCreenH, KSCreenH - TabbarH - 64)];
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
    _personLogo.backgroundColor = blueFontColor;
    _personLogo.layer.cornerRadius = logoW / 2.0f;
    _personLogo.layer.masksToBounds = YES;
    [_personLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LoadImageUrl,self.leavingPersonLogo]] placeholderImage:nil];
    [_leavingView addSubview:_personLogo];
    
    CGFloat waiteLogoW = [UIView getWidth:13.0f];
    _waiteLoga = [[UIImageView alloc] initWithFrame:CGRectMake(logoW , _personLogo.maxY - waiteLogoW, waiteLogoW , waiteLogoW)];
    //    _waiteLoga.backgroundColor = [UIColor redColor];
    if (self.lstatus == 0) {
        _waiteLoga.image = [UIImage imageNamed:@"等待"];
    }else{
        _waiteLoga.image = [UIImage imageNamed:@"完成"];

    }
      [ _leavingView addSubview:_waiteLoga];
    
    _nameLabel = [ViewTool getLabelWith:CGRectMake(_personLogo.maxX + 2 * topSpace, _personLogo.y + topSpace / 2.0f, KSCreenW - _personLogo.maxX - 4 * topSpace, [UIView getHeight:20]) WithTitle:self.leavingPersonName WithFontSize:15.0f WithTitleColor:blackFontColor WithTextAlignment:NSTextAlignmentLeft];
    
    [_leavingView addSubview:_nameLabel];
    
    _waiteLabel = [ViewTool getLabelWith:CGRectMake(_nameLabel.x, _nameLabel.maxY + 1.5 * topSpace , [UIView getWidth:100], [UIView getHeight:15]) WithTitle:@" " WithFontSize:14.0f WithTitleColor:grayFontColor WithTextAlignment:NSTextAlignmentLeft];
    if (self.lstatus ) {
        _waiteLabel.text = @"已完成审批";
    }else{
        _waiteLabel.text = @"等待我的审批";
    }
    [_leavingView addSubview:_waiteLabel];
    
    CGFloat dateW = [UIView getWidth:80];
    CGFloat dateX = KSCreenW - 2 * topSpace - dateW;
    _dateLabel = [ViewTool getLabelWith:CGRectMake(dateX , _nameLabel.maxY, dateW, [UIView getHeight:15]) WithTitle:@"  " WithFontSize:14.0f WithTitleColor:blueFontColor WithTextAlignment:NSTextAlignmentRight];
    //    _dateLabel.backgroundColor = [UIColor orangeColor];
    [_leavingView addSubview:_dateLabel];
    
    CGFloat timeW = [UIView getWidth:60];
    CGFloat timeX = KSCreenW - 2 * topSpace - timeW;
    _timeLabel = [ViewTool getLabelWith:CGRectMake(timeX, _waiteLabel.y,timeW, [UIView getHeight:15]) WithTitle:@"  " WithFontSize:14.0f WithTitleColor:blueFontColor WithTextAlignment:NSTextAlignmentRight];
    [_leavingView addSubview:_timeLabel];
    
    UIView *line = [ViewTool getLineViewWith:CGRectMake(2 * topSpace, _personLogo.maxY + topSpace , KSCreenW - 4 * topSpace, 1) withBackgroudColor:grayLineColor];
    [_leavingView addSubview:line];
    
    titleArray = @[@"审批编号",@"所在部门",@"请假类型",@"开始时间",@"结束时间",@"请假天数",@"请假事由"];
//     NSArray * titleArray2 = @[@"7823478-1-3249",@"所在部门",@"请假类型",@"开始时间",@"结束时间",@"请假天数",@"请假事由"];
    for (int i = 0; i < titleArray.count ; i ++) {
       labelW = [UIView getWidth:60];
       labelH = [UIView getWidth:20.0];
//        CGFloat contentLabelH = [UIView getWidth:20.0f];
        UILabel *label = [ViewTool getLabelWith:CGRectMake(line.x, line.maxY + topSpace + i * (labelH +  topSpace), labelW, labelH) WithTitle:titleArray[i] WithFontSize:14.0f WithTitleColor:grayFontColor WithTextAlignment:NSTextAlignmentLeft];
        [_leavingView addSubview:label];
        
        UILabel *contentLabel = [ViewTool getLabelWith:CGRectMake(label.maxX , label.y, KSCreenW - label.maxX - 2 * topSpace, labelH) WithTitle:@"...." WithFontSize:14.0f WithTitleColor:blackFontColor WithTextAlignment:NSTextAlignmentLeft];
        contentLabel.tag = 7788 + i;
//        contentLabel.backgroundColor = blueFontColor;
        [_leavingView addSubview:contentLabel];
    
        //最后一个请假事由可以根据字数来设定label的高度
        if (i == titleArray.count -1) {
            contentLabel.numberOfLines = 0;
#warning 获得请假事由计算高度
//            CGFloat h = [contentLabel.text boundingRectWithSize:CGSizeMake(contentLabel.width, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0f], NSForegroundColorAttributeName : grayFontColor} context:nil].size.height;
//            contentLabel.frame = CGRectMake(label.maxX + topSpace, topSpace + i * (labelH + 0.5 * topSpace), KSCreenW - label.maxX - 2 * topSpace, h);
            _leavingView.frame = CGRectMake(0, 0, KSCreenW, contentLabel.maxY + topSpace);
        }
    }
//    _leavingView.backgroundColor = [UIColor redColor];
  
    
    
   
    
     approView1 = [[ApproSubVIew alloc] initWithFrame:CGRectMake(3 * topSpace,_leavingView.maxY + 2 * topSpace, KSCreenW - 6 * topSpace, [UIView getWidth:60])];
//    approView1.isHadApproval = NO;//这里就传前面的type类型对应的数字
  
    approView1.approvalState = self.lstatus; //0 待通过 1 通过
    approView1.nameString = @"  ";
    
   approView2 = [[ApproSubVIew alloc] initWithFrame:CGRectMake(3 * topSpace, approView1.maxY + 2 * topSpace, KSCreenW - 6 * topSpace, [UIView getWidth:60])];
//    approView2.isHadApproval = NO;
   
    //在给赋值的时候 是放在approView 的setType 方法里的 所有 设定typ之前要先有 状态的，头像的 值
    approView2.approvalState = self.lstatus;
    approView2.nameString = @"我";
    
    approView1.postApproName = self.leavingPersonName;
    approView1.leavingPersonLogo = self.leavingPersonLogo;
    approView1.nameString = self.leavingPersonName;
    
    approView2.handleLeavingLogo = [[NSUserDefaults standardUserDefaults] objectForKey:@"logo"];
      approView1.apptype = 0;
     approView2.apptype = 1;
//    UIView *linV = [ViewTool getLineViewWith:CGRectMake(approView2.x + approView1.approvalStateImage.width / 2.0f, _leavingView.maxY, 0.5, approView2.y - _leavingView.maxY) withBackgroudColor:grayLineColor];
//    [_scrollView addSubview:linV];
    
    [_scrollView addSubview:approView1];
    [_scrollView addSubview:approView2];
    
    
   
    
    if (approView2.maxY + 64 > KSCreenH - TabbarH) {
        _scrollView.contentSize = CGSizeMake(0, approView2.maxY + TabbarH);
    }else{
        _scrollView.contentSize = CGSizeMake(0, 0);
    }
    
}

- (void)addBtn
{
    _btnView = [[UIView alloc] initWithFrame:CGRectMake(0, KSCreenH - TabbarH, KSCreenW, TabbarH)];
    _btnView.backgroundColor = TabbarColor;
    [self.view addSubview:_btnView];
    
    UIView *linelineline = [ViewTool getLineViewWith:CGRectMake(0, 0, KSCreenW, 1) withBackgroudColor:grayLineColor];
    [_btnView addSubview:linelineline];
    
    
    _agreeBtn = [[myButton alloc] initWithFrame:CGRectMake(0, 0, KSCreenW / 2.0f, TabbarH)];
    [_agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    [_agreeBtn setTitleColor:darkOrangeColor forState:UIControlStateNormal];
    [_agreeBtn addTarget:self action:@selector(handleLeaving:) forControlEvents:UIControlEventTouchUpInside];
    [_agreeBtn setImage:[UIImage imageNamed:@"同意"] forState:UIControlStateNormal];
    
    _rejectBtn = [[myButton alloc] initWithFrame:CGRectMake(KSCreenW / 2.0f, 0, KSCreenW / 2.0f, TabbarH)];
    [_rejectBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    [_rejectBtn setTitleColor:yellowBgColor forState:UIControlStateNormal];
    [_rejectBtn addTarget:self action:@selector(handleLeaving:) forControlEvents:UIControlEventTouchUpInside];
    [_rejectBtn setImage:[UIImage imageNamed:@"拒绝"] forState:UIControlStateNormal];
    
    UIView *midLine = [ViewTool getLineViewWith:CGRectMake(_agreeBtn.width , TabbarH / 4.0, 1, TabbarH / 2.0) withBackgroudColor:grayLineColor];
    [_btnView addSubview:midLine];
    
    [_btnView addSubview:_agreeBtn];
    [_btnView addSubview:_rejectBtn];
    
}

- (void)handleLeaving:(UIButton *)btn
{
    NSDictionary *dict;
    if ([btn.currentTitle isEqualToString:@"同意"]) {
        dict = [DataTool changeType:@{@"token" : TOKEN,@"uid" : @(UID),@"id": @(self.approID),@"lstatus": @(1)}];
    }else{
        dict = [DataTool changeType:@{@"token" : TOKEN,@"uid" : @(UID),@"id": @(self.approID),@"lstatus": @(2)}];
    }
    [self.view makeToastActivity];
    [DataTool postWithUrl:HANDLE_LEAVING_URL parameters:dict success:^(id data) {
        NSLog(@"%@",CRMJsonParserWithData(data));
        id backData = CRMJsonParserWithData(data);
        
        if([backData[@"code"] intValue] == 100){
             [self.view hideToastActivity];
            [self.view makeToast:@"处理成功"];
        }else{
             [self.view hideToastActivity];
            [self.view makeToast:@"处理失败"];
        }
       
    } fail:^(NSError *error) {
        NSLog(@"error%@",error);
         [self.view hideToastActivity];
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    [self initData];
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
