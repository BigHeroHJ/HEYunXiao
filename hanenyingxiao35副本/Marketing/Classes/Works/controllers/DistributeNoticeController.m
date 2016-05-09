//
//  DistributeNoticeController.m
//  Marketing
//
//  Created by Hanen 3G 01 on 16/2/29.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//发布公告

#import "DistributeNoticeController.h"
#import "AppDelegate.h"
#import "MyTabBarController.h"
#import "SelectViewController.h"
#import "UserModel.h"
#import "SelectPersonView.h"


@interface DistributeNoticeController ()<UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SelectStaffViewDelegate,SelectPersonViewDelegate>
{
    UIScrollView  * _mainScrollView;
    CGFloat    space;
    UIView      *_topView;
    UILabel     *_noticeTitle;//公告名称
    UITextField *_noticeName;
    UILabel     *_distributeManTitle;
    UITextField *_distributePerson;
    UILabel     *_noticeContentTitle;
    UITextView  *_noticeConten;
    
    UIButton    *_noticePicBtn;
    UIImageView *_showPicImage;
    
    NSMutableArray *_coverPicArr;
    NSMutableArray *_contentPIcArr;
    
    UIView      *_coverView;
    UILabel     *_coverImageLabel;
    UIImageView *_showCoverImage;
    UIButton    *_takePicBtn;
    
    
    UIView      *_bottomView;
    UIScrollView *_picScroollVeiw;
    UILabel     *_titleLabel;
    UIButton    *_addPersonsBtn;
    int     personCount;
    NSMutableArray *_personArray;
    
    
    UIButton    *_postBtn;
    
    CGFloat    diff;
    BOOL       isCoverImage;
    
    UIView   *_backView;
    SelectPersonView *selectView;
    
}
@end

@implementation DistributeNoticeController


- (void)viewDidLoad
{
    [super viewDidLoad];
    diff = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel: @"新建发布"];

    self.navigationItem.leftBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithAction:@selector(distributeNotice)];
     _personArray = [NSMutableArray array];
    _coverPicArr = [NSMutableArray array];
    _contentPIcArr = [NSMutableArray array];
    
    if (IPhone4S) {
        space = 5.0;
    }else{
        space = [UIView getWidth:8.0f];
    }
    [self initScrollView];
    [self drawTopView];
    [self drawMidView];
    [self drawBottomView];
    [self drawPostButton];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)initScrollView
{
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, KSCreenW, KSCreenH - 64 - 49)];
    _mainScrollView.delegate = self;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [_mainScrollView addGestureRecognizer:tap];
    [self.view addSubview:_mainScrollView];
    
}
- (void)drawTopView
{
    _topView = [[UIView alloc] initWithFrame:[UIView getRectWithX:0 Y:0 width:KSCreenW andHeight:250]];
//    _topView.backgroundColor = [UIColor cyanColor];
    [_mainScrollView addSubview:_topView];
    
    _noticeTitle = [ViewTool getLabelWith:CGRectMake(2 * space, space, 100, 15.0f) WithTitle:@"公告名称" WithFontSize:14.0f WithTitleColor:lightGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_topView addSubview:_noticeTitle];
    
    _noticeName = [[UITextField alloc] initWithFrame:CGRectMake(_noticeTitle.x, _noticeTitle.maxY + space /2.0, KSCreenW - 4 * space, 20)];
    _noticeName.delegate = self;
    [_topView addSubview:_noticeName];
    _noticeName.font = [UIFont systemFontOfSize:16.0f];
//    _noticeName.backgroundColor = [UIColor orangeColor];
    
    UIView *line1 = [ViewTool getLineViewWith:CGRectMake(_noticeTitle.x, _noticeName.maxY + space, KSCreenW - 4 * space, 1) withBackgroudColor:grayLineColor];
    [_topView addSubview:line1];
    
    _distributeManTitle = [ViewTool getLabelWith:CGRectMake(_noticeTitle.x, line1.maxY + space, 100, 20.0f) WithTitle:@"发布人" WithFontSize:14.0 WithTitleColor:lightGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_topView addSubview:_distributeManTitle];
    
    
    _distributePerson = [[UITextField alloc] initWithFrame:CGRectMake(_noticeTitle.x, _distributeManTitle.maxY + space / 2.0, line1.width, [UIView getHeight:20.0f])];
    _distributePerson.font = [UIFont systemFontOfSize:16.0f];
    _distributePerson.delegate = self;
    _distributePerson.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    
    [_topView addSubview:_distributePerson];
    
    UIView *line2 = [ViewTool getLineViewWith:CGRectMake(_noticeTitle.x, _distributePerson.maxY + space, KSCreenW - 4 * space, 0.8) withBackgroudColor:grayLineColor];
    [_topView addSubview:line2];
    
    _noticeContentTitle = [ViewTool getLabelWith:CGRectMake(_noticeName.x, line2.maxY + space, 100, 20.0f) WithTitle:@"发布内容" WithFontSize:14.0 WithTitleColor:lightGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_topView addSubview:_noticeContentTitle];
    
    _noticeConten = [[UITextView alloc] initWithFrame:CGRectMake(_noticeTitle.x, _noticeContentTitle.maxY + space, line2.width, [UIView getHeight:80.0f])];
//    _noticeConten.backgroundColor = [UIColor redColor];
    _noticeConten.delegate = self;
    _noticeConten.textColor = blackFontColor;
    _noticeConten.font = [UIFont systemFontOfSize:18.0f];
    [_topView addSubview:_noticeConten];
    
    
    _noticePicBtn = [[UIButton alloc] initWithFrame:CGRectMake(_noticeTitle.x, _noticeConten.maxY + space, [UIView getWidth:40], [UIView getHeight:40])];
    [_topView addSubview:_noticePicBtn];
    [_noticePicBtn addTarget:self action:@selector(takePicture3:) forControlEvents:UIControlEventTouchUpInside];
    _noticePicBtn.tag = 130;
    [_noticePicBtn setImage:[UIImage imageNamed:@"相机star"] forState:UIControlStateNormal];
    
    _showPicImage = [[UIImageView alloc] init];
    _showPicImage.frame = CGRectMake(_noticePicBtn.maxX + space, _noticePicBtn.y, _noticePicBtn.width, _noticePicBtn.width);
    [_topView addSubview:_showPicImage];
//    _showPicImage.backgroundColor = [UIColor redColor];
    
    
    UIView * lightgrayView = [[UIView alloc] initWithFrame:CGRectMake(0, _noticePicBtn.maxY + 2 * space, KSCreenW, [UIView getHeight:15.0f])];
    lightgrayView.backgroundColor = graySectionColor;
    [_topView addSubview:lightgrayView];
    
    
//    CGRect rect = [lightgrayView convertRect:lightgrayView.frame toView:self.view];
    _topView.frame = CGRectMake(0, 0, KSCreenW, lightgrayView.maxY);
    
    
}

- (void)drawMidView
{
    
    _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.maxY, KSCreenW, [UIView getWidth:50])];
    _coverView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_coverView];
    
    
    _coverImageLabel = [ViewTool getLabelWith:CGRectMake(2 * space, space, [UIView getWidth:60], 15.0f) WithTitle:@"封面图片" WithFontSize:14.0f WithTitleColor:lightGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_coverView addSubview:_coverImageLabel];
    
    _showCoverImage = [[UIImageView alloc] initWithFrame:CGRectMake(_coverImageLabel.maxX + space, _coverImageLabel.y,40.0f, 40.0f)];
    [_coverView addSubview:_showCoverImage];
//    _showCoverImage.backgroundColor = [UIColor redColor];
    
    _takePicBtn = [[UIButton alloc] initWithFrame:CGRectMake(KSCreenW - 2 * space - _showCoverImage.width, _coverImageLabel.y, _showCoverImage.width, _showCoverImage.width)];
    [_coverView addSubview:_takePicBtn];
    [_takePicBtn setImage:[UIImage imageNamed:@"相机star"] forState:UIControlStateNormal];
    [_takePicBtn addTarget:self action:@selector(takePicture3:) forControlEvents:UIControlEventTouchUpInside];
    _takePicBtn.tag = 131;
    
    UIView * grayView = [[UIView alloc] initWithFrame:CGRectMake(0, _showCoverImage.maxY + 2 * space, KSCreenW, [UIView getWidth:15])];
    grayView.backgroundColor = graySectionColor;
    [_coverView addSubview:grayView];
    
    _coverView.frame = CGRectMake(0, _topView.maxY, KSCreenW, grayView.maxY);
    
    
    
}
- (void)drawBottomView
{
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _coverView.maxY, KSCreenW, [UIView getHeight:50])];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_bottomView];
//    _picScroollVeiw = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _coverView.maxY, KSCreenW, [UIView getHeight:50])];
//    _picScroollVeiw.userInteractionEnabled = YES;
////    _picScroollVeiw
//    _bottomView.backgroundColor = [UIColor whiteColor];
//    [_mainScrollView addSubview:_picScroollVeiw];
    
    _titleLabel = [ViewTool getLabelWith:CGRectMake(2 * space, space, 100, 15.0f) WithTitle:@"发布人群" WithFontSize:14.0 WithTitleColor:lightGrayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_bottomView addSubview:_titleLabel];
    
//    _addPersonsBtn = [[UIButton alloc] initWithFrame:[UIView getRectWithX:_titleLabel.x Y:_titleLabel.maxY + space width:40.0f andHeight:40.0f]];
//    [_addPersonsBtn setImage:[UIImage imageNamed:@"添加人员"] forState:UIControlStateNormal];
//    _addPersonsBtn.layer.cornerRadius = _addPersonsBtn.width / 2.0;
//    _addPersonsBtn.layer.masksToBounds = YES;
//    _addPersonsBtn.backgroundColor = [UIColor lightGrayColor];
//    [_addPersonsBtn addTarget:self action:@selector(addPerson8:) forControlEvents:UIControlEventTouchUpInside];
//    [_picScroollVeiw addSubview:_addPersonsBtn];
////    _bottomView.frame = CGRectMake(0, _coverView.maxY, KSCreenW, _addPersonsBtn.maxY +  space);
    
   selectView = [[SelectPersonView alloc] initWithFrame:CGRectMake(2 * space, _titleLabel.maxY + space / 2.0f, KSCreenW - 4 * space, [UIView getHeight:50.0f])];
    selectView.backgroundColor = [UIColor whiteColor];
    selectView.delegate = self;
    [_bottomView addSubview:selectView];
    
    
   _bottomView.frame = CGRectMake(0, _coverView.maxY, KSCreenW, selectView.maxY +  space);
//    NSLog(@"%f,%f",_bottomView.maxY + 64,KSCreenH - 49);
    if (_bottomView.maxY + 64 > KSCreenH - 49) {
        _mainScrollView.contentSize = CGSizeMake(0, _bottomView.maxY + 10);
    }else{
 _mainScrollView.contentSize = CGSizeMake(0, 0);
    }

}
- (void)drawPostButton
{
    _postBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, KSCreenH - TabbarH, KSCreenW, TabbarH)];
    [_postBtn addTarget:self action:@selector(postDistribute1:) forControlEvents:UIControlEventTouchUpInside];
    [_postBtn setTitle:@"确定提交" forState:UIControlStateNormal];
    [_postBtn setTitleColor:darkOrangeColor forState:UIControlStateNormal];
    [self.view addSubview:_postBtn];
    UIView *line3 = [ViewTool getLineViewWith:CGRectMake(0, 0, KSCreenW, 1) withBackgroudColor:grayLineColor];
    [_postBtn addSubview:line3];
    
    
}
#pragma mark--添加发布人群
//添加发布人群
- (void)addPerson
{
    SelectViewController *selectViewController = [[SelectViewController alloc]init];
    selectViewController.modalPresentationStyle =  UIModalPresentationPageSheet;
    selectViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    selectViewController.delegate = self;
    
    [self.navigationController pushViewController:selectViewController animated:YES];
//    self.navigationController.navigationBarHidden = YES;
//    self.tabBarController.tabBar.hidden = YES;
//    AppDelegate * appdelagte = [UIApplication sharedApplication].delegate;
//    appdelagte.tabbarControl.bottomView.hidden = YES;
//    
//    //背影黑罩
//    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCreenW, KSCreenH)];
//    _backView.backgroundColor = [UIColor blackColor];
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBlackView:)];
//    [_backView addGestureRecognizer:tap];
//    _backView.alpha = 0.1;
//    
//    [self.view addSubview:_backView];
//    
//    [UIView animateWithDuration:0.2 animations:^{
//        _backView.alpha = 0.6f;
//    } completion:^(BOOL finished) {
//        [self addSelectView];
//    }];
    
    
    
}
- (void)getSelectedStaff:(NSArray *)array
{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
//    for (int i = 0; i < arr.count; i ++) {
//        UserModel *model1 = arr[i];
//    for (int j = 0; j < selectView.allPersonArray.count; i++) {
//        UserModel *mod = selectView.allPersonArray[j];
//        if (model1.uid == mod.uid) {
//            [arr removeObject:model1];
//        }
//    }
//  }
    NSLog(@"返回的数组人数%lu",(unsigned long)arr.count);
    selectView.personArray = arr;
    
//    NSLog(@"人数%ld",array.count);3264732
//    NSLog(@"%d",personCount);
//    CGFloat picW = _addPersonsBtn.width;
//    CGFloat  X = _addPersonsBtn.x;
////    _addPersonsBtn.hidden = YES;
//    for (int i = 0; i < array.count; i ++) {
//        UserModel *model = array[i];
//        UIButton * picBtn = [[UIButton alloc] initWithFrame:CGRectMake( X +  i * (_addPersonsBtn.width + space), _addPersonsBtn.y, picW, picW)];
//        picBtn.tag = 24680 + i + _personArray.count;
//        [picBtn addTarget:self action:@selector(clickToDeletePic:) forControlEvents:UIControlEventTouchUpInside];
//        
//        picBtn.layer.cornerRadius = picW/2.0f;
//        picBtn.layer.masksToBounds = YES;
//        
//        [_picScroollVeiw addSubview:picBtn];
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LoadImageUrl,model.logo]]]];
//        [picBtn setImage:image forState:UIControlStateNormal];
//        if (i == array.count - 1) {
//            
////            _picScroollVeiw.contentSize = CGSizeMake(KSCreenW + 34, 0);
//            _addPersonsBtn.frame = CGRectMake(picBtn.maxX + space, picBtn.y, picW, picW);
//            _picScroollVeiw.contentSize = CGSizeMake(_addPersonsBtn.maxX + space, 0);
//        }
//        
//    
//    }
//    
//       [_personArray addObjectsFromArray:array];
//        personCount = (int)_personArray.count;
//    NSLog(@"%d",personCount);
    
}

- (void)clickToDeletePic:(UIButton *)btn
{
//#warning 删除有点问题
//    NSLog(@"personCount %d",personCount);
//    [btn removeFromSuperview];
//    NSInteger tag = btn.tag - 24680;
//    NSLog(@"tag %d",tag);
//    NSLog(@"personArr %@",_personArray);
    [_personArray removeObjectAtIndex:0];
    btn.hidden = YES;
    personCount--;
    if (personCount == 0) {
        _addPersonsBtn.frame = [UIView getRectWithX:_titleLabel.x Y:_titleLabel.maxY + space width:[UIView getWidth:30] andHeight:[UIView getWidth:30]];
        [_personArray removeAllObjects];
    }
    
//    for(int i = 0;i < _personArray.count; i++){
//        UserModel * model = _personArray[i];
//    }
}
//- (void)addSelectView
//{
//    _selectStaffView = [[SelectStaffView alloc]initWithFrame:CGRectMake(KSCreenW, 0, KSCreenW - 50, KSCreenH)];
//    [self.view addSubview:_selectStaffView];
//    [UIView animateWithDuration:0.2 animations:^{
//        _selectStaffView.frame = CGRectOffset(_selectStaffView.frame, - KSCreenW+ 50, 0);
//    }];
//}

//- (void)tapBlackView:(UITapGestureRecognizer *)tap
//{
//    [UIView animateWithDuration:0.3 animations:^{
//        _selectStaffView.frame = CGRectOffset(_selectStaffView.frame, KSCreenW - 50, 0);
//        
//    } completion:^(BOOL finished) {
//        [_selectStaffView removeFromSuperview];
//        [UIView animateWithDuration:0.1 animations:^{
//            self.navigationController.navigationBarHidden = NO;
//            _backView.alpha = 0;
//            
//        } completion:^(BOOL finished) {
//            [_backView removeFromSuperview];
//            
//            
//        }];
//    }];

#pragma mark --提交发布
//提交发布
- (void)postDistribute1:(UIButton *)btn
{


   

//    NSString * coverImgStr =  [[NSData dataWithContentsOfFile:[[NSUserDefaults standardUserDefaults] objectForKey:@"coverPicPath"]] base64Encoding];
//    NSString *contentStr = [[NSData dataWithContentsOfFile:[[NSUserDefaults standardUserDefaults] objectForKey:@"contentPicPath"]] base64Encoding];
  
  
   
    
//    if (_noticeName.text == nil) {
//        [self.view makeToast:@"请填写公告名称"];
//    }
    if (_noticeConten.text == nil) {
         [self.view makeToast:@"请填写公告内容"];
    }
//    if () {
//        <#statements#>
//    }
//    dealeID = @"";
    NSMutableString *alluserIds = [[NSMutableString alloc] init];
    for (int i = 0; i< selectView.allPersonArray.count; i ++) {
        UserModel * model = selectView.allPersonArray[i];
//        NSLog(@"%@,%d",model.name,model.uid);
        NSString *str = [NSString stringWithFormat:@"%d,",model.uid];
//        NSLog(@"model.uid  %d",model.uid);
        [alluserIds appendString:str];
//          NSLog(@"%@",str);
    }
//    NSLog(@"dealeID  %@",alluserIds);
    if (selectView.allPersonArray.count == 0 ) {
          [self.view makeToast:@"请选择发布人群"];
        
    }else if (_noticeName.text == nil || _noticeName.text.length == 0) {
        [self.view makeToast:@"请填写公告名称"];
    }else  if (_noticeConten.text == nil || _noticeConten.text.length == 0) {
        [self.view makeToast:@"请填写公告内容"];
    }else {
        _postBtn.enabled = NO;
        [self.view makeToastActivity];
        NSString *Personuid = [alluserIds substringToIndex:alluserIds.length - 1];
           NSLog(@"处理后的 人员uid %@",Personuid);
        NSMutableDictionary * paramDict = [DataTool changeType:@{@"title" : _noticeName.text,@"content" :_noticeConten.text,@"author": @(UID),@"readers" : Personuid,@"token" : TOKEN,@"uid" :@(UID)}];
        
        NSString *coverImgStr;
        NSString *contentStr;
        if (_coverPicArr.count != 0) {
            coverImgStr  = [(NSData *)_coverPicArr.firstObject base64Encoding];
            //        NSLog(@"封面%@",coverImgStr);
        }
        if (_contentPIcArr.count != 0) {
            contentStr = [(NSData *)_contentPIcArr.firstObject base64Encoding];
            //         NSLog(@"内容%@",contentStr);
        }
        
        if(coverImgStr){
            [paramDict setObject:coverImgStr forKey:@"logo"];
        }
        if(contentStr){
          [paramDict setObject:contentStr forKey:@"img"];
        }
        if ([contentStr isEqualToString:coverImgStr]) {
//            NSLog(@"内容图片和封面图片是同一张");
        }
        
//            NSLog(@"新建公告的参数是%@",paramDict);
        [DataTool postWithUrl:MANAGER_CREAT_NOTICE_URL parameters:paramDict success:^(id data) {
               
            id backData = CRMJsonParserWithData(data);
                   NSLog(@"%@",backData);
            if([backData[@"code"] intValue] == 100){
//                [self.view hideToastActivity];
                [self.view makeToast:@"发布成功"];
                [self distributeNotice];//退回上一页
                
            }else{
                 [self.view hideToastActivity];
                [self.view makeToast:@"发布失败"];
                
            }
        } fail:^(NSError *error) {
            NSLog(@"error%@",error.localizedDescription);
            [self.view makeToast:[NSString stringWithFormat:@"%@",error.localizedDescription]];
             [self.view hideToastActivity];
            _postBtn.enabled = YES;
        }];

    }
 
}


- (void)keyboardWillShow:(NSNotification *)noti
{
    NSDictionary *usrInfoDict = noti.userInfo;
//    NSLog(@"%@",usrInfoDict);
    CGRect keyRect = [usrInfoDict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat showtime = [usrInfoDict[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if(_noticeName.isFirstResponder){
//        NSDictionary *usrInfoDict = noti.userInfo;
//        NSLog(@"%@",usrInfoDict);
//        CGRect keyRect = [usrInfoDict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//        CGFloat showtime = [usrInfoDict[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGRect rect = [_noticeName convertRect:_noticeName.frame toView:self.view ];
        diff = fabs( keyRect.origin.y - CGRectGetMaxY(rect)) + [UIView getHeight:20];
        
        if (keyRect.origin.y < CGRectGetMaxY(rect)) {
            [UIView animateWithDuration:showtime animations:^{
                //                self.view.transform = CGAffineTransformMakeTranslation(0, -diff);
                self.view.frame = CGRectMake(0, -diff, KSCreenW, KSCreenH - 64);
            }];
        }
    }else if(_noticeConten.isFirstResponder){
//        NSDictionary *usrInfoDict1 = noti.userInfo;
//        
//        CGRect keyRect1 = [usrInfoDict1[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//        CGFloat showtime1 = [usrInfoDict1[UIKeyboardAnimationDurationUserInfoKey] floatValue];
#warning 这里转换坐标系 怎么会不对呢
        CGRect rect = [_noticeConten convertRect:_noticeConten.frame toView:self.view ];
//              NSLog(@"%f,%f",keyRect.origin.y, CGRectGetMaxY(rect));
//        NSLog(@"%f,%f,%f,%f",KSCreenH,KSCreenH - 271, CGRectGetMaxY(rect),CGRectGetMaxY(_noticeConten.frame) + 64);
        diff = fabs( keyRect.origin.y - (_noticeConten.maxY + 64)) + [UIView getHeight:20];
        //        NSLog(@"%f,%f",keyRect1.origin.y, CGRectGetMaxY(rect));
        if (keyRect.origin.y < (_noticeConten.maxY + 64)) {
            [UIView animateWithDuration:showtime animations:^{
                //                self.view.transform = CGAffineTransformMakeTranslation(0, -diff);
                self.view.frame = CGRectMake(0, -diff, KSCreenW, KSCreenH - 64);
            }];
        }
    }else if([_distributePerson isFirstResponder]){
        CGRect rect = [_distributePerson convertRect:_distributePerson.frame toView:self.view ];
        
        diff = fabs( keyRect.origin.y - CGRectGetMaxY(rect)) + [UIView getHeight:20];
        
        if (keyRect.origin.y < CGRectGetMaxY(rect)) {
            [UIView animateWithDuration:showtime animations:^{
                //                self.view.transform = CGAffineTransformMakeTranslation(0, -diff);
                self.view.frame = CGRectMake(0, -diff, KSCreenW, KSCreenH - 64);
            }];
        }
    }
    
}
- (void)keyboardWillHide:(NSNotification *)noti
{
    if (self.view.y < 0) {
        NSDictionary *InfoDict = noti.userInfo;
        
        CGFloat Hidetime = [InfoDict[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        [UIView animateWithDuration:Hidetime animations:^{
            self.view.frame = CGRectMake(0, 0, KSCreenW, KSCreenH);
        }];
    }
    //    NSDictionary *InfoDict = noti.userInfo;
    //
    //    CGFloat Hidetime = [InfoDict[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //  [UIView animateWithDuration:Hidetime animations:^{
    //      self.view.transform = CGAffineTransformMakeTranslation(0,- diff);
    //  }];
    
}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    
// NSLog(@"发部人群");
//    if (![_distributePerson isExclusiveTouch] || ![_noticeName isExclusiveTouch] || ![_noticeConten isExclusiveTouch]) {
//        [_distributePerson resignFirstResponder];
//        [_noticeConten resignFirstResponder];
//        [_noticeName resignFirstResponder];
//    }
//}
//- (void)takePicture:(UIButton *)sender
//{
//    if (sender.tag == 130) {//内容图片
//        
//    }else if (sender.tag ==131){//封面图片
//        
//    }
//}

//获取照片
- (void)takePicture3:(UIButton *)sender
{
    //uialertsheet
    if (sender.tag == 131) {
        isCoverImage = YES;
    }else{
        isCoverImage = NO;
    }
    NSLog(@"是否是封面图片%d",isCoverImage);
//    isCoverImage = YES;
    if(IOS7){
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开手机相册",@"手机相机拍摄", nil];
        [actionSheet showInView:self.view];
    }else{
        UIAlertController * alertionControll = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"打开手机相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self takePictureInPhoneWithTag:sender.tag];
        }];
        UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"手机相机拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self takePictureWithCameraWithTag:sender.tag];
        }];
        UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertionControll addAction:action1];
        [alertionControll addAction:action2];
        [alertionControll addAction:action3];
        if(alertionControll != nil){
            [self presentViewController:alertionControll animated:YES completion:nil];
        }
    }
    
    
    
}
#pragma mark -- 相册
- (void)takePictureInPhoneWithTag:(NSInteger)tag
{
    
    UIImagePickerController *imagePick = [[UIImagePickerController alloc] init];
    imagePick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePick.delegate = self;//遵循两个代理方法
    imagePick.allowsEditing = YES;
    [self presentViewController:imagePick animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];

    NSString * docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSFileManager * fielManege = [NSFileManager defaultManager];
    [fielManege createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
//    NSString * contentPicPath = [NSString stringWithFormat:@"%@%@",docPath,@"/ContentImage.png"];//内容图片的存放路径
//    [[NSUserDefaults standardUserDefaults] setObject:contentPicPath forKey:@"contentPicPath"];
    
//    NSString * coverPicPath = [NSString stringWithFormat:@"%@%@",docPath,@"/CoverImage.png"];//封面图片的存放路径
//    [[NSUserDefaults standardUserDefaults] setObject:coverPicPath forKey:@"coverPicPath"];
    
//    [fielManege createFileAtPath:[NSString stringWithFormat:@"%@%@",docPath,@"/image.png"] contents:data attributes:nil];
//    [picker dismissViewControllerAnimated:YES completion:nil];
 
    //一种可裁剪 一种原始
    //UIImagePickerControllerEditedImage
    //UIImagePickerControllerOriginalImage
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data;//将图片转成data类型
        data = UIImageJPEGRepresentation(image, 0.4);//后参数压缩系数
    NSLog(@"是否是封面图片%d",isCoverImage);
        if(isCoverImage){
//            [fielManege createFileAtPath:coverPicPath contents:data attributes:nil];
            [_coverPicArr addObject:data];
            _showCoverImage.image = image;
        }else{
//            [fielManege createFileAtPath:contentPicPath contents:data attributes:nil];
            [_contentPIcArr addObject:data];
            _showPicImage.image = image;
        }
//        [fielManege createFileAtPath:[NSString stringWithFormat:@"%@%@",docPath,@"/image.png"] contents:data attributes:nil];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_noticeName resignFirstResponder];
    [_noticeConten resignFirstResponder];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 相机
- (void)takePictureWithCameraWithTag:(NSInteger)tag
{
   
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后可编辑图片
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"无法打开摄像机" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertVC animated:YES completion:nil];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:action];
    }
    
}

#pragma mark --actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self takePictureInPhoneWithTag:130];
    }else if (buttonIndex == 1){
        [self takePictureWithCameraWithTag:131];
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    [actionSheet dismissWithClickedButtonIndex:2 animated:YES];
}

- (void)handleTap
{
    if (![_distributePerson isExclusiveTouch] || ![_noticeName isExclusiveTouch] || ![_noticeConten isExclusiveTouch]) {
        [_distributePerson resignFirstResponder];
        [_noticeConten resignFirstResponder];
        [_noticeName resignFirstResponder];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    _postBtn.enabled = YES;
    [_personArray removeAllObjects];
   
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = NO;
}
- (void)distributeNotice
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
