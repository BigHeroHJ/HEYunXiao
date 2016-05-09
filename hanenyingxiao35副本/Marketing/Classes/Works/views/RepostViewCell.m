//
//  RepostViewCell.m
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/31.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "RepostViewCell.h"
#import "ChartView.h"
#define WIDTH KSCreenW/320.0
#define HEIGHT KSCreenH/568.0

@interface RepostViewCell ()<UIScrollViewDelegate>
{
    ChartView  *zhe;
    UIScrollView *scrollview;
}
@end

@implementation RepostViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (CGFloat)cellHeight
{
    return 200.0f;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView WithIndex:(NSInteger)Index
{
//    static NSString  *noticeCellId = @"RepostViewCell";
    
//    RepostViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noticeCellId];
    
//    if (!cell) {
     RepostViewCell *    cell = [[RepostViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        //        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:.1];
        cell.backgroundColor = [UIColor whiteColor];
        [cell addSubviewsWithINdexi:Index];
//    }
    
    return cell;
}

- (void)addSubviewsWithINdexi:(NSInteger)Index
{
    if(scrollview){
        [scrollview removeFromSuperview];
        [zhe removeFromSuperview];
    }
    _XArr = [NSMutableArray array];
    _YArr = [NSMutableArray array];
    [_XArr removeAllObjects];
    [_YArr removeAllObjects];
    
    scrollview = [[UIScrollView alloc] init];
    scrollview.backgroundColor = graySectionColor;
    scrollview.delegate = self;
    //    scrollview.bounces = NO;
    scrollview.showsHorizontalScrollIndicator = NO;
  
    [self.contentView addSubview:scrollview];
    
//    if(_Yarr.count != 0 ){
//        scrollview.contentOffset = CGPointMake(30 * WIDTH + _Yarr.count*50 *WIDTH - KSCreenW , 0);
//    }
//    zhe = [[ChartView alloc] initWithFrame:CGRectMake1(0, 5, 30+50 * WIDTH*_Xarr.count +5, 200)];
    
    zhe = [[ChartView alloc] init];
    if(Index == 0){
        zhe.chooseType = 1;
    }else if (Index == 1){
        zhe.chooseType = 2;
    }else if (Index == 2){
        zhe.chooseType = 3;
    }
//    zhe.chooseType = 3; //设置了三种 y的标记
//    zhe.xarr = _Xarr;
//    zhe.yarr = _Yarr;
    
    [scrollview addSubview:zhe];
    
//    [zhe setNeedsDisplay];
}
- (void)setDataArray:(NSArray *)dataArray
{
//    if(self.indexssss == 0){
//        zhe.chooseType = 1;
//    }else if (self.indexssss == 1){
//        zhe.chooseType = 2;
//    }else if (self.indexssss == 2){
//        zhe.chooseType = 3;
//    }
    _dataArray = dataArray;
    if(_XArr.count){
        [_XArr removeAllObjects];
    }
    if (_YArr.count) {
        [_YArr removeAllObjects];
    }
    NSLog(@"传来的数组的个数%d",dataArray.count);
//    for (int i = 0; i < dataArray.count; i++) {
//        NSDictionary *dict = dataArray[i];
//        NSLog(@"cell 图标的 数据 %@",dataArray[i]);
//        [_XArr addObject:[NSString stringWithFormat:@"%@",dict[@"time"]]];
//        [_YArr addObject:[NSString stringWithFormat:@"%@",dict[@"count"]]];
//        //        _Yarr = [NSMutableArray arrayWithObjects:@"30",@"50",@"20",@"70",@"50",@"65",@"20",@"35", nil];
//    }
    //    _Xarr = [NSMutableArray arrayWithArray:dateArray];
    //      _Yarr = [NSMutableArray arrayWithObjects:@"30",@"50",@"20",@"70",@"50",@"65",@"20",@"35", nil];
    int today;
    NSDate *date = [NSDate date];
    NSString * currentMonth = [DateTool getMonth:date];
    NSString *currentday = [DateTool getDay:date];
    today = [currentday intValue];
    
    for (int i = 0; i < dataArray.count; i++) {
        NSString * dateS = [NSString stringWithFormat:@"%@/%@",currentMonth,dataArray[i][@"time"]];
        [_XArr addObject:dateS];
        
          [_YArr addObject:[NSString stringWithFormat:@"%@",dataArray[i][@"count"]]];
//        NSLog(@"%@",dateS);
    }
      NSLog(@"全部复制完:%lu,%lu",(unsigned long)_XArr.count,(unsigned long)_YArr.count);
//    if (_XArr.count == 0) {
//        NSRange dayCount = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]];
//        //            if (_Xarr.count == 0) {
//        NSString *monthStr = [DateTool getMonth:[NSDate date]];
//        for (int i = 0; i< dayCount.length; i++) {
//            [_XArr addObject:[NSString stringWithFormat:@"%@/%d",monthStr,i + 1]];
//        }
//        
//    }
//    NSLog(@"全部复制完:%lu,%lu",(unsigned long)_XArr.count,(unsigned long)_YArr.count);
    zhe.xarr = _XArr;
    zhe.yarr = _YArr;
    zhe.frame = CGRectMake(0, 0, 30 * WIDTH+50 * WIDTH*_XArr.count, 200);
    scrollview.frame = CGRectMake(0, 0, KSCreenW, zhe.height + 5);
//    NSLog(@"%@",NSStringFromCGRect(scrollview.frame));
  scrollview.contentSize = CGSizeMake(zhe.frame.size.width+5, 0);
    [zhe setNeedsDisplay];
    
}

- (void)setType:(int)type
{
    _type = type;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

CG_INLINE CGRect
CGRectMake1(CGFloat x,CGFloat y,CGFloat width,CGFloat height)
{
    //创建appDelegate 在这不会产生类的对象,(不存在引起循环引用的问题)
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    //计算返回
    return CGRectMake(x * app.autoSizeScaleX, y * app.autoSizeScaleY, width * app.autoSizeScaleX, height * app.autoSizeScaleY);
}

@end
