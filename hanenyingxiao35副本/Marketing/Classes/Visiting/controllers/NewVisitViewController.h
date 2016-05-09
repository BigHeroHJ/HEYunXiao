//
//  NewVisitViewController.h
//  Marketing
//
//  Created by wmm on 16/3/3.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientModel.h"

@protocol NewVisitViewDelegate <NSObject>

- (void)refreshData;

@end

@interface NewVisitViewController : UIViewController

@property (nonatomic, weak) id <NewVisitViewDelegate>delegate;

@property (nonatomic, assign) ClientModel *clientModel;


@end
