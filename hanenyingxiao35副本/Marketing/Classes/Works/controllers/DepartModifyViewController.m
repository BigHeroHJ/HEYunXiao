//
//  DepartModifyViewController.m
//  Marketing
//
//  Created by wmm on 16/3/13.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "DepartModifyViewController.h"
#import "SelectViewController.h"
#import "SelectPersonView.h"

@interface DepartModifyViewController ()<SelectStaffViewDelegate,SelectPersonViewDelegate>{
    
    BOOL isClickManager;
      SelectPersonView * selectView;
}

@property (strong, nonatomic) UITextField *nameFld;
@property (strong, nonatomic) UITextField *managerFld;
@property (strong, nonatomic) NSMutableArray *staffArray;
@property (strong, nonatomic) UILabel *addStaffLabel;
@property (strong, nonatomic) UIButton *addUserBtn;
@property (strong, nonatomic) UIImageView *addUserImg;

@end

@implementation DepartModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = [ViewTool getNavigitionTitleLabel:@"部门设置"];
    self.navigationItem.leftBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithAction:@selector(popViewController)];
    
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(clickToModDepartment)];
//    self.navigationItem.rightBarButtonItem = rightBarItem;
    self.navigationItem.rightBarButtonItem=nil;
    self.navigationItem.rightBarButtonItem.tintColor = mainOrangeColor;
    
    
//    self.navigationItem.rightBarButtonItem.tintColor = mainOrangeColor;
//    self.navigationItem.rightBarButtonItem = [ViewTool getBarButtonItemWithTarget:self WithTextString:@"完成" WithAction:@selector(clickToModDepartment)];

    _staffArray = [NSMutableArray array];
    [self createUI];
    //    [self initData];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = NO;
}

- (void)popViewController
{
    [_staffArray removeAllObjects];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickToModDepartment{
    NSMutableString *alluserIds = [[NSMutableString alloc] init];
    for (int i = 0; i< selectView.allPersonArray.count; i ++) {
        UserModel * model = selectView.allPersonArray[i];
        NSLog(@"%@,%d",model.name,model.uid);
        NSString *str = [NSString stringWithFormat:@"%d,",model.uid];
        NSLog(@"model.uid  %d",model.uid);
        [alluserIds appendString:str];
        NSLog(@"%@",str);
    }
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:@(UID), @"uid", TOKEN, @"token", @(_depart.departId), @"id",  @(_managerFld.tag), @"muid", alluserIds, @"ids", nil];
    NSLog(@"%@",params);
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:UPDATE_DEPARTMENT_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"UPDATE_DEPARTMENT_URL:%@",responseObject);
        int code = [[(NSDictionary *)responseObject objectForKey:@"code"] intValue];
        if(code != 100)
        {
            NSString * message = [(NSDictionary *)responseObject objectForKey:@"message"];
            [self.view makeToast:message];
        }else{
            [self.view makeToast:@"修改成功"];
        }
        [self popViewController];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)createUI{
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, [UIView getHeight:10]+64, KSCreenW, [UIView getHeight:20])];
    nameLabel.text = @"部门名称";
    nameLabel.textColor = grayFontColor;
    nameLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:nameLabel];
    
    
    _nameFld = [[UITextField alloc]initWithFrame:CGRectMake(20, nameLabel.maxY+10, KSCreenW, [UIView getHeight:20])];
//    _nameFld.placeholder = @"请输入部门名称";
    _nameFld.text = _depart.dname;
    _nameFld.textColor = blackFontColor;
    _nameFld.font = [UIFont systemFontOfSize:16];
    _nameFld.userInteractionEnabled = NO;
    [self.view addSubview:_nameFld];
    
    UILabel *lineLab = [[UILabel alloc] initWithFrame:CGRectMake(10, _nameFld.maxY+9, self.view.width-20, 1)];
    lineLab.layer.borderWidth = 1;
    lineLab.layer.borderColor = [grayLineColor CGColor];
    [self.view addSubview:lineLab];
    
    UILabel *managedUserLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, _nameFld.maxY+[UIView getHeight:10], KSCreenW, [UIView getHeight:20])];
    managedUserLabel.text = @"部门负责人";
    managedUserLabel.textColor = grayFontColor;
    managedUserLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:managedUserLabel];
    
    _managerFld = [[UITextField alloc]initWithFrame:CGRectMake(20, managedUserLabel.maxY+10, KSCreenW, [UIView getHeight:20])];
//    _managerFld.placeholder = @"请选择负责人";
    _managerFld.text = _depart.muidname;
    _managerFld.tag = _depart.muid;
    _managerFld.textColor = blackFontColor;
    _managerFld.font = [UIFont systemFontOfSize:16];
    _managerFld.userInteractionEnabled = NO;
    [self.view addSubview:_managerFld];
    
    UIButton *managedUserBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, managedUserLabel.maxY+10, KSCreenW, [UIView getHeight:20])];
    managedUserBtn.tag = 0;
    [managedUserBtn addTarget:self action:@selector(openStaffView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:managedUserBtn];
    
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, _managerFld.maxY+10, self.view.width, [UIView getHeight:20])];
    sectionView.layer.borderWidth = 1;
    sectionView.layer.borderColor = [grayListColor CGColor];
    sectionView.backgroundColor = graySectionColor;
    [self.view addSubview:sectionView];
    
    
    _addStaffLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, sectionView.maxY+[UIView getHeight:10], KSCreenW, [UIView getHeight:20])];
    _addStaffLabel.text = @"添加人员";
    _addStaffLabel.textColor = grayFontColor;
    _addStaffLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_addStaffLabel];
    
//        _addUserImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, _addStaffLabel.maxY+10, [UIView getHeight:30], [UIView getHeight:30])];
//        _addUserImg.image = [UIImage imageNamed:@"添加人员"];
//        _addUserImg.userInteractionEnabled = YES;
//        UIGestureRecognizer *singleTap = [[UIGestureRecognizer alloc]initWithTarget:self action:@selector(openStaffView)];
//        [_addUserImg addGestureRecognizer:singleTap];
//    
//        [self.view addSubview:_addUserImg];
    
//    _addUserBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, _addStaffLabel.maxY+10, [UIView getHeight:30], [UIView getHeight:30])];
//    [_addUserBtn setBackgroundImage:[UIImage imageNamed:@"添加人员"] forState:UIControlStateNormal];
//    //    _addUserBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"添加人员"]];
//    _addUserBtn.tag = 1;
//    [_addUserBtn addTarget:self action:@selector(openStaffView:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_addUserBtn];
//
    selectView = [[SelectPersonView alloc] initWithFrame:CGRectMake(2 * 10, _addStaffLabel.maxY + 10 / 2.0f, KSCreenW - 4 * 10, [UIView getHeight:50.0f])];
    selectView.backgroundColor = [UIColor whiteColor];
    selectView.delegate = self;
    [self.view addSubview:selectView];
    
    UILabel *lineLab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, KSCreenH-TabbarH-1, self.view.width, 1)];
    lineLab2.layer.borderWidth = 1;
    lineLab2.layer.borderColor = [grayListColor CGColor];
    [self.view addSubview:lineLab2];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [selectBtn setTitle:NSLocalizedString(@"删除部门", nil) forState:UIControlStateNormal];
    [selectBtn setTitleColor:mainOrangeColor forState:UIControlStateNormal];
    [selectBtn.titleLabel setFont:[UIView getFontWithSize:15.0f]];
    selectBtn.frame = CGRectMake(0, KSCreenH-TabbarH, self.view.width, TabbarH);
    [selectBtn addTarget:self action:@selector(clickToDelDepart) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:selectBtn];
    
}


//SelectStaffViewDelegate
- (void)getSelectedStaff:(NSArray *)array{
    
    NSLog(@"返回的人数%ld",array.count);
    if(isClickManager){
        if (array.count > 1) {
            [self.view makeToast:@"请选择一个部门负责人"];
        }else{
            UserModel *model = array[0];
            _managerFld.text = model.name;
            _managerFld.tag = model.uid;
            [_staffArray addObject:[NSString stringWithFormat:@"%d",model.uid]];
            if (self.navigationItem.rightBarButtonItem == nil) {
                UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(clickToModDepartment)];
                rightBarItem.tintColor = mainOrangeColor;
                self.navigationItem.rightBarButtonItem = rightBarItem;
            }
        }
    }else{
    
            if (self.navigationItem.rightBarButtonItem == nil) {
                UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(clickToModDepartment)];
                rightBarItem.tintColor = mainOrangeColor;
                self.navigationItem.rightBarButtonItem = rightBarItem;
            }
            selectView.personArray = array;
           
            
        
        
        //        [_addUserBtn setFrame:CGRectMake(20, _addStaffLabel.maxY+10, [UIView getHeight:20], [UIView getHeight:20])];
    }
}
- (void)addPerson
{
    isClickManager = NO;
    SelectViewController *selectViewController = [[SelectViewController alloc]init];
    self.modalPresentationStyle =  UIModalPresentationPageSheet;
    
    selectViewController.delegate = self;
    
    [self.navigationController pushViewController:selectViewController animated:YES];
}
- (void)openStaffView{
     isClickManager = YES;
    SelectViewController *selectViewController = [[SelectViewController alloc]init];
    self.modalPresentationStyle =  UIModalPresentationPageSheet;
    
    selectViewController.delegate = self;
    
    [self.navigationController pushViewController:selectViewController animated:YES];
}
//
//- (void)openStaffView2{
//    
//    SelectViewController *selectViewController = [[SelectViewController alloc]init];
//    self.modalPresentationStyle =  UIModalPresentationPageSheet;
//    isClickManager = YES;
//    selectViewController.delegate = self;
//    
//    [self presentViewController:selectViewController animated:YES completion:^{
//        selectViewController.view.superview.frame = CGRectMake(0, 0, KSCreenW, KSCreenH);
//    }];
//}

- (void)clickToDelDepart{
    NSString *str = [NSString stringWithFormat:@"是否删除%@",_depart.dname];
    ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"提示" message:str];
    [alert addBtnTitle:@"是" action:^{
        NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:@(UID), @"uid", TOKEN, @"token", @(_depart.departId), @"id",  nil];
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        NSLog(@"%@------------",params);
        manager.requestSerializer.timeoutInterval = 20;
        [manager POST:DELETE_DEPARTMENT_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"DELETE_DEPARTMENT_URL:%@",responseObject);
        NSLog(@"%@",responseObject);
        int code = [[(NSDictionary *)responseObject objectForKey:@"code"] intValue];
        if(code != 100)
            {
                NSString * message = [(NSDictionary *)responseObject objectForKey:@"message"];
                [self.view makeToast:message];
    
            }else{
                [self.view makeToast:@"删除成功"];
            }
            

//            [[self navigationController] popViewControllerAnimated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
    }];
        UIViewController *viewCtl = self.navigationController.viewControllers[2];
        
        [self.navigationController popToViewController:viewCtl animated:YES];
    }];
    [alert addBtnTitle:@"否" action:^{
    
    }];

    [alert showAlertWithSender:self];

    
//    NSString *str = [NSString stringWithFormat:@"是否删除%@",_depart.dname];
//    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleActionSheet];
//    //添加Button
//    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:@(UID), @"uid", TOKEN, @"token", @(_depart.departId), @"id",  nil];
//        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
//        NSLog(@"%@------------",params);
//        manager.requestSerializer.timeoutInterval = 20;
//        [manager POST:DELETE_DEPARTMENT_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"DELETE_DEPARTMENT_URL:%@",responseObject);
//            NSLog(@"%@",responseObject);
//            int code = [[(NSDictionary *)responseObject objectForKey:@"code"] intValue];
//            if(code != 100)
//            {
//                NSString * message = [(NSDictionary *)responseObject objectForKey:@"message"];
//                [self.view makeToast:message];
//                
//            }else{
//                [self.view makeToast:@"删除成功"];
//            }
////                    [self popViewController];
//            [[self navigationController] popViewControllerAnimated:YES];
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"%@",error);
//        }];
//        
//    }]];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
//    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)clickToDelDepartUser{
    //    [_staffArray addObject:uidStr];
}

//关闭虚拟键盘。
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_nameFld resignFirstResponder];
    
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
