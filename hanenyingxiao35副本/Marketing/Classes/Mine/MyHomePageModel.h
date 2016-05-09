//
//  MyHomePageModel.h
//  Marketing
//
//  Created by HanenDev on 16/3/4.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyHomePageModel : NSObject

@property(nonatomic,assign)int        uid;
@property(nonatomic,strong)NSString   *username;
@property(nonatomic,strong)NSString   *name;
@property(nonatomic,assign)int        type;
@property(nonatomic,assign)int        department;
@property(nonatomic,strong)NSString   *departmentName;
@property(nonatomic,assign)int        position;
@property(nonatomic,strong)NSString   *positionname;
@property(nonatomic,strong)NSString   *logo;//头像
@property(nonatomic,strong)NSString   *img;//二维码

@end
