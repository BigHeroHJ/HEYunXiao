//
//  StaffTableViewCell.m
//  Marketing
//
//  Created by wmm on 16/3/10.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "StaffTableViewCell.h"

@implementation StaffTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDapart:(DepartmentModel *)model
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        [self getDepartStaff:model];
        self.model = model;
        self.users = [NSMutableArray array];
        UIImageView *departImg = [[UIImageView alloc] initWithFrame:CGRectMake(LEFTWIDTH,10, 40, 40)];
        departImg.layer.masksToBounds = YES;
        departImg.layer.cornerRadius = 20;
        if (self.model.img != nil) {
            NSString *urlStr = [NSString stringWithFormat:@"%@/crm%@",HEAD_URL,self.model.img];
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
            departImg.image = [UIImage imageWithData:data];
        }else{
            departImg.image = [UIImage imageNamed:@"defaultHeaderImg.png"];
        }
        
        UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(LEFTWIDTH*2+departImg.width,10, KSCreenW-80, 40)];
        nameLbl.font = [UIFont systemFontOfSize:14];
        nameLbl.textColor = blackFontColor;
        nameLbl.text = self.model.dname;
        
        UILabel *lineLab = [[UILabel alloc] initWithFrame:CGRectMake(LEFTWIDTH, 59, KSCreenW-LEFTWIDTH*2, 1)];
        lineLab.layer.borderWidth = 1;
        lineLab.layer.borderColor = [grayLineColor CGColor];
        
        [self.contentView addSubview:departImg];
        [self.contentView addSubview:nameLbl];
        [self.contentView addSubview:lineLab];

    }
    return self;
}

//GET_USER_BY_DEPARTMENT_URL
- (void)getDepartStaff:(DepartmentModel *)depart{
    
    [_users removeAllObjects];
    NSDictionary * params2 = [NSDictionary dictionaryWithObjectsAndKeys:@(UID), @"uid", TOKEN, @"token", @(depart.departId), @"department", nil];
    AFHTTPRequestOperationManager * manager2 = [AFHTTPRequestOperationManager manager];
    manager2.requestSerializer.timeoutInterval = 20;
    [manager2 POST:GET_USER_BY_DEPARTMENT_URL parameters:params2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"GET_USER_BY_DEPARTMENT_URL:%@",responseObject);
        NSArray * departArray = [(NSDictionary *)responseObject objectForKey:@"data"];
        for (NSDictionary *user  in departArray) {
            UserModel *userModel = [[UserModel alloc]init];
            [userModel setValuesForKeysWithDictionary:user];
            [_users addObject:userModel];
        }
        
        UILabel *numLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.width-40,20, 20, 20)];
        numLbl.font = [UIFont systemFontOfSize:14];
        numLbl.textColor = blueFontColor;
        NSString *num = [NSString stringWithFormat:@"%lu",(unsigned long)self.users.count];
        numLbl.text = num;
        NSLog(@"%@-------------------",num);
        [self.contentView addSubview:numLbl];
        
        for (int i = 0; i < _users.count; i++ ) {
            if (i >= 5) {
                return ;
            }
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(KSCreenW/4*3-15*i,20, 20, 20)];
            img.layer.masksToBounds = YES;
            img.layer.cornerRadius = 10;
            if (self.model.img != nil) {
                NSString *urlStr = [NSString stringWithFormat:@"%@/crm%@",HEAD_URL,self.model.img];
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
                img.image = [UIImage imageWithData:data];
            }else{
                img.image = [UIImage imageNamed:@"defaultHeaderImg.png"];
            }
            [self.contentView addSubview:img];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

//
//- (void)showSelectedImg:(UIButton *)button{
//    if(self.selectedImg.hidden == YES){
//        self.selectedImg.hidden = NO;
//        self.isSelected = YES;
//    }
//    else{
//        self.selectedImg.hidden = YES;
//        self.isSelected = NO;
//    }
//}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
