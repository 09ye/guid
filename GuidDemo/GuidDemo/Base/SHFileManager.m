//
//  SHFileManager.m
//  PPTV
//
//  Created by yebaohua on 14/12/24.
//  Copyright (c) 2014年 yebaohua. All rights reserved.
//

#import "SHFileManager.h"

@implementation SHFileManager

//文件大小 10.0M 不大于1G 1.0G
+(float) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        long long size =[[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        if (size/1024.0/1024.0/1024.0>0) {
            return (size/1024.0/1024.0/1024.0)*0.1f;// 0.1G
        }
        return  (size/1024.0/1024.0)*0.1f;//0.1M
    }
    return 0.0f;
}
+(NSString *)getFileSizeString:(NSString *)size
{
    if([size floatValue]>=1024*1024)//大于1M，则转化成M单位的字符串
    {
        return [NSString stringWithFormat:@"%0.1fM",[size floatValue]/1024/1024];
    }
    else if([size floatValue]>=1024&&[size floatValue]<1024*1024) //不到1M,但是超过了1KB，则转化成KB单位
    {
        return [NSString stringWithFormat:@"%0.1fK",[size floatValue]/1024];
    }
    else//剩下的都是小于1K的，则转化成B单位
    {
        return [NSString stringWithFormat:@"%0.1fB",[size floatValue]];
    }
}

+(float)getFileSizeNumber:(NSString *)size
{
    NSInteger indexM=[size rangeOfString:@"M"].location;
    NSInteger indexK=[size rangeOfString:@"K"].location;
    NSInteger indexB=[size rangeOfString:@"B"].location;
    if(indexM<1000)//是M单位的字符串
    {
        return [[size substringToIndex:indexM] floatValue]*1024*1024;
    }
    else if(indexK<1000)//是K单位的字符串
    {
        return [[size substringToIndex:indexK] floatValue]*1024;
    }
    else if(indexB<1000)//是B单位的字符串
    {
        return [[size substringToIndex:indexB] floatValue];
    }
    else//没有任何单位的数字字符串
    {
        return [size floatValue];
    }
}

+(NSString *)getDocumentPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Zipres"];
}

+(NSString *)getTargetFloderPath
{
    return [self getDocumentPath];
}

+(NSString *)getTempFolderPath
{
   
    return [[self getDocumentPath] stringByAppendingPathComponent:@"temp"];
}

+(BOOL)isExistFile:(NSString *)fileName
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:fileName];
}

+(float)getProgress:(float)totalSize currentSize:(float)currentSize
{
    return currentSize/totalSize;
}

+(float)currentCachesFileSize{
    
    NSString *savePath=[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Zipres"];
    
    NSFileManager *filemgr;
    
    NSArray *filelist;
    
    int count;
    
    float cacheSize = 0;
    
    filemgr =[NSFileManager defaultManager];
    
    filelist = [filemgr contentsOfDirectoryAtPath:savePath error:NULL];
    
    count = [filelist count];
    
    for (NSString *url in filelist) {
        
       long long size = [[filemgr attributesOfItemAtPath:[NSString stringWithFormat:@"%@/%@",savePath,url] error:nil] fileSize];
        if(size){
            cacheSize = cacheSize + size;
        }
       
        
    }
    
    cacheSize = (cacheSize/1024.0/1024.0/1024.0);
    
    return cacheSize;
    
}
+(float) getFileSize:(NSString *)filePath
{
    
    NSFileManager *filemgr;
    
    NSArray *filelist;
    
    int count;
    
    float cacheSize = 0;
    
    filemgr =[NSFileManager defaultManager];
    
    filelist = [filemgr contentsOfDirectoryAtPath:filePath error:NULL];
    
    count = [filelist count];
    
    for (NSString *url in filelist) {
        
        long long size = [[filemgr attributesOfItemAtPath:[NSString stringWithFormat:@"%@/%@",filePath,url] error:nil] fileSize];
        if(size){
            cacheSize = cacheSize + size;
        }
        
        
    }
    
    cacheSize = (cacheSize/1024.0/1024.0);
    
    return cacheSize;
}

+ (BOOL)deleteFileOfPath :(NSString*) file
{
   NSFileManager* fileManager=[NSFileManager defaultManager];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:file];
    if (!blHave) {
        NSLog(@"no  have");
        return NO;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:file error:nil];
        if (blDele) {
            NSLog(@"dele success");
            return YES;
        }else {
            NSLog(@"dele fail");
            return NO;
        }
        
    }
}

@end
