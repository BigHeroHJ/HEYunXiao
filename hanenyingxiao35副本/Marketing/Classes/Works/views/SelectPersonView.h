//
//  SelectPersonView.h
//  Marketing
//
//  Created by Hanen 3G 01 on 16/3/29.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectPersonViewDelegate <NSObject>

- (void)addPerson;

@end

@interface SelectPersonView : UIView



@property (nonatomic, strong) NSMutableArray *allPersonArray;

@property (nonatomic, strong) NSMutableArray *logoArray;

@property (nonatomic, strong) NSArray *personArray;


@property (nonatomic, weak) id<SelectPersonViewDelegate>delegate;

@end
