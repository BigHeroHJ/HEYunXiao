//
//  SatusSelectViewController.h
//  Marketing
//
//  Created by HanenDev on 16/3/7.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StatusSelectDelegate <NSObject>

- (void)selectStatusWith:(NSString *)string withNum:(NSInteger)count withInt:(int)number;//数据字典value值

@end

@interface SatusSelectViewController : UIViewController
@property(nonatomic,strong)NSString  *itemTitle;
@property(nonatomic,strong)NSString  *valuetTitle;
@property(nonatomic,strong)NSMutableArray   *ar;

@property(nonatomic,assign)NSInteger num;
@property (nonatomic, weak) id <StatusSelectDelegate>delegate;
@end
