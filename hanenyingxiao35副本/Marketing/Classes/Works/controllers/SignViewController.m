//
//  SignViewController.m
//  移动营销
//
//  Created by Hanen 3G 01 on 16/2/24.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//签到 签退 页面

#import "SignViewController.h"
#import "PostSignInViewController.h"
#import "Person StatisticsController.h"
#import "SignModel.h"
#import "VisitedCell.h"
#import "SubSignModel.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "ChangePlaceMap.h"
@interface SignViewController ()<UITableViewDataSource,UITableViewDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,ChangePlaceMapDelegate>
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
    
      //定位信息
    UIView      *_PlaceView;
    BMKMapView *_placeImage;
    UILabel     *_placeNameLabel;
    UILabel     *_placeLocalLabel;
    UIButton    *_changePlaceBtn;
    BMKLocationService *_locationSevice;
  
    BMKGeoCodeSearch *geoSearch;
    NSString *cityStr;

    
    UIButton    *_signInBtn;
    UIButton    *_signOutBtn;
    UIView      *_signBtnView;
    
    //今天的日期信息
    NSString    *_dateString;
    NSString    *_timeString;
    NSString    *_weekDayString;
    
    NSTimer     *_timer;
    
    
     UITableView  *_VisitedTableview;
    NSMutableArray *_dataArray;
    
    CLLocationCoordinate2D currentCoordinate;
    
}

@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    
    
    if (IPhone4S) {
        TopSpace = 9.0f;
    }else{
        TopSpace =[UIView getWidth: 9.0f];
    }
    [self getCrrentDate];
   
    [self creatInfoView];//加上个人签到签退 时间日期视图
//     [self getSignInfo];//获得签到签退的情况
//    
//    
//     [self choseViewShow];//选择视图的显示 隐藏
    
   
//      [self creatSignBtnView];//签到 签退按钮
    _locationSevice = [[BMKLocationService alloc] init];
   
    
    [_locationSevice startUserLocationService];
    geoSearch = [[BMKGeoCodeSearch alloc] init];
  
//    NSLog(@"开启定位");
    
    self.navigationItem.leftBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithAction:@selector(popLastView)];
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
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(freshTime) userInfo:nil repeats:YES];
}

//获取数据
- (void)getSignInfo
{
//    int userID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue];
//   
//    NSString *backToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
//    
//    NSLog(@"%d, %@",userID,backToken);
  
    NSDictionary *dict = @{@"uid" : @(UID), @"token" :  TOKEN};
    [DataTool sendGetWithUrl:SIGN_IN_OUT_DETAIL_URL parameters:dict success:^(id data) {
        NSDictionary * backData = CRMJsonParserWithData(data);
        NSLog(@"%@",backData);
        model = [[SignModel alloc] init];
        [model setValuesForKeysWithDictionary:backData];
//        (NSMutableArray *)model.list;
//        NSLog(@"请求数据中国打印%d",model.checkinCount);
        for (int i =0 ; i< model.list.count; i ++) {
            SubSignModel * subModel = [[SubSignModel alloc] init];
//            [subModel setValuesForKeysWithDictionary:model.list[i]];
//            [subModel setValue:model.list[i][@"addtime"] forKey:@"addtime"];
//            [subModel setValue:model.list[i][@"remark"] forKey:@"remark"];
//            [subModel setValue:model.list[i][@"company"] forKey:@"company"];
//            [subModel setValue:model.list[i][@"address"] forKey:@"address"];
//            [subModel setValue:model.list[i][@"img"] forKey:@"img"];
//            [subModel setValue:model.list[i][@"type"] forKey:@"type"];
            [subModel setValuesForKeysWithDictionary:model.list[i]];
//                if ((i + 1) % 2 == 0) {//奇数位
//                    [subModel setValue:@(1) forKey:@"signState"];//已签退
//                }else{
//                    [subModel setValue:@(0) forKey:@"signState"];//已签到
//                }
            [_dataArray addObject:subModel];
            
        }
       
//        NSLog(@"dataArray.count %ld",_dataArray.count);
       
        [self useData];
      
        
    } fail:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
}

- (void)useData
{
//    [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LoadImageUrl,model.logo]] placeholderImage:nil];
    int checkInCount = (int )model.checkinCount;
    int checkOutCount = (int)model.checkoutCount;
    NSLog(@"%d,%d",checkInCount,checkOutCount);
    if (checkInCount != 0 ) {
        self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"name"]]];
         NSString * coungStr = [NSString stringWithFormat:@"%d",checkInCount];
        NSMutableAttributedString *checkInAttributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"今日已成功签到%d次",checkInCount]];
        [checkInAttributeStr setAttributes:@{NSFontAttributeName : [UIView getFontWithSize:14],NSForegroundColorAttributeName : darkOrangeColor} range:NSMakeRange(checkInAttributeStr.length - coungStr.length - 1 , coungStr.length)];
        _signInLable.attributedText = checkInAttributeStr;
        
    }else{
         self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:@"签到签退"];
        _signInLable.text = @"今日还未签到";
    }
    if (checkOutCount != 0 ) {
        NSString * countStr = [NSString stringWithFormat:@"%d",checkOutCount];
        NSMutableAttributedString *checkOutAttributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"今日已成功签退%d次",checkOutCount]];
        [checkOutAttributeStr setAttributes:@{NSFontAttributeName : [UIView getFontWithSize:14],NSForegroundColorAttributeName : darkOrangeColor} range:NSMakeRange(checkOutAttributeStr.length -countStr.length - 1, countStr.length)];
        _signOutLabel.attributedText = checkOutAttributeStr;
    }else{
        _signOutLabel.text = @"今日还未签退";
    }
    if(!_PlaceView){
        [self creatPlaceInfoView];
    }
    if (!_VisitedTableview) {
        [self drawVisitedTableView];
    }{
      [_VisitedTableview reloadData];
    }
    //加上地理位置视图
//    [self drawVisitedTableView];//拜访的一些信息
    
   
    
    
//#warning 注意这里只是看下地图地址可用不
    if (model.checkinCount != 0 || model.checkoutCount != 0) {//签到次数是0的话
        _PlaceView.hidden = YES;
        _VisitedTableview.hidden = NO;
    }else{
        _VisitedTableview.hidden = YES;
        _PlaceView.hidden = NO;
    }
      CGFloat maxY;
    if (_signBtnView) {
        //        [_signBtnView removeFromSuperview];
        if (_PlaceView.hidden == NO ) {
            maxY = _PlaceView.maxY;
//            _PlaceView.backgroundColor = blueFontColor;
        }else if(_VisitedTableview.hidden == NO){
            maxY = _VisitedTableview.maxY;
        }
        
         NSLog(@"第二次 frame%f",_signBtnView.frame.origin.y);
        //KSCreenH - [UIView getHeight:200]
        _signBtnView .frame = CGRectMake(0, maxY + 2 * TopSpace, KSCreenW, [UIView getHeight:150]);
        
    }else{
         [self  creatSignBtnView];
    }
    //判断可用不可用
    if(checkInCount == 0){
        _signInBtn.enabled = YES;
        _signOutBtn.enabled = NO;
    }else{
        if(model.isCheckout == 0){
            _signInBtn.enabled = NO;
            _signOutBtn.enabled = YES;
        }else{
            _signInBtn.enabled = YES;
            _signOutBtn.enabled = NO;
        }
    }
   
    //else{
//    _signOutBtn.enabled = NO;
//    _signInBtn.enabled = YES;
//}
}

//用户位置更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    if(_placeImage.hidden == NO){
        _placeImage.centerCoordinate = coordinate;
        _placeImage.scrollEnabled = NO;
    }
    [_placeImage updateLocationData:userLocation];
    currentCoordinate = userLocation.location.coordinate;
    [self poiToDeGeoCodeWith:coordinate];
}
//将anntation 的经纬度进行 反地理编码
- (void)poiToDeGeoCodeWith:(CLLocationCoordinate2D )coordinate
{
    //    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0,0};
    //    pt = coordinate;
//    NSLog(@"===%f,  %f",coordinate.latitude,coordinate.longitude);
    BMKReverseGeoCodeOption *reverOption = [[BMKReverseGeoCodeOption alloc] init];
    reverOption.reverseGeoPoint = coordinate;
    BOOL flag = [geoSearch reverseGeoCode:reverOption];
    if (flag) {
        NSLog(@"反geo检索发送成功");
    }else{
        NSLog(@"反geo检索发送失败");
        
    }
}
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
        NSLog(@"用户位置：%@", result.address);
    if (IOS7 == NO) {
        if ([result.address containsString:@"省"]) {
            NSRange rang = [result.address rangeOfString:@"省"];
            cityStr = [result.address substringFromIndex:rang.location + 1];
        }else{
            cityStr = result.address;
        }
    }else{
        NSRange range = [result.address rangeOfString:@"省"];
        if (range.length > 0) {
            cityStr = [result.address substringFromIndex:range.location + 1];
        }else{
            cityStr = result.address;
        }
    }
    
    _placeLocalLabel.text = cityStr;//给地址信息赋值
}
#pragma mark --点击地理位置的代理方法
- (void)changPlaceWith:(NSString *)placeName
{
    _placeNameLabel.text = [NSString stringWithFormat:@"%@%@",_placeLocalLabel.text,placeName];
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
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LoadImageUrl,[[NSUserDefaults standardUserDefaults] objectForKey:@"logo"]]] placeholderImage:nil];
    _imageView.layer.cornerRadius = imageW / 2.0;
    _imageView.layer.masksToBounds = YES;
    [_userInfoView addSubview:_imageView];
    
    //名字根据用户登录来获取
    [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    
    _nameLabel = [ViewTool getLabelWith:CGRectMake(_imageView.maxX + 2 * TopSpace, TopSpace - 2.0f, 100, [UIView getHeight:20]) WithTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"name"] WithFontSize:18.0 WithTitleColor:blackFontColor WithTextAlignment:NSTextAlignmentLeft];
//    _nameLabel.backgroundColor = [UIColor redColor];
    [_userInfoView addSubview:_nameLabel];
    
    //根据签到签退的情况来 改变label文字的状态
    
    
    _signInLable = [ViewTool getLabelWith:CGRectMake(_nameLabel.x, _nameLabel.maxY + 5, 200, [UIView getHeight:15]) WithTitle:nil WithFontSize:14.0f WithTitleColor:lightGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
//    _signInLable.backgroundColor = [UIColor orangeColor];
    
    [_userInfoView addSubview:_signInLable];
    
    
    _signOutLabel = [ViewTool getLabelWith:CGRectMake(_nameLabel.x, _signInLable.maxY + 5, 200, [UIView getHeight:15.0f]) WithTitle:nil WithFontSize:14.0f WithTitleColor:lightGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_userInfoView addSubview:_signOutLabel];
    
    //添加虚线
    UIView *line = [ViewTool getLineViewWith:CGRectMake(_imageView.x, _imageView.maxY + TopSpace, KSCreenW - 2 * TopSpace, 0.8) withBackgroudColor:grayLineColor];
    [_userInfoView addSubview:line];
    
    //添加 日期 时间
    
    UIImageView *dateImageView = [[UIImageView alloc] initWithFrame:CGRectMake( _imageView.x, line.maxY + 2 * TopSpace, 20, 20)];
    dateImageView.image = [UIImage imageNamed:@"时间"];
//    dateImageView.backgroundColor = [UIColor orangeColor];
    [_userInfoView addSubview:dateImageView];
    
//
    NSMutableAttributedString * dateStr = [[NSMutableAttributedString alloc] initWithString:_dateString];
    [dateStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName : blackFontColor} range:NSMakeRange(0, _dateString.length)];
    [dateStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName : lightGrayFontColor} range:NSMakeRange(4, _dateString.length - 4)];
    _dateLabel = [ViewTool getLabelWithFrame:CGRectMake(dateImageView.maxX + TopSpace, dateImageView.y, [UIView getWidth:130], dateImageView.height) WithAttrbuteString:dateStr];
//    _dateLabel.backgroundColor = [UIColor redColor];
    [_userInfoView addSubview:_dateLabel];
    
    
    UIImageView *timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake( self.view.width / 2.0 + TopSpace, dateImageView.y, 20, 20)];
timeImageView.image = [UIImage imageNamed:@"当前时间"];
    [_userInfoView addSubview:timeImageView];
    
     NSMutableAttributedString * timeStr = [[NSMutableAttributedString alloc] initWithString:_timeString];
    [timeStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName : blackFontColor} range:NSMakeRange(0, _timeString.length)];
    [timeStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName : lightGrayFontColor } range:NSMakeRange(5, _timeString.length - 5)];
    _timeLabel = [ViewTool getLabelWithFrame:CGRectMake(timeImageView.maxX + TopSpace, timeImageView.y, [UIView getWidth:100], timeImageView.height)  WithAttrbuteString:timeStr];
    [_userInfoView addSubview:_timeLabel];
    
    UIView *line2 = [ViewTool getLineViewWith:CGRectMake(_imageView.x, _timeLabel.maxY + 2 * TopSpace, KSCreenW - 2 * TopSpace, 0.8) withBackgroudColor:grayLineColor];
    [_userInfoView addSubview:line2];
//    NSLog(@"%@",NSStringFromCGRect(line2.frame));
    _userInfoView.frame = CGRectMake(0, 64, KSCreenW, line2.maxY);
 
    
    
}
//地理位置拜访信息
//根据数据返回 看看是否有签到的情况 再选择隐藏 地址视图 还是拜访tableview
- (void)creatPlaceInfoView
{
    _PlaceView = [[UIView alloc] initWithFrame:CGRectMake(0, _userInfoView.maxY +1 , KSCreenW, [UIView getWidth:80])];
//    _PlaceView.backgroundColor = [UIColor redColor];
//    NSLog(@"地址中打印%d",model.checkinCount);
    
    [self.view addSubview:_PlaceView];
    
    _placeImage = [[BMKMapView alloc] initWithFrame:CGRectMake(2 * TopSpace , TopSpace, _PlaceView.height - TopSpace / 2.0f, _PlaceView.height - 2 * TopSpace)];
//    _placeImage.delegate = self;
    _placeImage.zoomLevel = 15.0f;
    _placeImage.scrollEnabled = NO;
    _placeImage.userInteractionEnabled = NO;
    [_placeImage setMapType:BMKMapTypeStandard];
    _placeImage.layer.borderColor = [UIColor whiteColor].CGColor;
//    _placeImage.backgroundColor = [UIColor orangeColor];
    [_PlaceView addSubview:_placeImage];
    
    _placeNameLabel = [ViewTool getLabelWith:CGRectMake(_placeImage.maxX + TopSpace, _placeImage.y, KSCreenW - _placeImage.maxX - 2 * TopSpace, 20) WithTitle:@" " WithFontSize:18.0f WithTitleColor:blackFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_PlaceView addSubview:_placeNameLabel];
    
    _placeLocalLabel = [ViewTool getLabelWith:CGRectMake(_placeImage.maxX + TopSpace, _placeNameLabel.maxY + TopSpace - 2, KSCreenW - _placeImage.maxX - 2 * TopSpace, 15) WithTitle:@"" WithFontSize:14.0 WithTitleColor:grayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_PlaceView addSubview:_placeLocalLabel];
    
    
    
    _changePlaceBtn = [[UIButton alloc] initWithFrame:CGRectMake(_placeLocalLabel.x , _placeLocalLabel.maxY + TopSpace - 2, [UIView getWidth:120], 15)];
    [_changePlaceBtn setTitle:@"地点不准？点我微调" forState:UIControlStateNormal];
//    _changePlaceBtn.backgroundColor = [UIColor redColor];
    _changePlaceBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_changePlaceBtn setTitleColor:blueFontColor forState:UIControlStateNormal];
    _changePlaceBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
//    [_changePlaceBtn setImage:[UIImage imageNamed:@"定位"] forState:UIControlStateNormal];
    [_changePlaceBtn addTarget:self action:@selector(changePlace:) forControlEvents:UIControlEventTouchUpInside];
    [_PlaceView addSubview:_changePlaceBtn];
    
    UIView *line2 = [ViewTool getLineViewWith:CGRectMake(_placeImage.x, _placeImage.maxY +  TopSpace, KSCreenW - 4 * TopSpace, 1) withBackgroudColor:grayLineColor];
    [_PlaceView addSubview:line2];
    _PlaceView.frame = CGRectMake(0, _userInfoView.maxY, KSCreenW, line2.maxY);
}
//绘制已拜访的记录视图
- (void)drawVisitedTableView
{
    _VisitedTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, _userInfoView.maxY + 1, KSCreenW, [UIView getWidth:140]) style:UITableViewStylePlain];
    _VisitedTableview.delegate = self;
    _VisitedTableview.dataSource = self;
//    _VisitedTableview.scrollEnabled = NO;
    _VisitedTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_VisitedTableview];
}


- (void)creatSignBtnView
{
    CGFloat maxY;
    if (_PlaceView.hidden == NO ) {
        maxY = _PlaceView.maxY;
    }else if(_VisitedTableview.hidden == NO){
        maxY = _VisitedTableview.maxY;
    }
    //KSCreenH - [UIView getHeight:200]
    _signBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, maxY + 2 * TopSpace, KSCreenW, [UIView getHeight:150])];
//    NSLog(@"第一次创建 frame%f",_signBtnView.frame.origin.y);
//    _signBtnView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_signBtnView];
    
//    UIView *lin = [ViewTool getLineViewWith:CGRectMake( 0, 0, KSCreenW - 2 * TopSpace, 1) withBackgroudColor:grayLineColor];
//    [_signBtnView addSubview:lin];
    
    
    CGFloat btnW = [UIView getWidth:80];
    _signInBtn = [[UIButton alloc] initWithFrame:CGRectMake(_signBtnView.width / 2.0 - btnW - 3 * TopSpace, _signBtnView.height / 2.0 - btnW/2.0 - 2 * TopSpace, btnW, btnW)];
    _signInBtn.tag = 100;
    _signInBtn.layer.cornerRadius = btnW / 2.0;
    _signInBtn.layer.masksToBounds = YES;
//    _signInBtn.backgroundColor = darkOrangeColor;
    [_signInBtn setBackgroundImage:[UIImage imageNamed:@"签到"] forState:UIControlStateNormal];
    [_signInBtn addTarget:self action:@selector(signInOrSignOut:) forControlEvents:UIControlEventTouchUpInside];
    [_signBtnView addSubview:_signInBtn];
    
    _signOutBtn = [[UIButton alloc] initWithFrame:CGRectMake(_signBtnView.width / 2.0  + 3 * TopSpace, _signBtnView.height / 2.0 - btnW/2.0 - 2 * TopSpace, btnW, btnW)];
    _signOutBtn.tag = 101;
     [_signOutBtn addTarget:self action:@selector(signInOrSignOut:) forControlEvents:UIControlEventTouchUpInside];
    _signOutBtn.layer.cornerRadius = btnW / 2.0;
    _signOutBtn.layer.masksToBounds = YES;
    [_signOutBtn setBackgroundImage:[UIImage imageNamed:@"签退"] forState:UIControlStateNormal];
//    _signOutBtn.backgroundColor =  yellowBgColor;
    [_signBtnView addSubview:_signOutBtn];
}
- (void)choseViewShow
{
  
    if (model.checkinCount == 0 || model.checkoutCount == 0){//
        _VisitedTableview.hidden = NO;
        _PlaceView.hidden = YES;
    }else{
        _VisitedTableview.hidden = NO;
        _PlaceView.hidden = YES;
    }
    if(_VisitedTableview.hidden == NO){
        _signBtnView.frame = CGRectMake(0, _VisitedTableview.maxY + 2 * TopSpace, KSCreenW, [UIView getHeight:150]);
    }
    
    if (_PlaceView.hidden == NO) {
        _signBtnView.frame = CGRectMake(0, _PlaceView.maxY + 2 * TopSpace, KSCreenW, [UIView getHeight:150]);
    }
}

//签到 签退
- (void)signInOrSignOut:(UIButton *)sender
{
 
        PostSignInViewController *postSignVC = [[PostSignInViewController alloc] init];
        postSignVC.currentTime = [_timeString substringFromIndex:5];
    NSLog(@"%@",cityStr);
        postSignVC.currentPlace = _placeLocalLabel.text;
    if (sender.tag == 100) {
        postSignVC.signType = 1;
    }else{
        postSignVC.signType = 2;
    }
    postSignVC.longt = [NSString stringWithFormat:@"%f",currentCoordinate.longitude];
    postSignVC.lati = [NSString stringWithFormat:@"%f",currentCoordinate.latitude];
    
        [self.navigationController pushViewController:postSignVC animated:YES];
   
}
#pragma mark --代理
#pragma mark --tableview的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"tableview zhong --%ld",/_dataArray.count);
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


//更改地址
- (void)changePlace:(UIButton * )sender
{
    ChangePlaceMap *changMapVC = [[ChangePlaceMap alloc] init];
    changMapVC.delegate = self;
    [self.navigationController pushViewController:changMapVC animated:YES];
}

#pragma mark --刷新时间
- (void)freshTime
{
    [self getCrrentDate];
    NSMutableAttributedString * timeStr = [[NSMutableAttributedString alloc] initWithString:_timeString];
    [timeStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName : blackFontColor} range:NSMakeRange(0, _timeString.length)];
    [timeStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName : lightGrayFontColor } range:NSMakeRange(5, _timeString.length - 5)];
    _timeLabel.attributedText = timeStr;
    
}
#pragma mark --当前时间
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
- (void)handleSatistic:(UIButton * )btn
{
//    NSLog(@"统计");
    Person_StatisticsController * statisticVC = [[Person_StatisticsController alloc] init];
    [self.navigationController pushViewController:statisticVC animated:YES];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    [_dataArray removeAllObjects];
    [self getSignInfo];//获得签到签退的情况
    [self choseViewShow];
    geoSearch.delegate = self;
    _locationSevice.delegate = self;
    _placeImage.delegate = self;
    [_locationSevice startUserLocationService];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = NO;
    [_locationSevice stopUserLocationService];
    _locationSevice.delegate = nil;
    _placeImage.delegate = nil;
    geoSearch.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)popLastView
{
    [self.navigationController popViewControllerAnimated:YES];
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
