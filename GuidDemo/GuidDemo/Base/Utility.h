//
//  Utility.h
//  RT5030S
//
//  Created by yebaohua on 14-9-29.
//  Copyright (c) 2014年 yebaohua. All rights reserved.
//

#import "SHTools.h"

@interface Utility : SHTools
//post 请求参数 key=vlaue&key=value
+ (NSData *)createPostData:(NSDictionary*) params;

+ (NSString *)createPostString:(NSDictionary*) params;
// data 是星期几 返回[0,周一]。。。
+(NSArray *)weekDayWithDate:(NSDate *)date;
//判断数组中是否存在这个key value 的字典
+(BOOL)containsObject:(NSMutableArray *)array forKey:(NSString *)key forValue:(NSString *)value;
//删除 数组存在 key =value 的索引
+(void)removeObject:(NSMutableArray *)array forKey:(NSString *)key forValue:(NSString *)value;

+(NSString *)encodeVideoUrl:(NSString *) url ;
+(NSString *)encodeVideoUrl:(NSString *) url key:(NSString *)key;
@end
