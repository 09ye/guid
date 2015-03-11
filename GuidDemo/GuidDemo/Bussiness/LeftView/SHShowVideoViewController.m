//
//  SHShowVideoViewController.m
//  GuidDemo
//
//  Created by Ye Baohua on 15/3/8.
//  Copyright (c) 2015年 Ye Baohua. All rights reserved.
//

#import "SHShowVideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SHShowVideoViewController ()
{
    MPMoviePlayerViewController *playerViewController;
}

@end

@implementation SHShowVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.intent.args objectForKey:@"title"];
    [self playMovie:@"test"];
    // Do any additional setup after loading the view from its nib.
}
-(void)playMovie:(NSString *)fileName{
    //视频文件路径
    
        NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
    //视频URL
    fileName = @"http://padload-cnc.wasu.cn/pcsan08/mams/vod/201409/29/16/201409291618156309b21cbd8_4e58bd54.mp4";
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test"withExtension:@"mp4"];
    NSURL *url = [NSURL URLWithString:fileName];
    //视频播放对象
    playerViewController =[[MPMoviePlayerViewController alloc]     initWithContentURL:url];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playVideoFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:[playerViewController moviePlayer]];
    //    playerViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    playerViewController.view.frame = self.view.bounds;
    [self.view addSubview:playerViewController.moviePlayer.view];
    MPMoviePlayerController *player = [playerViewController moviePlayer];
        player.movieSourceType = MPMovieSourceTypeFile;
    player.shouldAutoplay = NO;
    [player setControlStyle:MPMovieControlStyleEmbedded];
    [player setFullscreen:YES];
    //    player.scalingMode = MPMovieScalingModeFill;
    [player prepareToPlay];
    [player play];
//    [self.navigationController presentMoviePlayerViewControllerAnimated:playerViewController];
    
    //    [self presentMoviePlayerViewControllerAnimated:playerViewController];
    
}

#pragma mark -------------------视频播放结束委托--------------------

/*
 @method 当视频播放完毕释放对象
 */
- (void) playVideoFinished:(NSNotification *)theNotification//当点击Done按键或者播放完毕时调用此函数
{
    MPMoviePlayerController *player = [theNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [player stop];
    [playerViewController dismissModalViewControllerAnimated:YES];
        [playerViewController.view removeFromSuperview];
    playerViewController = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
