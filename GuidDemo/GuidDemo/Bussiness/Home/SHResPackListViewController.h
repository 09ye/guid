//
//  SHResPackListViewController.h
//  GuidDemo
//
//  Created by Ye Baohua on 15/3/13.
//  Copyright (c) 2015年 Ye Baohua. All rights reserved.
//

#import "SHTableViewController.h"
@class SHResPackListViewController;
@protocol SHResPackListViewControllerDeleaget <NSObject>

-(void)resPackListViewControllerDidSelect:(SHResPackListViewController*)controller detail:(NSDictionary *)detail;

@end
@interface SHResPackListViewController : SHTableViewController

@property(nonatomic,assign) id<SHResPackListViewControllerDeleaget>deleaget;
@end
