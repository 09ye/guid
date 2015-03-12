//
//  SHFileManager.h
//  PPTV
//
//  Created by yebaohua on 14/12/24.
//  Copyright (c) 2014年 yebaohua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileManager.h"

@interface SHFileManager : FileManager

+(float) fileSizeAtPath:(NSString*) filePath;

+(NSString *)getFileSizeString:(NSString *)size;
//经文件大小转化成不带单位ied数字
+(float)getFileSizeNumber:(NSString *)size;

+(NSString *)getTargetFloderPath;//得到实际文件存储文件夹的路径
//+(NSString *)getTempFolderPath;//得到临时文件存储文件夹的路径
+(BOOL)isExistFile:(NSString *)fileName;//检查文件名是否存在

//传入文件总大小和当前大小，得到文件的下载进度
+(CGFloat) getProgress:(float)totalSize currentSize:(float)currentSize;
// 单位G
+(float) currentCachesFileSize;
+(float) getFileSize:(NSString *)filePath;
// 完整路径
+ (BOOL)deleteFileOfPath :(NSString*) file;


@end
