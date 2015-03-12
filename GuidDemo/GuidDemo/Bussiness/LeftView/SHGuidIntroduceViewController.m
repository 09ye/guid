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
}

@end

@implementation SHGuidIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.intent.args objectForKey:@"title"];
    mbtnSao.layer.cornerRadius = 5.0;
    mbtnStart.layer.cornerRadius = 5.0;
    [mSlider setThumbImage:[UIImage imageNamed:@"media_player_progress_button"] forState:UIControlStateNormal];
    mlabIntroduce =  [[UILabel alloc]initWithFrame:CGRectMake(10, 10, UIScreenWidth-20, 0)];
    mlabIntroduce.userstyle = @"labmiddark";
    mlabIntroduce.numberOfLines = 0;
    mlabIntroduce.text = @"mlabIntroducemlabIntroducemlabIw我ntroducemlabIntroducemlabIntroduceml我abIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIw我ntroducemlabIntroducemlabIntroduceml我abIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIw我ntroducemlabIntroducemlabIntroduceml我abIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIw我ntroducemlabIntroducemlabIntroduceml我abIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroducemlabIntroduce";
    [mlabIntroduce sizeToFit];
    [mScrollview addSubview:mlabIntroduce];
    [mScrollview setContentSize:mlabIntroduce.frame.size];
    
    [self showMp3];
    
}
-(void)showMp3
{
    NSString *string = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp3"];
    //把音频文件转换成url格式
    NSURL *url = [NSURL fileURLWithPath:string];
    //初始化音频类 并且添加播放文件
    avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    avAudioPlayer.delegate = self;
    avAudioPlayer.volume = 1;
    avAudioPlayer.numberOfLoops = 0;  //-1为一直循环
    [avAudioPlayer prepareToPlay];
    [avAudioPlayer play];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                             target:self
                                           selector:@selector(playProgress)                                                     userInfo:nil
                                            repeats:YES];
    
}
-(void)playProgress
{
    [mSlider setValue:avAudioPlayer.currentTime/avAudioPlayer.duration];
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [timer invalidate]; //NSTimer暂停   invalidate  使...无效;
}



- (IBAction)btnSaoOntouch:(id)sender {
}

- (IBAction)segmentOnvaluechange:(id)sender {
}

- (IBAction)btnStartPauseOntouch:(UIButton *)sender {
    if (avAudioPlayer.playing) {
        [avAudioPlayer pause];
        sender.imageView.image = [UIImage imageNamed:@"start"];
    }else{
        [avAudioPlayer play];
         sender.imageView.image = [UIImage imageNamed:@"pause"];
    }
}
@end
