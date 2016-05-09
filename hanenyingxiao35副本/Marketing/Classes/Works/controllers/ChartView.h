//
//  ChartView.h
//  zhexian
//
//  Created by User on 16/3/11.
//  Copyright © 2016年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartView : UIView

@property (nonatomic ,retain) NSMutableArray *xarr; //x的坐标标记值
@property (nonatomic ,retain) NSMutableArray *yarr; //y的数值

@property (nonatomic, assign) int chooseType;//1 = 客户拜访，2 = 新增客户 ，3 = 客户总量
@property (nonatomic, assign) int maxNum;
@property (nonatomic, assign) int minNum;
@end
