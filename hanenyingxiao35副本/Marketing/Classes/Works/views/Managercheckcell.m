//
//  Managercheckcell.m
//  
//
//  Created by Hanen 3G 01 on 16/3/14.
//
//

#import "Managercheckcell.h"

@implementation Managercheckcell
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
