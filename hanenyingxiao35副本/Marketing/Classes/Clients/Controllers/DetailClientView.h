//
//  DetailClientView.h
//  Marketing
//
//  Created by HanenDev on 16/3/1.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolButton.h"

@protocol DetailClientViewDelegate <NSObject>

- (void)changeDetailClientView:(NSInteger)tag;

@end
@interface DetailClientView : UIView

@property(nonatomic,strong)ToolButton *detailBtn;
@property(nonatomic,strong)ToolButton *visitBtn;
@property(nonatomic,weak)id<DetailClientViewDelegate>delegate;
@end
