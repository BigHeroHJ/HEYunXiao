//
//  MyNavigationController.m
//  CSR
//
//  Created by Hanen 3G 01 on 16/2/15.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "MyNavigationController.h"
#import "FirstViewController.h"
#import "MyTabBarController.h"

@interface MyNavigationController ()

@end

@implementation MyNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _firstViewController = [[FirstViewController alloc] init];
    [self pushViewController:_firstViewController animated:YES];
    [[UINavigationBar appearance] setBackgroundColor:TabbarColor];

}


-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:animated];
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    return [super popViewControllerAnimated:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


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
