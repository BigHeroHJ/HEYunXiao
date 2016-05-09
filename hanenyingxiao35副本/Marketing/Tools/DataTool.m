//
//  DataTool.m
//  Marketing
//
//  Created by wmm on 16/2/26.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "DataTool.h"
#import "AFNetworking.h"
#import "MyTabBarController.h"

@implementation DataTool

+ (void)sendGetWithUrl:(NSString *)url parameters:(NSDictionary *)dict success:(SuccessBlock)successblock fail:(FailBlock)failblock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successblock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failblock(error);
    }];
}

+ (void)postWithUrl:(NSString *)url parameters:(NSDictionary *)dict success:(SuccessBlock)successBlock fail:(FailBlock)faileBlock
{
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        faileBlock(error);
    }];
}
#pragma mark - 私有方法
//将NSDictionary中的Null类型的项目转化成@""
+(NSDictionary *)nullDic:(NSDictionary *)myDic
{
    NSArray *keyArr = [myDic allKeys];
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < keyArr.count; i ++)
    {
        id obj = [myDic objectForKey:keyArr[i]];
        
        obj = [self changeType:obj];
        
        [resDic setObject:obj forKey:keyArr[i]];
    }
    return resDic;
}

//将NSDictionary中的Null类型的项目转化成@""
+(NSArray *)nullArr:(NSArray *)myArr
{
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < myArr.count; i ++)
    {
        id obj = myArr[i];
        
        obj = [self changeType:obj];
        
        [resArr addObject:obj];
    }
    return resArr;
}

//将NSString类型的原路返回
+(NSString *)stringToString:(NSString *)string
{
    return string;
}

//将Null类型的项目转化成@""
+(NSString *)nullToString
{
    return @"";
}

#pragma mark - 公有方法
//类型识别:将所有的NSNull类型转化成@""
+(id)changeType:(id)myObj
{
    if ([myObj isKindOfClass:[NSDictionary class]])
    {
        return [self nullDic:myObj];
    }
    else if([myObj isKindOfClass:[NSArray class]])
    {
        return [self nullArr:myObj];
    }
    else if([myObj isKindOfClass:[NSString class]])
    {
        return [self stringToString:myObj];
    }
    else if([myObj isKindOfClass:[NSNull class]])
    {
        return [self nullToString];
    }
    else
    {
        return myObj;
    }
}

+ (void)login:(NSString *)username withPass:(NSString *)password fromView:(UIViewController *)viewController{
    
    [viewController.view makeToastActivity];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:username, @"username", password, @"password", nil];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:LOGIN_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [viewController.view hideToastActivity];
        NSLog(@"%@",responseObject);
        int code = [[(NSDictionary *)responseObject objectForKey:@"code"] intValue];
        if(code != 100)
        {
            NSString * message = [(NSDictionary *)responseObject objectForKey:@"message"];
            [viewController.view makeToast:message];
            
        }else{
            
            NSString * token = [(NSDictionary *)responseObject objectForKey:@"token"];
            NSDictionary *user = [(NSDictionary *)responseObject objectForKey:@"user"];
            
            NSDictionary *dict = [DataTool changeType:user];
            
            NSString * userid = (NSString *)[dict objectForKey:@"uid"];
            NSString * username = (NSString *)[dict objectForKey:@"username"];
            NSString * department = (NSString *)[dict objectForKey:@"department"];
            NSString * departmentName = (NSString *)[dict objectForKey:@"departmentName"];
            NSString * img = (NSString *)[dict objectForKey:@"img"];
            NSString * logo = (NSString *)[dict objectForKey:@"logo"];
            NSString * name = (NSString *)[dict objectForKey:@"name"];
            NSString * type = (NSString *)[dict objectForKey:@"type"];
//          NSString *type = [[[NSUserDefaults standardUserDefaults] objectForKey:@"type"] stringValue];//取值
            
            NSLog(@"%@",type);
            
            [userDefaults setObject:token forKey:@"token"];
            [userDefaults setObject:userid forKey:@"uid"];
            [userDefaults setObject:username forKey:@"username"];
            [userDefaults setObject:department forKey:@"department"];
            [userDefaults setObject:type forKey:@"type"];
            [userDefaults setObject:img forKey:@"img"];
            [userDefaults setObject:logo forKey:@"logo"];
            [userDefaults setObject:name forKey:@"name"];
            [userDefaults setObject:departmentName forKey:@"departmentName"];
            
            [userDefaults setObject:password forKey:@"password"];

            [userDefaults synchronize];
            
//            _myTabBarController = [[MyTabBarController alloc] init];
//            [self presentViewController:_myTabBarController animated:YES completion:nil];
            
//            MyNavigationController *myNavigationController = viewController.navigationController;
//            
//            [viewController presentViewController:myNavigationController.myTabBarController animated:YES completion:nil];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [viewController.view hideToastActivity];
        [viewController.view makeToast:@"登录失败"];
    }];
    
}

+ (void)getReportByUrl:(NSString *)Id complationBlock:(void(^)(NSDictionary *dic))complation
{
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@(UID), @"uid", TOKEN, @"token", nil];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
        [manager POST:WORK_REPORT_URL parameters:param success:^(AFHTTPRequestOperation *operation,id responseObject) {
            __block NSDictionary *dic = responseObject;
            //NSLog(@"___________________________________________________%@",responseObject);
            if (complation) {
                complation(dic);
            }
            
        } failure:^(AFHTTPRequestOperation *operation,NSError *error)
         {
             NSLog(@"失败失败失败失败失败失败失败失败失败失败%@",error);
         }];
   // }

    
    
}

@end
