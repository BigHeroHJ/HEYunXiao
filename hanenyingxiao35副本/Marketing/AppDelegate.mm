//
//  AppDelegate.m
//  Marketing
//
//  Created by Hanen 3G 01 on 16/2/24.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "AppDelegate.h"
#import "MyNavigationController.h"
#import "FirstViewController.h"
#import "MyTabBarController.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface AppDelegate ()
{
     BMKMapManager* _mapManager;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.2222sfdsf

//    [NSThread sleepForTimeInterval:2.0];
//     使用百度地图，先启动BaiduMapManager
    _mapManager=[[BMKMapManager alloc]init];
    
    BOOL ret=[_mapManager start:@"d9q8I5pCEVE5Ooa5Fy99wq1NLclyf8dm" generalDelegate:nil];
    if (!ret){
        NSLog(@"启动失败");
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor whiteColor];
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    if(KSCreenH > 480){
        myDelegate.autoSizeScaleX = KSCreenW/320;
        myDelegate.autoSizeScaleY = KSCreenH/568;
    }else{
        myDelegate.autoSizeScaleX = 1.0;
        myDelegate.autoSizeScaleY = 1.0;
    }
     _tabbarControl = [[MyTabBarController alloc] init];
    [[NSUserDefaults standardUserDefaults] setFloat:_tabbarControl.bottomView.height forKey:@"tabbarH"];
    NSLog(@" tabbarH %f",TabbarH);
    self.window.rootViewController = self.tabbarControl;
//    _mainNavController = [[MyNavigationController alloc] init];
//    self.window.rootViewController = _mainNavController;
    if (UID != 0 & TOKEN != nil) {
        MyTabBarController *myTabBarController = [[MyTabBarController alloc] init];
        self.window.rootViewController = myTabBarController;
        [[UINavigationBar appearance] setBackgroundColor:TabbarColor];
    }else{
        _mainNavController = [[MyNavigationController alloc] init];
        self.window.rootViewController = _mainNavController;    
//        FirstViewController *firstViewController = [[FirstViewController alloc] init];
//        self.window.rootViewController = firstViewController;
//        [[UINavigationBar appearance] setBackgroundColor:TabbarColor];
    }
    [self.window makeKeyAndVisible];

    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certttain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//    [BMKMapView willBackGround];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    [BMKMapView didForeGround];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
