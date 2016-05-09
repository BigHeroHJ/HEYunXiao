//
//  MapDetailViewController.m
//  Marketing
//
//  Created by HanenDev on 16/3/8.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "MapDetailViewController.h"
#import "MapLineCell.h"
#import "RouteLineViewController.h"
#import "MapButton.h"

#define STARTX [UIView getWidth:20]
#define ROWH 60

@interface MapDetailViewController ()<RouteLineDelegate>
{
    BOOL  _isChange;
}
@end

@implementation MapDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:@"客户地图"];
    self.navigationItem.leftBarButtonItem=[ViewTool getBarButtonItemWithTarget:self WithAction:@selector(goToBack)];
    
    //初始化检索对象
    _geoSearcher =[[BMKGeoCodeSearch alloc]init];
    //初始化路径检索
    _routeSearch=[[BMKRouteSearch alloc]init];
    
    _isChange = NO;
    
    [self initViews];
    [self createTableView];
    
    
}

//设置代理
-(void)viewWillAppear:(BOOL)animated
{
    _routeSearch.delegate=self;
    _geoSearcher.delegate = self;
    self.tabBarController.hidesBottomBarWhenPushed = YES;
}

//代理不用时，置为nil
-(void)viewWillDisappear:(BOOL)animated
{
    _routeSearch.delegate=nil;
    _geoSearcher.delegate = nil;
    self.tabBarController.hidesBottomBarWhenPushed = NO;

}

- (void)initViews{
    
    
    UIView  *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KSCreenW, 110)];
    bgView.backgroundColor = graySectionColor;
    [self.view addSubview:bgView];
    
    UIImageView *bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"背景"]];
    bgImage.frame = CGRectMake(0, 0, KSCreenW, [UIView getHeight:110]);
    [bgView addSubview:bgImage];
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(STARTX, 15, 20, 20)];
    imageView1.image = [UIImage imageNamed:@"我的位置1"];
    [bgView addSubview:imageView1];
    
    _myLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView1.maxX+15, 10, KSCreenW-imageView1.maxX-15 - STARTX, 30)];
    _myLabel.text = @"我的位置";
    _myLabel.textColor = blackFontColor;
    [bgView addSubview:_myLabel];
    
    UIView  *lineView = [ViewTool getLineViewWith:CGRectMake(imageView1.maxX+15, _myLabel.maxY + 15, KSCreenW-imageView1.maxX-15 - STARTX - 15-10, 1) withBackgroudColor:[UIColor colorWithRed:172/255.0f green:172/255.0f blue:172/255.0f alpha:1]];
    
    [bgView addSubview:lineView];
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(STARTX, imageView1.maxY+10, 20, 20)];
    imageView2.image = [UIImage imageNamed:@"点"];
    [bgView addSubview:imageView2];
    
    UIImageView *imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(STARTX, imageView2.maxY+10, 20, 20)];
    imageView3.image = [UIImage imageNamed:@"华泰证劵 目的地"];
    [bgView addSubview:imageView3];
    
    _addrLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView1.maxX+15, lineView.maxY + 15, KSCreenW-imageView1.maxX-15 - STARTX, 30)];
    _addrLabel.text = _districtStr;
    _addrLabel.textColor = grayFontColor;
    [bgView addSubview:_addrLabel];
    
    
    //地理编码
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geoCodeSearchOption.city= self.cityStr;
    geoCodeSearchOption.address = _addrLabel.text;
    BOOL flag = [_geoSearcher geoCode:geoCodeSearchOption];
    if(flag){
        NSLog(@"geo检索发送成功");
    }else{
        NSLog(@"geo检索发送失败");
    }
    
    MapButton *changeButton = [[MapButton alloc]initWithFrame:CGRectMake(KSCreenW -15 - STARTX, 45, 20, 20)];
    [changeButton setImage:[UIImage imageNamed:@"切换"] forState:UIControlStateNormal];
    changeButton.isSelect = NO;
    [changeButton addTarget:self action:@selector(addrChangedClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:changeButton];
    
    UIView *carView = [[UIView alloc]initWithFrame:CGRectMake(0, bgView.maxY, KSCreenW, 50)];
    carView.tag = 1230;
    [self.view addSubview:carView];
    UIImageView *carImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"背景2"]];
    carImage.frame = CGRectMake(0, 0, KSCreenW, 50);
    [carView addSubview:carImage];
    
    UIImageView *whiteImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Arrow"]];
    whiteImg.tag = 10010;
    whiteImg.hidden = YES;
    [carView addSubview:whiteImg];
    
    
    NSArray * titleArray=@[@"步行",@"公交",@"驾车"];
    //NSArray *imageArr = @[@"步行enter",@"公交enter",@"驾车enter"];
    
    for (int i=0; i<titleArray.count; i++)
    {
        CGFloat btnW = 50;
        CGFloat space = (KSCreenW - 2*STARTX - 3*btnW)/2;
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(STARTX +(btnW + space)*i, 0, btnW, 50)];
        [btn setImage:[UIImage imageNamed:titleArray[i]] forState:UIControlStateNormal];
        //[btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateSelected];
        btn.tag=1000+i;
        [btn addTarget:self action:@selector(searLine:) forControlEvents:UIControlEventTouchUpInside];
        [carView addSubview:btn];
    }
    _lastTag = 1000;
//    UIButton *btn = (UIButton *)[carView viewWithTag:_lastTag];
//    [btn setBackgroundImage:[UIImage imageNamed:imageArr[_lastTag - 1000]] forState:UIControlStateNormal];
    
}
- (void)createTableView{
    
    UIView *view=[self.view viewWithTag:1230];
    _walkTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, view.maxY, KSCreenW, KSCreenH-view.maxY)];
    _walkTableView.delegate=self;
    _walkTableView.dataSource=self;
    _walkTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _busTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, view.maxY, KSCreenW, KSCreenH-view.maxY)];
    _busTableView.delegate=self;
    _busTableView.dataSource=self;
    _busTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    _carTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, view.maxY, KSCreenW, KSCreenH-view.maxY)];
    _carTableView.delegate=self;
    _carTableView.dataSource=self;
    _carTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void)addrChangedClick:(MapButton *)sender{
    if (sender.isSelect == NO) {
        _isChange = YES;
        
        _myLabel.text = _districtStr;
        _addrLabel.text = @"我的位置";
        sender.isSelect = YES;
        
        
    }else{
        _isChange = NO;
        
        _myLabel.text = @"我的位置";
        _addrLabel.text = _districtStr;
        sender.isSelect = NO;
    }
    
}

- (void)searLine:(UIButton *)sender{
    
    UIImageView *imag = [self.view viewWithTag:10010];
    imag.hidden = NO;
    imag.center = CGPointMake(sender.centerX, sender.centerY +25-3);
    imag.bounds = CGRectMake(0, 0, 12, 8);
    
    NSArray * titleArray=@[@"步行",@"公交",@"驾车"];
    NSArray *imageArr = @[@"步行enter",@"公交enter",@"驾车enter"];
    UIButton *btn = (UIButton *)[self.view viewWithTag:_lastTag];
    [btn setImage:[UIImage imageNamed:titleArray[_lastTag - 1000]] forState:UIControlStateNormal];
    
    long count  = sender.tag - 1000;
    [sender setImage:[UIImage imageNamed:imageArr[count]] forState:UIControlStateNormal];
    
    _lastTag = (int)sender.tag;
    
    
    CLLocationCoordinate2D  coordinate1;
    CLLocationCoordinate2D  coordinate2;
    if (_isChange == NO) {
        coordinate1 = self.myLocation;
        coordinate2 = location;
        NSLog(@"%f ++++------%f",coordinate1.latitude,coordinate2.latitude);
    }else{
        coordinate1 = location;
        coordinate2 = self.myLocation;
        NSLog(@"%f ------++++++++ %f",coordinate1.latitude,coordinate2.latitude);
    }if(sender.tag-1000 == 0){
        
        [self.view addSubview:_walkTableView];
        
        BMKPlanNode* start = [[BMKPlanNode alloc]init];
        start.pt = coordinate1;
        start.cityName = self.cityStr;
        BMKPlanNode* end = [[BMKPlanNode alloc]init];
        if (!location.longitude && !location.latitude) {
            end.pt= self.endCoordinate;
            end.cityName = self.cityStr;
        }else{
            end.pt= coordinate2;
            end.cityName = self.cityStr;
        }
       
        BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
        walkingRouteSearchOption.from = start;
        walkingRouteSearchOption.to = end;
        BOOL flag = [_routeSearch walkingSearch:walkingRouteSearchOption];
        if(flag){
            NSLog(@"walk检索发送成功");
        }else{
            NSLog(@"walk检索发送失败");
        }

    }if (sender.tag-1000 == 1){
        
        [self.view addSubview:_busTableView];
        
        BMKPlanNode *startNode=[[BMKPlanNode alloc]init];
        startNode.pt=coordinate1;
        BMKPlanNode *endNode=[[BMKPlanNode alloc]init];
        if (!location.longitude && !location.latitude) {
            endNode.pt= self.endCoordinate;
            endNode.cityName = self.cityStr;
        }else{
            endNode.pt= coordinate2;
            endNode.cityName = self.cityStr;
        }
        NSLog(@"%@  end",endNode.name);
        BMKTransitRoutePlanOption *transitOption=[[BMKTransitRoutePlanOption alloc]init];
        transitOption.city=self.cityStr;
        NSLog(@"%@+++++++++公交",transitOption.city);
        transitOption.from=startNode;
        transitOption.to=endNode;
        BOOL flag=[_routeSearch transitSearch:transitOption];
        if(flag){
            NSLog(@"公交检索发送成功");
        }else{
            NSLog(@"公交检索发送失败");
        }
        
    }if (sender.tag-1000==2){
        
        [self.view addSubview:_carTableView];
        
        BMKPlanNode *start=[[BMKPlanNode alloc]init];
        start.pt=coordinate1;
        BMKPlanNode *end=[[BMKPlanNode alloc]init];
        if (!location.longitude && !location.latitude) {
            end.pt= self.endCoordinate;
            end.cityName = self.cityStr;
        }else{
            end.pt= coordinate2;
            end.cityName = self.cityStr;
        }
        BMKDrivingRoutePlanOption *drivingOption=[[BMKDrivingRoutePlanOption alloc]init];
        drivingOption.from=start;
        drivingOption.to=end;
        BOOL flag = [_routeSearch drivingSearch:drivingOption];
        if(flag)
        {
            NSLog(@"car检索发送成功");
        }
        else
        {
            NSLog(@"car检索发送失败");
        }
        
        //        [self performSelector:@selector(delayClick) withObject:nil afterDelay:0.5];
        
    }

}
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        location= result.location;
        NSLog(@"%f,%f",location.latitude,location.longitude);
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}
- (void)onGetWalkingRouteResult:(BMKRouteSearch *)searcher result:(BMKWalkingRouteResult *)result errorCode:(BMKSearchErrorCode)error{
    self.searchWalkArr=result.routes;
    //NSLog(@"%@  步行路线---+++---+++----+-+--",result.routes);
    [_walkTableView reloadData];
}
- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error{
    
    //NSMutableArray *lineArr = [[NSMutableArray alloc]init];
    self.searchBusArr=result.routes;
    //NSLog(@"%@  公交路线---+++---+++----+-+--",result.routes);
    if (error == BMK_SEARCH_NO_ERROR) {
        
    }else if ( error == BMK_SEARCH_AMBIGUOUS_KEYWORD
              ){
        NSLog(@"检索词有岐义");
    }
    else if ( error == BMK_SEARCH_NOT_SUPPORT_BUS_2CITY
             ){
        NSLog(@"不支持跨城市公交");
    }
    
    [_busTableView reloadData];
}
-(void)onGetDrivingRouteResult:(BMKRouteSearch *)searcher result:(BMKDrivingRouteResult *)result errorCode:(BMKSearchErrorCode)error
{
    self.searchCarArr=result.routes;
    
    BMKDrivingRouteLine *plan=(BMKDrivingRouteLine *)[result.routes objectAtIndex:0];
    
    // 计算路线方案中的路段数目
    int size = (int)[plan.steps count];
    NSLog(@"%@",plan.steps);
    for (int i = 0; i < size; i++) {
        BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
        //NSLog(@"%@ %@",transitStep.instruction,infos.title);
        NSLog(@"%@     %@    %@     ",
              transitStep.entrace.title,
              transitStep.exit.title,
              transitStep.instruction);
    }
    
    
//    NSLog(@"%lu",(unsigned long)result.routes.count);
//    NSLog(@"起点poi列表数组%@",result.suggestAddrResult.startPoiList);
//    NSLog(@"终点poi列表数组%@",result.suggestAddrResult.endPoiList);
    if(error==BMK_SEARCH_NO_ERROR)
    {
    }else if ( error == BMK_SEARCH_AMBIGUOUS_KEYWORD
              ){
        NSLog(@"检索词有岐义");
    }
    else if ( error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR
             ){
        NSLog(@"检索地址有岐义");
    }else if (error==BMK_SEARCH_RESULT_NOT_FOUND){
        NSLog(@"没有找到检索结果");
    }else if (error==BMK_SEARCH_KEY_ERROR){
        NSLog(@"key错误");
    }
    
    [_carTableView reloadData];
}

#pragma mark
#pragma -----代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==_busTableView){
        return self.searchBusArr.count;
    }else if (tableView==_carTableView){
        return self.searchCarArr.count;
    }else if (tableView==_walkTableView){
        return self.searchWalkArr.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROWH;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"cell";
    MapLineCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    [cell.xiaBtn addTarget:self action:@selector(clickToHide:) forControlEvents:UIControlEventTouchUpInside];
    
    if (cell==nil)
    {
        cell=[[MapLineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (tableView == _walkTableView) {
         BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[self.searchWalkArr objectAtIndex:indexPath.row];
        
        cell.titleLabel.text=@"步行方案";
        cell.subTitLab.text=[NSString stringWithFormat:@"%d分钟",(plan.duration.hours*60+plan.duration.minutes)];
        cell.mileLabel.text=[NSString stringWithFormat:@"%.2fkm",plan.distance/1000.0f];
        
        cell.timeImage.image = nil;
        cell.walkImage.image = nil;
        
        
    }
    if (tableView==_busTableView)
    {
        BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[self.searchBusArr objectAtIndex:indexPath.row];
        // 计算路线方案中的路段数目
        int size = (int)[plan.steps count];
        NSLog(@"%@",plan.steps);
        NSString *vehicleName = @"";
        
        int num = 0;
        int num1 = 0;
        for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            BMKVehicleInfo *infos = transitStep.vehicleInfo;
            //NSLog(@"%@ %@",transitStep.instruction,infos.title);
//            NSLog(@"%@     %@    %@    %@    ",
//                  transitStep.entrace.title,
//                  transitStep.exit.title,
//                  transitStep.instruction,
//                  (transitStep.stepType == BMK_BUSLINE ? @"公交路段" : (transitStep.stepType == BMK_SUBWAY ? @"地铁路段" : @"步行路段"))
//                  );
            if (transitStep.stepType==BMK_WAKLING)
            {
                NSLog(@"%@++++++++++++",transitStep.instruction);
                NSString *str = [transitStep.instruction componentsSeparatedByString:@"米"][0];
                NSString *string;
                
                string = [str componentsSeparatedByString:@"步行"][1];
                int a = [string intValue];
                NSLog(@"%@=========步行数",string);
                num = num +a;
            }
            if (transitStep.stepType==BMK_BUSLINE | transitStep.stepType==BMK_SUBWAY) {
                NSString *str = [transitStep.instruction componentsSeparatedByString:@"经过"][1];
                NSString *string = [str componentsSeparatedByString:@"站,"][0];
                NSLog(@"%@//////////总站数",string);
                int a = [string intValue];
                
                num1 = num1 + a;
            }
            //判断是否有线路名称
            if (infos) {
                if ([vehicleName isEqualToString:@""]) {
                    vehicleName = [NSString stringWithFormat:@"%@",infos.title];
                }
                else{
                    vehicleName = [NSString stringWithFormat:@"%@ - %@",vehicleName,infos.title];
                }
            }
        }
        
        cell.titleLabel.text=vehicleName;
        
        cell.subTitLab.text= [NSString stringWithFormat:@"%d分钟",(plan.duration.hours*60+plan.duration.minutes)];
        
        cell.mileLabel.text = [NSString stringWithFormat:@"%.2fkm",plan.distance/1000.0f];
        cell.walkLabel.text = [NSString stringWithFormat:@"%d米",num];
        cell.timeLabel.text = [NSString stringWithFormat:@"%d站",num1];
        return cell;
        
    }
    if (tableView==_carTableView)
    {
        BMKDrivingRouteLine *plan=(BMKDrivingRouteLine *)[self.searchCarArr objectAtIndex:indexPath.row];
        int size = (int)[plan.steps count];
        
        for (int i = 0; i < size; i++) {
//            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            //NSLog(@"%@ %@",transitStep.instruction,infos.title);
//            NSLog(@"%@",transitStep.instruction);
        }
        
        cell.titleLabel.text=@"驾车方案";
        cell.subTitLab.text=[NSString stringWithFormat:@"%d分钟",(plan.duration.hours*60 + plan.duration.minutes)];
        cell.mileLabel.text=[NSString stringWithFormat:@"%.2fkm",plan.distance/1000.0f];
        
        cell.timeImage.image = nil;
        cell.walkImage.image = nil;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RouteLineViewController *routeVC=[[RouteLineViewController alloc]init];
    
    if (_isChange == NO) {
        routeVC.startStr = @"我的位置";
        routeVC.endStr = _districtStr;
    }else{
        routeVC.startStr = _districtStr;
        routeVC.endStr = @"我的位置";
    }
//    routeVC.startStr = _myLabel.text;
//    routeVC.endStr = _addrLabel.text;
    
    routeVC.delegate = self;
    
    if (tableView == _walkTableView) {
        
        
        BMKWalkingRouteLine* plan=self.searchWalkArr[indexPath.row];
        routeVC.routeArray=plan.steps;
        
//        routeVC.height = 160+64+60*(indexPath.row + 1);
//        
//        routeVC.view.frame=CGRectMake(0, 60*(indexPath.row + 1), KSCreenW, KSCreenH-60*(indexPath.row + 1) -160-64);
//        [self addChildViewController:routeVC];
//        [_walkTableView addSubview:routeVC.view];
        
        [self.navigationController pushViewController:routeVC animated:NO];

    }
    if (tableView == _busTableView){
        
        BMKTransitRouteLine* plan=self.searchBusArr[indexPath.row];
        routeVC.routeArray=plan.steps;
        routeVC.result = 1;
        
//        routeVC.height = 160+64+60*(indexPath.row + 1);
//        
//        routeVC.view.frame=CGRectMake(0, 60*(indexPath.row + 1), KSCreenW, KSCreenH-60*(indexPath.row + 1) -160-64);
//        [self addChildViewController:routeVC];
//        [_busTableView addSubview:routeVC.view];
        
        [self.navigationController pushViewController:routeVC animated:NO];
    }
    if (tableView == _carTableView){
        BMKDrivingRouteLine *plan=(BMKDrivingRouteLine *)[self.searchCarArr objectAtIndex:indexPath.row];
        routeVC.routeArray=plan.steps;
        
//        routeVC.height = 160+64+60*(indexPath.row + 1);
//        
//        routeVC.view.frame=CGRectMake(0, 60*(indexPath.row + 1), KSCreenW, KSCreenH-60*(indexPath.row + 1) -160-64);
//        [self addChildViewController:routeVC];
//        [_carTableView addSubview:routeVC.view];
        
        [self.navigationController pushViewController:routeVC animated:NO];
    }
    
}
- (void)getToHide:(UIButton *)btn{
    
    UIView *view = [[btn superview]superview];
    view.hidden = YES;
    //[view removeFromSuperview];
//    _busTableView.userInteractionEnabled = YES;
//    _carTableView.userInteractionEnabled = YES;
}
- (void)clickToHide:(MapButton *)btn{
    
}
- (void)goToBack{
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
