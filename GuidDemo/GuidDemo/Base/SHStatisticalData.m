//
//  SHStatisticalData.m
//  PPTV
//
//  Created by Ye Baohua on 15/2/2.
//  Copyright (c) 2015年 yebaohua. All rights reserved.
//

#import "SHStatisticalData.h"
#import "Utility.h"

@implementation SHStatisticalData

+(void) requestDmalog:(NSString *)title
{
    NSMutableDictionary * dic  = [[NSMutableDictionary alloc]init];
    [dic setValue:@"pad" forKey:@"JSv"];
    [dic setValue:@"" forKey:@"DMt"];
    [dic setValue:SHEntironment.instance.deviceid forKey:@"DMu"];
    [dic setValue:@"" forKey:@"DMac"];
    [dic setValue:@"pad" forKey:@"DMv"];
    [dic setValue:[NSString stringWithFormat:@"%0.0lf.%d",[[NSDate date]timeIntervalSince1970],(arc4random()%9000)+1000] forKey:@"DMvt"];//1000~9999
    [dic setValue:@"3" forKey:@"DMtp"];
    [dic setValue:@"" forKey:@"DMts"];
    [dic setValue:@"" forKey:@"DMva"];
    [dic setValue:@"" forKey:@"DMvb"];
    [dic setValue:@"" forKey:@"DMvc"];
    [dic setValue:@"" forKey:@"DMvd"];
    [dic setValue:@"" forKey:@"DMrf"];
    [dic setValue:@"" forKey:@"DMrff"];
    [dic setValue:@"" forKey:@"DMc"];
    [dic setValue:@"" forKey:@"DMjv"];
    [dic setValue:title forKey:@"DMt"];
    [dic setValue:@"" forKey:@"DMtv"];
    [dic setValue:@"" forKey:@"DMtvs"];
    [dic setValue:@"" forKey:@"DMp"];
    [dic setValue:@"" forKey:@"DMcc"];
    NSString * urlparams  = [NSString stringWithFormat:@"/dmalog?%@",[Utility createPostString:dic]];
    SHHttpTask* getTask= [[SHHttpTask alloc]init];
    getTask.URL = [[NSString stringWithFormat:@"%@%@",URL_STATISTICS,urlparams] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    getTask.delegate = self;
    [getTask start:^(SHTask *task) {
        NSLog(@"统计发送成功Dmalog");
    } taskWillTry:^(SHTask *task) {
        
    } taskDidFailed:^(SHTask *task) {
        
    }];
}

+(void) requestDmaevent:(NSMutableDictionary*) dicType
{
    NSMutableDictionary * dic  = [[NSMutableDictionary alloc]init];
    [dic setValue:@"pad" forKey:@"DMJSv"];
    [dic setValue:@"" forKey:@"DMt"];
    [dic setValue:SHEntironment.instance.deviceid forKey:@"DMu"];
    [dic setValue:@"" forKey:@"DMac"];
    [dic setValuesForKeysWithDictionary:dicType];
//    [dic setValue:@"" forKey:@"DMec"];
//    [dic setValue:@"" forKey:@"DMel"];
//    [dic setValue:@"" forKey:@"DMeo"];
    [dic setValue:@"1" forKey:@"DMev"];
    [dic setValue:[NSString stringWithFormat:@"%0.0lf",[[NSDate date]timeIntervalSince1970]] forKey:@"DMet"];
    [dic setValue:@"utf-8" forKey:@"DMcs"];
    [dic setValue:[NSNumber numberWithInt:(arc4random()%9000)+1000] forKey:@"DMr"];
    NSString * urlparams  = [NSString stringWithFormat:@"/dmaevent?%@",[Utility createPostString:dic]];
    SHHttpTask* getTask= [[SHHttpTask alloc]init];
    getTask.URL = [[NSString stringWithFormat:@"%@%@",URL_STATISTICS,urlparams] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    getTask.delegate = self;
    [getTask start:^(SHTask *task) {
         NSLog(@"统计发送成功Dmaevent");
    } taskWillTry:^(SHTask *task) {
        
    } taskDidFailed:^(SHTask *task) {
        
    }];
}
@end
