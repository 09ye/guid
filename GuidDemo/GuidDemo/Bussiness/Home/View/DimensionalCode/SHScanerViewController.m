//
//  SHScanerViewController.m
//  crowdfunding-arcturus
//
//  Created by lqh77 on 14-5-4.
//  Copyright (c) 2014年 WSheely. All rights reserved.
//

#import "SHScanerViewController.h"
#import "SHIOS7_ScanViewController.h"
#import "QRCodeGenerator.h"


@interface SHScanerViewController ()

@end

@implementation SHScanerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"二维码";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"扫描" target:self action:@selector(scanAction:)];
    
    UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scanButton setTitle:@"扫描" forState:UIControlStateNormal];
    scanButton.frame = CGRectMake(250, 40, 120, 40);
    [scanButton addTarget:self action:@selector(scanAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton];
    
}


-(void)scanAction:(id)sender{
    
    if(!iOS7)
    {
        SHIOS7_ScanViewController * rt = [[SHIOS7_ScanViewController alloc]init];
        [self presentViewController:rt animated:YES completion:^{
            
        }];
    }
    else
    {
        num = 0;
        upOrdown = NO;
        //初始话ZBar
        ZBarReaderViewController * reader = [[ZBarReaderViewController alloc]init];
        //设置代理
        reader.readerDelegate = self;
        //reader.readerView
        NSLog(@"%@",reader.readerView);
        
        
        //支持界面旋转
        reader.supportedOrientationsMask = ZBarOrientationMaskAll;
        reader.showsHelpOnFail = NO;
        reader.showsZBarControls=NO;
        reader.showsCameraControls=NO;
       
        reader.scanCrop = CGRectMake(0.1, 0.2, 0.8, 0.8);//扫描的感应框
        ZBarImageScanner * scanner = reader.scanner;
        [scanner setSymbology:ZBAR_I25
                       config:ZBAR_CFG_ENABLE
                           to:0];
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
        view.backgroundColor = [UIColor redColor];
        
        reader.cameraOverlayView = view;
        
        
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
        label.text = @"请将扫描的二维码至于下面的框内\n谢谢！";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = 1;
        label.lineBreakMode = 0;
        label.numberOfLines = 2;
        label.backgroundColor = [UIColor clearColor];
        [view addSubview:label];
        
        UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pick_bg.png"]];
        image.frame = CGRectMake(20, 80, 280, 280);
        [view addSubview:image];
        
        //    UIButton * tu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //    [tu setTitle:@"相册" forState:UIControlStateNormal];
        //    tu.frame = CGRectMake(100, 200, 120, 40);
        //    [tu addTarget:self action:@selector(hello) forControlEvents:UIControlEventTouchUpInside];
        //    [view addSubview:tu];
        
        _line = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 220, 2)];
        _line.image = [UIImage imageNamed:@"line.png"];
        [image addSubview:_line];
        //定时器，设定时间过1.5秒，
        timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
        
        [self presentViewController:reader animated:YES completion:^{
            
        }];
    }

} 

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(30, 10+2*num, 220, 2);
        if (2*num == 260) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(30, 10+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
    
}

#pragma mark   ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark   zbar 委托 方法

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
    }];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //初始化
        ZBarReaderController * read = [ZBarReaderController new];
        //设置代理
        read.readerDelegate = self;
        CGImageRef cgImageRef = image.CGImage;
        ZBarSymbol * symbol = nil;
        id <NSFastEnumeration> results = [read scanImage:cgImageRef];
        for (symbol in results)
        {
            break;
        }
        NSString * result;
        if ([symbol.data canBeConvertedToEncoding:NSShiftJISStringEncoding])
            
        {
            result = [NSString stringWithCString:[symbol.data cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        }
        else
        {
            result = symbol.data;
        }
        
        NSLog(@" 11  %@",result); 
        _contentText.text=result;
        
         [[UIApplication sharedApplication]  openStr:result]; 
    }];
}




/*
 ////  生成 二维码
 */

- (void)button2:(NSString  *)sender {
    /*字符转二维码
     导入 libqrencode文件
     引入头文件#import "QRCodeGenerator.h" 即可使用
     */
	_imageview.image = [QRCodeGenerator qrImageForString:sender imageSize:_imageview.bounds.size.width];
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
