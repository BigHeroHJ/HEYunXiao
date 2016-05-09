//
//  SelectPersonView.m
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/29.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "SelectPersonView.h"
#import "UserModel.h"
#define imageW [UIView getWidth:40] // 图片宽度

@interface SelectPersonView ()
{
    UIScrollView  *imagesScrolleview;
    // 标识被编辑的按钮 -1 为添加新的按钮
    NSInteger editTag;
    
    UIButton *addBtn;
    CGFloat  space;
    
}
@end

@implementation SelectPersonView


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //sdfds
        _allPersonArray = [NSMutableArray array];
        [_allPersonArray removeAllObjects];
        imagesScrolleview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
//        imagesScrolleview.backgroundColor = blueFontColor;
        imagesScrolleview.showsHorizontalScrollIndicator = NO;
//        imagesScrolleview.delaysContentTouches = YES;
        [self addSubview:imagesScrolleview];
        
        if (KSCreenW == 320 ) {
            space = [UIView getHeight:5.0f];
        }else{
            space = [UIView getHeight:10.0f];
        }
        [self addSubviews];
//        for (int i = 0; i< imagesScrolleview.subviews.count; i++) {
//            id  vi = imagesScrolleview.subviews[i];
//            NSLog(@"%@",[vi class]);
//        }
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    
    for (UIView *vi in imagesScrolleview.subviews) {
        if ([vi isKindOfClass:[UIButton class]]) {
            //
            if(vi.tag != 161616){
                [vi removeFromSuperview];
            }
            
        }
    }
   
    
   
    NSLog(@"总人数租里面个数%ld",_allPersonArray.count);
    for (int i = 0; i< _allPersonArray.count; i++) {
        //        UIImage *chooseImage = [images[i] aspectRatioThumbnail];
        UserModel *model = _allPersonArray[i];
        UIImage *image = [self imageFromURLString:[NSString stringWithFormat:@"%@%@",LoadImageUrl,model.logo]];
        NSLog(@"选择的人的名字%@",model.name);
        UIButton *imageView = [[UIButton alloc] initWithFrame:CGRectMake((imageW + space) * i, 0, imageW, imageW)];
        imageView.tag = 313131 + i;
        [imageView bringSubviewToFront:imagesScrolleview];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LoadImageUrl,model.logo]]];
        
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, imageView.width, imageView.height)];
//        btn.backgroundColor = [UIColor redColor];
//        [imageView addSubview:btn];
        [imageView addTarget:self action:@selector(clickTodelete1:) forControlEvents:UIControlEventTouchUpInside];
        
        [imageView setBackgroundImage:image forState:UIControlStateNormal];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LoadImageUrl,model.logo]] forState:UIControlStateNormal];
        //        imageView.backgroundColor = BlueColor;
        imageView.hidden = NO;
//        [imageView addTarget:self action:@selector(clickTodelete:) forControlEvents:UIControlEventTouchUpInside];
        [imagesScrolleview addSubview:imageView];
        if (i == _allPersonArray.count - 1) {
                        CGRect frame = addBtn.frame;
                        addBtn.frame = CGRectMake(imageView.maxX + 10, imageView.y, frame.size.width, frame.size.height);
            
//                        CGAffineTransform transfom = CGAffineTransformMakeTranslation(imageView.maxX + 10, imageView.y);
//                        addBtn.transform = transfom;
            
            imagesScrolleview.contentSize = CGSizeMake(addBtn.maxX + 10, 0);
        }
    
    }
    if(_allPersonArray.count == 0 ){
        addBtn.frame = CGRectMake(5,5,imageW,imageW);
    }
//    NSLog(@"view的子视图的个数%ld",imagesScrolleview.subviews.count);
    //    for (int i = 0; i< _allPicArray.count   ; i++) {
    ////        NSLog(@"%@",_allPicArray[i]);
    //    }
}

- (void)setPersonArray:(NSArray *)personArray
{
//    for (int i = 0; i< _allPersonArray.count; i++) {
//         UserModel *mo = personArray[i];
//         NSLog(@"_allPersonArray.count%ld",_allPersonArray.count);
//        NSLog(@"加入之前数组里的是什么%@",_allPersonArray[i]);
//         NSLog(@"加入之前数组里的是什么%@",mo.name);
//    }
    NSLog(@"加入之前的%ld",_allPersonArray.count);
    _personArray = personArray;
//    for (UserModel *model in personArray) {
//        [_logoArray addObject:model.logo];
//        NSLog(@"数组赋值的时候人名%@",model.name);
//    }
    
    for (int i = 0; i< personArray.count; i++) {
        UserModel *mo = personArray[i];
         NSLog(@"数组赋值的时候 打印选择的人名%@",mo.name);
        [_allPersonArray addObject:mo];
        NSLog(@"人加入后的个数有%ld",_allPersonArray.count);
    }
    NSLog(@"人加入完毕的个数有%ld",_allPersonArray.count);
    [self setNeedsDisplay];
}

- (void)addPic
{
    if ([self.delegate respondsToSelector:@selector(addPerson)]) {
        [self.delegate addPerson];
    }
}
- (void)addSubviews
{
    
       addBtn = [[UIButton alloc] initWithFrame:CGRectMake(5,5,imageW,imageW)];
    
        addBtn.tag = 161616;
        [addBtn setImage:[UIImage imageNamed:@"添加人员"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addPic) forControlEvents:UIControlEventTouchUpInside];
//        addBtn.center = CGPointMake(self.width / 2.0f, self.height - 60.0f);
        [imagesScrolleview addSubview:addBtn];
    
}
- (void)clickTodelete1:(UIButton *)btn
{
    [btn removeFromSuperview];
    NSLog(@"tag == %d",btn.tag);
    [_allPersonArray removeObjectAtIndex:btn.tag - 313131];
    [self setNeedsDisplay];
}
- (UIImage *) imageFromURLString: (NSString *) urlstring
{
             // This call is synchronous and blocking
             return [UIImage imageWithData:[NSData
                                            dataWithContentsOfURL:[NSURL URLWithString:urlstring]]];
}

@end
