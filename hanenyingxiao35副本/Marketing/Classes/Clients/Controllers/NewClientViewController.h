//
//  NewClientViewController.h
//  Marketing
//
//  Created by HanenDev on 16/3/2.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientModel.h"

@interface NewClientViewController : UIViewController

@property (nonatomic, strong) NSDictionary * dictionary;

@property(nonatomic,strong)NSMutableArray        *levelArray;
@property(nonatomic,strong)NSMutableArray        *fromArray;
@property(nonatomic,strong)NSMutableArray        *statusArray;

@end
