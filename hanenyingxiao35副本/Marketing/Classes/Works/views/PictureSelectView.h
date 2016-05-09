//
//  PictureSelectView.h
//  YunGui
//
//  Created by Hanen 3G 01 on 16/3/23.
//  Copyright © 2016年 hanen. All rights reserved.
//图片选择

#import <UIKit/UIKit.h>

@protocol PictureSelectViewDelegate <NSObject>

- (void)addImage;

@end

@interface PictureSelectView : UIView
//上传照片的数组
@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, weak) id<PictureSelectViewDelegate>delegate;

@property (nonatomic, strong) NSMutableArray *allPicArray;

//已有照片的显示数组
@property (nonatomic, strong) NSMutableArray *showImages;

@property (nonatomic, assign) BOOL  isHadCheck;//已检查的话 不用添加图片按钮 直接展示
@end
