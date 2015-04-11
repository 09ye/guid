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
    NSDictionary * detail;
}

@end

@implementation SHShowVideoViewController
// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return YES;
}

// 支持横竖屏显示
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation

{
    // Return YES for supported orientations
    return true;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    detail = [self.intent.args objectForKey:@"detail"];
    self.title = [detail objectForKey:@"name"];
    [self playMovie:[detail objectForKey:@"fpath"]];
    // Do any additional setup after loading the view from its nib.
}
-(void)playMovie:(NSString *)fileName{
   
    NSURL *url = [[NSURL alloc ]initFileURLWithPath:fileName];
    playerViewController =[[MPMoviePlayerViewController alloc]     initWithContentURL:url];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playVideoFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:[playerViewController moviePlayer]];
    //    playerViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    playerViewController.view.frame = self.view.bounds;
    [self.view addSubview:playerViewController.moviePlayer.view];
    MPMoviePlayerController *player = [playerViewController moviePlayer];
    player.movieSourceType = MPMovieSourceTypeFile;
    player.shouldAutoplay = NO;
    [player setControlStyle:MPMovieControlStyleEmbedded];
    [player prepareToPlay];
    [player play];    
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
