//
//  NoticeDetailController.m
//  Marketing
//
//  Created by Hanen 3G 01 on 16/2/26.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//公告详情


#import "NoticeDetailController.h"

@interface NoticeDetailController ()
{
    CGFloat  TopSpace;
    
    UILabel      *_MainTitle;
    UILabel      *_groupLabel;
    UILabel      *_timeLabel;
    
    UIImageView  *_imageView;
    UILabel      *_detailNoticeLabel;
    
    NSDictionary      * _detailData;
    
    
    

    
}
@end

@implementation NoticeDetailController
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IPhone4S) {
        TopSpace = 5.0f;
    }else{
        TopSpace =  [UIView getWidth:10.0f];
    }
    self.view.backgroundColor = [UIColor whiteColor];
     self.navigationItem.leftBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithAction:@selector(popLastView)];
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:self.BigTitle] ;
    
    [self initData];
   
//    [self useData];
    
}
//请求数据
- (void)initData
{
    NSDictionary * dict = @{@"token": TOKEN,@"uid" : @(UID), @"id": self.noticeID};
//    NSLog(@"%@",dict);
    [DataTool sendGetWithUrl:NOTICE_DETAIL_URL parameters:dict success:^(id data) {
        id backData = CRMJsonParserWithData(data);
        _detailData = backData[@"notice"];
        NSLog(@"公告详情：_detaildata%@ backData%@",_detailData,backData);
        if (_detailData) {
            [self drawView];
        }
      
    } fail:^(NSError *error) {
        NSLog(@"error%@",error.localizedDescription);
    }];
}

- (void)drawView
{
   
    _MainTitle = [ViewTool getLabelWith:CGRectMake(2 * TopSpace, 64 + TopSpace, KSCreenW - 4 * TopSpace, 20) WithTitle:_detailData[@"title"] WithFontSize:16.0f WithTitleColor:blackFontColor WithTextAlignment:NSTextAlignmentLeft];

    [self.view addSubview:_MainTitle];
 
    CGFloat W;
    if (_detailData[@"authorname"]) {
       W  = [[NSString stringWithFormat:@"%@",_detailData[@"authorname"]] boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName :grayFontColor} context:nil].size.width;
    }
   
    _groupLabel = [ViewTool getLabelWith:CGRectMake(_MainTitle.x, _MainTitle.maxY + TopSpace, W, 15) WithTitle:_detailData[@"authorname"] WithFontSize:14.0f WithTitleColor:grayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:_groupLabel];
    
    
    _timeLabel = [ViewTool getLabelWith:CGRectMake(_groupLabel.maxX + TopSpace, _groupLabel.y, [UIView getWidth:120], 15) WithTitle:[DateTool getYearmonthFromStr:_detailData[@"addtime"]] WithFontSize:14.0f WithTitleColor:grayFontColor  WithTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:_timeLabel];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_MainTitle.x, _groupLabel.maxY + TopSpace, KSCreenW - 4 * TopSpace, [UIView getWidth:180])];
//    _imageView.backgroundColor = [UIColor purpleColor];
    NSString * urlstr =[NSString stringWithFormat:@"%@%@",LoadImageUrl,_detailData[@"img"]];
    NSLog(@"内容图片的地址%@",urlstr);
       NSLog(@"封面图片的地址%@",[NSString stringWithFormat:@"%@%@",LoadImageUrl,_detailData[@"logo"]]);
    [_imageView sd_setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:nil];
    [self.view addSubview:_imageView];
    
    
    //计算文字的高度 再去填写
    CGFloat H = [_detailData[@"content"] boundingRectWithSize:CGSizeMake(KSCreenW - 2 *TopSpace, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName :blackFontColor} context:nil].size.height;
    
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.firstLineHeadIndent = 30.0f;
//    paragraphStyle.headIndent = 8;
//    paragraphStyle.lineSparcing = 5;
//    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//    paragraphStyle.
//
//    NSDictionary *dict = @{NSParagraphStyleAttributeName : paragraphStyle,NSFontAttributeName : [UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName : blackFontColor};
    
//    NSAttributedString *mutableStr = [[NSAttributedString alloc] initWithString:_detailData[@"content"] attributes:dict];
    
//    _detailNoticeLabel = [ViewTool getLabelWithFrame:CGRectMake(_MainTitle.x, _imageView.maxY + 2 * TopSpace, _imageView.width, H) WithAttrbuteString:mutableStr];
    _detailNoticeLabel = [ViewTool getLabelWith:CGRectMake(_MainTitle.x, _imageView.maxY + 2 * TopSpace, _imageView.width, H) WithTitle:_detailData[@"content"] WithFontSize:14.0f WithTitleColor:blackFontColor WithTextAlignment:NSTextAlignmentLeft];
     _detailNoticeLabel.numberOfLines = 0;
    [self.view addSubview:_detailNoticeLabel];
    
    
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
