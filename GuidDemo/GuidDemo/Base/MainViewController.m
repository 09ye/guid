
//
//  SHMainViewController.m
//  crowdfunding-arcturus
//
//  Created by WSheely on 14-4-8.
//  Copyright (c) 2014年 WSheely. All rights reserved.
//
#import "MainViewController.h"
#import "SHGuideViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SHMainFuntionViewController.h"


@interface MainViewController ()<SHGuideViewControllerDelegate>
{
    
    SHGuideViewController  *guideVC;
}

@end

@implementation MainViewController

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
    
   
    //[BWStatusBarOverlay showWithMessage:@"loading" loading:YES animated:YES];
    //[BWStatusBarOverlay dismissAnimated:YES];
    
    // 引导页
    [self  showGuidePage] ;
    // Do any additional setup after loading the view from its nib.
    
}

-(void)bootSetting{
    
    mDictionary = [[NSMutableDictionary alloc]init];
    
    
    //    [SHConfigManager.instance setURL:URL_FOR(@"site/getAppConfig")];
    //    [SHConfigManager.instance refresh];
    //    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationWithName:) name: object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:CORE_NOTIFICATION_CONFIG_STATUS_CHANGED object:nil];
    //    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationWithName:) name: object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:NOTIFICATION_LOGIN_SUCCESSFUL object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:NOTIFICATION_LOGINOUT object:nil];
    
    UINavigationController * nacontroller = [[UINavigationController alloc]initWithRootViewController: [[SHMainFuntionViewController alloc ] init]];
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [nacontroller.navigationBar setTitleTextAttributes:attributes];
    nacontroller.navigationBar.translucent = NO;
    
    nacontroller.navigationBar.tintColor = [UIColor whiteColor];
    if(!iOS7){
        nacontroller.navigationBar.clipsToBounds = YES;
    }
    [nacontroller.navigationBar setBackgroundImage:[UIImage imageNamed:@"ic_title"] forBarMetrics:UIBarMetricsDefault];
    //    nacontroller.navigationBar.barTintColor = [UIColor colorWithRed:31/255.0 green:129/255.0 blue:198/255.0 alpha:1];
    nacontroller.view.frame =  self.view.bounds;
    [self.view addSubview:nacontroller.view];
    [self addChildViewController:nacontroller];
    
    
    
    
    
}
-(void) autologin
{
    NSString * username = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    NSString * password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    if (username && password) {
        SHEntironment.instance.loginName = username;
        SHEntironment.instance.password = password;
        SHPostTaskM * post = [[SHPostTaskM alloc]init];
        post.tag = 0;
        post.URL = URL_FOR(@"login");
        post.delegate  = self;
        [post start];
    }
    
}
-(void) taskDidFinished:(SHTask *)task
{
    [self dismissWaitDialog];
    if (task.tag == 0) {
        NSDictionary *  result = (NSDictionary *)[task result];
        SHEntironment.instance.sessionid = [result objectForKey:@"SessionId"];
        [[NSUserDefaults standardUserDefaults] setValue:[result objectForKey:@"PersonInfoState"]  forKey:@"personinfo_state"];// 个人信息完整
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGIN_SUCCESSFUL object:nil];
        SHPostTaskM * post = [[SHPostTaskM alloc]init];
        post.tag = 1;
        post.URL = URL_FOR(@"getuserinformationbysession");
        post.delegate  = self;
        [post start];
        
        
        
    }else if(task.tag == 1){
        NSDictionary * mResult = (NSDictionary *)[task result];
        [[NSUserDefaults standardUserDefaults] setValue:[mResult objectForKey:@"MobileNumber"]  forKey:@"moblile"];
        [[NSUserDefaults standardUserDefaults] setValue:[mResult objectForKey:@"EmailAddress"]   forKey:@"email"];
        [[NSUserDefaults standardUserDefaults] setValue:[mResult objectForKey:@"DisplayName"]   forKey:@"display_name"];
        [[NSUserDefaults standardUserDefaults] setValue:[mResult objectForKey:@"UserInformationID"]   forKey:@"pseron_id"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
    }
}




- (void)loginSuccessful:(NSObject *)sender
{
}

#pragma  mark  引导页加载

-(void)showGuidePage {
    //判断是否出现引导页
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        
    }
    else{
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
        
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        // 这里判断是否第一次
        guideVC=[[SHGuideViewController alloc]  init];
        guideVC.delegate=self;
        [self.view addSubview:guideVC.view];
        return  ;
        
    }else{
        
        [self bootSetting];
        
    }
    
}
-(void) guideViewController:(SHGuideViewController *)aguidVC viewClosed:(int)viewClosed{
    
    
    [guideVC.view   removeFromSuperview];
    
    [self bootSetting];
    
    
}


@end
