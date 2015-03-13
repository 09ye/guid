//
//  SHGuidIntroduceViewController.m
//  GuidDemo
//
//  Created by Ye Baohua on 15/3/8.
//  Copyright (c) 2015年 Ye Baohua. All rights reserved.
//

#import "SHGuidIntroduceViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface SHGuidIntroduceViewController ()<AVAudioPlayerDelegate>
{
    AVAudioPlayer *avAudioPlayer;
    NSTimer *timerSlider;
    NSDictionary * detail;
    AppDelegate * app;

}

@end

@implementation SHGuidIntroduceViewController
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    app.attractionShow = true;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    app.attractionShow = false;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    detail = [self.intent.args objectForKey:@"detail"];
    self.title = [detail objectForKey:@"name"];
    mbtnSao.layer.cornerRadius = 5.0;
    mbtnStart.layer.cornerRadius = 5.0;
    [mSlider setThumbImage:[UIImage imageNamed:@"media_player_progress_button"] forState:UIControlStateNormal];
    mlabIntroduce =  [[UILabel alloc]initWithFrame:CGRectMake(10, 10, UIScreenWidth-20, 0)];
    mlabIntroduce.userstyle = @"labmiddark";
    mlabIntroduce.numberOfLines = 0;
    mlabIntroduce.text = [detail objectForKey:@"txt"];
    [mlabIntroduce sizeToFit];
    [mScrollview addSubview:mlabIntroduce];
    [mScrollview setContentSize:mlabIntroduce.frame.size];
    
    app  = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc]
                                  initWithTarget:self
                                  action:@selector(progressSliderTapped:)] ;
    [mSlider addGestureRecognizer:gr];
    
    [self showMp3];
    
}
-(void)showMp3
{
    if(![detail objectForKey:@"mp3Path"] || [[detail objectForKey:@"mp3Path"] isEqualToString:@""]){
        return;
    }
    //把音频文件转换成url格式
    NSURL *url = [NSURL fileURLWithPath:[detail objectForKey:@"mp3Path"]];
    
    //初始化音频类 并且添加播放文件
    
    if (app.avAudioPlayer) {
        [app.avAudioPlayer stop];
    }
    avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    avAudioPlayer.delegate = self;
    avAudioPlayer.volume = 1;
    avAudioPlayer.numberOfLoops = 0;  //-1为一直循环
    [avAudioPlayer prepareToPlay];
    [avAudioPlayer play];
    app.avAudioPlayer =  avAudioPlayer;
    timerSlider = [NSTimer scheduledTimerWithTimeInterval:0.1
                                             target:self
                                           selector:@selector(playProgress)                                                     userInfo:nil
                                            repeats:YES];
    mlabTotalTime.text = [self stringtTimeToHumanString:avAudioPlayer.duration];
    mlabCurrentTime.text = [self stringtTimeToHumanString:avAudioPlayer.currentTime];
    
}
-(void)playProgress
{
    mlabCurrentTime.text = [self stringtTimeToHumanString:avAudioPlayer.currentTime];
    [mSlider setValue:avAudioPlayer.currentTime/avAudioPlayer.duration];
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [timerSlider invalidate]; //NSTimer暂停   invalidate  使...无效;
}



- (IBAction)btnSaoOntouch:(id)sender {
    [self scannerAction:nil];
}



- (IBAction)btnStartPauseOntouch:(UIButton *)sender {
    if (avAudioPlayer.isPlaying) {
        [avAudioPlayer pause];
        [sender setBackgroundImage:[UIImage imageNamed:@"mediacontroller_play"] forState:UIControlStateNormal];
    }else{
        [avAudioPlayer play];
        [sender setBackgroundImage:[UIImage imageNamed:@"mediacontroller_pause"] forState:UIControlStateNormal];

    }
}


-(void)progressSliderTapped:(UIGestureRecognizer *)g
{
    UISlider* s = (UISlider*)g.view;
    if (s.highlighted)
        return;
    CGPoint pt = [g locationInView:s];
    CGFloat percentage = pt.x / s.bounds.size.width;
    CGFloat delta = percentage * (s.maximumValue - s.minimumValue);
    CGFloat value = s.minimumValue + delta;
    [s setValue:value animated:YES];
    long seek = percentage * avAudioPlayer.duration;
    
    avAudioPlayer.currentTime= seek;
    if(avAudioPlayer.isPlaying)
        [avAudioPlayer playAtTime:avAudioPlayer.currentTime];
    
}
- (IBAction)progressSliderUpAction:(UISlider*)sender {
    
NSLog(@"UpAction==%f",sender.value);
}

- (IBAction)progressSliderDownAction:(UISlider *)sender {
    avAudioPlayer.currentTime= sender.value*avAudioPlayer.duration;
    if(avAudioPlayer.isPlaying)
        [avAudioPlayer playAtTime:avAudioPlayer.currentTime];
    
   NSLog(@"DownAction==%f",sender.value);
}
- (IBAction)segmentOnvaluechange:(UISlider*)sender {
    NSLog(@"valuechange==%f",sender.value);
        avAudioPlayer.currentTime= sender.value*avAudioPlayer.duration;
//        if(avAudioPlayer.isPlaying)
//            [avAudioPlayer playAtTime:avAudioPlayer.currentTime];
}

-(NSString *)stringtTimeToHumanString:(unsigned long)seconds {
    unsigned long  h, m, s;
    h = seconds / 3600;
    m = (seconds - h * 3600) / 60;
    s = seconds - h * 3600 - m * 60;
    return [NSString stringWithFormat:@"%02ld:%02ld",m,s];
}

#pragma  mark   ===========================
#pragma  mark  二维码扫描

- (void)scannerAction:(id)sender {
    
    num = 0;
    
    AppDelegate* app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if(!iOS7)
    {
        SHIOS7_ScanViewController * rt = [[SHIOS7_ScanViewController alloc]init];
        [app.viewController presentViewController:rt animated:YES completion:^{
            
        }];
    }
    else
    {
        
        upOrdown = NO;
        //初始话ZBar
        __autoreleasing ZBarReaderViewController * reader = [[ZBarReaderViewController alloc]init];
        //设置代理
        reader.readerDelegate = self;
        
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
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        view.backgroundColor = [UIColor clearColor];
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
        
        UIButton  *b=[UIButton  buttonWithType:UIButtonTypeCustom];
        [b setFrame:CGRectMake(0, 440, 320, 35)];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [b  setTitle:@"取消" forState:UIControlStateNormal];
        [b  addTarget:self action:@selector(cancelMe) forControlEvents:UIControlEventTouchUpInside];
        [view bringSubviewToFront:b];
        [view addSubview:b];
        
        _line = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 220, 2)];
        _line.image = [UIImage imageNamed:@"line.png"];
        [image addSubview:_line];
        
        //定时器，设定时间过1.5秒，
        timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
        
        [app.viewController presentViewController:reader animated:YES completion:^{
            
        }];
    }
    
}

-(void)cancelMe{
    
    [timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    
    AppDelegate* app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [app.viewController  dismissViewControllerAnimated:YES completion: nil ];
    
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
    
    
    AppDelegate* app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.viewController  dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
    }];
    
    //    [picker dismissViewControllerAnimated:YES completion:^{
    //          [picker removeFromParentViewController];
    //    }];
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
        
        NSLog(@" 二维码<<<<  %@",result);
        NSData *testData = [result dataUsingEncoding: NSUTF8StringEncoding];
        NSString * url =[[NSString alloc]initWithData:testData encoding:NSUTF8StringEncoding];
        [self refresh:[Utility decryptUseDES:url]];

        
    }];
}
-(void) refresh:(NSString * )url
{
    
    SHHttpTask * post  = [[SHHttpTask alloc]init];
    post.URL = url;
    post.delegate = self;
    [post start:^(SHTask *task) {
        NSError * error ;
        NSDictionary * network = nil;
        if([task result] != nil){
            network  = [NSJSONSerialization JSONObjectWithData:[task result] options:(NSJSONReadingOptions)NSJSONWritingPrettyPrinted error:&error];
        }
        if ([network objectForKey:@"scene_id"]) {
            NSArray * list = [SHXmlParser.instance listAttractions];
            for(int i = 0;i<list.count;i++){
                NSDictionary * dic =[list objectAtIndex:i];
                if([[dic objectForKey:@"code"] isEqualToString:[network objectForKey:@"scene_id"]]){
                    self.title = [dic objectForKey:@"name"];
                    detail = [dic mutableCopy];
                    mlabIntroduce.text = [dic objectForKey:@"txt"];
                    [mlabIntroduce sizeToFit];
                    [self showMp3];
                }
                
            }
        }else{
            [self showAlertDialog:@"未找到相关景点"];
        }
    } taskWillTry:^(SHTask *task) {
        
    } taskDidFailed:^(SHTask *task) {
        
    }];
}
@end
