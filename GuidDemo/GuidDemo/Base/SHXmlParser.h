//
//  SHXmlParser.h
//  GuidDemo
//
//  Created by Ye Baohua on 15/3/9.
//  Copyright (c) 2015年 Ye Baohua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHXmlParser : NSObject<NSXMLParserDelegate>
{

}
@property (nonatomic,strong)NSString * pathName;
@property (nonatomic,strong)NSMutableDictionary * detail;
@property (nonatomic,strong) NSMutableArray * listPics;
@property (nonatomic,strong) NSMutableArray * listVideos;
@property (nonatomic,strong) NSMutableArray * listHotPoints;
@property (nonatomic,strong) NSMutableArray * listAttractions;


+(SHXmlParser*)instance;

-(BOOL)start:(NSString *)path;

@end
