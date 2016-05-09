//
//  MapLineCell.h
//  Marketing
//
//  Created by HanenDev on 16/3/8.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapButton.h"

@interface MapLineCell : UITableViewCell

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *subTitLab;

@property(nonatomic,strong)UIImageView * mileImage;
@property(nonatomic,strong)UILabel     * mileLabel;
@property(nonatomic,strong)UIImageView * timeImage;
@property(nonatomic,strong)UILabel     * timeLabel;
@property(nonatomic,strong)UIImageView * walkImage;
@property(nonatomic,strong)UILabel     * walkLabel;
@property(nonatomic,strong)MapButton    * xiaBtn;

@end
