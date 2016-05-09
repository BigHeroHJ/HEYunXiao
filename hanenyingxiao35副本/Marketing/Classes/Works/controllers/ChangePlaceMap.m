//
//  ChangePlaceMap.m
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/13.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "ChangePlaceMap.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface ChangePlaceMap ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKMapView *_mapView;
    BMKLocationService  *locationSevice;
    BMKGeoCodeSearch *geoSearch;
    NSString       *userNowCityName;//用户定位的地址 城市
    CLLocationCoordinate2D userNowCoordinate2D;
    UILabel  *_showPlaceLabel;
    NSString   *_usePlaceDetail;
    
}
@end

@implementation ChangePlaceMap
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self creatMapView];
    
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:@"地点微调"];
      self.navigationItem.leftBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithAction:@selector(popLastView)];
    [self initSevice];
}

- (void)creatMapView
{
    _showPlaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, KSCreenW, [UIView getWidth:50])];
    _showPlaceLabel.font = [UIView getFontWithSize:15.0f];
    _showPlaceLabel.textColor = blackFontColor;
    _showPlaceLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_showPlaceLabel];
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, _showPlaceLabel.maxY, KSCreenW, KSCreenH - 64)];
    _mapView.delegate = self;
    _mapView.zoomLevel = 15.0f;
    [self.view addSubview:_mapView];
    _mapView.scrollEnabled = YES;
    
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isRotateAngleValid = true;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = false;//精度圈是否显示
//    displayParam.locationViewImgName= @"icon";//定位图标名称
    displayParam.locationViewOffsetX = 0;//定位偏移量(经度)
    displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
    [_mapView updateLocationViewWithParam:displayParam];
    
    [_mapView setMapType:BMKMapTypeStandard];//设置标准地图类型
}
- (void)initSevice
{
    locationSevice = [[BMKLocationService alloc] init];
    locationSevice.delegate = self;
    
    [self startLocation];
   
    geoSearch = [[BMKGeoCodeSearch alloc] init];
    geoSearch.delegate = self;
}

- (void)startLocation
{
    locationSevice.distanceFilter = 5.0;
    locationSevice.desiredAccuracy = kCLLocationAccuracyBest;
      [locationSevice startUserLocationService];
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    _mapView.showsUserLocation = YES;
    
    _mapView.zoomEnabled = 20.0f;
}
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    // 动态更新我的位置数据
    [_mapView updateLocationData:userLocation];
}
/**
 *  用户位置更新
 *
 *  @param userLocation
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    _mapView.centerCoordinate = coordinate;
    //    _mapView.zoomLevel = 15.0f;
    
    userNowCoordinate2D = coordinate;
    
    [_mapView updateLocationData:userLocation];
    
    //此类表示图层自定义样式的参数 可以出定位蓝色点的圆圈
    /*
     float    _locationViewOffsetX; // 定位图标偏移量(经度)
     float    _locationViewOffsetY; // 定位图标偏移量（纬度）
     bool     _isAccuracyCircleShow;// 精度圈是否显示
     bool     _isRotateAngleValid;  // 跟随态旋转角度是否生效
     NSString* _locationViewImgName;// 定位图标名称
     */
    
    //
    [self poiToDeGeoCodeWith:coordinate];
    
    
    /*
     kCLLocationAccuracyBestForNavigation  最高精度，这种级别用于导航程序
     kCLLocationAccuracyBest  最高精度
     kCLLocationAccuracyHundredMeters 精度为100米内
     kCLLocationAccuracyKilometer   精度到公里范围内
     kCLLocationAccuracyNearestTenMeters   精度到10米内
     kCLLocationAccuracyThreeKilometers  精度到3公里范围内
     
     
     CLTimeIntervalMax 设备支持的最大时间跨度
     */
    
    //    //定位的距离筛选器 必须在开始定位前设置
    //    locationSevice.distanceFilter = 10.0;//10米
    //    //过于消耗电量 可以设置成默认的无筛选器
 
}
- (void)poiToDeGeoCodeWith:(CLLocationCoordinate2D )coordinate
{
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0,0};
    pt = coordinate;
    NSLog(@"===%f,  %f",coordinate.latitude,coordinate.longitude);
    BMKReverseGeoCodeOption *reverOption = [[BMKReverseGeoCodeOption alloc] init];
    reverOption.reverseGeoPoint = pt;
    BOOL flag = [geoSearch reverseGeoCode:reverOption];
    if (flag) {
        NSLog(@"反geo检索发送成功");
    }else{
        NSLog(@"反geo检索发送失败");
        _usePlaceDetail = [NSString stringWithFormat:@"%@",_showPlaceLabel.text];
        if ([self.delegate respondsToSelector:@selector(changPlaceWith:)]) {
            [self.delegate changPlaceWith:_usePlaceDetail];
        }
    }
}
//在这里得到反编码的结果 得到详细地址
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    //移除之前的覆盖物和标注
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    
    /*
     
     BMK_SEARCH_NO_ERROR = 0,///<检索结果正常返回
     BMK_SEARCH_AMBIGUOUS_KEYWORD,///<检索词有岐义
     BMK_SEARCH_AMBIGUOUS_ROURE_ADDR,///<检索地址有岐义
     BMK_SEARCH_NOT_SUPPORT_BUS,///<该城市不支持公交搜索
     BMK_SEARCH_NOT_SUPPORT_BUS_2CITY,///<不支持跨城市公交
     BMK_SEARCH_RESULT_NOT_FOUND,///<没有找到检索结果
     BMK_SEARCH_ST_EN_TOO_NEAR,///<起终点太近
     BMK_SEARCH_KEY_ERROR,///<key错误
     BMK_SEARCH_NETWOKR_ERROR,///网络连接错误
     BMK_SEARCH_NETWOKR_TIMEOUT,///网络连接超时
     BMK_SEARCH_PERMISSION_UNFINISHED,///还未完成鉴权，请在鉴权通过后重试
     
     */
      NSString *cityStr;
    if(error == 0){//
        
        
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
        annotation.coordinate = result.location;
        annotation.title = result.address;
        //        [_mapView addAnnotation:annotation];
        
//        NSLog(@"定位的用户地址名称:%@",result.address);
      
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
        
    }
    _usePlaceDetail = [NSString stringWithFormat:@"%@%@",cityStr,_showPlaceLabel.text];
    if ([self.delegate respondsToSelector:@selector(changPlaceWith:)]) {
        [self.delegate changPlaceWith:_usePlaceDetail];
    }
    NSLog(@" _usePlaceDetail %@",_usePlaceDetail);
//    self.placeblock(_usePlaceDetail);
}

//返回大头针视图
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    NSLog(@"addAnnotation");
    NSString *reuserAnnotion = @"reuseAnnotion";
    BMKAnnotationView *annotionView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuserAnnotion];
    if (annotionView == nil) {
        annotionView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuserAnnotion];
        ((BMKPinAnnotationView*)annotionView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotionView).animatesDrop = YES;
        ((BMKPinAnnotationView*)annotionView).image = [UIImage imageNamed:@"999"];
    }
    //    BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc] init];
    //    pointAnnotation.title = @"小河嘻嘻嘻";
    annotionView.centerOffset = CGPointMake(0, -(annotionView.frame.size.height * 0.5));
    annotionView.annotation = annotation;
    //*************************************************
    //可以去改变点击后弹出出现的泡泡view
    annotionView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //    UIView *vie = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    //    vie.backgroundColor = [UIColor whiteColor];
    //    vie.alpha = 0.7;
    //    annotionView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:vie];
    //*************************************************
    annotionView.draggable = YES;
    //    annotionView.backgroundColor = [UIColor greenColor];
    return annotionView;
}

//添加一个标注
- (void)addAnnotionWith:(CLLocationCoordinate2D )coordinate withTitle:(NSString *)title
{
  
    
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title = title;
    [_mapView addAnnotation:annotation];
    
}
//点击底层标注 就是地图上的一些地方
- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi*)mapPoi
{
    NSLog(@"onClickedMapPoi-%@",mapPoi.text);
    NSString* showmeg = [NSString stringWithFormat:@"您点击了底图标注:%@,\r\n当前经度:%f,当前纬度:%f,\r\nZoomLevel=%d;RotateAngle=%d;OverlookAngle=%d", mapPoi.text,mapPoi.pt.longitude,mapPoi.pt.latitude, (int)_mapView.zoomLevel,_mapView.rotation,_mapView.overlooking];
    NSLog(@".....%@",showmeg);
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0,0};
    pt.longitude = mapPoi.pt.longitude;
    pt.latitude = mapPoi.pt.latitude;
    
    
    [self addAnnotionWith:pt withTitle:mapPoi.text];
    _showPlaceLabel.text = mapPoi.text;
    
    [self poiToDeGeoCodeWith:pt];
}


//
//-(void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate{
//    //长按之前删除所有标注
//    NSArray *arrayAnmation=[[NSArray alloc] initWithArray:_mapView.annotations];
//    [_mapView removeAnnotations:arrayAnmation];
//    //得到经纬度
//    locaLatitude=coordinate.latitude;
//    locaLongitude=coordinate.longitude;
//    CLLocationCoordinate2D pt=(CLLocationCoordinate2D){0,0};
//    pt=(CLLocationCoordinate2D){coordinate.latitude,coordinate.longitude};
//    BOOL flag= [geoSearch reverseGeocode:pt];
//    if (flag) {
//        NSLog(@"success");
//    }else{
//        NSLog(@"falied");
//    }
//}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    locationSevice.delegate = self;
    _mapView.delegate = self;
    geoSearch.delegate = self;
    [locationSevice startUserLocationService];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = NO;
    [locationSevice stopUserLocationService];
    locationSevice.delegate = nil;
    _mapView.delegate = nil;
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

@end
