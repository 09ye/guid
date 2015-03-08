//
//  config.h
//  Zambon
//
//  Created by sheely on 13-9-23.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import "Core.h"
#import "common.h"
#import "SHAppDelegate.h"
#import "Utility.h"
#import "SHStatisticalData.h"


#define URL_HEADER @ "http://padapi.wasu.cn"
#define URL_ADS @"http://afp.csbew.com/s.htm"//广告
#define URL_STATISTICS  @"http://dmav1.junjichu.net"//统计

#define URL_BATA @ "http://123.103.20.88:18014"
//测试 pad.cs.wasu.cn:18014
//正式 padapi.wasu.cn
#define URL_DEVELOPER @ "http://padapi.wasu.cn"

#define URL_UPDATE @"http://zambon-update1.mobilitychina.com:8095/get_config"

#define URL_FOR(a) [NSString stringWithFormat:@"%@/%@",URL_HEADER,a]

#define DEVICE_TOKEN @"DeviceTokenStringKEY"




#define LIST_PAGE_SIZE 10

#define RECT_RIGHTSHOW CGRectMake(87, 23, 930, 730)
#define RECT_RIGHTNAVIGATION CGRectMake(0, 0, 930, 44)
#define RECT_RIGHTLIST CGRectMake(0, 44, 240, 678)
#define RECT_RIGHTCONTENT CGRectMake(240, 0, 687  , 730)
#define RECT_RIGHTCONTENT2 CGRectMake(667, 23, 350  , 730)
#define CELL_GENERAL_HEIGHT 110
#define CELL_GENERAL_HEIGHT2 80
#define CELL_GENERAL_HEIGHT3 44
#define CELL_SECTION_HEADER_GENERAL_HEIGHT 38
#define RECT_MAIN_LANDSCAPE_RIGHT CGRectMake(-20, 0, 768, 1004)
#define RECT_MAIN_LANDSCAPE_LEFT CGRectMake(20, 0, 768, 1004)

#define USER_CENTER_LOGINNAME @"user_center_loginname"
#define USER_CENTER_PASSWORD @"user_center_password"

#define COLLECT_LIST @"collect_list"
#define RECORD_LIST @"record_list"
#define DOWNLOAD_INFO_LIST @"download_info_list"
#define SEARCH_LIST @"search_list"

//notification
#define NOTIFICATION_LOGIN_SUCCESSFUL @"notification_login_successful"
#define NOTIFY_SinaAuthon_Success     @"SinaAuthonSuccess"
#define NOTIFICATION_INTENT_CANCLE_SUCCESSFUL     @"notification_intent_cancle_successful"
#define NOTIFICATION_HOME_TABBAR_DIDSELECT     @"notification_home_tabbar_didselect"



#define IPAD ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(768, 1024), [[UIScreen mainScreen] currentMode].size) : NO)
#define IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define RETAIN ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define IPHONE4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define UIScreenWidth MAX([[UIScreen mainScreen]bounds].size.width ,[[UIScreen mainScreen]bounds].size.height)
#define UIScreenHeight MIN([[UIScreen mainScreen]bounds].size.width ,[[UIScreen mainScreen]bounds].size.height)

#define BEST_SCROLLVIEW_WIDTH 262
typedef enum
{
    emDownLoaded,// 完成
    emDownloading,//下载中
    emPaused,//暂停
    emWaiting,// 等待
    
    
}DownLoadState;


