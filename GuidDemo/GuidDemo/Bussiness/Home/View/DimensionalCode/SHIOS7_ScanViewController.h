//
//  SHIOS7_ScanViewController.h
//  crowdfunding-arcturus
//
//  Created by lqh77 on 14-5-4.
//  Copyright (c) 2014年 WSheely. All rights reserved.
//

#import "SHViewController.h"
#import <AVFoundation/AVFoundation.h>

 

@interface SHIOS7_ScanViewController : SHViewController <AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;


@end
