//
//  LeavingModel.m
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/8.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "LeavingModel.h"

@implementation LeavingModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}
- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        [super setValue:value forKey:@"leavingID"];
    }else{
        [super setValue:value forKey:key];
    }
}
@end
