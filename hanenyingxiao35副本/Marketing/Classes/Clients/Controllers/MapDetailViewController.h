//
//  MapDetailViewController.h
//  Marketing
//
//  Created by HanenDev on 16/3/8.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

@interface MapDetailViewController : UIViewController<BMKRouteSearchDelegate,BMKGeoCodeSearchDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView      * _walkTableView;
    UITableView      * _busTableView;
    UITableView      * _carTableView;
    
    BMKRouteSearch   * _routeSearch;//路线规划
    BMKGeoCodeSearch * _geoSearcher;//地理编码
    
    CLLocationCoordinate2D location;
    
    int  _lastTag;
}
@property(nonatomic,strong)UILabel      * addrLabel;
@property(nonatomic,strong)UILabel      * myLabel;
@property(nonatomic,strong)UITextField  *addrTF;
@property(nonatomic,strong)NSArray      *searchWalkArr;
@property(nonatomic,strong)NSArray      *searchBusArr;
@property(nonatomic,strong)NSArray      *searchCarArr;
@property(nonatomic)CLLocationCoordinate2D myLocation;

@property(nonatomic,copy)NSString       * cityStr;//定位之后的城市
@property(nonatomic,copy)NSString       *addrDetailStr;//定位之后的详细地址
@property(nonatomic,copy)NSString       *districtStr;

@property (nonatomic, assign) CLLocationCoordinate2D endCoordinate;

@end
