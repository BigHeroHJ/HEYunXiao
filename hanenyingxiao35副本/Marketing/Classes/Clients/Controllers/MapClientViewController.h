//
//  MapClientViewController.h
//  Marketing
//
//  Created by HanenDev on 16/3/7.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
@protocol MapClientViewControllerDelegate <NSObject>

- (void)getClickPlaceName:(NSString *)PlaceString withCoordinat2D:(CLLocationCoordinate2D )pt;

@end



@interface MapClientViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKGeoCodeSearchDelegate,UISearchBarDelegate>
{
    BMKMapView *_mapView;//地图
    BMKLocationService* _locService;//定位
    BMKPoiSearch * _poiSearch;//检索
    BMKGeoCodeSearch * _geoSearcher;//地理编码
    
    CLLocationDegrees latitude;//纬度
    CLLocationDegrees longitude;//经度
    
    CLLocationCoordinate2D location;
    UILabel *label;
}

@property(nonatomic,copy)NSString * cityStr;//定位之后的城市
@property(nonatomic,copy)NSString *addrDetailStr;//定位之后的详细地址
@property(nonatomic,copy)NSString *districtStr;//搜索之后的小区名称


@property (nonatomic, strong) NSString *locationLongide;
@property (nonatomic, strong) NSString *locationLatitude;

@property (nonatomic, weak) id <MapClientViewControllerDelegate>delegate;

@property(nonatomic)int result;

@end


