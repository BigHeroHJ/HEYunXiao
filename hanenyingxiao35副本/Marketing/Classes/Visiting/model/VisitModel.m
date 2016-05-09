//
//  VisitModel.m
//  Marketing
//
//  Created by wmm on 16/3/6.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "VisitModel.h"

@implementation VisitModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        [super setValue:value forKey:@"visitId"];
    }else if ([key isEqualToString:@"typename"]){
        [super setValue:value forKey:@"visittype"];
    }else{
        [super setValue:value forKey:key];
    }
}

@end
