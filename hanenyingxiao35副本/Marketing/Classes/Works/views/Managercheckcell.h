//
//  Managercheckcell.h
//  
//
//  Created by Hanen 3G 01 on 16/3/14.
//
//

#import <Foundation/Foundation.h>

@interface Managercheckcell : NSObject
@property (nonatomic, strong) NSString * company;
@property (nonatomic, strong) NSString * remark;
@property (nonatomic, strong) NSString * logo;
@property (nonatomic, strong) NSString * signId;
@property (nonatomic, strong) NSString * addtime;
@property (nonatomic, strong) NSString * name;

@property (nonatomic, assign) int uid;

@property (nonatomic, assign) int type;
@property (nonatomic, assign) int checkinCount;
@property (nonatomic, assign) int checkoutCount;
@end
