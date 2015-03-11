//
//  SHMainFuntionViewController.h
//  GuidDemo
//
//  Created by Ye Baohua on 15/3/8.
//  Copyright (c) 2015年 Ye Baohua. All rights reserved.
//

#import "SHTableViewController.h"
#import "ZBarSDK.h"
#import "SHIOS7_ScanViewController.h"
#import "QRCodeGenerator.h"


@interface SHMainFuntionViewController : SHTableViewController<ZBarReaderDelegate,UIActionSheetDelegate>
{
    __weak IBOutlet UIScrollView *mScrollview;
    __weak IBOutlet UIButton *mbtnSao;

   
    int num;
    BOOL upOrdown;
    NSTimer * timer;
}
- (IBAction)btnSaoOntouch:(id)sender;
@property (nonatomic, strong) UIImageView    * line;
@end
