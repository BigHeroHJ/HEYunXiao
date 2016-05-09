//
//  ClientModel.h
//  Marketing
//
//  Created by HanenDev on 16/3/8.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientModel : NSObject

@property(nonatomic,assign)int         clientId;
@property(nonatomic,strong)NSString    *company;
@property(nonatomic,strong)NSString    *address;
@property(nonatomic,assign)int         status;
@property(nonatomic,strong)NSString    *cname;
@property(nonatomic,strong)NSString    *addtime;
@property(nonatomic,strong)NSString    *ordertime;//预计拜访的时间
@property(nonatomic,strong)NSString    *visittime;//实际拜访时间
@property (nonatomic, strong) NSString *clevelname;
@property(nonatomic,strong)NSString *lon;
@property(nonatomic,strong)NSString *lat;

@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *visittype;

@end
