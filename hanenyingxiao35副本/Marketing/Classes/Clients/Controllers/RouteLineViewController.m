//
//  RouteLineViewController.m
//  Marketing
//
//  Created by HanenDev on 16/3/8.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "RouteLineViewController.h"

#define  ROUND 8.0f
#define STARTX [UIView getWidth:20]

@interface RouteLineViewController ()
{
     UITableView * _tableView;
}
@end

@implementation RouteLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:@"地图详情"];
    self.navigationItem.leftBarButtonItem=[ViewTool getBarButtonItemWithTarget:self WithAction:@selector(goToBack)];
    
    [self createView];
}
- (void)createView{
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, KSCreenH-self.height) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
    
    
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, 50)];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(STARTX, 16, 18, 18)];
    imageView.image=[UIImage imageNamed:@"起点&终点"];
    //imageView.backgroundColor= [UIColor redColor];
    [headerView addSubview:imageView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(imageView.maxX+5, 5, KSCreenW-imageView.maxX, 40)];
    label.text=[NSString stringWithFormat:@"起点 (%@)",self.startStr];
    [headerView addSubview:label];
    _tableView.tableHeaderView=headerView;
    
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, 50)];
    UIImageView *picView=[[UIImageView alloc]initWithFrame:CGRectMake(STARTX, 16, 18, 18)];
    picView.image=[UIImage imageNamed:@"起点&终点"];
    //picView.backgroundColor= [UIColor blueColor];
    [footerView addSubview:picView];
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(picView.maxX+5, 5, KSCreenW-imageView.maxX, 40)];
    lab.text=[NSString stringWithFormat:@"终点 (%@)",self.endStr];
    [footerView addSubview:lab];
    
//    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(KSCreenW - STARTX-20, 21, 14, 8)];
//    [button setImage:[UIImage imageNamed:@"下拉收回"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(clickToHide:) forControlEvents:UIControlEventTouchUpInside];
//    [footerView addSubview:button];
    
    
    _tableView.tableFooterView=footerView;
}
- (void)clickToHide:(UIButton *)btn{
    
    if ([self.delegate respondsToSelector:@selector(getToHide:)]) {
        [self.delegate getToHide:btn];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.routeArray.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *content=[self.routeArray[indexPath.row] instruction];
    CGFloat height=[self getHeightByString:content withFont:[UIFont systemFontOfSize:15.0f]];
    
    return height+20.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UIView * view=[[UIView alloc]init];
        view.tag=1000;
        view.backgroundColor=[UIColor greenColor];
        [cell addSubview:view];
        
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.tag = 3000;
        [cell addSubview:imgView];
        
        UILabel *label=[[UILabel alloc]init];
        label.tag=2000;
        [cell addSubview:label];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    UILabel *label=[cell viewWithTag:2000];
    NSString *content=[self.routeArray[indexPath.row] instruction];
    label.text=content;
    label.numberOfLines=0;
    label.font=[UIFont systemFontOfSize:15.0f];
    CGFloat height=[self getHeightByString:content withFont:[UIFont systemFontOfSize:15.0f]];
    label.frame=CGRectMake(STARTX + 20+5, 10, KSCreenW-70, height);
    
    UIImageView *imageV = [cell viewWithTag:3000];
    if (self.result == 1) {
        if (indexPath.row == 0 || indexPath.row == self.routeArray.count - 1) {
            imageV.frame = CGRectMake(STARTX, 0, 20 , label.height +20);
            imageV.image = [UIImage imageNamed:@"点"];
            //imageV.backgroundColor = [UIColor redColor];
        }else{
            imageV.frame = CGRectMake(STARTX +9, 0, 2, label.height + 20);
            imageV.backgroundColor = blueFontColor;
        }
    }else{
    imageV.frame = CGRectMake(STARTX +9, 0, 2, label.height + 20);
    imageV.backgroundColor = blueFontColor;
    }
//    if(self.result == 1){
//        BMKTransitStep* transitStep = [self.routeArray objectAtIndex:indexPath.row];
//        if (transitStep.stepType==BMK_WAKLING)
//        {
//            imageV.frame = CGRectMake(STARTX + 9, 0, 2, label.height +20);
//            imageV.image = [UIImage imageNamed:@"点"];
//            
//            //            UIImageView *ima;
//            //            imageV.transform=CGAffineTransformMakeRotation(M_PI);
//            
//        }else{
//            imageV.frame = CGRectMake(STARTX +9, 0, 2, label.height + 20);
//            imageV.backgroundColor = [UIColor colorWithRed:143/255 green:217/255 blue:223/255 alpha:0.6];
//        }
//    }
    
    
    
//    UIView *view=[cell viewWithTag:1000];
//    view.frame=CGRectMake(label.x/2, label.centerY, ROUND, ROUND);
//    view.layer.cornerRadius=ROUND/2.0f;
//    view.layer.masksToBounds=YES;
    
    //    cell.textLabel.text=[[self.routeArray objectAtIndex:indexPath.row] instruction];
    //    cell.textLabel.numberOfLines=0;
    
    return cell;
}

-(CGFloat)getHeightByString:(NSString*)string   withFont:(UIFont*)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(KSCreenW-50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return size.height ;
    
}

- (void)goToBack{
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = NO;
}
- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
