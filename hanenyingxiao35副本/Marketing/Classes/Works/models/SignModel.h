//
//  SignModel.h
//  Marketing
//
//  Created by Hanen 3G 01 on 16/2/26.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignModel : NSObject

@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) int isCheckout;
@property (nonatomic, assign) int checkinCount;
@property (nonatomic, assign) int checkoutCount;
@property (nonatomic, strong) NSArray * list;
//@property (nonatomic, strong) NSString * img;//签到图片
@property (nonatomic, strong) NSString *address;//地址
//@property (nonatomic, strong) NSString *addtime;
//@property (nonatomic, strong) NSString *remark;
@property (nonatomic, assign) int  code;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *lon;
@property (nonatomic, strong) NSString * lat;

@end
