//
//  PictureViewController.m
//  Marketing
//
//  Created by Hanen 3G 01 on 16/4/7.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "PictureViewController.h"

@interface PictureViewController ()
{
    UIImageView *imageV;
}
@end

@implementation PictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.5];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.f];
     self.navigationItem.leftBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithAction:@selector(popLastView)];
    imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, (KSCreenH - KSCreenW) / 2.0f, KSCreenW, KSCreenW)];
    [self.view addSubview:imageV];
    __block UIActivityIndicatorView *activityIndicator;
    [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LoadImageUrl,self.imageUrl]] placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (!activityIndicator)
        {
            [imageV addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
            activityIndicator.center = imageV.center;
            [activityIndicator startAnimating];
        }
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [activityIndicator removeFromSuperview];
        activityIndicator = nil;
    }];
}
- (void)popLastView
{
    [self.navigationController popViewControllerAnimated:YES];
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
