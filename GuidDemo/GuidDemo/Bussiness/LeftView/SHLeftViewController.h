//
//  SHLeftViewController.h
//  GuidDemo
//
//  Created by Ye Baohua on 15/3/8.
//  Copyright (c) 2015年 Ye Baohua. All rights reserved.
//

#import "SHTableViewController.h"

@interface SHLeftViewController : SHTableViewController
{
    __weak IBOutlet UISegmentedControl *mSegment;
    
}
@property(nonatomic,retain) UINavigationController *navigationController; // If this view controller has been pushed onto a navigation controller, return it.

- (IBAction)segmentValueChangeOntouch:(UISegmentedControl *)sender;

@end
