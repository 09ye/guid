//
//  SHStatisticalData.h
//  PPTV
//
//  Created by Ye Baohua on 15/2/2.
//  Copyright (c) 2015年 yebaohua. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    emOnline,// 在线
    emVideo,//下载中
    emVideoTime,//暂停
    emVideoHits,// 等待
    
    
}emEvent;

@interface SHStatisticalData : NSObject<SHTaskDelegate>

+(void) requestDmalog:(NSString * )title;

+(void) requestDmaevent:(NSMutableDictionary*) dicType;


@end
