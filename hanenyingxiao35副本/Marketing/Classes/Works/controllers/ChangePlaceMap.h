//
//  ChangePlaceMap.h
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/13.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//地点微调地图

#import "BaseController.h"

@protocol ChangePlaceMapDelegate <NSObject>

- (void)changPlaceWith:(NSString *)placeName;

@end

//typedef void(^changPlace)(NSString * detailplace);

@interface ChangePlaceMap : BaseController

@property (nonatomic, assign) id <ChangePlaceMapDelegate>delegate;
//@property (nonatomic, assign) changPlace placeblock;
//- (void)changePlace:(changPlace)placeBlock;
@end
