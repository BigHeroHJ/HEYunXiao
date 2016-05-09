//
//  DetailClientViewController.h
//  Marketing
//
//  Created by HanenDev on 16/3/1.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientModel.h"

@interface DetailClientViewController : UIViewController

@property(nonatomic,assign)int   cID;
@property(nonatomic,strong)NSString *titleStr;
@property(nonatomic,strong)ClientModel *model;

@property(nonatomic,strong)NSMutableArray        *levelArray;
@property(nonatomic,strong)NSMutableArray        *fromArray;
@property(nonatomic,strong)NSMutableArray        *statusArray;

@end
