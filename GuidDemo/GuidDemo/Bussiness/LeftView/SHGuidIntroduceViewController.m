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
    NSTimer *timer;
    NSDictionary * detail;
    AppDelegate * app;
}

@end

@implementation SHGuidIntroduceViewController

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
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1
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
    [timer invalidate]; //NSTimer暂停   invalidate  使...无效;
}



- (IBAction)btnSaoOntouch:(id)sender {
    
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
@end
