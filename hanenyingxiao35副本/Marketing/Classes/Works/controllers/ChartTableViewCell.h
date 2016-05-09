//
//  ChartTableViewCell.h
//  Marketing
//
//  Created by User on 16/3/11.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartTableViewCell : UITableViewCell

@property (nonatomic , retain) UILabel *visit;
@property (nonatomic , retain) UILabel *reportOne;
@property (nonatomic , retain) UILabel *reportTwo;
@property (nonatomic , retain) UILabel *reportOneNum;
@property (nonatomic , retain) UILabel *reportTwoNum;
@property (nonatomic , retain) UILabel *Num;
@property (nonatomic , retain) UILabel *NumBottom;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, assign) BOOL isUp;
@end
