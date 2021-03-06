//
//  Utility.m
//  RT5030S
//
//  Created by yebaohua on 14-9-29.
//  Copyright (c) 2014年 yebaohua. All rights reserved.
//

#import "Utility.h"
#import <sys/xattr.h>

@implementation Utility

+ (NSData *)createPostData:(NSDictionary*) params
{
    NSString *postString=@"";
    for(NSString *key in [params allKeys])
    {
        NSString *value=[params objectForKey:key];
        postString=[postString stringByAppendingFormat:@"%@=%@&",key,value];
    }
    if([postString length]>1)
    {
        postString=[postString substringToIndex:[postString length]-1];
    }
    SHLog(@"%@",postString);
    NSData * data = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return data;
}
+ (NSString *)createPostString:(NSDictionary*) params
{
    NSString *postString=@"";
    for(NSString *key in [params allKeys])
    {
        NSString *value=[params objectForKey:key];
        postString=[postString stringByAppendingFormat:@"%@=%@&",key,value];
    }
    if([postString length]>1)
    {
        postString=[postString substringToIndex:[postString length]-1];
    }
    SHLog(@"%@",postString);
    return postString;
}
+(NSArray *)weekDayWithDate:(NSDate *)date{
    
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *weekDayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
    NSInteger mDay = [weekDayComponents weekday];
    NSArray *week=@[@0,@""];
    switch (mDay) {
        case 0:{
            week=@[@6,@"周日"];
            break;
        }
        case 1:{
            week=@[@6,@"周日"];
            break;
        }
        case 2:{
            week=@[@0,@"周一"];
            break;
        }
        case 3:{
            week=@[@1,@"周二"];
            break;
        }
        case 4:{
            week=@[@2,@"周三"];
            break;
        }
        case 5:{
            week=@[@3,@"周四"];
            break;
        }
        case 6:{
            week=@[@4,@"周五"];
            break;
        }
        case 7:{
            week=@[@5,@"周六"];
            break;
        }
        default:{
            break;
        }
    };
    return week;
}
+(BOOL)containsObject:(NSMutableArray *)array forKey:(NSString *)key forValue:(NSString *)value
{
    for (NSDictionary *dic in array) {
        if ([[NSString stringWithFormat:@"%@",[dic objectForKey:key]] isEqualToString:value]) {
            return YES;
            
        }
    }
    return  NO;
}
+(void)removeObject:(NSMutableArray *)array forKey:(NSString *)key forValue:(NSString *)value
{
    for (NSDictionary *dic in array) {
        if ([[dic objectForKey:key] isEqualToString:value] ) {
            [array  removeObject:dic];
            break;
        }
    }

}

+(NSString *)encodeVideoUrl:(NSString *) url
{
    return  [self encodeVideoUrl:url key:@"#&@^!&WaSu8&(6Lx"];
}
+(NSString *)encodeVideoUrl:(NSString *) url key:(NSString *)key
{
    int ckey_length = 4;
    key  = [[SHTools md5Encrypt:(![key isEqualToString:@""]?key:@"12345678")]lowercaseString];
    NSString * keya  = [[SHTools md5Encrypt:([key substringWithRange:NSMakeRange(0, 16)])]lowercaseString];
    NSString * keyb  = [[SHTools md5Encrypt:([key substringWithRange:NSMakeRange(16, 16)])]lowercaseString];
    NSString * keyc  = [url substringWithRange:NSMakeRange(0, ckey_length)];
    NSString * cryptkey = [NSString stringWithFormat:@"%@%@",keya,[[SHTools md5Encrypt:[NSString stringWithFormat:@"%@%@",keya,keyc]]lowercaseString]];
    int key_length =  cryptkey.length;
    url = [[NSString alloc]initWithData:[Base64 decode:[url substringFromIndex:ckey_length]] encoding:NSUTF8StringEncoding];
    int string_length = url.length;
    NSData *testData = [cryptkey dataUsingEncoding: NSUTF8StringEncoding];
    Byte *cryptkey2 = (Byte *)[testData bytes];
    NSMutableArray *mdkey = [[NSMutableArray alloc]init];
    NSMutableArray *box = [[NSMutableArray alloc]init];
    int i,j,k,tmp;
    for (int i = 0; i<128; i++) {
        [box addObject:[NSNumber numberWithInt:i]];
        [mdkey addObject:[NSNumber numberWithInt:(cryptkey2[i%key_length] & 0xFF)]];
    }
    for (j = i = 0; i<128; i++) {
        j = (j+ [[box objectAtIndex:i]intValue]+[[mdkey objectAtIndex:i]intValue])%128;
        tmp = [[box objectAtIndex:i]intValue];
        [box replaceObjectAtIndex:i withObject:[box objectAtIndex:j]];
        [box replaceObjectAtIndex:j withObject:[NSNumber numberWithInt:tmp]];
        
    }
    Byte *str3 = (Byte *)[[url dataUsingEncoding: NSUTF8StringEncoding] bytes];
    
    Byte result[string_length];
    for (k=j=i=0 ; i < string_length;i++) {
        k =  (k+1)%128;
        j = (j+ [[box objectAtIndex:k]intValue])%128;
        tmp  = [[box objectAtIndex:k]intValue];
        [box replaceObjectAtIndex:k withObject:[box objectAtIndex:j]];
        [box replaceObjectAtIndex:j withObject:[NSNumber numberWithInt:tmp]];
        int  powB = [[box objectAtIndex:(([[box objectAtIndex:k]intValue]+[[box objectAtIndex:j]intValue])%128)]intValue];
        result[i] = (Byte)str3[i]&0xff ^ powB;
    }
    
    NSData *adata = [[NSData alloc] initWithBytes:result length:string_length];
    NSString *aString = [[NSString alloc] initWithData:adata encoding:NSUTF8StringEncoding];
    NSString * result1  = aString;
    int string10 = [[result1 substringWithRange:NSMakeRange(0, 10)]intValue];
    int  time  = [[NSDate date]timeIntervalSince1970];
    NSString * string16 = [result1 substringWithRange:NSMakeRange(10, 16)];
    NSString * stringkey = [NSString stringWithFormat:@"%@%@",[result1 substringFromIndex:26] ,keyb];
    NSString * stringmd5  = [[SHTools md5Encrypt:stringkey]lowercaseString];
    NSString * string162 =  [stringmd5 substringWithRange:NSMakeRange(0, 16)];
    NSString * results  = @"" ;
    if((string10 == 0 || string10-time>0) && [string16 isEqualToString:string162]){
        results =  [result1 substringFromIndex:26];
    }
    NSLog(@"encodeVideoUrl===%@",results);
    return results;
}

+ (CGSize)setoriginW: (CGSize)imageWH setoriginH:(CGSize)originWH

{
    float dWidth = imageWH.width;                                  //img的宽高
    float dHeight = imageWH.height;
    float dAspectRatio = dWidth/dHeight;                           //纵横比
    
    float dPictureWidth = originWH.width;
    float dPictureHeight = originWH.height;                        //传图的宽高
    float dPictureAspectRatio = dPictureWidth/dPictureHeight;      //长宽比
    
    CGSize newImage = CGSizeZero;
    if (dPictureAspectRatio > dAspectRatio){
        
        float nNewHeight = dWidth/dPictureWidth*dPictureHeight;
        newImage = CGSizeMake(dWidth, nNewHeight);
        
        
    }else if (dPictureAspectRatio < dAspectRatio){
        
        float nNewWidth = dHeight/dPictureHeight*dPictureWidth;
        newImage = CGSizeMake(nNewWidth, dHeight);
        NSLog(@"newImage = %f \n %f",newImage.width,newImage.height);
    }
    
    return  newImage;
}
+(CGRect) sizeFitImage:(CGSize)originWH
{
    CGRect newRect = CGRectZero;
    float dWidth = UIScreenWidth;                                  //img的宽高
    float dHeight = UIScreenHeight;
    float dAspectRatio = dWidth/dHeight;                           //纵横比
    
    float dPictureWidth = originWH.width;
    float dPictureHeight = originWH.height;                        //传图的宽高
    float dPictureAspectRatio = dPictureWidth/dPictureHeight;      //长宽比
    
    if (dPictureAspectRatio > dAspectRatio){
        
        float nNewHeight = dWidth/dPictureWidth*dPictureHeight;
        newRect = CGRectMake(0, abs((dHeight-nNewHeight))/2, dWidth, nNewHeight);
    }else if (dPictureAspectRatio < dAspectRatio){
        
        float nNewWidth = dHeight/dPictureHeight*dPictureWidth;
        newRect = CGRectMake(abs((dWidth-nNewWidth))/2, 0,nNewWidth, dHeight);
    }
    
    return  newRect;
}

/*字符串加密
 *参数
 *plainText : 加密明文
 *key        : 密钥 64位
 */
+ (NSString *) encryptUseDES:(NSString *)plainText
{
    NSString * key = @"12345678";
    NSString *ciphertext = nil;
    const char *textBytes = [plainText UTF8String];
    NSUInteger dataLength = [plainText length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    Byte iv[] = {1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8};
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          textBytes, dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        NSString * string  = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
        NSLog(@"加密后：%@",string);
        ciphertext = [Base64 encode:data];
    }
     NSLog(@"DES encode==%@",ciphertext);
    return ciphertext;
}

//解密
+ (NSString *) decryptUseDES:(NSString*)cipherText 
{
    
    NSString * key = @"12345678";
    NSData* cipherData = [Base64 decode:cipherText];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    Byte iv[] = {1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8};
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          iv ,
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          1024,
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
       
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
     NSLog(@"base64 decode==%@",[[NSString alloc] initWithData:[Base64 decode:plainText] encoding:NSUTF8StringEncoding]);
    NSLog(@"DES decode==%@",plainText);
    return plainText;
}
/**
 加密
 */
+ (NSData *)AES256EncryptWithKey:(NSData*) date key:(NSString *)key {//加密
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [date length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    Byte iv[] = {1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6};
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          iv,
                                          [date bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}

/**
 加密
 */
+ (NSData *)AES256DecryptWithKey:(NSData*) date key:(NSString *)key {//解密
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [date length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    Byte iv[] = {1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6};
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [date bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

+(void)addNotBackUp{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSURL *url = [NSURL URLWithString:documentsDirectory];
    
    [self addSkipBackupAttributeToItemAtURL:url];
    
    paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    url = [NSURL URLWithString:documentsDirectory];
    [self addSkipBackupAttributeToItemAtURL:url];
}
+(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    if ( ! [[NSFileManager defaultManager] fileExistsAtPath:[URL path]] ) return YES;
    
    BOOL success = YES;
    if ( [self systemVersionIsHighOrEqualToIt:@"5.1"] ) {
        NSError *error = nil;
        success = [URL setResourceValue:[NSNumber numberWithBool:YES]
                                 forKey:NSURLIsExcludedFromBackupKey
                                  error:&error];
    } else if ( [self systemVersionIsEqualToIt:@"5.0.1"] ) {
        const char *filePath = [[URL path] fileSystemRepresentation];
        const char *attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        success = (result == 0);
    }
    
    return success;
}
+(BOOL)systemVersionIsHighOrEqualToIt:(NSString*)minSystemVersion
{
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if ( [systemVersion compare:minSystemVersion options:NSNumericSearch] != NSOrderedAscending ) {
        return YES;
    }
    return NO;
}

+(BOOL)systemVersionIsEqualToIt:(NSString*)version
{
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if ( [systemVersion compare:version options:NSNumericSearch] == NSOrderedSame ) {
        return YES;
    }
    return NO;
}


@end
