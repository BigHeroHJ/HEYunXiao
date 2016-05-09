//
//  SginDetailViewController.m
//  Marketing
//
//  Created by Hanen 3G 01 on 16/4/7.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "SginDetailViewController.h"
#import "PictureViewController.h"

@interface SginDetailViewController ()
{
    //第一部分
    UIView     *_timePlaceView;
    UILabel    *_timeTitleLabel;
    UILabel    *_currentTimeLabel;
    UILabel    *_signPlaceLabel;
    UIButton   *_currentPlaceBtn;
    
    //中间部分
    UIView     *_recordView;
    UILabel    *_recordTitle;
    UITextView *_textView;
    UIButton   *_takePictureBtn;
    UIImageView *_showPicView;
    
    //下面部分
    UILabel    *_companyTitle;
    //    UILabel    *_companyNameLabel;
    UILabel  *_companyField;

    CGFloat   TopSpace;
    
}
@end

@implementation SginDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (IPhone4S) {
        TopSpace = 5.0f;
    }else{
        TopSpace =  [UIView getWidth:10.0f];
    }
   self.navigationItem.leftBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithAction:@selector(popLastView)];
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:self.name];
    
    [self creatSignInfoView];// 签到 时间和地点
    [self creatRecordView];//备注视图
    [self creatCompnyView];
    
    // Do any additional setup after loading the view.
}
- (void)popLastView
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)creatSignInfoView
{
    _timePlaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, KSCreenW, [UIView getHeight:100])];
    _timePlaceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_timePlaceView];
    NSString *title2 ;
    if (self.signType == 1) {
        title2 = @"签到时间";
    }else{
        title2 = @"签退时间";
    }
    _timeTitleLabel = [ViewTool getLabelWith:CGRectMake(TopSpace, TopSpace, 200, 15) WithTitle:title2 WithFontSize:14.0f WithTitleColor:grayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_timePlaceView addSubview:_timeTitleLabel];
    
    _currentTimeLabel = [ViewTool getLabelWith:CGRectMake(_timeTitleLabel.x, _timeTitleLabel.maxY + TopSpace, 200, 20) WithTitle:self.addTime WithFontSize:16.0f WithTitleColor:blackFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_timePlaceView addSubview:_currentTimeLabel];
    
    
    UIView *line = [ViewTool getLineViewWith:CGRectMake(_currentTimeLabel.x, _currentTimeLabel.maxY + TopSpace, KSCreenW - 2 * TopSpace, 0.8) withBackgroudColor:grayLineColor];
    [_timePlaceView addSubview:line];
    
    NSString *title1 ;
    if (self.signType == 1) {
        title1 = @"签到地点";
    }else{
        title1 = @"签退地点";
    }
    _signPlaceLabel = [ViewTool getLabelWith:CGRectMake(_currentTimeLabel.x, line.maxY + TopSpace, 200, 15) WithTitle:title1 WithFontSize:14.0f WithTitleColor:grayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_timePlaceView addSubview:_signPlaceLabel];
    
    UIImageView *imaged = [[UIImageView alloc] initWithFrame:CGRectMake(_signPlaceLabel.x, _signPlaceLabel.maxY + TopSpace, [UIView getWidth:15.0f], [UIView getWidth:15.0f])];
    imaged.image = [UIImage imageNamed:@"定位"];
    //    imaged.backgroundColor = [UIColor redColor];
    [_timePlaceView addSubview:imaged];
    
    
    //    CGFloat w = [self.currentPlace boundingRectWithSize:CGSizeMake(MAXFLOAT , 20) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIView getFontWithSize:15.0f]} context:nil].size.width;
    _currentPlaceBtn = [[UIButton alloc] initWithFrame:CGRectMake(imaged.maxX, _signPlaceLabel.maxY + TopSpace, KSCreenW - imaged.maxX, 20)];
    [_currentPlaceBtn setTitleColor:blackFontColor forState:UIControlStateNormal];
    //    _currentPlaceBtn.backgroundColor = [UIColor cyanColor];
    //    _currentPlaceBtn setImage:[UIImage ] forState:<#(UIControlState)#>
    _currentPlaceBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    //    _currentPlaceBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    _currentPlaceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _currentPlaceBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_currentPlaceBtn setTitle:self.currentPlace forState:UIControlStateNormal];
    [_currentPlaceBtn setTitleColor:blackFontColor forState:UIControlStateNormal];
    _currentPlaceBtn.titleLabel.font = [UIView getFontWithSize:16.0f];
//    [_currentPlaceBtn addTarget:self action:@selector(changePlace) forControlEvents:UIControlEventTouchUpInside];
    
    [_timePlaceView addSubview:_currentPlaceBtn];
    
    UIView * lighGrayView = [[UIView alloc] initWithFrame:CGRectMake(0, _currentPlaceBtn.maxY + TopSpace, KSCreenW, [UIView getHeight:20])];
    lighGrayView.backgroundColor = graySectionColor;
    [_timePlaceView addSubview:lighGrayView];
    _timePlaceView.frame = CGRectMake(0, 64, KSCreenW, lighGrayView.maxY);
    
}

- (void)creatRecordView
{
    _recordView = [[UIView alloc] initWithFrame:CGRectMake(0, _timePlaceView.maxY, KSCreenW, [UIView getHeight:130])];
    _recordView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_recordView];
    
    //    [UIColor colorWithRed:162 / 255 green:162 / 255 blue:162 / 255 alpha:1];
    NSString *title ;
    if (self.signType == 1) {
        title = @"签到备注";
    }else{
        title = @"签退备注";
    }
    _recordTitle = [ViewTool getLabelWith:CGRectMake( TopSpace, TopSpace, 200, 15) WithTitle:title WithFontSize:14.0 WithTitleColor:grayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_recordView addSubview:_recordTitle];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(2 * TopSpace, _recordTitle.maxY + 2, KSCreenW - 4 * TopSpace, [UIView getHeight:50])];
//    _textView.delegate = self;
    //    _textView.layer.borderWidth = 0.5;
    //    _textView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.8].CGColor;
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.textColor = blackFontColor;

    _textView.text = self.remarkSign;
    _textView.editable = NO;
    _textView.font = [UIView getFontWithSize:15.0f];
    [_recordView addSubview:_textView];
    
    
//    _takePictureBtn = [[UIButton alloc] initWithFrame:CGRectMake(_textView.x, _textView.maxY + TopSpace, [UIView getWidth:50], [UIView getWidth:50])];
//    [_takePictureBtn addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];
//    [_takePictureBtn setImage:[UIImage imageNamed:@"相机star"] forState:UIControlStateNormal];
    //    _takePictureBtn.backgroundColor = [UIColor orangeColor];
//    [_recordView addSubview:_takePictureBtn];
    
    _showPicView = [[UIImageView alloc] initWithFrame:CGRectMake(_textView.x, _textView.maxY + TopSpace, [UIView getWidth:50], [UIView getWidth:50])];
    [_recordView addSubview:_showPicView];
//    _showPicView.backgroundColor = cyanFontColor;
//    UITapGestureRecognizer *tapGues = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap23:)];
//    [_showPicView addGestureRecognizer:tapGues];
    [_showPicView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LoadImageUrl,self.signImage]] placeholderImage:nil];
   
    
    
    UIView * lighGrayView2 = [[UIView alloc] initWithFrame:CGRectMake(0, _showPicView.maxY + 2 * TopSpace, KSCreenW, [UIView getHeight:20])];
    lighGrayView2.backgroundColor = graySectionColor;
    [_recordView addSubview:lighGrayView2];
    _recordView.frame = CGRectMake(0, _timePlaceView.maxY, KSCreenW, lighGrayView2.maxY );
    
}
//- (void)handleTap23:(UIGestureRecognizer *)tap
//{
//    PictureViewController *picture = [[PictureViewController alloc] init];
//    picture.imageUrl = self.signImage;
//    [self.navigationController pushViewController:picture animated:YES];
//
//}
- (void)creatCompnyView
{
    _companyTitle = [ViewTool getLabelWith:CGRectMake( TopSpace, _recordView.maxY + 2 * TopSpace, 100, 15) WithTitle:@"公司" WithFontSize:14.0f WithTitleColor:grayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:_companyTitle];
    
    _companyField = [[UILabel alloc] initWithFrame:CGRectMake(_companyTitle.x, _companyTitle.maxY + TopSpace, KSCreenW - 4 * TopSpace, 20)];
//    _companyField.delegate = self;
    _companyField.text = self.company;
    _companyField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_companyField];
    
    UIView *line2 = [ViewTool getLineViewWith:CGRectMake(_companyTitle.x, _companyField.maxY + TopSpace, KSCreenW - 4 * TopSpace, 0.8) withBackgroudColor:grayLineColor];
    [self.view addSubview:line2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.hidesBottomBarWhenPushed = YES;
//    _postBtn.enabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = NO;
    
    //    NSString * docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    //    NSString * imagePath = [NSString stringWithFormat:@"%@/image.png",docPath];
    //    [fielManege removeItemAtPath:imagePath error:nil];
    
//    [[NSUserDefaults standardUserDefaults] setObject:@" " forKey:@"temImagePath"];
    
    
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
