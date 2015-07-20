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
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    _locationManager = [[CLLocationManager alloc]init];
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }
    _locationManager.delegate = self;
//    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    [_locationManager startUpdatingLocation];
    self.myLoaction = [[CLLocation alloc] initWithLatitude:0.0 longitude:0.0];
    [Utility addNotBackUp];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    return YES;
}
-(NSDictionary *) distanceFromCurrentLocationPoint
{
    NSArray * list = [SHXmlParser.instance listHotPoints];
    NSDictionary * dicResult ;
    double minDistance = 30.0;
    if([[SHXmlParser.instance detail]objectForKey:@"accuracy"]){
        minDistance = [[[SHXmlParser.instance detail]objectForKey:@"accuracy"]intValue];
    }
    for(int i = 0;i<list.count;i++){
        NSDictionary * dic =[list objectAtIndex:i];
        CLLocation *locationPoint=[[CLLocation alloc] initWithLatitude:[[dic objectForKey:@"latitude"]doubleValue] longitude:[[dic objectForKey:@"longitude"]doubleValue]];
        CLLocationDistance meters=[self.myLoaction distanceFromLocation:locationPoint];
        if (minDistance >meters) {
            dicResult = dic;
            minDistance = meters;
        }
        
    }
    return dicResult;
}
-(NSDictionary *) distanceFromCurrentLocationAttraction
{
    NSArray * list = [SHXmlParser.instance listAttractions];
    NSDictionary * dicResult ;
    double minDistance = 30.0;
    if([[SHXmlParser.instance detail]objectForKey:@"accuracy"]){
        minDistance = [[[SHXmlParser.instance detail]objectForKey:@"accuracy"]intValue];
    }
    for(int i = 0;i<list.count;i++){
        NSDictionary * dic =[list objectAtIndex:i];
        CLLocation *locationPoint=[[CLLocation alloc] initWithLatitude:[[dic objectForKey:@"latitude"]doubleValue] longitude:[[dic objectForKey:@"longitude"]doubleValue]];
        CLLocationDistance meters=[self.myLoaction distanceFromLocation:locationPoint];
        if (minDistance >meters) {
            dicResult = dic;
            minDistance = meters;
        }
        
    }
    return dicResult;
}
- (void)configUpdate:(NSObject*)sender
{
    [SHConfigManager.instance show];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.myLoaction = [locations lastObject];
//    self.myLoaction =  [[CLLocation alloc]initWithLatitude:31.254600 longitude:121.430331];
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOCATION_CHANGE object:self.myLoaction];
    NSLog(@"%3.5f===%3.5f",self.myLoaction.coordinate.latitude,self.myLoaction.coordinate.longitude);
    if(!self.attractionShow){
        NSDictionary * dic  = [self distanceFromCurrentLocationAttraction];
        if (dic) {
            NSDate *lastPlayDate = [dic objectForKey:@"last_play_date"];
            NSDate *nextPlayDate = [[NSDate alloc] initWithTimeInterval:15 * 60 sinceDate:lastPlayDate];
            NSDate *now = [NSDate date];
            if ([nextPlayDate compare:now] == NSOrderedAscending) {
                [dic setValue:now forKey:@"last_play_date"];
                SHIntent * intent =[[SHIntent alloc]init];
                intent.target = @"SHGuidIntroduceViewController";
                [intent.args setValue:dic forKey:@"detail"];
                [[UIApplication sharedApplication]open:intent];
            }
        }
    }
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
@end
