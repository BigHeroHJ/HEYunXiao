//
//  ChartView.m
//  zhexian
//
//  Created by User on 16/3/11.
//  Copyright © 2016年 User. All rights reserved.
//

#import "ChartView.h"
#define WIDTH KSCreenW/320.0
#define HEIGHT KSCreenH/568.0

@interface ChartView ()
{
      NSArray *yyarr ;
    NSMutableArray *XpointArr;
    CGFloat   avgHeight;//每一个值得高度 ，根据最大值和最小值
    
    CGFloat    gridHeight;//整个列表的高度
    CGFloat    leftSpace;
    CGFloat    bottomSpace;
    CGFloat    avgGridheight;//每个格子的高度
    CGFloat    avgGridWidth;//每个格子的宽度
//    CGFloat  WIDTH;
//    CGFloat  HEIGHT;
}
@end

@implementation ChartView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"self的高度 %f",frame.size.height);
        XpointArr = [NSMutableArray array];
        gridHeight = [UIView getHeight:205.0f] - 5;
        leftSpace = 30 * WIDTH;
        bottomSpace = 20 * WIDTH;
        avgHeight = 0;
        avgGridheight = 0;
//        avgGridWidth = 0;
        for (UIView *v1 in self.subviews ) {
            [v1 removeFromSuperview];
        }
        avgGridWidth = 50 * WIDTH;
        [self addSubviews];
        
        
    }
       NSLog(@"self的高度 %f",frame.size.height);
    return self;
}

- (void)addSubviews
{
    self.backgroundColor=[UIColor colorWithRed:240/256.0 green:240/256.0 blue:240/256.0 alpha:1];
    
//    NSArray *xxarr = [NSArray arrayWithObjects:@"2/14",@"2/15",@"2/16",@"2/17",@"2/18",@"2/19",@"2/20",@"2/21",nil];
    
   
}
- (void)setYarr:(NSMutableArray *)yarr
{
    avgHeight = 0;
    avgGridheight = 0;
    _yarr = yarr;
       if (self.chooseType == 1) {
        yyarr = [NSArray arrayWithObjects:@"0",@"20",@"40",@"60",@"80",@"100",nil];
//        avgHeight = (gridHeight - bottomSpace)/ 100.0f;
    
        
    }else if (self.chooseType == 2){
        yyarr = [NSArray arrayWithObjects:@"0",@"10",@"20",@"30",@"40",@"50",nil];
//         avgHeight = (gridHeight - bottomSpace )/ 50.0f + 1.5;
    }else{
        yyarr = [NSArray arrayWithObjects:@"0",@"20",@"40",@"60",@"80",@"100",nil];
//          avgHeight = (gridHeight - bottomSpace)/ 100.0f;
    }
    avgGridheight = (gridHeight - bottomSpace) / (yyarr.count - 1);//根据纵坐标的个数 来计算每个竖的宽度
//NSLog(@"计算的时候格子的高度%f，每一个1 代表多少高度%f",avgGridheight,avgHeight);
    //        WIDTH = [UIView getWidth:50.0f];
    //        HEIGHT = self.height / yyarr
//    NSArray *reversedArr = [[yyarr reverseObjectEnumerator] allObjects];
    //纵坐标
//    for (int i = 0; i<yyarr.count; i++) {
//        UILabel *count = [[UILabel alloc] init];
//        count.backgroundColor = cyanFontColor;
//        count.center = CGPointMake(bottomSpace , avgGridheight*i);
//        count.bounds = CGRectMake(0, 0, 20*WIDTH, 10*HEIGHT);
//        count.font = [UIFont systemFontOfSize:11];
//        NSLog(@"y 坐标%@",reversedArr[i]);
//        count.textAlignment = NSTextAlignmentCenter;
//        count.text = [reversedArr objectAtIndex:i];
//        count.textColor = [UIColor colorWithWhite:0.85 alpha:0.8];
//        [self addSubview:count];
//    }
}
- (void)setXarr:(NSMutableArray *)xarr
{
    _xarr = xarr;
    
    //横坐标
  
    
}
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    NSLog(@"self.choosetype %d",self.chooseType);
    if (self.chooseType == 1) {
//        yyarr = [NSArray arrayWithObjects:@"0",@"20",@"40",@"60",@"80",@"100",nil];
        avgHeight = (self.height - bottomSpace)/ 100.0f;
        
        
    }else if (self.chooseType == 2){
//        yyarr = [NSArray arrayWithObjects:@"0",@"10",@"20",@"30",@"40",@"50",nil];
        avgHeight = (self.height - bottomSpace )/ 50.0f;
    }else if(self.chooseType == 3){
//        yyarr = [NSArray arrayWithObjects:@"0",@"20",@"40",@"60",@"80",@"100",nil];
        avgHeight = (self.height - bottomSpace)/ 100.0f;
    }
    avgGridheight = (self.height - bottomSpace) / (yyarr.count - 1);//根据纵坐标的个数 来计算每个竖的宽度
    NSLog(@"计算的时候格子的高度%f，每一个1 代表多少高度%f",avgGridheight,avgHeight);

    NSArray *reversedArr = [[yyarr reverseObjectEnumerator] allObjects];
    //纵坐标
   //    NSMutableArray *YYarr = [NSMutableArray arrayWithObjects:@"82",@"68",@"84",@"62",@"67",@"64",@"85",@"81", nil];
     for (int i = 0; i<self.xarr.count; i++) {
     
         CGPoint point = CGPointMake(leftSpace + avgGridWidth * i , self.height - bottomSpace / 2.0f);
         [XpointArr addObject:@(point.x)];//计算数组里有值得点的横坐标
     
     }
    for (UIImageView *v1 in self.subviews) {
        [v1 removeFromSuperview];
    }
    NSLog(@"self高度 %f",self.height);
//
//    if(_xarr.count != 0 || _yarr.count != 0){
        CGContextRef context = UIGraphicsGetCurrentContext();
        //
        CGContextSetLineWidth(context, 2*HEIGHT);
        //
        CGContextSetStrokeColorWithColor(context, [UIColor purpleColor].CGColor);
        //
        CGContextMoveToPoint(context, leftSpace, self.height - bottomSpace -([_yarr.firstObject integerValue])*avgHeight + 1);//折线的起点 就y数组的第一个点
        //
        //    NSLog(@"xArr  yArr%ld",_yarr.count);
        //
        
        for (int i = 0; i < _yarr.count ; i ++) {
            //折线节点图片
//                    NSLog(@"y数组对应得数组在纵坐标上的高度：%f",[_yarr[i] doubleValue ]*avgHeight);
            UIImageView *image = [[UIImageView alloc] init];
            image.center = CGPointMake(([[XpointArr objectAtIndex:i] integerValue]), self.height - bottomSpace -([[_yarr objectAtIndex:i] integerValue])*avgHeight);
            
            image.bounds = CGRectMake(0, 0, 8*WIDTH, 8*WIDTH);
            image.image = [UIImage imageNamed:@"dot2.png"];
            [self addSubview:image];
            
            //添加每个点的数值
            UILabel *count = [[UILabel alloc] init];
            count.text = [_yarr objectAtIndex:i];
            count.center = CGPointMake((image.center.x), (image.center.y-15));
            if (image.center.y - 15 < 0) {
                count.center = CGPointMake((image.center.x), (image.center.y + 15));
            }else{
                count.center = CGPointMake((image.center.x), (image.center.y-15));
            }
            count.bounds = CGRectMake(0, 0, 20*WIDTH, 10*HEIGHT);
            count.font = [UIFont systemFontOfSize:11];
            count.textAlignment = NSTextAlignmentCenter;
            count.textColor = [UIColor purpleColor];
            [self addSubview:count];
            
            //画折线
//                    NSLog(@"xpoint 坐标%ld",[[XpointArr objectAtIndex:i] integerValue]);
            CGContextAddLineToPoint(context, ([[XpointArr objectAtIndex:i] integerValue]), self.height - bottomSpace - ([[_yarr objectAtIndex:i] integerValue])*avgHeight);
            //        CGContextAddLineToPoint(context, image.center.x, image.center.y);
//            CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:210.0f/255.0f green:197.0f/255.0f blue:236.0f/255.0f alpha:1].CGColor);
            
        }
         CGContextStrokePath(context);
    
//    if(_yarr.count != 0){
//        CGContextStrokePath(context);
//        //折线填充区域
        CGContextRef context1 = UIGraphicsGetCurrentContext();
        CGContextMoveToPoint(context1, leftSpace,2*HEIGHT);
        CGContextSetLineWidth(context1, 0);
        for (int i = 0; i < _yarr.count ; i ++) {
//            NSLog(@"%f",[_yarr[i] doubleValue]);
            CGContextAddLineToPoint(context1, ([[XpointArr objectAtIndex:i] integerValue]), self.height -bottomSpace - ([[_yarr objectAtIndex:i] integerValue])*avgHeight);
        }
        int num;
        if (_yarr.count != 0) {
            num = (int)_yarr.count - 1;
        }else{
            num = 0;
        }
        CGContextAddLineToPoint(context1, ([XpointArr[num] integerValue]), self.height -bottomSpace);
        CGContextAddLineToPoint(context1, leftSpace, self.height -bottomSpace);
        CGContextAddLineToPoint(context1, leftSpace, self.height - bottomSpace - ([[_yarr firstObject] integerValue])*avgHeight);
        
        [[UIColor colorWithRed:210.0f/255.0f green:197.0f/255.0f blue:236.0f/255.0f alpha:1] setFill];
        CGContextFillPath(context1);
        CGContextStrokePath(context1);



    
        //画横线
        for (int i = 0; i < yyarr.count; i ++) {
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            CGContextSetLineWidth(context, 1*HEIGHT);
            
            CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.85 alpha:0.8].CGColor);
            //        NSLog(@"画横线的时候格子的高度%f",avgGridheight);
            CGContextMoveToPoint(context, leftSpace, avgGridheight * i);
            
            CGContextAddLineToPoint(context, (avgGridWidth*XpointArr.count+bottomSpace), (avgGridheight*i));
            CGContextStrokePath(context);
        }
        
        //画竖线
        for (int i = 0; i < XpointArr.count; i ++) {
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            CGContextSetLineWidth(context, 1*HEIGHT);
            
            CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.85 alpha:0.8].CGColor);
            
            CGContextMoveToPoint(context, [XpointArr[i] doubleValue], 0);
            
            CGContextAddLineToPoint(context, [XpointArr[i] doubleValue], self.height - bottomSpace);
            CGContextStrokePath(context);
        }

//    }
    for (int i = 0; i<yyarr.count; i++) {
        UILabel *count = [[UILabel alloc] init];
//        count.backgroundColor = cyanFontColor;
                count.center = CGPointMake( leftSpace / 2.0f, avgGridheight*i + 3);
//        count.center = CGPointMake(10, avgGridheight * i);
        count.bounds = CGRectMake(0, 0, 20*WIDTH, 10*HEIGHT);
        count.font = [UIFont systemFontOfSize:11];
        NSLog(@"y 坐标%@",reversedArr[i]);
        count.textAlignment = NSTextAlignmentCenter;
        count.text = [reversedArr objectAtIndex:i];
        count.textColor = [UIColor lightGrayColor];
        [self addSubview:count];
    }
    //横坐标
    for (int i = 0; i<self.xarr.count; i++) {
        UILabel *date = [[UILabel alloc] init];
//        date.backgroundColor = cyanFontColor;
        CGPoint point = CGPointMake(leftSpace + avgGridWidth * i , self.height - bottomSpace / 2.0f);
//         [XpointArr addObject:@(point.x)];//计算数组里有值得点的横坐标
        date.center = point;
        date.bounds = CGRectMake(0, 0, 30*WIDTH, 10*HEIGHT);
        date.font = [UIFont systemFontOfSize:11];
        date.textAlignment = NSTextAlignmentCenter;
        date.text = [_xarr objectAtIndex:i];
        date.textColor =[UIColor lightGrayColor];
        //        date.backgroundColor = [UIColor redColor];
       
        //        NSLog(@"横坐标的x %f",point.x);
        [self addSubview:date];
    }

}

@end
