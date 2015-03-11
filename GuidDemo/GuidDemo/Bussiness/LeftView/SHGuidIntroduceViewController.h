//
//  SHGuidIntroduceViewController.h
//  GuidDemo
//
//  Created by Ye Baohua on 15/3/8.
//  Copyright (c) 2015年 Ye Baohua. All rights reserved.
//

#import "SHTableViewController.h"

@interface SHGuidIntroduceViewController : SHTableViewController
{
    
    __weak IBOutlet UIScrollView *mScrollview;
    UILabel *mlabIntroduce;
    __weak IBOutlet UIButton *mbtnSao;
    __weak IBOutlet UILabel *mlabCurrentTime;
    __weak IBOutlet UILabel *mlabTotalTime;
    __weak IBOutlet UISlider *mSlider;
    __weak IBOutlet UIButton *mbtnStart;
}
- (IBAction)btnSaoOntouch:(id)sender;
- (IBAction)segmentOnvaluechange:(id)sender;
- (IBAction)btnStartPauseOntouch:(UIButton *)sender;

@end
