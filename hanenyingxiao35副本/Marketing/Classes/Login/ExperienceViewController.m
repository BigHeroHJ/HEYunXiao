//
//  ExperienceViewController.m
//  Marketing
//
//  Created by wmm on 16/3/29.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "ExperienceViewController.h"

@interface ExperienceViewController (){
    int i;
}

@property(nonatomic,strong) UIImageView *bg;
@property(nonatomic,strong) UIButton *bgBtn;


@end

@implementation ExperienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"exper1.png"]];
    
    self.bgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, KSCreenW, KSCreenH)];
    [self.bgBtn setImage:[UIImage imageNamed:@"exper1.png"] forState:UIControlStateNormal];
    [self.bgBtn addTarget:self action:@selector(changeImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bgBtn];
    
    i = 1;
//    self.bg = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, KSCreenW, KSCreenH)];
//    self.bg.image = [UIImage imageNamed:@"exper1.png"];
//    [self.view addSubview:self.bg];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}
//- (void)viewDidAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

- (void)changeImage{
    i++;
    if (i == 12) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    NSString *name = [NSString stringWithFormat:@"exper%d",i];
    [self.bgBtn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];

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
