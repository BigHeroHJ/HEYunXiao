//
//  RecordDetailController.m
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/8.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "RecordDetailController.h"

@interface RecordDetailController ()
{
    CGFloat    topSpace ;
    
    UIScrollView  * _scrollView;
    //类型
    UIView        *_typeView;
    UILabel       *_typeTitle;
    UILabel       *_typeLabel;
    
    //标题 小结 计划
    UIView        *_workSummaryView;
    UILabel       *_workTitleLabel;
    UILabel       *_workTitle;
    UILabel       *_workSumlabel;
    UILabel       *_workSum;
    UILabel       *_workPlaneLabel;
    UILabel       *_workPlan;
    CGFloat        lastY;//btn
    
    
    UIView       *_workRecordView;
    UILabel      *_recordLabel;
    UILabel      *_recordContentLabel;
//    UIButton     *_recordBtn;
    UIImageView  *_showRecordPic;
    
    
     NSDictionary  *_dataDict;
    UIView      *_bottomView;
    UILabel     *_titleLabel;
    UIImageView    *_addPersonsBtn;
    
}
@end

@implementation RecordDetailController
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IPhone4S) {
        topSpace = 5.0f;
    }else{
        topSpace = [UIView getWidth:10.0f];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithAction:@selector(popViewcontroll)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:@"日志详情"] ;
    [self creatScrollView];
    [self creatTypeView];
    [self creatWorkSummaryView];
    [self creatRecordView];
    [self drawBottomView];
    
    [self initData];
}
- (void)initData
{
    NSDictionary *dict = @{@"token" : TOKEN,@"uid" : @(UID),@"wid": @(self.recId)};
//        NSLog(@"%d",self.recId);
    [DataTool sendGetWithUrl:RECORD_DETAIL_URL parameters:dict success:^(id data) {
        id backData = CRMJsonParserWithData(data);
        NSLog(@"%@",backData);
        _dataDict = [DataTool changeType:backData[@"working"]];
        [self useData];
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)useData
{
    int type = [_dataDict[@"type"] intValue];
    if (type == 1) {
        _typeLabel.text = @"日报";
    }else if (type == 2){
        _typeLabel.text = @"周报";
    }else{
        _typeLabel.text = @"月报";
    }
    NSString * plan = _dataDict[@"plan"];
    _workPlan.text = plan;
    
    NSString * remark = _dataDict[@"remark"];
    _recordContentLabel.text = remark;
    
    NSString * topic = _dataDict[@"topic"];
    _workTitle.text = topic;
    
    NSString  * content = _dataDict[@"content"];
    _workSum.text = content;
    
    NSString *imagePath = [NSString stringWithFormat:@"%@%@",LoadImageUrl,_dataDict[@"img"]];
    NSLog(@"imagePath %@",imagePath);
    [_showRecordPic sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:nil];
    //管理员查看日志接收人 就是自己啊
    [_addPersonsBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LoadImageUrl,[[NSUserDefaults standardUserDefaults] objectForKey:@"logo"]]] placeholderImage:nil];
    
}

- (void)creatScrollView
{
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, KSCreenW, KSCreenH - 64 )];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleScrolltap:)];
//    [_scrollView addGestureRecognizer:tap];
    
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
    
    
    _typeTitle = [ViewTool getLabelWith:CGRectMake(2 * topSpace, topSpace, 100, 15) WithTitle:@"报表类型" WithFontSize:14.0f WithTitleColor:grayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_typeView addSubview:_typeTitle];

    CGFloat btnW = [UIView getWidth: 30];
    CGFloat btnH = [UIView getWidth:20];
    _typeLabel = [ViewTool getLabelWith:CGRectMake(_typeTitle.x, _typeTitle.maxY + topSpace, btnW, btnH) WithTitle:@".." WithFontSize:15.0f WithTitleColor:blackFontColor WithTextAlignment:NSTextAlignmentCenter];
    _typeLabel.layer.cornerRadius = 10.0f;
    _typeLabel.layer.masksToBounds = YES;
    _typeLabel.layer.borderColor = grayLineColor.CGColor;
    _typeLabel.layer.borderWidth = 1;
    [_typeView addSubview:_typeLabel];
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, _typeLabel.maxY + topSpace, KSCreenW, [UIView getWidth:15.0f])];
    grayView.backgroundColor = graySectionColor;
    [_typeView addSubview:grayView];
    
    _typeView.frame = CGRectMake(0, 0,KSCreenW, grayView.maxY);
    
}

- (void)creatWorkSummaryView
{
    _workSummaryView = [[UIView alloc] initWithFrame:CGRectMake(0, _typeView.maxY, KSCreenW, 200)];
    //    _workSummaryView.backgroundColor = [UIColor greenColor];
    [_scrollView addSubview:_workSummaryView];
    
    _workTitleLabel = [ViewTool getLabelWith:CGRectMake(2 * topSpace, topSpace, 100, 15) WithTitle:@"工作标题" WithFontSize:14.0f WithTitleColor:grayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_workSummaryView addSubview:_workTitleLabel];
    
    _workTitle = [[UILabel alloc] initWithFrame:CGRectMake(_workTitleLabel.x, _workTitleLabel.maxY + topSpace, KSCreenW - 4 * topSpace, 20)];
    _workTitle.textColor = blackFontColor;
    [_workSummaryView addSubview:_workTitleLabel];
    _workTitle.font = [UIView getFontWithSize:15.0f];
    _workTitle.text = @"....";
    [_workSummaryView addSubview:_workTitle];
    
    UIView *line1 = [ViewTool getLineViewWith:CGRectMake(_workTitleLabel.x, _workTitle.maxY + topSpace, KSCreenW - 4 * topSpace, 1) withBackgroudColor:grayLineColor];
    [_workSummaryView addSubview:line1];
    
    
    _workSumlabel = [ViewTool getLabelWith:CGRectMake(2 * topSpace, line1.maxY + topSpace, 100, 15) WithTitle:@"工作小结" WithFontSize:14.0f WithTitleColor:grayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_workSummaryView addSubview:_workSumlabel];
    
    _workSum = [[UILabel alloc] initWithFrame:CGRectMake(_workTitleLabel.x, _workSumlabel.maxY + topSpace, KSCreenW - 4 * topSpace, 20)];
    [_workSummaryView addSubview:_workSum];
    _workSum.font = [UIView getFontWithSize:15.0f];
    _workSum.text = @"....";
    
    UIView *line2 = [ViewTool getLineViewWith:CGRectMake(_workTitleLabel.x, _workSum.maxY + topSpace, KSCreenW - 4 * topSpace, 1) withBackgroudColor:grayLineColor];
    [_workSummaryView addSubview:line2];
    
    
    _workPlaneLabel = [ViewTool getLabelWith:CGRectMake(2 * topSpace, line2.maxY + topSpace, 100, 15) WithTitle:@"工作计划" WithFontSize:14.0f WithTitleColor:grayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_workSummaryView addSubview:_workPlaneLabel];
    
    _workPlan = [[UILabel alloc] initWithFrame:CGRectMake(_workTitleLabel.x, _workPlaneLabel.maxY + topSpace, KSCreenW - 4 * topSpace, 20)];
    
    [_workSummaryView addSubview:_workPlan];
    _workPlan.font = [UIView getFontWithSize:15.0f];
    _workPlan.text = @"....";
    
    
    UIView *grayView1 = [[UIView alloc] initWithFrame:CGRectMake(0, _workPlan.maxY + topSpace, KSCreenW, [UIView getWidth:15.0f])];
    grayView1.backgroundColor = graySectionColor;
    [_workSummaryView addSubview:grayView1];
    
    //    CGRect rect = [grayView1 convertRect:grayView1.frame toView:_scrollView];
    
    _workSummaryView.frame = CGRectMake(0, _typeView.maxY,KSCreenW, grayView1.maxY );
}


- (void)creatRecordView
{
    _workRecordView = [[UIView alloc] initWithFrame:CGRectMake(0, _workSummaryView.maxY, KSCreenW, [UIView getHeight:130])];
    //    _workRecordView.backgroundColor = [UIColor redColor];
    [_scrollView addSubview:_workRecordView];
    
    //    [UIColor colorWithRed:162 / 255 green:162 / 255 blue:162 / 255 alpha:1];
    _recordLabel = [ViewTool getLabelWith:CGRectMake(2 * topSpace,2 * topSpace, 200, 15) WithTitle:@"日志备注" WithFontSize:14.0 WithTitleColor:grayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_workRecordView addSubview:_recordLabel];
    
    _recordContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(2 * topSpace, _recordLabel.maxY + 2, KSCreenW - 4 * topSpace, [UIView getHeight:50])];
    
    //    _textView.layer.borderWidth = 0.5;
    //    _textView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.8].CGColor;
    _recordContentLabel.backgroundColor = [UIColor whiteColor];
    _recordContentLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    _recordContentLabel.numberOfLines = 0;
    _recordContentLabel.font = [UIView getFontWithSize:15.0f];
    [_workRecordView addSubview:_recordContentLabel];
    
    
//    _recordBtn = [[UIButton alloc] initWithFrame:CGRectMake(_textView.x, _textView.maxY + topSpace, [UIView getWidth:50], [UIView getWidth:50])];
//    [_recordBtn addTarget:self action:@selector(takePic:) forControlEvents:UIControlEventTouchUpInside];
//    [_recordBtn setImage:[UIImage imageNamed:@"相机star"] forState:UIControlStateNormal];
//    //    _takePictureBtn.backgroundColor = [UIColor orangeColor];
//    [_workRecordView addSubview:_recordBtn];
    
    _showRecordPic = [[UIImageView alloc] initWithFrame:CGRectMake(_recordContentLabel.x, _recordContentLabel.maxY + topSpace,  [UIView getWidth:50], [UIView getWidth:50])];
//    _showRecordPic.backgroundColor = [UIColor redColor];
    [_workRecordView addSubview:_showRecordPic];
    
    
    UIView * lighGrayView2 = [[UIView alloc] initWithFrame:CGRectMake(0, _showRecordPic.maxY + 2 * topSpace, KSCreenW, [UIView getHeight:20])];
    lighGrayView2.backgroundColor = graySectionColor;
    [_workRecordView addSubview:lighGrayView2];
    
    _workRecordView.frame = CGRectMake(0, _workSummaryView.maxY, KSCreenW, lighGrayView2.maxY);
    
}

- (void)drawBottomView
{
    //sdf
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _workRecordView.maxY, KSCreenW, [UIView getHeight:50])];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_bottomView];
    
    _titleLabel = [ViewTool getLabelWith:CGRectMake(2 * topSpace, topSpace, 200, 15.0f) WithTitle:@"日志接收人" WithFontSize:14.0 WithTitleColor:lightGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_bottomView addSubview:_titleLabel];
    
    _addPersonsBtn = [[UIImageView alloc] initWithFrame:[UIView getRectWithX:_titleLabel.x Y:_titleLabel.maxY width:[UIView getWidth:25] andHeight:[UIView getWidth:25]]];
//    [_addPersonsBtn setImage:[UIImage imageNamed:@"添加人员"] forState:UIControlStateNormal];
    _addPersonsBtn.layer.cornerRadius = _addPersonsBtn.width / 2.0;
    _addPersonsBtn.layer.masksToBounds = YES;
//    _addPersonsBtn.backgroundColor = [UIColor lightGrayColor];
//    [_addPersonsBtn addTarget:self action:@selector(addPerson2:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_addPersonsBtn];
    _bottomView.frame = CGRectMake(0, _workRecordView.maxY, KSCreenW, _addPersonsBtn.maxY +  topSpace);
//    NSLog(@"%f,%f",_bottomView.maxY + 64,KSCreenH - TabbarH);
    if (_bottomView.maxY + 64 > KSCreenH) {
        _scrollView.contentSize = CGSizeMake(0, _bottomView.maxY + 10);
    }else{
        _scrollView.contentSize = CGSizeMake(0, 0);
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
- (void)popViewcontroll
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
