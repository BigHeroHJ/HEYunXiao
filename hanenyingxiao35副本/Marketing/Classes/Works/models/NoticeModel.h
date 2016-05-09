/*!
 Here , We Become Master!
  @header NoticeModel.h
  @abstract 项目名字：移动营销

 
 
  @author Created by Hanen 3G 01 on 16/2/24.
  @version 1.00 16/2/24 Creation
  Copyright © 2016年 Hanen 3G 01. All rights reserved.
*/

#import <Foundation/Foundation.h>

@interface NoticeModel : NSObject
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) int noticeId;
@property (nonatomic, strong) NSString * addtime;
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) int  isread;
@end
