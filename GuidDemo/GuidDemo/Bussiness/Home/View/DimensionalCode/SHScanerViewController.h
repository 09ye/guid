//
//  SHScanerViewController.h
//  crowdfunding-arcturus
//
//  Created by lqh77 on 14-5-4.
//  Copyright (c) 2014年 WSheely. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
/*
 AVFoundation.framework (weak)
 
 CoreMedia.framework (weak)
 
 CoreVideo.framework (weak)
 
 QuartzCore.framework
 
 libiconv.dylib
 */
 

@interface SHScanerViewController : SHViewController<ZBarReaderDelegate,UIAlertViewDelegate>
{

    int num;
    BOOL upOrdown;
    NSTimer * timer;


}

@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *contentText;

@property (nonatomic, strong) UIImageView * line;
@end
