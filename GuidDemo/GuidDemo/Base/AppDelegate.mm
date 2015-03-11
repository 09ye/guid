//
//  AppDelegate.m
//  crowdfunding-arcturus
//
//  Created by WSheely on 14-4-8.
//  Copyright (c) 2014年 WSheely. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"




#import "ASIHTTPRequest.h"




@implementation AppDelegate



@synthesize wbtoken;
static bool __isupdate = NO;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    //    [SHAnalyzeFactory setAnalyExtension:[[SHAnalyzeFactoryExtension1 alloc]init]];
#ifdef DEBUG
    [SHTask pull:URL_HEADER newUrl:URL_DEVELOPER];
#endif
    // Override point for customization after application launch.
    
    
    //
    //    // 新浪微博
    //    [WeiboSDK enableDebugMode:YES];
    //    [WeiboSDK registerApp:APPID_Sina];
    //
    //    [WXApi  registerApp:APPID_WeoXin];
    //    //需要注意的是，SendMessageToWXReq的scene成员，如果scene填WXSceneSession，那么消息会发送至微信的会话内。如果scene填WXSceneTimeline，那么消息会发送至朋友圈。如果scene填WXSceneFavorite,那么消息会发送到“我的收藏”中。scene默认值为WXSceneSession。
    //    _scene = WXSceneTimeline;
    //    _mapManager = [[BMKMapManager alloc]init];
    //    _locService = [[BMKLocationService alloc]init];
    //    _locService.delegate = self;
    //    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    //    _geocodesearch.delegate = self;
    //
    //    BOOL ret = [_mapManager start:@"XUhLsGNq9Ch1HfTgZH8LFZs8"  generalDelegate:self];// ybh ky
    ////zambon key  RNuxCab28lK3wgb3jGhsrpa3
    //    if (!ret) {
    //        NSLog(@"manager start failed!");
    //    }
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
//    _locationManager.distanceFilter = 100.0f;
    [_locationManager startUpdatingLocation];
    //    [_locService startUserLocationService];
    //
    //
    //    [ShareSDK registerApp:@"24732465ea3a"];     //参数为ShareSDK官网中添加应用后得到的AppKey
    //
    //
    //    [ShareSDK connectSinaWeiboWithAppKey:APPID_Sina
    //                               appSecret:APPID_KEY_Sina
    //                             redirectUri:Sina_RedirectURI];
    //
    //    [ShareSDK connectQQWithQZoneAppKey:@"100371282"
    //                     qqApiInterfaceCls:[QQApiInterface class]
    //                       tencentOAuthCls:[TencentOAuth class]];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configUpdate:) name:CORE_NOTIFICATION_CONFIG_STATUS_CHANGED object:nil];
//    [SHConfigManager instance];
//    [SHConfigManager instance].URL = URL_FOR(@"get_config");
    
    //    [self loadCachesfiles];
    
    [self loadCacheList];
    return YES;
}
- (void)configUpdate:(NSObject*)sender
{
    [SHConfigManager.instance show];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation * currLocation = [locations lastObject];
    NSLog(@"%3.5f===%3.5f",currLocation.coordinate.latitude,currLocation.coordinate.longitude);
   
    
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//    [SHConfigManager.instance refresh];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    if(__isupdate == NO){
//        [SHConfigManager.instance refresh];
//        __isupdate = YES;
//    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma  download
-(void)beginRequest:(int )videoId hdType:(int)hdType isCollection:(BOOL)isCollection isBeginDown:(BOOL)isBeginDown
{
    ////    如果不存在则创建临时存储目录
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:[SHFileManager getTargetFloderPath]])
    {
        [fileManager createDirectoryAtPath:[SHFileManager getTargetFloderPath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (!self.requestlist) {
        self.requestlist = [[NSMutableArray alloc]init];
    }
    SHPostTaskM * post = [[SHPostTaskM alloc]init];
    post.URL = URL_FOR(@"Pad/download");
    [post.postArgs setValue:[NSNumber numberWithInt:videoId] forKey:@"id"];
    post.delegate = self;
    [post start:^(SHTask *task) {
        NSArray * array  = [[task result]mutableCopy];
        if (array.count<1) {
            return ;
        }
        NSMutableDictionary * dic = [array objectAtIndex:0];
        
        if([fileManager fileExistsAtPath:[[SHFileManager getTargetFloderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",[dic objectForKey:@"id"]]]])//存在已经下好的MP4
        {
            return;
        }
        NSDictionary *urls = [dic objectForKey:@"list"];
        NSString *key  =[NSString stringWithFormat:@"hd%d",hdType];
        NSString * url = [urls objectForKey:key];
        
        if (!url || [url isEqualToString:@""]) {
            if (![[urls objectForKey:@"hd0"] isEqualToString:@""]) {
                url = [urls objectForKey:@"hd0"];
            }else  if (![[urls objectForKey:@"hd1"] isEqualToString:@""]) {
                url = [urls objectForKey:@"hd1"];
            }else  if (![[urls objectForKey:@"hd2"] isEqualToString:@""]) {
                url = [urls objectForKey:@"hd2"];
            }else{
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"对不起，未找到相应的下载资源" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
                [myAlertView show];
                return;
            }
            
        }
        url = [Utility encodeVideoUrl:url];
        
        [dic setValue:[[SHFileManager getTargetFloderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]] forKey:@"path"];// 没有格式
        [dic setValue:[NSNumber numberWithInt:emDownloading] forKey:@"state"];
        [dic setValue:[NSNumber numberWithInt:hdType] forKey:@"hdType"];
        [dic setValue:[NSNumber numberWithBool:isCollection] forKey:@"isCollection"];
        ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
        request.delegate=self;
        [request setDownloadDestinationPath:[[SHFileManager getTargetFloderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",[dic objectForKey:@"id"]]]];
        [request setTemporaryFileDownloadPath:[[SHFileManager getTargetFloderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",[dic objectForKey:@"id"]]]];
        //    [request setDownloadProgressDelegate:self];
        //    [request setDownloadProgressDelegate:downCell.progress];//设置进度条的代理,这里由于下载是在AppDelegate里进行的全局下载，所以没有使用自带的进度条委托，这里自己设置了一个委托，用于更新UI
        [request setAllowResumeForFileDownloads:YES];//支持断点续传
        [request setTimeOutSeconds:120];
        [request setNumberOfTimesToRetryOnTimeout:3];
        [request setUserInfo:[NSDictionary dictionaryWithObject:dic forKey:@"file"]];//设置上下文的文件基本信息
        [request startAsynchronous];
        if (isBeginDown) {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"成功添加至离线观看" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            [myAlertView show];
            [self.cachesInfolist addObject:dic];
        }
        [self.requestlist addObject:request];
        
    } taskWillTry:^(SHTask *task) {
        
    } taskDidFailed:^(SHTask *task) {
        
    }];
    
    //    文件开始下载时，把id;文件名;图片url;文件URL
    
    //    NSString *fileName=[[fileInfo objectForKey:@"id"] stringByAppendingFormat:@";%@;%@;%@;",[fileInfo objectForKey:@"title"],[fileInfo objectForKey:@"pic"],[fileInfo objectForKey:@"url"]];
    
    //    [fileInfo setValue:@"http://padload-cnc.wasu.cn/pcsan08/mams/vod/201409/29/16/201409291618156309b21cbd8_4e58bd54.mp4" forKey:@"url"];
    
    
}
-(void) loadCacheList
{
    NSData * data  = [[NSUserDefaults standardUserDefaults] valueForKey:DOWNLOAD_INFO_LIST];// 下载文件信息
    if (data) {
        self.cachesInfolist = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    if (!self.cachesInfolist) {
        self.cachesInfolist  = [[NSMutableArray alloc]init];
    }
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    for (int i = 0; i<self.cachesInfolist.count; i++) {
        NSMutableDictionary * dic = [self.cachesInfolist objectAtIndex:i];
        
        if([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@.temp",[dic objectForKey:@"path"]]]){
            [self beginRequest:[[dic objectForKey:@"id"]intValue] hdType:[[dic objectForKey:@"hdType"]intValue] isCollection:[[dic objectForKey:@"isCollection"]boolValue]  isBeginDown:NO];
            
            
        }
        if([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@.mp4",[dic objectForKey:@"path"]]]){
            [dic setValue:[NSNumber numberWithInt:emDownLoaded] forKey:@"state"];
        }else{
            [self.cachesInfolist removeObject:dic];
        }
        
    }
    
}
#pragma ASIHttpRequest回调委托

//出错了，如果是等待超时，则继续下载
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error=[request error];
    NSLog(@"ASIHttpRequest出错了!%@",error);
    
}

-(void)requestStarted:(ASIHTTPRequest *)request
{
    NSLog(@"开始了!");
}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {
    
    NSLog(@"didReceiveResponseHeaders-%@",[responseHeaders valueForKey:@"Content-Length"]);
    NSLog(@"收到回复了！");
    NSMutableDictionary *fileInfo=[request.userInfo objectForKey:@"file"];
    [fileInfo setValue:[SHFileManager getFileSizeString:[[request responseHeaders] objectForKey:@"Content-Length"]] forKey:@"fileSize"];
    
    
    
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self.cachesInfolist];
    [[NSUserDefaults standardUserDefaults ] setValue:data forKey:DOWNLOAD_INFO_LIST];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
}

-(void)setProgress:(float)newProgress
{
    NSLog(@"setProgress-%f",newProgress);
}
@end
