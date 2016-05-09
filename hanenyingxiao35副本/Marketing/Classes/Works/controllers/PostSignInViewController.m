//
//  PostSignInViewController.m
//  Marketing
//
//  Created by Hanen 3G 01 on 16/2/25.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//提交签到页面

#import "PostSignInViewController.h"
#import "FinishSignController.h"
#import "ChangePlaceMap.h"
#import "MapClientViewController.h"
//#define TopSpace  [UIView getWidth:10.0f]

@interface PostSignInViewController ()<UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,MapClientViewControllerDelegate>
{
    //第一部分
    UIView     *_timePlaceView;
    UILabel    *_timeTitleLabel;
    UILabel    *_currentTimeLabel;
    UILabel    *_signPlaceLabel;
    UIButton   *_currentPlaceBtn;
    
    //中间部分
    UIView     *_recordView;
    UILabel    *_recordTitle;
    UITextView *_textView;
    UIButton   *_takePictureBtn;
    UIImageView *_showPicView;
    
    //下面部分
    UILabel    *_companyTitle;
//    UILabel    *_companyNameLabel;
    UITextField  *_companyField;
    CGFloat       diff;//键盘弹出时 高度差
    
    UIButton   *_postBtn;//提交按钮
    
    CGFloat   TopSpace;
    
    NSFileManager * fielManege;
    
//    CLLocationCoordinate2D Coordinate;
}
@end

@implementation PostSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:@"签到签退"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (IPhone4S) {
        TopSpace = 5.0f;
    }else{
        TopSpace =  [UIView getWidth:10.0f];
    }
    fielManege = [NSFileManager defaultManager];
    [self creatSignInfoView];// 签到 时间和地点
    [self creatRecordView];//备注视图
    [self creatCompnyView];
    [self creatPostBtn];//提交按钮
    
    self.navigationItem.leftBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithAction:@selector(popLastView)];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
   
}

- (void)creatSignInfoView
{
    _timePlaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, KSCreenW, [UIView getHeight:100])];
    _timePlaceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_timePlaceView];
    NSString *title2 ;
    if (self.signType == 1) {
        title2 = @"签到时间";
    }else{
        title2 = @"签退时间";
    }
    _timeTitleLabel = [ViewTool getLabelWith:CGRectMake(TopSpace, TopSpace, 80, 15) WithTitle:title2 WithFontSize:14.0f WithTitleColor:grayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_timePlaceView addSubview:_timeTitleLabel];
    
    _currentTimeLabel = [ViewTool getLabelWith:CGRectMake(_timeTitleLabel.x, _timeTitleLabel.maxY + TopSpace, 80, 20) WithTitle:self.currentTime WithFontSize:18.0f WithTitleColor:blackFontColor WithTextAlignment:NSTextAlignmentLeft];
     [_timePlaceView addSubview:_currentTimeLabel];
    
    
    UIView *line = [ViewTool getLineViewWith:CGRectMake(_currentTimeLabel.x, _currentTimeLabel.maxY + TopSpace, KSCreenW - 2 * TopSpace, 0.8) withBackgroudColor:grayLineColor];
    [_timePlaceView addSubview:line];
    
    NSString *title1 ;
    if (self.signType == 1) {
        title1 = @"签到地点(点击微调)";
    }else{
        title1 = @"签退地点(点击微调)";
    }
    _signPlaceLabel = [ViewTool getLabelWith:CGRectMake(_currentTimeLabel.x, line.maxY + TopSpace, 200, 15) WithTitle:title1 WithFontSize:14.0f WithTitleColor:grayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_timePlaceView addSubview:_signPlaceLabel];
    
    UIImageView *imaged = [[UIImageView alloc] initWithFrame:CGRectMake(_signPlaceLabel.x, _signPlaceLabel.maxY + TopSpace, [UIView getWidth:15.0f], [UIView getWidth:15.0f])];
    imaged.image = [UIImage imageNamed:@"定位"];
//    imaged.backgroundColor = [UIColor redColor];
    [_timePlaceView addSubview:imaged];
    
    
//    CGFloat w = [self.currentPlace boundingRectWithSize:CGSizeMake(MAXFLOAT , 20) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIView getFontWithSize:15.0f]} context:nil].size.width;
    _currentPlaceBtn = [[UIButton alloc] initWithFrame:CGRectMake(imaged.maxX, _signPlaceLabel.maxY + TopSpace, KSCreenW - imaged.maxX, 20)];
    [_currentPlaceBtn setTitleColor:blackFontColor forState:UIControlStateNormal];
//    _currentPlaceBtn.backgroundColor = [UIColor cyanColor];
//    _currentPlaceBtn setImage:[UIImage ] forState:<#(UIControlState)#>
    _currentPlaceBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
//    _currentPlaceBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    _currentPlaceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _currentPlaceBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_currentPlaceBtn setTitle:self.currentPlace forState:UIControlStateNormal];
    [_currentPlaceBtn setTitleColor:blackFontColor forState:UIControlStateNormal];
    _currentPlaceBtn.titleLabel.font = [UIView getFontWithSize:16.0f];
    [_currentPlaceBtn addTarget:self action:@selector(changePlace) forControlEvents:UIControlEventTouchUpInside];
    
    [_timePlaceView addSubview:_currentPlaceBtn];
    
    UIView * lighGrayView = [[UIView alloc] initWithFrame:CGRectMake(0, _currentPlaceBtn.maxY + TopSpace, KSCreenW, [UIView getHeight:20])];
    lighGrayView.backgroundColor = graySectionColor;
    [_timePlaceView addSubview:lighGrayView];
    _timePlaceView.frame = CGRectMake(0, 64, KSCreenW, lighGrayView.maxY);

}

- (void)creatRecordView
{
    _recordView = [[UIView alloc] initWithFrame:CGRectMake(0, _timePlaceView.maxY, KSCreenW, [UIView getHeight:130])];
    _recordView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_recordView];
    
//    [UIColor colorWithRed:162 / 255 green:162 / 255 blue:162 / 255 alpha:1];
    NSString *title ;
    if (self.signType == 1) {
        title = @"请填写签到备注(必填)";
    }else{
        title = @"请填写签退备注(必填)";
    }
    _recordTitle = [ViewTool getLabelWith:CGRectMake( TopSpace, TopSpace, 200, 15) WithTitle:title WithFontSize:14.0 WithTitleColor:grayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [_recordView addSubview:_recordTitle];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(2 * TopSpace, _recordTitle.maxY + 2, KSCreenW - 4 * TopSpace, [UIView getHeight:50])];
    _textView.delegate = self;
//    _textView.layer.borderWidth = 0.5;
//    _textView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.8].CGColor;
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.textColor = blackFontColor;
    _textView.font = [UIView getFontWithSize:15.0f];
    [_recordView addSubview:_textView];
    
    
    _takePictureBtn = [[UIButton alloc] initWithFrame:CGRectMake(_textView.x, _textView.maxY + TopSpace, [UIView getWidth:50], [UIView getWidth:50])];
    [_takePictureBtn addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];
    [_takePictureBtn setImage:[UIImage imageNamed:@"相机star"] forState:UIControlStateNormal];
//    _takePictureBtn.backgroundColor = [UIColor orangeColor];
    [_recordView addSubview:_takePictureBtn];
    
    _showPicView = [[UIImageView alloc] initWithFrame:CGRectMake(_takePictureBtn.maxX + TopSpace, _takePictureBtn.y, _takePictureBtn.height, _takePictureBtn.height)];
    [_recordView addSubview:_showPicView];
    
    
    UIView * lighGrayView2 = [[UIView alloc] initWithFrame:CGRectMake(0, _takePictureBtn.maxY + 2 * TopSpace, KSCreenW, [UIView getHeight:20])];
    lighGrayView2.backgroundColor = graySectionColor;
    [_recordView addSubview:lighGrayView2];
    _recordView.frame = CGRectMake(0, _timePlaceView.maxY, KSCreenW, lighGrayView2.maxY );
    
}

- (void)creatCompnyView
{
    _companyTitle = [ViewTool getLabelWith:CGRectMake( TopSpace, _recordView.maxY + 2 * TopSpace, 100, 15) WithTitle:@"当前公司" WithFontSize:14.0f WithTitleColor:grayFontColor WithTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:_companyTitle];
    
    _companyField = [[UITextField alloc] initWithFrame:CGRectMake(_companyTitle.x, _companyTitle.maxY + TopSpace, KSCreenW - 4 * TopSpace, 20)];
    _companyField.delegate = self;
    _companyField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_companyField];
    
    UIView *line2 = [ViewTool getLineViewWith:CGRectMake(_companyTitle.x, _companyField.maxY + TopSpace, KSCreenW - 4 * TopSpace, 0.8) withBackgroudColor:grayLineColor];
    [self.view addSubview:line2];
}

- (void)creatPostBtn
{
    _postBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, KSCreenH - 64, KSCreenW, 64)];
    [_postBtn addTarget:self action:@selector(postSignInfo:) forControlEvents:UIControlEventTouchUpInside];
    [_postBtn setTitleColor:darkOrangeColor forState:UIControlStateNormal];
    _postBtn.backgroundColor = TabbarColor;
    [_postBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _postBtn.width, 1)];
    lineLabel.backgroundColor = grayLineColor;
    [_postBtn addSubview:lineLabel];
    
    [self.view addSubview:_postBtn];
}
- (void)changePlace
{
//    ChangePlaceMap * mapVC = [[ChangePlaceMap alloc] init];
////  [mapVC changePlace:^(NSString *detailplace) {
////      NSLog(@"detailplace%@",detailplace);
////      [_currentPlaceBtn setTitle:detailplace forState:UIControlStateNormal];
////  }];
//    mapVC.delegate = self;
//    [self.navigationController pushViewController:mapVC animated:YES];
    
    MapClientViewController *mapVC  = [[MapClientViewController alloc] init];
    mapVC.result = 1;
    mapVC.delegate = self;
    [self.navigationController pushViewController:mapVC animated:YES];
}

- (void)getClickPlaceName:(NSString *)PlaceString withCoordinat2D:(CLLocationCoordinate2D)pt
{
    [_currentPlaceBtn setTitle:PlaceString forState:UIControlStateNormal];
        _currentPlaceBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.longt = [NSString stringWithFormat:@"%f",pt.longitude];
    self.lati = [NSString stringWithFormat:@"%f",pt.latitude];
    
//    Coordinate = pt;
}
//- (void)changPlaceWith:(NSString *)placeName
//{
//    [_currentPlaceBtn setTitle:placeName forState:UIControlStateNormal];
//    _currentPlaceBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
//}
//获取照片
- (void)takePicture:(UIButton *)sender
{
    //uialertsheet
    if(IOS7){
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开手机相册",@"手机相机拍摄", nil];
        [actionSheet showInView:self.view];
    }else{
        UIAlertController * alertionControll = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"打开手机相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self takePictureInPhone];
        }];
        UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"手机相机拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self takePictureWithCamera];
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
- (void)takePictureInPhone
{
    UIImagePickerController *imagePick = [[UIImagePickerController alloc] init];
    imagePick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePick.delegate = self;//遵循两个代理方法
    imagePick.allowsEditing = YES;
    [self presentViewController:imagePick animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
   
    //当选择类型是图片的时候
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
        }
        [picker dismissViewControllerAnimated:YES completion:nil];
        [self saveImage:image WithName:@"Signimage.png"];
//        NSData *data;//将图片转成data类型
//        data = UIImageJPEGRepresentation(image, 1.0);//后参数压缩系数
//        
//        NSString * docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
//    
//        [fielManege createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
//        [fielManege createFileAtPath:[NSString stringWithFormat:@"%@%@",docPath,@"/image.png"] contents:data attributes:nil];
       
        _showPicView.image = image;
    }
}
-(void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName{
    ////    if (_isChangeBG) {
    //        //自定义裁剪图片
    //        //        UIGraphicsBeginImageContext(CGSizeMake(YPQScreenW, 194));
    //        //        [tempImage drawInRect:CGRectMake(0, 0, YPQScreenW, 194)];
    //        //        UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    //        //        UIGraphicsEndImageContext();
    //        UIImage *scaleImage = [self cutImage:tempImage];
    //        NSData *imageData = UIImageJPEGRepresentation(scaleImage, 0.5);
    //        for (int i = 1; i < 5; i ++) {
    //            if (imageData.length > 50 * 1024) {//封面 50k
    //                imageData = UIImageJPEGRepresentation(scaleImage, 0.5 - i * 0.1);
    //            } else {
    //                break;
    //            }
    //        }
    NSData *imageData = UIImageJPEGRepresentation(tempImage, 0.4);
    
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *totalPath = [documentPath stringByAppendingPathComponent:imageName];
    [imageData writeToFile:totalPath atomically:YES];
    //        [[NSUserDefaults standardUserDefaults] setObject:totalPath forKey:@"newBG"];
    //        [[NSUserDefaults standardUserDefaults] synchronize];
    //        UIImage *image = [UIImage imageWithContentsOfFile:totalPath];
    ////        [_bgIV setBackgroundImage:image forState:UIControlStateNormal];
    //
    //        [self uploadCoverImage:totalPath];
    //    } else {
    //
    //        for (int i = 1; i < 5; i ++) {
    //            if (imageData.length > 100 * 1024) {//头像 20k
    //                imageData = UIImageJPEGRepresentation(tempImage, 0.5 - i * 0.1);
    //            } else {
    //                break;
    //            }
    //        }
    //        NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    //        NSString *totalPath = [documentPath stringByAppendingPathComponent:imageName];
    //        [imageData writeToFile:totalPath atomically:YES];
    [[NSUserDefaults standardUserDefaults] setObject:totalPath forKey:@"temImagePath"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //        [self uploadUserImage:totalPath];
    //    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 相机
- (void)takePictureWithCamera
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
        [self takePictureInPhone];
    }else if (buttonIndex == 1){
        [self takePictureWithCamera];
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    [actionSheet dismissWithClickedButtonIndex:2 animated:YES];
}
#pragma mark --/提交签到
//提交签到
- (void)postSignInfo:(UIButton *)btn
{

//    FinishSignController *finishVC = [[FinishSignController alloc] init];
//    [self.navigationController pushViewController:finishVC animated:YES];
    
//    NSString * docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
//    NSString * imagePath = [NSString stringWithFormat:@"%@/image.png",docPath];
//    NSData *data = [NSData dataWithContentsOfFile:imagePath];
//    NSLog(@"imageData :%@",data);
  
   
//    NSLog(@"%@",base64Str);
//       NSLog(@"公司 %@",_companyField.text);
//    NSLog(@"地址 %@",_currentPlaceBtn.currentTitle);
    if(_currentPlaceBtn.titleLabel.text.length == 0 |_currentPlaceBtn.currentTitle == nil){
        [self.view makeToast:@"请填写您的地址"];
       
    }else if(_companyField.text == nil | _companyField.text.length == 0){
        [self.view makeToast:@"请填写企业"];
       
    }else if(_textView.text.length == 0){
         [self.view makeToast:@"请填写备注"];
    }else{
        _postBtn.enabled = NO;
        [self.view makeToastActivity];
        NSData *data = [NSData dataWithContentsOfFile:[[NSUserDefaults standardUserDefaults] objectForKey:@"temImagePath"]];
        
        NSString *base64Str = [data base64Encoding];
    NSMutableDictionary *dict = [DataTool changeType:@{@"token":TOKEN,@"uid": @(UID),@"address": _currentPlaceBtn.currentTitle,@"remark":_textView.text,@"company" : _companyField.text,@"type" : @(self.signType)}];
    if (base64Str) {
        [dict setObject:base64Str forKey:@"img"];
    }
//    NSLog(@"定位的经纬度 %@,%@",self.longt,self.lati);
    if (self.longt && self.lati) {
        [dict setObject:self.longt forKey:@"lon"];
        [dict setObject:self.lati forKey:@"lat"];
    }
   
        [DataTool postWithUrl:POST_SIGN_URL parameters:dict success:^(id data) {
            //        NSLog(@"",(int)backD[@"code"]);
            id backD = CRMJsonParserWithData(data);
            if([backD[@"code"] intValue] == 100){
                if(self.signType == 1){
//                    [self.view makeToast:@"您已成功提交签到" ];
                    [ self.view makeToast:@"您已成功提交签到" duration:2.5f position:@"center"];
                }else{
                    [self.view makeToast:@"您已成功提交签退" duration:2.5f position:@"center"];
                }
//                [self.view makeToast:@"您已成功提交"];
                _postBtn.enabled = NO;
                [self.view hideToastActivity];
                [self performSelector:@selector(popLastView) withObject:nil afterDelay:1.5f];
//                [self popLastView];
            }else{
                [self.view makeToast:@"签到提交失败"];
                 [self.view hideToastActivity];
            }
            //        NSLog(@"log1");
        } fail:^(NSError *error) {
            NSLog(@"error %@",error.localizedDescription);
        }];
        [self.view hideToastActivity];
    }
}
    //注意字典的里面的元素 要判断 不能是空的才可以
    //_currentPlaceBtn.currentTitle
//    NSLog(@"%@",data);//存在本地的照片
    //@"img": data == nil ? @" ": data
//    NSDictionary *dict = @{@"token":TOKEN,@"uid": @(UID),@"address":@"南京市大运河",@"remark":_textView.text,@"company" : _companyField.text,@"type" : @(self.signType),@"img":  data};
//    [DataTool sendGetWithUrl:POST_SIGN_URL parameters:dict success:^(id data) {
//        id backData = CRMJsonParserWithData(data);
//        NSLog(@"%@",backData[@"code"]);
//    } fail:^(NSError *error) {
//        
//    }];

#pragma mark --textview代理方法
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [_textView resignFirstResponder];
    return YES;
}
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
//{
//    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//        return NO;
//    }
//    return YES;
//}
#pragma mark --textfield代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (![_textView isExclusiveTouch] || ![_companyField isExclusiveTouch]) {
        [_textView resignFirstResponder];
        [_companyField resignFirstResponder];
    }
}
#pragma mark --键盘通知
- (void)keyboardWillShow:(NSNotification *)noti
{
    if(_companyField.isFirstResponder){
        NSDictionary *usrInfoDict = noti.userInfo;
//        NSLog(@"%@",usrInfoDict);
        CGRect keyRect = [usrInfoDict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat showtime = [usrInfoDict[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        diff = fabs( keyRect.origin.y - _companyField.maxY) + [UIView getHeight:20];
       
        if (keyRect.origin.y < _companyField.maxY) {
            [UIView animateWithDuration:showtime animations:^{
//                self.view.transform = CGAffineTransformMakeTranslation(0, -diff);
                self.view.frame = CGRectMake(0, -diff, KSCreenW, KSCreenH - 64);
            }];
        }
    }else if(_textView.isFirstResponder){
        NSDictionary *usrInfoDict1 = noti.userInfo;
    
        CGRect keyRect1 = [usrInfoDict1[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat showtime1 = [usrInfoDict1[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGRect rect = [_textView convertRect:_textView.frame toView:self.view ];

        diff = fabs( keyRect1.origin.y - CGRectGetMaxY(rect)) + [UIView getHeight:20];
//        NSLog(@"%f,%f",keyRect1.origin.y, CGRectGetMaxY(rect));
        if (keyRect1.origin.y < CGRectGetMaxY(rect)) {
            [UIView animateWithDuration:showtime1 animations:^{
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

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    _postBtn.enabled = YES; 
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = NO;
    
//    NSString * docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
//    NSString * imagePath = [NSString stringWithFormat:@"%@/image.png",docPath];
//    [fielManege removeItemAtPath:imagePath error:nil];
    
     [[NSUserDefaults standardUserDefaults] setObject:@" " forKey:@"temImagePath"];
    
    
}
- (void)popLastView
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didReceiveMemoryWarning
{
        [super didReceiveMemoryWarning];//即使没有显示在window上，也不会自动的将self.view释放。注意跟ios6.0之前的区分
        // Add code to clean up any of your own resources that are no longer necessary.
        // 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidUnLoad
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
            //需要注意的是self.isViewLoaded是必不可少的，其他方式访问视图会导致它加载，在WWDC视频也忽视这一点。
            if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
            {
                // Add code to preserve data stored in the views that might be
                // needed later.
                // Add code to clean up other strong references to the view in
                // the view hierarchy.
                self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
            }
        }
    }


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
