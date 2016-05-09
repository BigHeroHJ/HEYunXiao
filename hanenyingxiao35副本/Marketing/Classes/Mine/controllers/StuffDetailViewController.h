//
//  StuffDetailViewController.h
//  Marketing
//
//  Created by HanenDev on 16/2/26.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StuffDetailViewController : UIViewController

@property(nonatomic,strong)UIImageView *headerImageView;
@property(nonatomic,strong)UIButton    *qrBtn;
@property(nonatomic,strong)UILabel     *nameLabel;
@property(nonatomic,strong)UILabel     *phoneLabel;

@property(nonatomic)int cID;
@property(nonatomic,strong)NSString     *name;
@property(nonatomic,strong)NSString     *imag;
@property(nonatomic,strong)NSString     *phone;
@property(nonatomic,strong)NSString     *logo;
@property(nonatomic,strong)NSString    *positionName;
@property(nonatomic,strong)NSString    *departmentName;

@end
