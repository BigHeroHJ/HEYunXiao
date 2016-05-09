//
//  AddressBookCell.h
//  Marketing
//
//  Created by HanenDev on 16/3/3.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressBookCell : UITableViewCell

@property(nonatomic,strong)UIImageView   *headerImage;
@property(nonatomic,strong)UILabel       *nameLabel;
@property(nonatomic,strong)UIButton      *phoneBtn;

@end
