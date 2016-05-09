//
//  PictureSelectView.m
//  YunGui
//
//  Created by Hanen 3G 01 on 16/3/23.
//  Copyright © 2016年 hanen. All rights reserved.
//

#import "PictureSelectView.h"
#import <AssetsLibrary/AssetsLibrary.h>


#define imageH [UIView getWidth:40] // 图片高度
#define imageW [UIView getWidth:40] // 图片宽度
#define kMaxColumn 3 // 每行显示数量
#define MaxImageCount 9 // 最多显示图片个数
#define deleImageWH 25 // 删除按钮的宽高
#define kAdeleImage @"Btn_Normal_Weijiancha.png" // 删除按钮图片
#define kAddImage @"add.png" // 添加按钮图片

@interface PictureSelectView ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIScrollView  *imagesScrolleview;
    // 标识被编辑的按钮 -1 为添加新的按钮
    NSInteger editTag;
    
    UIButton *addBtn;
    CGFloat  space;
    
//    NSMutableArray  *_allPicArray;
}
@end

@implementation PictureSelectView
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _allPicArray = [NSMutableArray array];
        
        imagesScrolleview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        imagesScrolleview.showsHorizontalScrollIndicator = NO;
        imagesScrolleview.delaysContentTouches = YES;
        [self addSubview:imagesScrolleview];
    
        if (KSCreenW == 320 ) {
            space = [UIView getHeight:5.0f];
        }else{
            space = [UIView getHeight:10.0f];
        }
        
        for (int i = 0; i< imagesScrolleview.subviews.count; i++) {
                    id  vi = imagesScrolleview.subviews[i];
                    NSLog(@"%@",[vi class]);
                }
    }
    return self;
}

//- (void)setIsHadCheck:(BOOL)isHadCheck
//{
//    _isHadCheck = isHadCheck;
//    if (!_isHadCheck) {
//        [self addSubviews];
//    }
//}
- (void)addSubviews
{
    
//   addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.height - [UIView getHeight:55.0f], [UIView getHeight:50.0f   ] , [UIView getHeight:50.0f])];
//    
//    addBtn.tag = 15151515;
//    [addBtn setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
//    [addBtn addTarget:self action:@selector(addPic) forControlEvents:UIControlEventTouchUpInside];
//    addBtn.center = CGPointMake(self.width / 2.0f, self.height - 60.0f);
//    [imagesScrolleview addSubview:addBtn];
    
}
- (void)drawRect:(CGRect)rect
{
   
    for (UIView *vi in imagesScrolleview.subviews) {
        if ([vi isKindOfClass:[UIButton class]]) {
            //
            if(vi.tag != 15151515){
                [vi removeFromSuperview];
            }
            
        }
    }
//    NSLog(@"重绘之前 删除scrllview的图片 子视图剩余%ld",imagesScrolleview.subviews.count);
   //将按到的图片 放到总图片数组里面
   
//#warning 子视图会重叠
//    NSLog(@"需要排布的图片个数===%ld",_allPicArray.count);
    //数组是AlAsset 资源
    //获得等比缩略图 原图的等比缩略图[asset aspectRatioThumbnail];
    //       缩略图是相册中每张照片的poster图  [asset thumbnail];
    
    for (int i = 0; i< _allPicArray.count; i++) {
        //        UIImage *chooseImage = [images[i] aspectRatioThumbnail];
        NSData *data =_allPicArray[i];
        UIImage *img = [UIImage imageWithData:data];
    
        UIButton *imageView = [[UIButton alloc] initWithFrame:CGRectMake((imageW + space) * i, 0, imageW, imageW)];
        imageView.tag = 1 + i;
        [imageView bringSubviewToFront:imagesScrolleview];
        [imageView setBackgroundImage:img forState:UIControlStateNormal];
//        imageView.backgroundColor = BlueColor;
        imageView.hidden = NO;
        [imageView addTarget:self action:@selector(clickTodelete:) forControlEvents:UIControlEventTouchUpInside];
        [imagesScrolleview addSubview:imageView];
        if (i == _allPicArray.count - 1) {
//            CGRect frame = addBtn.frame;
//            addBtn.frame = CGRectMake(imageView.maxX + 10, imageView.y, frame.size.width, frame.size.height);
            
            //            CGAffineTransform transfom = CGAffineTransformMakeTranslation(imageView.maxX + 10, imageView.y);
            //            addBtn.transform = transfom;
            //            if (addBtn.maxX > kScreenWidth) {
            //                CGRect rect = self.frame;
            //                rect.size.height +=
            //            }
            imagesScrolleview.contentSize = CGSizeMake(imageView.maxX + 10, 0);
        }
        
    }
    
 NSLog(@"view的子视图的个数%ld",imagesScrolleview.subviews.count);
//    for (int i = 0; i< _allPicArray.count   ; i++) {
////        NSLog(@"%@",_allPicArray[i]);
//    }
}
- (void)addPic
{
    if ([self.delegate respondsToSelector:@selector(addImage)]) {
        [self.delegate addImage];
    }
}
- (void)setImages:(NSMutableArray *)images
{
    _images = images;
//    addBtn.hidden = YES;
    
    NSLog(@"新照片加入之前 数组 中的个数 %ld",_allPicArray.count);
    for (int i = 0; i< self.images.count; i++) {
       
//        UIImage *ima = [UIImage imageWithCGImage:[self.images[i] fullResolutionImage]];
//        NSData *data = UIImageJPEGRepresentation(ima, 0.5);
        
    
//        if (_allPicArray.count < 6) {
            [_allPicArray addObject:self.images[i]];
//        }
        
    }
//    for (int i = 0; i< _allPicArray.count; i++) {
//        NSLog(@"所有图片的顺序 …%@",_allPicArray[i]);
//    }
    [self setNeedsDisplay];
//    NSLog(@"view的子视图的个数%ld",imagesScrolleview.subviews.count);
}
- (void)clickTodelete:(UIButton *)btn
{
    [btn removeFromSuperview];
//    NSLog(@"tag == %d",btn.tag);
    [_allPicArray removeObjectAtIndex:btn.tag - 1];
    [self setNeedsDisplay];
}

//- (void)setShowImages:(NSMutableArray *)showImages
//{
//    _showImages = showImages;
//    for (int i = 0; i< showImages.count; i++) {
//      //展示图片
//        
//        }
//           
//}
//- (UIButton *)createButtonWithImage:(id)imageNameOrImage andSeletor : (SEL)selector
// {
//        UIImage *addImage = nil;
//        if ([imageNameOrImage isKindOfClass:[NSString class]]) {
//            addImage = [UIImage imageNamed:imageNameOrImage];
//            }
//        else if([imageNameOrImage isKindOfClass:[UIImage class]])
//             {
//                    addImage = imageNameOrImage;
//                }
//        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//       [addBtn setImage:addImage forState:UIControlStateNormal];
//     [addBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
//      addBtn.tag = self.subviews.count;
//   
//      // 添加长按手势,用作删除.加号按钮不添加
//        if(addBtn.tag != 0)
//           {
//          UILongPressGestureRecognizer *gester = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
//            [addBtn addGestureRecognizer:gester];
//        }
//      return addBtn;
//     
//}
//
//- (void)longPress : (UIGestureRecognizer *)gester
//{
//    if (gester.state == UIGestureRecognizerStateBegan)
//    {
//        UIImageView *btn = (UIImageView *)gester.view;
//        
//        UIButton *dele = [UIButton buttonWithType:UIButtonTypeCustom];
//        dele.bounds = CGRectMake(0, 0, deleImageWH, deleImageWH);
////        [dele setImage:[UIImage imageNamed:kAdeleImage] forState:UIControlStateNormal];
//        dele.backgroundColor = BlueColor;
//        [dele addTarget:self action:@selector(deletePic:) forControlEvents:UIControlEventTouchUpInside];
//        dele.frame = CGRectMake(btn.frame.size.width - dele.frame.size.width, 0, dele.frame.size.width, dele.frame.size.height);
//        
//        [btn addSubview:dele];
//        [self start : btn];
//}
//}
//-(NSMutableArray *)images
//{
//    if (_images == nil) {
//        _images = [NSMutableArray array];
//    }
//    return _images;
//}
//
//- (void)changeOld:(UIButton *)btn
//{
//    // 标识为修改(tag为修改标识)
//    if (![self deleClose:btn]) {
//         editTag = btn.tag;
//        [self callImagePicker];
//   }
// }
//
//- (BOOL)deleClose:(UIButton *)btn
// {
//    if (btn.subviews.count == 2) {
//       [[btn.subviews lastObject] removeFromSuperview];
//        [self stop:btn];
//       return YES;
//    }
//
//    return NO;
// }
//
//- (void)callImagePicker
// {
//    UIImagePickerController *pc = [[UIImagePickerController alloc] init];
//     pc.allowsEditing = YES;
//    pc.delegate = self;
//     [self.window.rootViewController presentViewController:pc animated:YES completion:nil];
// }
//
////- (void)longPress : (UIGestureRecognizer *)gester
////{
////    if (gester.state == UIGestureRecognizerStateBegan)
////    {
////        UIButton *btn = (UIButton *)gester.view;
////        
////        UIButton *dele = [UIButton buttonWithType:UIButtonTypeCustom];
////        dele.bounds = CGRectMake(0, 0, deleImageWH, deleImageWH);
////        [dele setImage:[UIImage imageNamed:kAdeleImage] forState:UIControlStateNormal];
////        [dele addTarget:self action:@selector(deletePic:) forControlEvents:UIControlEventTouchUpInside];
////        dele.frame = CGRectMake(btn.frame.size.width - dele.frame.size.width, 0, dele.frame.size.width, dele.frame.size.height);
////        
////        [btn addSubview:dele];
////        [self start : btn];
////    }
////}
//
//- (void)start : (UIImageView *)btn {
//     double angle1 = -5.0 / 180.0 * M_PI;
//    double angle2 = 5.0 / 180.0 * M_PI;
//    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
//     anim.keyPath = @"transform.rotation";
//
//     anim.values = @[@(angle1),  @(angle2), @(angle1)];
//     anim.duration = 0.25;
//     // 动画的重复执行次数
//      anim.repeatCount = MAXFLOAT;
//  
//      // 保持动画执行完毕后的状态
//      anim.removedOnCompletion = NO;
//     anim.fillMode = kCAFillModeForwards;
//
//     [btn.layer addAnimation:anim forKey:@"shake"];
// }
//
//- (void)stop : (UIImageView *)btn{
//    [btn.layer removeAnimationForKey:@"shake"];
//  }

//- (void)deletePic : (UIButton *)btn
//{
//    [self.images removeObject:[(UIButton *)btn.superview imageForState:UIControlStateNormal]];
//    [btn.superview removeFromSuperview];
//    if ([[self.subviews lastObject] isHidden]) {
//        [[self.subviews lastObject] setHidden:NO];
//    }
//}
//
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
// {
//        UIImage *image = info[UIImagePickerControllerEditedImage];
//        if (editTag == -1) {
//                 // 创建一个新的控件
//                 UIButton *btn = [self createButtonWithImage:image andSeletor:@selector(changeOld:)];
//                [self insertSubview:btn atIndex:self.subviews.count - 1];
//                [self.images addObject:image];
//                if (self.subviews.count - 1 == MaxImageCount) {
//                        [[self.subviews lastObject] setHidden:YES];
//           
//                     }
//            }
//         else
//            {
//                    // 根据tag修改需要编辑的控件
//                    UIButton *btn = (UIButton *)[self viewWithTag:editTag];
//                    int index = [self.images indexOfObject:[btn imageForState:UIControlStateNormal]];
//                   [self.images removeObjectAtIndex:index];
//                [btn setImage:image forState:UIControlStateNormal];
//                    [self.images insertObject:image atIndex:index];
//          }
//     // 退出图片选择控制器
//     [picker dismissViewControllerAnimated:YES completion:nil];
//  }
@end
