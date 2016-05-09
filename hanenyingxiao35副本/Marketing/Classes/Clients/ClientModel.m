//
//  ClientModel.m
//  Marketing
//
//  Created by HanenDev on 16/3/8.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "ClientModel.h"

@implementation ClientModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        [super setValue:value forKey:@"clientId"];
    }else if ([key isEqualToString:@"typename"]){
        [super setValue:value forKey:@"visittype"];
    }else{
        [super setValue:value forKey:key];
    }
}
@end
