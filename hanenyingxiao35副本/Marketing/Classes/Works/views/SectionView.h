//
//  SectionView.h
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/31.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sectionViewDelegate <NSObject>

- (void)addBtnwithIndex:(UIButton *)btn;

@end

@interface SectionView : UIView
- (id)initWithFrame:(CGRect)frame withIndex:(NSInteger)index;
@property (nonatomic , retain) UILabel *visit;
@property (nonatomic , retain) UILabel *reportOne;
@property (nonatomic , retain) UILabel *reportTwo;
@property (nonatomic , retain) UILabel *reportOneNum;
@property (nonatomic , retain) UILabel *reportTwoNum;
@property (nonatomic , retain) UILabel *Num;
@property (nonatomic , retain) UILabel *NumBottom;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, assign) int isUp;
@property (nonatomic, strong) UIButton *btn ;

@property (nonatomic, weak) id<sectionViewDelegate>delegate;
@end
