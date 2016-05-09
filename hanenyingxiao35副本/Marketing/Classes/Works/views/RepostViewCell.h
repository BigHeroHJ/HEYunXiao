//
//  RepostViewCell.h
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/31.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepostViewCell : UITableViewCell

+ (CGFloat)cellHeight;
+ (instancetype)cellWithTableView:(UITableView *)tableView WithIndex:(NSInteger)Index;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *XArr;
@property (nonatomic, strong) NSMutableArray *YArr;

@property (nonatomic, assign) int type; // 0 1 2

@property (nonatomic, assign) int indexssss;
@end
