//
//  SHGuidIntroduceViewController.h
//  GuidDemo
//
//  Created by Ye Baohua on 15/3/8.
//  Copyright (c) 2015年 Ye Baohua. All rights reserved.
//

#import "SHTableViewController.h"
#import "ZBarSDK.h"
#import "SHIOS7_ScanViewController.h"
#import "QRCodeGenerator.h"

@interface SHGuidIntroduceViewController : SHTableViewController<SHTaskDelegate,ZBarReaderDelegate>
{
    
    __weak IBOutlet UIScrollView *mScrollview;
    UILabel *mlabIntroduce;
    __weak IBOutlet UIButton *mbtnSao;
    __weak IBOutlet UILabel *mlabCurrentTime;
    __weak IBOutlet UILabel *mlabTotalTime;
    __weak IBOutlet UISlider *mSlider;
    __weak IBOutlet UIButton *mbtnStart;
    
    int num;
    BOOL upOrdown;
    NSTimer * timer;
}
@property (nonatomic, strong) UIImageView    * line;

- (IBAction)btnSaoOntouch:(id)sender;
- (IBAction)segmentOnvaluechange:(UISlider*)sender;
- (IBAction)btnStartPauseOntouch:(UIButton *)sender;
- (IBAction)progressSliderUpAction:(UISlider*)sender;
- (IBAction)progressSliderDownAction:(UISlider *)sender;

@end
