//
//  DepartmentModel.m
//  Marketing
//
//  Created by wmm on 16/3/9.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "DepartmentModel.h"

@implementation DepartmentModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        [super setValue:value forKey:@"departId"];
    }else{
        [super setValue:value forKey:key];
    }
}

@end
