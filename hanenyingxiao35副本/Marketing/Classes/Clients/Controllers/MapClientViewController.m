//
//  MapClientViewController.m
//  Marketing
//
//  Created by HanenDev on 16/3/7.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "MapClientViewController.h"
#import "MapDetailViewController.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "Toast+UIView.h"
#import "ClientsViewController.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]


@interface MapClientViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UISearchBar      *_searchBar;
    ClientsViewController *_clientVC;
    UITableView      *_tableview;
    UIView *viback;
    
    NSMutableArray  *_placeArray;
    NSString *userClickPlace;
    NSString *clickDetailPlace;
    
    CLLocationCoordinate2D  userNowCoordinate;
    CLLocationCoordinate2D  clickCoordinate;
    CLLocationCoordinate2D  searchCoordinate;
    NSString  *lastSearchString;
    
    UIView  *_backView;
}
@end

@implementation MapClientViewController

- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * str=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return str;
    }
    return nil ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:@"客户地图"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem=[ViewTool getBarButtonItemWithTarget:self WithAction:@selector(goToBack)];
    
    _placeArray = [NSMutableArray array];
    //显示地图
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, KSCreenH)];
    _mapView.mapType=BMKMapTypeStandard;
    _mapView.isSelectedAnnotationViewFront = YES;
    _mapView.scrollEnabled=YES;
    
    // 设置地图级别
    [_mapView setZoomLevel:16];
    
    self.view=_mapView;
    
//    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
//    displayParam.isRotateAngleValid = true;//跟随态旋转角度是否生效
//    displayParam.isAccuracyCircleShow = false;//精度圈是否显示
////    displayParam.locationViewImgName= @"我的位置";//定位图标名称
//    displayParam.locationViewOffsetX = 0;//定位偏移量(经度)
//    displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
//    [_mapView updateLocationViewWithParam:displayParam];
    
    //初始化定位服务
    _locService=[[BMKLocationService alloc]init];
      [_locService startUserLocationService];
    //初始化检索对象
    _geoSearcher =[[BMKGeoCodeSearch alloc]init];
    
    //初始化poi检索
    _poiSearch=[[BMKPoiSearch alloc]init];
    
    [self initViews];
    
    
    [self addTableView];
    
    if (self.locationLongide && self.locationLatitude ) {
        
        CLLocationCoordinate2D pt = CLLocationCoordinate2DMake([self.locationLatitude floatValue], [self.locationLongide floatValue]);
        [_mapView setCenterCoordinate:pt];
        [self poiToDeGeoCodeWith:pt];
    
//        [_locService stopUserLocationService];
    }
}
- (void)addTableView{
    
    viback = [[UIView alloc] initWithFrame:CGRectMake(0, _searchBar.maxY + 64, KSCreenW, KSCreenH - _searchBar.maxY - 64)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackView)];
    [viback addGestureRecognizer:tap];
    
    [self.view addSubview:viback];
    viback.alpha = 0;
    viback.backgroundColor = blackFontColor;
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, _searchBar.maxY + 64, KSCreenW, KSCreenH - _searchBar.maxY - 64)];
    _tableview.backgroundColor = graySectionColor;
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [self.view addSubview:_tableview];
    _tableview.alpha = 0;
    _tableview.hidden = YES;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _placeArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *mapCell = @"mapcellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mapCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mapCell];
        
    }
    
    BMKPointAnnotation *point = _placeArray[indexPath.row];
    
    cell.textLabel.text = point.title;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *arr = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:arr];
    
    BMKPointAnnotation *point = _placeArray[indexPath.row];
    userClickPlace = point.title;
    
    BMKPointAnnotation *pointAnnotation = _placeArray[indexPath.row];
//    clickDetailPlace = pointAnnotation.title;
    searchCoordinate = pointAnnotation.coordinate;
    [self poiToDeGeoCodeWith:pointAnnotation.coordinate];
//      [_mapView addAnnotation:pointAnnotation];

    [_mapView setCenterCoordinate:pointAnnotation.coordinate];
    _mapView.zoomLevel = 17.0f;
    [UIView animateWithDuration:0.25 animations:^{
//        _tableview.frame = CGRectMake(0, 0, KSCreenW, [UIView getWidth:200]);
        _tableview.alpha = 0;
        
    } completion:^(BOOL finished) {
        _tableview.hidden = YES;
        viback.alpha = 0;
        viback.hidden = YES;
    }];
    [_searchBar resignFirstResponder];
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchBar resignFirstResponder];
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if (lastSearchString.length != 0 && [searchBar.text isEqualToString:@""]) {
        return NO;
    }else{
        return YES;
    }
}
//点击取消按钮
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
   
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
    [UIView animateWithDuration:0.2 animations:^{
        viback.alpha = 0.5;
    } completion:^(BOOL finished) {
     
    }];
 
}
#pragma mark --文字改变时搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (lastSearchString != nil && [searchText isEqualToString:@""]) {
        [_placeArray removeAllObjects];
//            [_searchBar resignFirstResponder];
            NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
            [_mapView removeAnnotations:array];
            [_mapView setCenterCoordinate:userNowCoordinate];
            _tableview.alpha = 0;
            viback.alpha = 0;
            viback.hidden = YES;
            _tableview.hidden = YES;
            _mapView.zoomLevel = 16.0f;
          [_searchBar resignFirstResponder];
        
//        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, searchBar.maxY + 64, KSCreenW, KSCreenH - searchBar.maxY - 64)];
//        _backView.backgroundColor = [UIColor clearColor];
//        [_mapView insertSubview:_backView atIndex:1];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//        [_backView addGestureRecognizer:tap];
    }else{
        
        [_placeArray removeAllObjects];
        if (![searchText isEqualToString:@""]) {
            BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
            citySearchOption.pageIndex = 0;
            citySearchOption.pageCapacity = 20;
            citySearchOption.city=self.cityStr;
            citySearchOption.keyword =searchBar.text;
            NSLog(@"%@-=--=-city-=-=-=--=-",citySearchOption.city);

            BOOL flag = [_poiSearch poiSearchInCity:citySearchOption];
            if(flag){
                
                NSLog(@"城市内检索发送成功");
                
                if(_tableview.hidden == YES){
                    [UIView animateWithDuration:0.25 animations:^{
                        _tableview.frame = CGRectMake(0, _searchBar.maxY + 64, KSCreenW, KSCreenH - _searchBar.maxY - 64);
                        _tableview.hidden = NO;
                        _tableview.alpha = 1;
                    }];
                }
            }else{
                
                NSLog(@"城市内检索失败；；；；；；；");
            }
        }

    }
    lastSearchString = searchText;
  
    
}

- (void)tapBackView
{
    viback.alpha = 0;
}
- (void)initViews{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KSCreenW, 44)];
    view.backgroundColor  = graySectionColor;
    [self.view addSubview:view];
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, KSCreenW , 44)];
    [_searchBar setBackgroundImage:[ViewTool getImageFromColor:graySectionColor WithRect:_searchBar.frame]];
    _searchBar.placeholder =@"搜索";
    _searchBar.delegate = self;
    [view addSubview:_searchBar];
    
    
}
//设置代理
-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate=self;
    _locService.delegate=self;
    _poiSearch.delegate=self;
    _geoSearcher.delegate = self;
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBarHidden = NO;
    
    [_searchBar resignFirstResponder];
    
}
- (void)viewDidDisappear:(BOOL)animated{
    
    NSArray *array = _mapView.annotations;
    [_mapView removeAnnotations:array];
    
    _searchBar.text = @"";
    [_searchBar resignFirstResponder];
}
//代理不用时，置为nil
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate=nil;
    _locService.delegate=nil;
    _poiSearch.delegate=nil;
    _geoSearcher.delegate = nil;
    self.tabBarController.hidesBottomBarWhenPushed = NO;
    
}

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView
{
    _mapView.showsUserLocation=NO;
    _mapView.userTrackingMode=BMKUserTrackingModeNone;
    _mapView.showsUserLocation=YES;
    
}
//用户位置更新，调用此函数
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    
    
//    if (self.locationLongide && self.locationLatitude) {
////        CLLocationCoordinate2D pt = CLLocationCoordinate2DMake([self.locationLatitude floatValue], [self.locationLongide floatValue]);
//        [_mapView setCenterCoordinate:pt];
//        [self poiToDeGeoCodeWith:pt];
//        
//    }else{
//        _mapView.centerCoordinate = userLocation.location.coordinate;
//    }
//    if (self.locationLongide && self.locationLatitude) {
//       
//    }else{
       _mapView.centerCoordinate = userLocation.location.coordinate;
        //发起反向地理编码检索
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
        BMKReverseGeoCodeOption *reverseGeoOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeoOption.reverseGeoPoint = pt;
        BOOL flag = [_geoSearcher reverseGeoCode:reverseGeoOption];
        if(flag){
            NSLog(@"反geo检索发送成功");
        }else{
            NSLog(@"反geo检索发送失败");
        }

//    }
    userNowCoordinate = userLocation.location.coordinate;
    [_mapView updateLocationData:userLocation];
    [_locService stopUserLocationService];//定位成功之后关闭定位
    
    latitude=userLocation.location.coordinate.latitude;//纬度
    longitude=userLocation.location.coordinate.longitude;//精度
    
}
#pragma mark -
#pragma mark --反地理编码

//返回反地理编码搜索结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        
        self.cityStr=result.addressDetail.city;
        self.addrDetailStr=[NSString stringWithFormat:@"%@%@%@",result.addressDetail.district,result.addressDetail.streetName,result.addressDetail.streetNumber];
        NSLog(@"%@xiangxidizhi ",self.addrDetailStr);
        NSLog(@"%@ ====cityname====",self.cityStr);
        
        
        NSLog(@"%@ %@",userClickPlace,self.addrDetailStr);
        NSString * place = [NSString stringWithFormat:@"%@%@",self.cityStr,self.addrDetailStr];
        
//        if (self.locationLatitude && self.locationLongide) {
//              [self addAnnotionWith:clickCoordinate withTitle:userClickPlace withSubtitle:place];
//        }else{
//              [self addAnnotionWith:clickCoordinate withTitle:userClickPlace withSubtitle:place];
//        }
      [self addAnnotionWith:clickCoordinate withTitle:userClickPlace withSubtitle:place];
        
    }
    else {
        [self.view makeToast:@"抱歉未找到结果"];
    }
}

#pragma mark -
#pragma mark --地图 BMKMapViewDelegate
//设置标注生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
 
        NSString *AnnotationViewID = @"xiaoQu";
    
        BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorGreen;
            // 设置从天上掉下的效果
            ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
        }
        // 设置位置
        annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
        annotationView.annotation = annotation;
        // 单击弹出泡泡，弹出泡泡前 annotation必须实现title属性
        annotationView.canShowCallout = YES;
        annotationView.image=[UIImage imageNamed:@"客户定位"];
        // 设置是否可以拖拽
        annotationView.draggable = NO;
    return annotationView;
    
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
    
   
//    _showPlaceLabel.text = mapPoi.text;
    userClickPlace = mapPoi.text;//
    
    [self poiToDeGeoCodeWith:pt];
    
  
}
- (void)poiToDeGeoCodeWith:(CLLocationCoordinate2D )coordinate
{
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0,0};
    pt = coordinate;
    NSLog(@"===%f,  %f",coordinate.latitude,coordinate.longitude);
    BMKReverseGeoCodeOption *reverOption = [[BMKReverseGeoCodeOption alloc] init];
    reverOption.reverseGeoPoint = pt;
    BOOL flag = [_geoSearcher reverseGeoCode:reverOption];
    if (flag) {
        NSLog(@"反geo检索发送成功");
    }else{
        NSLog(@"反geo检索发送失败");
        
    }
  clickCoordinate =  pt;
}

- (void)addAnnotionWith:(CLLocationCoordinate2D )coordinate withTitle:(NSString *)title withSubtitle:(NSString * )subtitle
{
    [_searchBar resignFirstResponder];
    
    NSArray *array = _mapView.annotations;
//    [_mapView removeOverlays:array];
    [_mapView removeAnnotations:array];
    
     NSLog(@"用户点击的地方%@,经纬度: %f,%f",userClickPlace,coordinate.longitude,coordinate.latitude);
    
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.subtitle = subtitle;
    annotation.title = title;
    [_mapView addAnnotation:annotation];
    
}
//当选中一个annotation views时，调用此接口
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}

- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    
//    NSLog(@"didAddAnnotationViews");
}
#pragma mark
#pragma mark-------点击弹出的气泡
// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSLog(@"paopaoclick");
    if ([view.annotation.title isEqualToString:@"我的位置"]) {
        return;
    }
     
    if ((self.locationLongide && self.locationLatitude) || self.result == 1) {
        NSString * string = [NSString stringWithFormat:@"%@",view.annotation.subtitle];
        if ([self.delegate respondsToSelector:@selector(getClickPlaceName:withCoordinat2D:)]) {
            [self.delegate getClickPlaceName:string withCoordinat2D:clickCoordinate];
        }
        NSLog(@"传回的 地理位置 经纬度 %@%f%f",string,clickCoordinate.longitude,clickCoordinate.latitude);
        [self.navigationController popViewControllerAnimated:YES];

    }else{
    
    MapDetailViewController * vc=[[MapDetailViewController alloc]init];
    vc.cityStr=self.cityStr;
    vc.addrDetailStr=self.addrDetailStr;
    
    vc.districtStr=view.annotation.title;
    vc.myLocation=(CLLocationCoordinate2D){latitude, longitude};
    if (self.locationLongide && self.locationLatitude) {
        vc.endCoordinate = CLLocationCoordinate2DMake([self.locationLatitude floatValue], [self.locationLongide floatValue]);
    }
    
    NSLog(@"%f+++++---------",vc.myLocation.latitude);
    NSLog(@"%@,%@",vc.cityStr,vc.addrDetailStr);
    [self.navigationController pushViewController:vc animated:NO];
    }
    
}
#pragma mark -
#pragma mark --poi搜索结果 BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    
    NSLog(@"%d+-+-++--+--+--++--+",result.totalPoiNum);
    // 清除屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        NSMutableArray *annotations = [NSMutableArray array];
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            item.subtitle= poi.address;
            
            [_placeArray addObject:item];
            [annotations addObject:item];
        }
          [_tableview reloadData];
        [_mapView addAnnotations:annotations];
        [_mapView showAnnotations:annotations animated:YES];
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    }else if ( error == BMK_SEARCH_AMBIGUOUS_KEYWORD
              ){
        NSLog(@"检索词有岐义");
    }
    else if ( error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR
             ){
        NSLog(@"检索地址有岐义");
    }
    else {
        // 各种情况的判断。。。
    }
}

#pragma mark------- 跳转
//跳转到详细地图界面
//-(void)searchLine:(UIButton *)btn
//{
//    label=[[btn superview] viewWithTag:2222];
//    
//    MapDetailViewController * vc=[[MapDetailViewController alloc]init];
//    vc.cityStr=self.cityStr;
//    vc.addrDetailStr=self.addrDetailStr;
//    if (label.text == nil) {
//        label = [[btn superview] viewWithTag:2233];
//    }
//    vc.districtStr=label.text;
//    vc.myLocation=(CLLocationCoordinate2D){latitude, longitude};
//    if (self.locationLongide && self.locationLatitude) {
//        vc.endCoordinate = CLLocationCoordinate2DMake([self.locationLatitude floatValue], [self.locationLongide floatValue]);
//    }
//   
//    NSLog(@"%f+++++---------",vc.myLocation.latitude);
//    NSLog(@"%@,%@",vc.cityStr,vc.addrDetailStr);
//    [self.navigationController pushViewController:vc animated:NO];
//    
//}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = 0;
    citySearchOption.pageCapacity = 20;
    citySearchOption.city=self.cityStr;
    citySearchOption.keyword =searchBar.text;
     _mapView.zoomLevel = 17.0f;
    BOOL flag = [_poiSearch poiSearchInCity:citySearchOption];
    if(flag){
        NSLog(@"城市内检索发送成功");
    }else{
        NSLog(@"城市内检索发送失败");
    }
    
    [searchBar resignFirstResponder];
    
    if(!_tableview.hidden){
        [UIView animateWithDuration:0.25 animations:^{
            _tableview.frame = CGRectMake(0, 0, KSCreenW, [UIView getWidth:200]);
            _tableview.alpha = 0;
            
        } completion:^(BOOL finished) {
            _tableview.hidden = YES;
            viback.alpha = 0;
            viback.hidden = YES;
        }];
       
    }
   
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [_searchBar resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_searchBar resignFirstResponder];
    [self.view endEditing:YES];
}

- (void)goToBack{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
