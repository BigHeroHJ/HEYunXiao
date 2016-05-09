//
//  DetailClientViewController.m
//  Marketing
//
//  Created by HanenDev on 16/3/1.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "DetailClientViewController.h"
#import "DetailClientView.h"
#import "MyClientCell.h"
#import "DetailClientCell.h"
#import "NewVisitViewController.h"
#import "SatusSelectViewController.h"
#import "JudgeNumber.h"
#import "VisitDetailViewController.h"

#define STARTX [UIView getWidth:10]
#define MYCELLHEIGHT 60
#define OTHERCELLHEIGHT 85.0f
#import "MapClientViewController.h"
@interface DetailClientViewController ()<DetailClientViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,StatusSelectDelegate,MapClientViewControllerDelegate>
{
    NSArray    *_detailArray;
    NSArray    *_contactArr;
    NSArray    *_otherArr;
    
    CGFloat  longt;
    CGFloat   lati;
    
    CLLocationCoordinate2D lonlat;
}


@property(nonatomic,strong)NSMutableArray    *visitArray;
@property(nonatomic,strong)DetailClientView  *bottomView;
/**
 *  客户详情
 */
@property(nonatomic,strong)UIView            *detailView;
@property(nonatomic,strong)UIScrollView      *scrollView;
/**
 *  历史拜访
 */
@property(nonatomic,strong)UIView            *visitView;
@property(nonatomic,strong)UITableView       *visitTableView;

@property(nonatomic,strong)UITextField    *companyTF;
@property(nonatomic,strong)UITextField    *nameTF;
@property(nonatomic,strong)UITextField    *numberTF;
@property(nonatomic,strong)UITextField    *departmentTF;
@property(nonatomic,strong)UITextField    *businessTF;
@property(nonatomic,strong)UITextField    *levelTF;
@property(nonatomic,strong)UITextField    *fromTF;
@property(nonatomic,strong)UITextField    *statusTF;

@property(nonatomic,strong)UITextField    *mobileTF;//电话
@property(nonatomic,strong)UITextField    *phoneTF;
@property(nonatomic,strong)UITextField    *emailTF;
@property(nonatomic,strong)UITextField    *addressTF;
@property(nonatomic,strong)UITextField    *remarkTF;

@property(nonatomic,strong)UITextField    *principalTF;
@property(nonatomic,strong)UITextField    *personTF;
@property(nonatomic,strong)UITextField    *creTimeTF;
@property(nonatomic,strong)UITextField    *lastTimeTF;


@property(nonatomic,strong)UIButton       *levelBtn;
@property(nonatomic,strong)UIButton       *formBtn;
@property(nonatomic,strong)UIButton       *statusBtn;


@end

@implementation DetailClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:self.titleStr];
    _bottomView = [[DetailClientView alloc]initWithFrame:CGRectMake(0, KSCreenH - [UIView getHeight:50], KSCreenW, [UIView getHeight:50])];
    _bottomView.delegate = self;
    [_bottomView.detailBtn setTitleColor:mainOrangeColor forState:UIControlStateNormal];
    [self.view addSubview:_bottomView];
    
    self.navigationItem.leftBarButtonItem=[ViewTool getBarButtonItemWithTarget:self WithAction:@selector(goToBack)];
    //[self getRightNavigationBar];
    
    [self createDetailView];
    [self createVisitView];
    [self initData];
    
    
    _visitArray = [[NSMutableArray alloc]initWithCapacity:0];
}
- (void)createDetailView{
    
    _detailArray = @[@"公司名称",@"姓名",@"编号",@"级别",@"公司部门",@"职位",@"来源",@"状态"];
    _contactArr = @[@"电话",@"手机",@"邮件",@"地址",@"备注"];
    _otherArr = @[@"负责人",@"创建人",@"创建时间",@"最后修改时间"];
    
    _detailView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KSCreenW, KSCreenH - 64 - [UIView getHeight:50])];
    [self.view addSubview:_detailView];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, KSCreenH - [UIView getHeight:50] - 64)];
    _scrollView.showsVerticalScrollIndicator=NO;
    [_detailView addSubview:_scrollView];
    
    [self createUI];
    
    
}
- (void)createUI{
    CGFloat labelH = 20;
    CGFloat tfH    = 30;
    CGFloat tfY    = 5+ labelH;
    CGFloat tfW    = [UIView getWidth:200];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, 30)];
    view.backgroundColor = graySectionColor;
    [_scrollView addSubview:view];
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(STARTX, 8, 5, view.height - 16)];
    imageView1.image = [UIImage imageNamed:@"lanse"];
    [view addSubview:imageView1];
    
    UILabel *basicLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView1.maxX + 5, 5, 200, 20)];
    basicLabel.text = @"基本信息";
    [ViewTool setLableFont12:basicLabel];
    basicLabel.textColor = blackFontColor;
    [view addSubview:basicLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STARTX, 30 - 1, KSCreenW , 1)];
    lineView.backgroundColor = grayLineColor;
    [view addSubview:lineView];
    
    for (int i = 0; i<_detailArray.count; i++) {
        UILabel *label = [ViewTool getLabelWith:CGRectMake(STARTX, view.maxY + 5+ MYCELLHEIGHT*i, KSCreenW, labelH) WithTitle:_detailArray[i] WithFontSize:13.0f WithTitleColor:lightGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
        [ViewTool setLableFont13:label];
        [_scrollView addSubview:label];
        
        UIView *line = [ViewTool getLineViewWith:CGRectMake(STARTX, view.maxY +(MYCELLHEIGHT -1)*(i+1) , KSCreenW - 2*STARTX, 1) withBackgroudColor:grayLineColor];
        [_scrollView addSubview:line];
        if (i == _detailArray.count - 1) {
            [line removeFromSuperview];
        }
    }
    
    _companyTF = [self addTextFieldWithFrame:CGRectMake(STARTX, view.maxY + tfY, tfW, tfH) AndStr:@"请添加公司(必填)" WithTrue:YES];
    [_scrollView addSubview:_companyTF];
    
    _nameTF = [self addTextFieldWithFrame:CGRectMake(STARTX, _companyTF.maxY + tfY+5, tfW, tfH) AndStr:@"请填写人员" WithTrue:YES];
    [_scrollView addSubview:_nameTF];
    
    _numberTF = [self addTextFieldWithFrame:CGRectMake(STARTX, _nameTF.maxY + tfY+5, tfW, tfH) AndStr:@"请填写编号" WithTrue:YES];
    [_numberTF setValue:placeholderGrayFontColor forKeyPath:@"_placeholderLabel.textColor"];
    [_scrollView addSubview:_numberTF];
    
    _levelTF = [self addTextFieldWithFrame:CGRectMake(STARTX, _numberTF.maxY + tfY+5, tfW, tfH) AndStr:@"请选择级别(必填)" WithTrue:NO];
    //_levelTF.enabled = NO;
    [_scrollView addSubview:_levelTF];
    
    _levelBtn = [[UIButton alloc]initWithFrame:CGRectMake(KSCreenW - STARTX - 30, _levelTF.y, 20, 20)];
    [_levelBtn addTarget:self action:@selector(clickToSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_levelBtn setImage:[UIImage imageNamed:@"级别"] forState:UIControlStateNormal];
    _levelBtn.tag = 1000;
    [_scrollView addSubview:_levelBtn];
    
    _departmentTF = [self addTextFieldWithFrame:CGRectMake(STARTX, _levelTF.maxY + tfY+5, tfW, tfH) AndStr:@"请填写部门(必填)" WithTrue:YES];
    [_scrollView addSubview:_departmentTF];
    
    _businessTF = [self addTextFieldWithFrame:CGRectMake(STARTX, _departmentTF.maxY + tfY+5, tfW, tfH) AndStr:@"请填写职务(必填)" WithTrue:YES];
    [_scrollView addSubview:_businessTF];
    
    _fromTF = [self addTextFieldWithFrame:CGRectMake(STARTX, _businessTF.maxY + tfY+5, tfW, tfH) AndStr:@"请选择来源(必填)" WithTrue:NO];
    //_fromTF.enabled = NO;
    [_scrollView addSubview:_fromTF];
    
    _formBtn = [[UIButton alloc]initWithFrame:CGRectMake(KSCreenW - STARTX - 30, _fromTF.y, 20, 20)];
    [_formBtn addTarget:self action:@selector(clickToSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_formBtn setImage:[UIImage imageNamed:@"来源"] forState:UIControlStateNormal];
    _formBtn.tag = 2000;
    [_scrollView addSubview:_formBtn];
    
    _statusTF = [self addTextFieldWithFrame:CGRectMake(STARTX, _fromTF.maxY + tfY+5, tfW, tfH) AndStr:@"请选择状态(必填)" WithTrue:NO];
    //_statusTF.enabled = NO;
    [_scrollView addSubview:_statusTF];
    
    _statusBtn = [[UIButton alloc]initWithFrame:CGRectMake(KSCreenW - STARTX - 30, _statusTF.y, 20, 20)];
    [_statusBtn addTarget:self action:@selector(clickToSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_statusBtn setImage:[UIImage imageNamed:@"状态"] forState:UIControlStateNormal];
    _statusBtn.tag = 3000;
    [_scrollView addSubview:_statusBtn];
    
    [self initUI];
    
}
- (void)initUI{
    CGFloat labelH = 20;
    CGFloat tfH    = 30;
    CGFloat tfY    = 5+ labelH;
    CGFloat tfW    = [UIView getWidth:240];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, _statusTF.maxY - 1, KSCreenW, 30)];
    view.backgroundColor = graySectionColor;
    [_scrollView addSubview:view];
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(STARTX, 8, 5, view.height - 16)];
    imageView1.image = [UIImage imageNamed:@"lanse"];
    [view addSubview:imageView1];
    
    UILabel *basicLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView1.maxX + 5, 5, 200, 20)];
    basicLabel.text = @"联系方式";
    [ViewTool setLableFont12:basicLabel];
    
    basicLabel.textColor = blackFontColor;
    [view addSubview:basicLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STARTX, 30 - 1, KSCreenW , 1)];
    lineView.backgroundColor = grayLineColor;
    [view addSubview:lineView];
    
    for (int i = 0; i<_contactArr.count; i++) {
        UILabel *label = [ViewTool getLabelWith:CGRectMake(STARTX, view.maxY + 5+ MYCELLHEIGHT*i, KSCreenW, labelH) WithTitle:_contactArr[i] WithFontSize:13.0f WithTitleColor:lightGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
        [ViewTool setLableFont13:label];
        [_scrollView addSubview:label];
        
        UIView *line = [ViewTool getLineViewWith:CGRectMake(STARTX, view.maxY +(MYCELLHEIGHT -1)*(i+1) , KSCreenW - 2*STARTX, 1) withBackgroudColor:grayLineColor];
        [_scrollView addSubview:line];
        
        if (i == _contactArr.count - 1) {
            [line removeFromSuperview];
        }
    }
    
    _mobileTF = [self addTextFieldWithFrame:CGRectMake(STARTX, view.maxY + tfY, tfW, tfH) AndStr:@"请输入电话" WithTrue:YES];
    _mobileTF.keyboardType = UIKeyboardTypeNumberPad;
    [_scrollView addSubview:_mobileTF];
    
    _phoneTF = [self addTextFieldWithFrame:CGRectMake(STARTX, _mobileTF.maxY + tfY + 5, tfW, tfH) AndStr:@"请输入手机(必填)" WithTrue:YES];
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    [_scrollView addSubview:_phoneTF];
    
    _emailTF = [self addTextFieldWithFrame:CGRectMake(STARTX, _phoneTF.maxY + tfY + 5, tfW, tfH) AndStr:@"请输入邮箱" WithTrue:YES];
    [_scrollView addSubview:_emailTF];
    
    _addressTF = [self addTextFieldWithFrame:CGRectMake(STARTX, _emailTF.maxY + tfY + 5, tfW, tfH) AndStr:@"请输入地址(必填)" WithTrue:YES];
    [_scrollView addSubview:_addressTF];
    
    UIButton *imageView = [[UIButton alloc] initWithFrame:CGRectMake(KSCreenW - STARTX -30, _addressTF.y, 20, 20)];
    [imageView setBackgroundImage: [UIImage imageNamed:@"定位蓝色"] forState:UIControlStateNormal];
    [imageView addTarget:self action:@selector(jumpToMap) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:imageView];
    
    _remarkTF = [self addTextFieldWithFrame:CGRectMake(STARTX, _addressTF.maxY + tfY + 5, tfW, tfH) AndStr:@"请填写备注" WithTrue:YES];
    [_scrollView addSubview:_remarkTF];
    
    [self initViews];
    
}
#pragma -----跳转地图
- (void)jumpToMap
{
    
    
    MapClientViewController * mapVC = [[MapClientViewController alloc] init];
    if (longt == 0&&lati == 0) {
        mapVC.result = 1;
    }else{
    mapVC.locationLongide = [NSString stringWithFormat:@"%f",longt];
    mapVC.locationLatitude =  [NSString stringWithFormat:@"%f",lati];
    }
    mapVC.delegate = self;
    [self.navigationController pushViewController:mapVC animated:YES];

    NSLog(@"%@++++++-------",mapVC.locationLatitude);

}
- (void)getClickPlaceName:(NSString *)PlaceString withCoordinat2D:(CLLocationCoordinate2D)pt{
    _addressTF.text = PlaceString;
    lonlat = pt;
}
- (void)initViews{
    CGFloat labelH = 20;
    CGFloat tfH    = 30;
    CGFloat tfY    = 5+ labelH;
    CGFloat tfW    = KSCreenW-2*STARTX;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, _remarkTF.maxY, KSCreenW, 30)];
    view.backgroundColor = graySectionColor;
    [_scrollView addSubview:view];
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(STARTX, 8, 5, view.height - 16)];
    imageView1.image = [UIImage imageNamed:@"lanse"];
    [view addSubview:imageView1];
    
    UILabel *basicLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView1.maxX + 5, 5, 200, 20)];
    basicLabel.text = @"其他";
    [ViewTool setLableFont12:basicLabel];
    
    basicLabel.textColor = blackFontColor;
    [view addSubview:basicLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STARTX, 30 - 1, KSCreenW , 1)];
    lineView.backgroundColor = grayLineColor;
    [view addSubview:lineView];
    
    for (int i = 0; i<_otherArr.count; i++) {
        UILabel *label = [ViewTool getLabelWith:CGRectMake(STARTX, view.maxY + 5+ MYCELLHEIGHT*i, KSCreenW, labelH) WithTitle:_otherArr[i] WithFontSize:13.0f WithTitleColor:lightGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
        [ViewTool setLableFont13:label];
        [_scrollView addSubview:label];
        
        UIView *line = [ViewTool getLineViewWith:CGRectMake(STARTX, view.maxY +(MYCELLHEIGHT -1)*(i+1) , KSCreenW - 2*STARTX, 1) withBackgroudColor:grayLineColor];
        [_scrollView addSubview:line];
    }
    
    _principalTF = [self addTextFieldWithFrame:CGRectMake(STARTX, view.maxY + tfY, tfW, tfH) AndStr:@"请填写负责人" WithTrue:NO];
    [_scrollView addSubview:_principalTF];
    
    _personTF = [self addTextFieldWithFrame:CGRectMake(STARTX, _principalTF.maxY + tfY + 5, _principalTF.width, tfH) AndStr:@"请填写创建人" WithTrue:NO];
    [_scrollView addSubview:_personTF];
    
    _creTimeTF = [self addTextFieldWithFrame:CGRectMake(STARTX, _personTF.maxY + tfY + 5, _principalTF.width, tfH) AndStr:@"请填写创建时间" WithTrue:NO];
    [_scrollView addSubview:_creTimeTF];
    
    _lastTimeTF = [self addTextFieldWithFrame:CGRectMake(STARTX, _creTimeTF.maxY + tfY + 5, _principalTF.width, tfH) AndStr:@"请填写最后修改时间" WithTrue:NO];
    [_scrollView addSubview:_lastTimeTF];
    
    [_scrollView setContentSize:CGSizeMake(KSCreenW, _lastTimeTF.maxY + 2)];
    
}
- (void)createVisitView{
    _visitView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KSCreenW, KSCreenH - 64 - [UIView getHeight:50])];
    _visitView.hidden = YES;
    _visitView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_visitView];
    
    _visitTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, KSCreenH - 64 - [UIView getHeight:50]) style:UITableViewStylePlain];
    _visitTableView.delegate = self;
    _visitTableView.dataSource = self;
    _visitTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_visitView addSubview:_visitTableView];
    
}
- (void)changeDetailClientView:(NSInteger)tag{
    if (tag == 1111) {//客户详情
        
        self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:self.titleStr];
        
        [_bottomView.detailBtn setImage:[UIImage imageNamed:@"客户详情 enter"] forState:UIControlStateNormal];
        [_bottomView.detailBtn setTitleColor:mainOrangeColor forState:UIControlStateNormal];
        
        [_bottomView.visitBtn setImage:[UIImage imageNamed:@"拜访历史"] forState:UIControlStateNormal];
        [_bottomView.visitBtn setTitleColor:lightGrayFontColor forState:UIControlStateNormal];
        
//        self.navigationItem.leftBarButtonItem=[ViewTool getBarButtonItemWithTarget:self WithAction:@selector(goToBack)];
        //[self getRightNavigationBar];
        self.navigationItem.rightBarButtonItem = nil;
        
        _detailView.hidden = NO;
        _visitView.hidden = YES;
        
    }else if (tag == 2222){//拜访历史
        
        self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:@"拜访历史"];
        
        [_bottomView.detailBtn setImage:[UIImage imageNamed:@"客户详情"] forState:UIControlStateNormal];
        [_bottomView.detailBtn setTitleColor:lightGrayFontColor forState:UIControlStateNormal];
        
        [_bottomView.visitBtn setImage:[UIImage imageNamed:@"拜访历史 enter"] forState:UIControlStateNormal];
        [_bottomView.visitBtn setTitleColor:mainOrangeColor forState:UIControlStateNormal];
//        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithString:@"新建" WithAction:@selector(clickToNewClient:)];
        
        _detailView.hidden = YES;
        _visitView.hidden = NO;
        
        [self requestHistoryData];
    }
}

#pragma mark
#pragma mark-----tableView的协议方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return OTHERCELLHEIGHT;
   
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _visitArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        static NSString *identifier =@"iDCell";
        MyClientCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyClientCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(STARTX, OTHERCELLHEIGHT - 1, KSCreenW -2*STARTX, 1)];
            lineView.backgroundColor = grayLineColor;
            [cell.contentView addSubview:lineView];
        }
            
        ClientModel *client = _visitArray[indexPath.row];
        cell.companyLabel.text = client.company;
        cell.addressLabel.text = client.address;
            
        cell.principalLabel.text = [NSString stringWithFormat:@"负责人>%@",client.cname];
        if (client.status == 1) {
            cell.statusLabel.text = @"已拜访";
            cell.timeLabel.text  = client.visittime;
            cell.statusCenterLabel.text = nil;
        }else{
            cell.statusCenterLabel.text = @"未拜访";
            cell.statusLabel.text = nil;
            cell.timeLabel.text  = nil;
        }
    
//        if (client.status == 1 ) {
//                NSString *hadVisitTime = client.visittime;
//                NSDate *date = [NSDate date];
//                NSDateFormatter *dateformate = [[NSDateFormatter alloc] init];
//                [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//                NSDate *visitDate = [dateformate dateFromString:hadVisitTime];
//                NSTimeInterval times = [date timeIntervalSinceDate:visitDate];
//                int days = ABS((int)times / (3600 * 24));
//                if (days == 0 ) {
//                    cell.statusLabel.text = @"今日已拜访";
//                }else if (days == 1){
//                    cell.statusLabel.text = @"昨日已拜访";
//                }else{
//                    cell.statusLabel.text = [NSString stringWithFormat:@"%d天前拜访",days];
//                }
//                cell.timeLabel.text = client.visittime;
//                cell.statusCenterLabel = nil;
//            
//        }else{
//            
//            NSString*  sttt = [DataTool changeType:client.ordertime];
//            if (![sttt isEqualToString:@""] && sttt.length !=0 ) {
//                NSString *hadVisitTime = client.ordertime;
//                NSDate *date = [NSDate date];
//                NSDateFormatter *dateformate = [[NSDateFormatter alloc] init];
//                [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//                NSDate *visitDate = [dateformate dateFromString:hadVisitTime];
//                NSTimeInterval times = [date timeIntervalSinceDate:visitDate];
//                int days = ABS((int)times / (3600 * 24));
//                if (days == 0 ) {
//                    cell.statusCenterLabel.text = @"今日未拜访";
//                }else{
//                    cell.statusCenterLabel.text = [NSString stringWithFormat:@"%d天未拜访",days];
//                }
//                    cell.timeLabel.text = nil;
//                    cell.statusLabel.text = nil;
//            }else{
//                cell.statusCenterLabel.text = @"未拜访";
//                cell.timeLabel.text = nil;
//                cell.statusLabel.text = nil;
//            }
//        }

        return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ClientModel *client = _visitArray[indexPath.row];
    VisitDetailViewController *vc= [[VisitDetailViewController alloc]init];
    vc.visitId = client.clientId;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark
/**
 *  保存按钮
 *
 *  @param btn 修改客户详情
 */
- (void)saveClick:(UIButton *)btn{
    NSLog(@"%@  gongsibumen",_departmentTF.text);
    
    if (_levelTF.text == nil | [_levelTF.text length] == 0 ){
        [self.view makeToast:@"请选择级别"];
        return;
    }else if (_departmentTF.text == nil | [_departmentTF.text length] == 0 ){
        [self.view makeToast:@"请填写公司部门名称"];
        return;
    }else if (_businessTF.text == nil | [_businessTF.text length] == 0 ){
        [self.view makeToast:@"请填写职位"];
        return;
    }else if (_fromTF.text == nil | [_fromTF.text length] == 0 ){
        [self.view makeToast:@"请选择来源"];
        return;
    }else if (_statusTF.text == nil | [_statusTF.text length] == 0 ){
        [self.view makeToast:@"请选择状态"];
        return;
    }else if (_phoneTF.text == nil | [_phoneTF.text length] == 0 ){
        [self.view makeToast:@"请输入手机号"];
        return;
    }else if (_addressTF.text == nil | [_addressTF.text length] == 0 ){
        [self.view makeToast:@"请填写地址"];
        return;
    }else if (![JudgeNumber boolenPhone:_phoneTF.text]){
        [self.view makeToast:@"请输入正确的手机号"];
        return;
    }

    ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"提示" message:@"是否保存修改"];
    [alert addBtnTitle:@"否" action:^{
        
    }];
    [alert addBtnTitle:@"是" action:^{
        [self dataWithDetailCustomer];
    }];
    [alert showAlertWithSender:self];
    
    
}

#pragma mark-- 新建拜访
- (void)clickToNewClient:(UIButton *)btn{
    
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;//可更改为其他方式
    transition.subtype = kCATransitionFromTop;//可更改为其他方式
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    NewVisitViewController *vc = [[NewVisitViewController alloc]init];
    vc.clientModel = _model;
    [self.navigationController pushViewController:vc animated:NO];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self getRightNavigationBar];
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
    
    [self requestHistoryData];
}

-(UITextField *)addTextFieldWithFrame:(CGRect)frame AndStr:(NSString *)placeholder WithTrue:(BOOL)ture
{
    UITextField *textF=[[UITextField alloc]initWithFrame:frame];
    textF.userInteractionEnabled = ture;
    textF.textColor = blackFontColor;
    textF.placeholder=placeholder;
    textF.delegate = self;
    [textF setValue:placeholderGrayFontColor forKeyPath:@"_placeholderLabel.textColor"];
    [ViewTool setTFPlaceholderFont14:textF];
    return textF;
}

- (void)getRightNavigationBar{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [btn addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

- (UIButton *)createButtonWithFrame:(CGRect)frame WithTitle:(NSString *)string WithFont:(CGFloat)font WithTag:(CGFloat)tag WithColor:(UIColor *)color
{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    [btn setTitle:string forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.tag = tag;
    [btn addTarget:self action:@selector(clickToSelect:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
#pragma mark
#pragma mark -------数据字典选择
- (void)clickToSelect:(UIButton *)btn{
    [self getRightNavigationBar];
    
    SatusSelectViewController *vc = [[SatusSelectViewController alloc]init];
    vc.delegate =self;
    vc.num = btn.tag;
    
    [self.navigationController pushViewController:vc animated:NO];
    
    switch (btn.tag) {
        case 1000:
        {
            vc.ar = _levelArray;
            vc.itemTitle = @"等级";
            if (_levelTF.text) {
                vc.valuetTitle = _levelTF.text;
            }
            
        }
            break;
        case 2000:
        {
            vc.itemTitle = @"来源";
            vc.ar = _fromArray;
            if (_fromTF.text) {
                vc.valuetTitle = _fromTF.text;
            }
        }
            break;
        case 3000:
        {
            vc.itemTitle = @"客户状态";
            vc.ar = _statusArray;
            if (_statusTF.text) {
                vc.valuetTitle = _statusTF.text;
            }
            
        }
            break;
        default:
            break;
    }
    
}
- (void)selectStatusWith:(NSString *)string withNum:(NSInteger)count withInt:(int)number{
    
    if (count == 1000) {
        _levelTF.text = string;
    }else if (count == 2000){
        _fromTF.text = string;
    }else if(count == 3000){
        _statusTF.text = string;
    }
    
}
//我的客户详情
- (void)initData{
    NSNumber *cidNum =[NSNumber numberWithInt:_cID];
    
    NSDictionary * dic =@{@"token":TOKEN,@"uid":@(UID),@"cid":cidNum };
    NSLog(@"%@++token %@++uid %d++cid",TOKEN,@(UID),_cID);
    [DataTool postWithUrl:DETAIL_CLIENT_URL parameters:dic success:^(id data) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@++++++",jsonDic);
        
        _nameTF.text = [DataTool changeType:jsonDic[@"cname"]];
        _companyTF.text = [DataTool changeType:jsonDic[@"company"]];
        _numberTF.text = [DataTool changeType:jsonDic[@"cno"]];
        _departmentTF.text = [DataTool changeType:jsonDic[@"department"]];
        _businessTF.text = [DataTool changeType:jsonDic[@"position"]];
        _levelTF.text = [DataTool changeType:jsonDic[@"clevelname"]];
        _fromTF.text = [DataTool changeType:jsonDic[@"cfromname"]];
        _statusTF.text = [DataTool changeType:jsonDic[@"cstatusname"]];
        
        _mobileTF.text = [DataTool changeType:jsonDic[@"telephone"]];
        _phoneTF.text = [DataTool changeType:jsonDic[@"phone"]];
        _emailTF.text = [DataTool changeType:jsonDic[@"email"]];
        _addressTF.text = [DataTool changeType:jsonDic[@"address"]];
        _remarkTF.text = [DataTool changeType:jsonDic[@"remark"]];
        _personTF.text = [DataTool changeType:jsonDic[@"addusername"]];
        _principalTF.text = [DataTool changeType:jsonDic[@"uidname"]];
        _creTimeTF.text = [DataTool changeType:jsonDic[@"addtime"]];
        _lastTimeTF.text = [DataTool changeType:jsonDic[@"updatetime"]];
//        if (![jsonDic[@"lon"] isEqualToString:@""]) {
        longt = [[DataTool changeType:jsonDic[@"lon"]] floatValue];
//        }
//        if (![jsonDic[@"lat"] isEqualToString:@""]) {
        lati =[[DataTool changeType:jsonDic[@"lat"]] floatValue] ;
//        }
      
        
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}
//修改我的客户详情
- (void)dataWithDetailCustomer{
    
    int a1;
    int b1;
    int c1;
    
    a1 = [_levelArray indexOfObject:_levelTF.text] + 1;
    b1 = [_fromArray indexOfObject:_fromTF.text] + 1;
    c1 = [_statusArray indexOfObject:_statusTF.text] + 1;


    NSLog(@"级别%d 来源%d 状态%d 客户id%d  职位 %@  部门 %@",a1,b1,c1,_cID,_businessTF.text,_departmentTF.text);
    NSLog(@"%@ url",MODIFY_DETAIL_CLIENT_URL);
    NSNumber *cidNum =[NSNumber numberWithInt:_cID];
    NSNumber *levelNum =[NSNumber numberWithInt:a1];
    NSNumber *fromNum =[NSNumber numberWithInt:b1];
    NSNumber *statusNum =[NSNumber numberWithInt:c1];
    NSMutableDictionary * dic =[NSMutableDictionary dictionaryWithDictionary:@{@"token":TOKEN,@"uid":@(UID),@"id":cidNum,@"clevel":levelNum,@"cfrom":fromNum,@"cstatus":statusNum,@"position":_businessTF.text,@"department":_departmentTF.text,@"cname":_nameTF.text,@"cno":_numberTF.text,@"company":_companyTF.text,@"telephone":_mobileTF.text,@"phone":_phoneTF.text,@"email":_emailTF.text,@"address":_addressTF.text,@"remark":_remarkTF.text,@"addusername":_personTF.text,@"uidname":_principalTF.text,@"addtime":_creTimeTF.text,@"updatetime":_lastTimeTF.text}];
    if (lonlat.longitude && lonlat.latitude) {
        [dic setObject:@(lonlat.longitude) forKey:@"lon"];
        [dic setObject:@(lonlat.latitude) forKey:@"lat"];
    }else{
        [dic setObject:@(longt) forKey:@"lon"];
        [dic setObject:@(lati) forKey:@"lat"];
    }
    NSLog(@"%@ dic++++++++",dic);
    [DataTool postWithUrl:MODIFY_DETAIL_CLIENT_URL parameters:dic success:^(id data) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",jsonDic);
        if ([[jsonDic[@"code"]stringValue] isEqualToString:@"100"]) {
            [self.view makeToast:jsonDic[@"message"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}
//我的客户-相关拜访
- (void)requestHistoryData{
    
    [_visitArray removeAllObjects];
    
    NSNumber *cidNum =[NSNumber numberWithInt:_cID];
    NSNumber *pageNum = [NSNumber numberWithInt:1];
    NSNumber *rowsNum = [NSNumber numberWithInt:20];
    NSDictionary * dic =@{@"token":TOKEN,@"uid":@(UID),@"cid":cidNum,@"page":pageNum,@"rows":rowsNum};
    [DataTool postWithUrl:HISTORY_CLIENT_URL parameters:dic success:^(id data) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@-----+++++++",jsonDic);
        NSMutableArray *array = jsonDic[@"visitlist"];
        for (int i= 0; i<array.count; i++) {
            ClientModel *client = [[ClientModel alloc]init];
            id dd = [DataTool changeType:array[i]];
            [client setValuesForKeysWithDictionary:dd];
            [_visitArray addObject:client];
        }
        
        [_visitTableView reloadData];
        
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
