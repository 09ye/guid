//
//  SHMainViewController.h
//  crowdfunding-arcturus
//
//  Created by WSheely on 14-4-8.
//  Copyright (c) 2014年 WSheely. All rights reserved.
//

#import "SHViewController.h"


@interface MainViewController : SHViewController <UITabBarDelegate,SHTaskDelegate>
{

    UINavigationController* lastnacontroller;
    NSMutableDictionary* mDictionary;

}






@end
