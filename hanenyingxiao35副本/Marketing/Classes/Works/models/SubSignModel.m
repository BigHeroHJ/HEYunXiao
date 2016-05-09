//
//  SubSignModel.m
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/7.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "SubSignModel.h"

@implementation SubSignModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}
- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        [super setValue:value forKey:@"signId"];
    }else{
        [super setValue:value forKey:key];
    }
}
@end
