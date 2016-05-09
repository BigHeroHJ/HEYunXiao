//
//  MoreController.m
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/24.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "MoreController.h"

@implementation MoreController
- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:@"更多"];
    self.navigationItem.leftBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithAction:@selector(popViewController)];
    UILabel  *label = [ViewTool getLabelWith:CGRectMake(0, (KSCreenH - 64) / 2.0f, KSCreenW, 20.0f) WithTitle:@"更多功能，敬请期待。" WithFontSize:15.0f WithTitleColor:grayFontColor WithTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:label];
    
//    UIImageView  *Image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 50, 50)];
//    Image.image = [UIImage imageNamed:@"拒绝"];
//    [self.view addSubview:Image];
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.hidesBottomBarWhenPushed = YES;

  
    //    _departmentTableView.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = NO;
}

@end
