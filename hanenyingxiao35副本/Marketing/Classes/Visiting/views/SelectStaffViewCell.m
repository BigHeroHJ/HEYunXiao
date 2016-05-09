//
//  SelectStaffViewCell.m
//  Marketing
//
//  Created by wmm on 16/3/3.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "SelectStaffViewCell.h"

@implementation SelectStaffViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDapart:(DepartmentModel *)model
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"%f---%f",self.height,self.width);
        // Initialization code
        self.clipsToBounds = YES;
        //选中单元格
        //        UIView *bgView = [[UIView alloc] init];
        //        bgView.backgroundColor = [UIColor colorWithRed:(20.0f/255.0f) green:(30.0f/255.0f) blue:(40.0f/255.0f) alpha:0.5f];
        //        self.selectedBackgroundView = bgView;
        
//        self.imageView.contentMode = UIViewContentModeCenter;
        
        self.model = model;
        UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        headerBtn.frame = CGRectMake(10,10, 40, 40);
        headerBtn.layer.cornerRadius = 20;
        headerBtn.layer.masksToBounds = 20;//圆形
        
        
        if (model==nil) {
            headerBtn.tag = 0;
            [headerBtn setBackgroundImage:[UIImage imageNamed:@"defaultHeaderImg.png"] forState:UIControlStateNormal];
        }else{
            headerBtn.tag = 1;
        if (self.model.img != nil) {
            NSString *urlStr = [NSString stringWithFormat:@"%@/crm%@",HEAD_URL,self.model.img];
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];

            [headerBtn setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
        }else{
            [headerBtn setBackgroundImage:[UIImage imageNamed:@"defaultHeaderImg.png"] forState:UIControlStateNormal];
        }
        }
        [headerBtn addTarget:self action:@selector(showSelectedImg:) forControlEvents:UIControlEventTouchUpInside];
        

        self.selectedImg = [[UIImageView alloc] initWithFrame:CGRectMake(40,40, 15, 15)];
        self.selectedImg.image = [UIImage imageNamed:@"选择.png"];
        self.selectedImg.hidden = YES;
        
        self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(60,10, KSCreenW-80, 40)];
        self.nameLbl.font = [UIFont systemFontOfSize:14];
        self.nameLbl.textColor = lightGrayFontColor;
        if (model==nil) {
            self.nameLbl.text = @"全部";
        }else{
            self.nameLbl.text = self.model.dname;
        }

        
        UILabel *lineLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 59, KSCreenW-20, 1)];
        lineLab.layer.borderWidth = 1;
        lineLab.layer.borderColor = [grayLineColor CGColor];
        
        [self.contentView addSubview:headerBtn];
        [self.contentView addSubview:self.selectedImg];
        [self.contentView addSubview:self.nameLbl];
        [self.contentView addSubview:lineLab];
        
    }
    return self;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withUser:(UserModel *)userModel
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"%f---%f",self.height,self.width);
        // Initialization code
        self.clipsToBounds = YES;
        //选中单元格
        //        UIView *bgView = [[UIView alloc] init];
        //        bgView.backgroundColor = [UIColor colorWithRed:(20.0f/255.0f) green:(30.0f/255.0f) blue:(40.0f/255.0f) alpha:0.5f];
        //        self.selectedBackgroundView = bgView;
        
        //        self.imageView.contentMode = UIViewContentModeCenter;
        
        self.userModel = userModel;
        UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        headerBtn.frame = CGRectMake(10,10, 40, 40);
        headerBtn.layer.cornerRadius = 20;
        headerBtn.layer.masksToBounds = 20;//圆形
        NSString *urlStr = [NSString stringWithFormat:@"%@/crm%@",HEAD_URL,userModel.logo];
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
        
        headerBtn.tag = 2;
        [headerBtn setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
        [headerBtn addTarget:self action:@selector(showSelectedImg:) forControlEvents:UIControlEventTouchUpInside];
        
        self.selectedImg = [[UIImageView alloc] initWithFrame:CGRectMake(40,40, 15, 15)];
        self.selectedImg.image = [UIImage imageNamed:@"选择.png"];
        self.selectedImg.hidden = YES;
        
        self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(60,10, KSCreenW-80, 40)];
        self.nameLbl.font = [UIFont systemFontOfSize:14];
        self.nameLbl.textColor = lightGrayFontColor;
        self.nameLbl.text = userModel.name;
        
        UILabel *lineLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 59, KSCreenW-20, 1)];
        lineLab.layer.borderWidth = 1;
        lineLab.layer.borderColor = [grayLineColor CGColor];
        
        [self.contentView addSubview:headerBtn];
        [self.contentView addSubview:self.selectedImg];
        [self.contentView addSubview:self.nameLbl];
        [self.contentView addSubview:lineLab];        
    }
    return self;
}

//
- (void)showSelectedImg:(UIButton *)button{
    if(self.selectedImg.hidden == YES){
        self.selectedImg.hidden = NO;
        self.isSelected = YES;
        self.nameLbl.textColor = blackFontColor;
    }
    else{
        self.selectedImg.hidden = YES;
        self.isSelected = NO;
        self.nameLbl.textColor = lightGrayFontColor;
    }
    if (button.tag == 0) {
        [self.delegate selectAllIsSelected:self.isSelected];
    }else if (button.tag == 1) {
        if (self.model != nil) {
            [self.delegate selectDepart:self.model isSelected:self.isSelected];
        }

    }else{
        if (self.userModel != nil) {
            [self.delegate selectUser:self.userModel isSelected:self.isSelected];
        }
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
