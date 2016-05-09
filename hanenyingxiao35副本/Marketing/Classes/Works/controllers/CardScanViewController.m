//
//  CardScanViewController.m
//  Marketing
//
//  Created by wmm on 16/3/13.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "CardScanViewController.h"
#import "HWCloudsdk.h"
#import "NewClientViewController.h"
#import "ClientModel.h"
#import "WorkViewController.h"
#import "SVProgressHUD.h"

@interface CardScanViewController (){
    int i;
}

@property (strong, nonatomic) UIView *overlayView;
@property (strong,nonatomic) UIImagePickerController * imagePikerViewController;
@property (strong,nonatomic) UIButton *takeButton;

@property (strong,nonatomic) WorkViewController *workViewController;

@end

@implementation CardScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    i = 0;
    self.imagePikerViewController = [[UIImagePickerController alloc] init];
    self.imagePikerViewController.delegate = self;
    self.imagePikerViewController.allowsEditing = YES;
    
    _workViewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"M,M,M");
    self.tabBarController.hidesBottomBarWhenPushed = YES;

}

- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    if (i == 0){
        [self startScanning];
    }

}

- (void)popViewController
{
//    [self.navigationController popViewControllerAnimated:YES];
    
    
    //此页面已经存在于self.navigationController.viewControllers中,并且是当前页面的前一页面
//    _workViewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    //初始化其属性
//    _workViewController.cardDictionary = nil;
    //传递参数过去
//    _workViewController.cardDictionary = _cardDictionary;
    //使用popToViewController返回并传值到上一页面
    
    self.tabBarController.hidesBottomBarWhenPushed = NO;
//    [self.navigationController popViewControllerAnimated:YES];

    [self.navigationController popToViewController:_workViewController animated:YES];
}

-(void)takePhoto{
    //拍照，会自动回调- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info，对于自定义照相机界面，拍照后回调可以不退出实现连续拍照效果
    NSLog(@"takePicture...");
    [self.imagePikerViewController takePicture];
    [SVProgressHUD showWithStatus:@"识别中"];
//    [self.view makeToastActivity];
    self.takeButton.hidden = YES;
}

- (UIView *)drawCameraView {
    UIView* cameraView = [[UIView alloc] initWithFrame:CGRectMake(0,0, KSCreenW, KSCreenH)];
    
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCreenW, 30)];
    upView.alpha = 0.5;
    upView.backgroundColor = [UIColor blackColor];
    [cameraView addSubview:upView];
    
    UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 35, KSCreenH-110)];
    leftView.alpha = 0.5;
    leftView.backgroundColor = [UIColor blackColor];
    [cameraView addSubview:leftView];
    
    UIView* rightView = [[UIView alloc] initWithFrame:CGRectMake(KSCreenW-35, 30, 35, KSCreenH-110)];
    rightView.alpha = 0.5;
    rightView.backgroundColor = [UIColor blackColor];
    [cameraView addSubview:rightView];
    
    //    UIView* middleView = [[UIView alloc] initWithFrame:CGRectMake(35, 30, KSCreenW-70, KSCreenH-110)];
    UIView* middleView = [[UIView alloc] initWithFrame:CGRectMake(35, 30, KSCreenW-70, KSCreenH-150)];
    middleView.alpha = 1;
    [cameraView addSubview:middleView];
    
    UIView * downView1 = [[UIView alloc] initWithFrame:CGRectMake(35, KSCreenH-120, KSCreenW-70, 40)];
    downView1.alpha = 0.5;
    downView1.backgroundColor = [UIColor blackColor];
    [cameraView addSubview:downView1];
    
    UIView * downView = [[UIView alloc] initWithFrame:CGRectMake(0, KSCreenH-80, KSCreenW, 80)];
    downView.alpha = 1;
    //    NSString *bg_path = [[NSBundle mainBundle] pathForResource:@"uexCardRec/card_bg" ofType:@"png"];
    //    UIImage *bg_img = [UIImage imageWithContentsOfFile:bg_path];
//    UIImage *bg_img = [UIImage imageNamed:@"card_bg.png"];
//    downView.backgroundColor = [UIColor colorWithPatternImage:bg_img];
    downView.backgroundColor = purpleFontColor;
    [cameraView addSubview:downView];
    
    
    
//    UIImageView *takeImg = [[UIImageView alloc] initWithFrame:CGRectMake(KSCreenW/2-30, KSCreenH-65, 80, 80)];
//    takeImg.image = [UIImage imageNamed:@"相机.png"];
//    takeImg.layer.cornerRadius = self.takeButton.width/2;
//    takeImg.layer.masksToBounds = YES;
//    [cameraView addSubview:takeImg];
    
    self.takeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.takeButton.alpha = 1;
    //      NSString *path = [[NSBundle mainBundle] pathForResource:@"uexCardRec/shot" ofType:@"png"];
    //      UIImage *img = [UIImage imageWithContentsOfFile:path];
    UIImage *img = [UIImage imageNamed:@"相机icon.png"];
    [self.takeButton setImage:img forState:UIControlStateNormal];
//    [self.takeButton setBackgroundImage:img forState:UIControlStateNormal];
    [self.takeButton setFrame:CGRectMake(KSCreenW/2-30, KSCreenH-70, 60, 60)];
    self.takeButton.layer.cornerRadius = self.takeButton.width/2;
    self.takeButton.layer.masksToBounds = YES;
    [self.takeButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    [cameraView addSubview:self.takeButton];
    
    
    //用于取消操作的button
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.alpha = 1;
    [cancelButton setFrame:CGRectMake(KSCreenW-70, KSCreenH-65, 50, 50)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [cancelButton addTarget:self action:@selector(cancelCamera) forControlEvents:UIControlEventTouchUpInside];
    [cameraView addSubview:cancelButton];
    
    
    UIView* leftUpLine = [[UIView alloc] initWithFrame:CGRectMake(35, 30, 3, 20)];
    leftUpLine.alpha = 1;
    leftUpLine.backgroundColor = blueFontColor;
    [cameraView addSubview:leftUpLine];
    
    UIView* leftUpLine2 = [[UIView alloc] initWithFrame:CGRectMake(35, 30, 20, 3)];
    leftUpLine2.alpha = 1;
    leftUpLine2.backgroundColor = blueFontColor;
    [cameraView addSubview:leftUpLine2];
    
    UIView* rightUpLine = [[UIView alloc] initWithFrame:CGRectMake(KSCreenW-38, 30, 3, 20)];
    rightUpLine.alpha = 1;
    rightUpLine.backgroundColor = blueFontColor;
    [cameraView addSubview:rightUpLine];
    
    UIView* rightUpLine2 = [[UIView alloc] initWithFrame:CGRectMake(KSCreenW-55, 30, 20, 3)];
    rightUpLine2.alpha = 1;
    rightUpLine2.backgroundColor = blueFontColor;
    [cameraView addSubview:rightUpLine2];
    
    UIView* leftButLine = [[UIView alloc] initWithFrame:CGRectMake(35, KSCreenH-140, 3, 20)];
    leftButLine.alpha = 1;
    leftButLine.backgroundColor = blueFontColor;
    [cameraView addSubview:leftButLine];
    
    UIView* leftButLine2 = [[UIView alloc] initWithFrame:CGRectMake(35, KSCreenH-122, 20, 3)];
    leftButLine2.alpha = 1;
    leftButLine2.backgroundColor = blueFontColor;
    [cameraView addSubview:leftButLine2];
    
    UIView* rightButLine = [[UIView alloc] initWithFrame:CGRectMake(KSCreenW-38, KSCreenH-140, 3, 20)];
    rightButLine.alpha = 1;
    rightButLine.backgroundColor = blueFontColor;
    [cameraView addSubview:rightButLine];
    
    UIView* rightButLine2 = [[UIView alloc] initWithFrame:CGRectMake(KSCreenW-55, KSCreenH-122, 20, 3)];
    rightButLine2.alpha = 1;
    rightButLine2.backgroundColor = blueFontColor;
    [cameraView addSubview:rightButLine2];
    
    return cameraView;
}


//startScanning
- (void)startScanning{
    i = 1;
    self.imagePikerViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePikerViewController.delegate = self;
    self.imagePikerViewController.showsCameraControls = NO;
    self.imagePikerViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.overlayView.backgroundColor = [UIColor clearColor];
    self.imagePikerViewController.cameraOverlayView = [self drawCameraView];
    self.overlayView.frame = self.imagePikerViewController.cameraOverlayView.frame;
    // 相机全屏
    CGSize screenBounds = [UIScreen mainScreen].bounds.size;
    CGFloat cameraAspectRatio = 4.0f/3.0f;
    CGFloat camViewHeight = screenBounds.width * cameraAspectRatio;
    CGFloat scale = screenBounds.height / camViewHeight;
    self.imagePikerViewController.cameraViewTransform = CGAffineTransformMakeTranslation(0, (screenBounds.height - camViewHeight) / 2.0);
    self.imagePikerViewController.cameraViewTransform = CGAffineTransformScale(self.imagePikerViewController.cameraViewTransform, scale, scale);
    
    self.imagePikerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:self.imagePikerViewController animated:YES completion:NULL];
}
#pragma mark -
#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.takeButton.hidden = NO;
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    [self popViewController];
    UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    HWCloudsdk *sdk = [[HWCloudsdk alloc] init];
//    UIImage *image = [UIImage imageNamed:@"cardimage.jpg"];
    NSString *apiKey = @"22a5bb9a-d5be-4fa3-bffe-d6280a31c531";
    NSLog(@"识别开始。。。");
    
    //    NSString *cardResult = [sdk cardLanguage:language cardImage: image apiKey:apiKey];
    [sdk cardLanguage:@"chns" cardImage:image apiKey:apiKey successBlock:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSData *data = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * rootDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSMutableString *reString = [NSMutableString string];
        [reString appendString:@"{"];
//        NSMutableArray *keyValues = [NSMutableArray array];
//        [picker dismissViewControllerAnimated:YES completion:nil];
//        [self.view hideToastActivity];
        
        
        NSString *code = [rootDic objectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
//            NewClientViewController *newClientViewController = [[NewClientViewController alloc] init];
//            newClientViewController.dictionary = rootDic;
//            [self.navigationController pushViewController:newClientViewController animated:YES];
//            _cardDictionary = rootDic;
//            _cardDictionary = root
            [SVProgressHUD dismiss];

            _workViewController.cardDictionary = rootDic;
        }else{
            NSString *result = [rootDic objectForKey:@"result"];
            NSLog(@"%@",result);
//            _cardDictionary = nil;
            [SVProgressHUD showErrorWithStatus:@"网络异常或超时,请稍后再试！"];
            [SVProgressHUD dismissWithDelay:1555.0];
        }
        [self cancelCamera];
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络异常或超时,请稍后再试！"];
    }];
}


-(void)cancelCamera{
    [self.imagePikerViewController dismissViewControllerAnimated:YES completion:nil];
    [self popViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
