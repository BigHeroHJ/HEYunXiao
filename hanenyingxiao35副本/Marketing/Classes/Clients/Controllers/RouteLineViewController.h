//
//  RouteLineViewController.h
//  Marketing
//
//  Created by HanenDev on 16/3/8.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

@protocol RouteLineDelegate <NSObject>

- (void)getToHide:(UIButton *)btn;

@end

@interface RouteLineViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSArray *routeArray;
@property(nonatomic)int result;
@property(nonatomic,strong)NSString *startStr;
@property(nonatomic,strong)NSString *endStr;

@property(nonatomic)int height;

@property(nonatomic,weak)id<RouteLineDelegate>delegate;

@end
