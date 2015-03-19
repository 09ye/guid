//
//  SHXmlParser.m
//  GuidDemo
//
//  Created by Ye Baohua on 15/3/9.
//  Copyright (c) 2015年 Ye Baohua. All rights reserved.
//

#import "SHXmlParser.h"
#import "GDataXMLNode.h"

@implementation SHXmlParser

static SHXmlParser* _instance = nil;

+(SHXmlParser*)instance{
    if(_instance == nil){
        _instance = [[SHXmlParser alloc]init];
        
    }
    return _instance;
}

- (id)init{
    if(self = [super init]){

       
    }
    return self;
}
-(BOOL)start:(NSString *)path
{
    self.pathName = path;
    [self initDom];
    return true;
}
- (GDataXMLDocument* )docForStyle:(NSString*)name{
    
    NSError* error = nil;
//    NSData * data = nil;
//    data = [[NSData alloc]initWithContentsOfFile: [[NSBundle mainBundle]pathForResource:name ofType:@"xml"] ];
    NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.xml",self.pathName,name]];
    NSString *documentStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    GDataXMLDocument *_parserColor = [[GDataXMLDocument alloc] initWithXMLString:documentStr options:0 error:&error];
   
    return _parserColor;
    
}
- (void) initDom
{
    self.detail = [[NSMutableDictionary alloc]init];
    GDataXMLDocument* doc = [self docForStyle:@"list"];
    GDataXMLElement * detail = [[doc nodesForXPath:[NSString stringWithFormat:@"/pack/detail"] error:nil]objectAtIndex:0];
    
    GDataXMLElement *parkEle = [[detail elementsForName:@"parkname"] objectAtIndex:0];
    [self.detail setValue:[parkEle stringValue] forKey:@"parkname"];
    
    GDataXMLElement *introEle = [[detail elementsForName:@"intro"] objectAtIndex:0];
    [self.detail setValue:[introEle stringValue] forKey:@"intro"];
    
    
    GDataXMLElement *aboutElement = [[detail elementsForName:@"about"] objectAtIndex:0];
     NSMutableDictionary * dicAbout = [[NSMutableDictionary alloc]init];
    [dicAbout setValue:[[aboutElement attributeForName:@"name"] stringValue] forKey:@"name"];
    [dicAbout setValue:[NSString stringWithFormat:@"%@/%@",self.pathName,[[aboutElement attributeForName:@"path"] stringValue]] forKey:@"path"];// 完整路径
    
    GDataXMLElement *shopElement = [[detail elementsForName:@"shop"] objectAtIndex:0];
    NSMutableDictionary * dicShop = [[NSMutableDictionary alloc]init];
    [dicShop setValue:[[shopElement attributeForName:@"name"] stringValue] forKey:@"name"];
    [dicShop setValue:[NSString stringWithFormat:@"%@/%@",self.pathName,[[shopElement attributeForName:@"path"] stringValue]] forKey:@"path"];
    
    NSMutableArray * listMore = [[NSMutableArray alloc]init];
    [listMore addObject:dicAbout];
    [listMore addObject:dicShop];
    [self.detail setValue:listMore forKey:@"more"];
    
     NSArray * arrayMaps=  [[[detail elementsForName:@"pics"]objectAtIndex:0] elementsForName:@"pic"];
    self.listPics = [[NSMutableArray alloc]init];
    for (GDataXMLElement *map in arrayMaps) {
        NSMutableDictionary * dic  = [[NSMutableDictionary alloc]init];
        [dic setValue:[[[map elementsForName:@"name"]objectAtIndex:0] stringValue] forKey:@"name"];
        [dic setValue:[NSString stringWithFormat:@"%@/%@",self.pathName,[[[map elementsForName:@"fpath"]objectAtIndex:0] stringValue]] forKey:@"fpath"];
        [self.listPics addObject:dic];
      
    }
    

    NSArray * arrayVideos=  [[[detail elementsForName:@"videos"]objectAtIndex:0] elementsForName:@"video"];
    self.listVideos = [[NSMutableArray alloc]init];
    for (GDataXMLElement *map in arrayVideos) {
        NSMutableDictionary * dic  = [[NSMutableDictionary alloc]init];
        [dic setValue:[[[map elementsForName:@"name"]objectAtIndex:0] stringValue] forKey:@"name"];
        [dic setValue:[NSString stringWithFormat:@"%@/%@",self.pathName,[[[map elementsForName:@"fpath"]objectAtIndex:0] stringValue]] forKey:@"fpath"];
        [self.listVideos addObject:dic];
    }
    
    GDataXMLElement *dituEle = [[detail elementsForName:@"ditu"]objectAtIndex:0];
    GDataXMLElement *ditupicEle = [[dituEle elementsForName:@"ditupic"]objectAtIndex:0];
    [self.detail setValue:[NSString stringWithFormat:@"%@/%@",self.pathName,[[ditupicEle attributeForName:@"fpath"]stringValue]] forKey:@"ditupic"];
    
    NSArray * arrayPoint=  [[[ditupicEle elementsForName:@"hotpotes"]objectAtIndex:0]elementsForName:@"hotpot"];
    self.listHotPoints = [[NSMutableArray alloc]init];
    for (GDataXMLElement *map in arrayPoint) {
        NSMutableDictionary * dic  = [[NSMutableDictionary alloc]init];
        [dic setValue:[[[[map elementsForName:@"idcode"]objectAtIndex:0] attributeForName:@"value"]stringValue] forKey:@"idcode"];
        [dic setValue:[[[[map elementsForName:@"latitude"]objectAtIndex:0] attributeForName:@"value"]stringValue] forKey:@"latitude"];
        [dic setValue:[[[[map elementsForName:@"longitude"]objectAtIndex:0] attributeForName:@"value"]stringValue] forKey:@"longitude"];
        [dic setValue:[[[[map elementsForName:@"potx"]objectAtIndex:0] attributeForName:@"value"]stringValue] forKey:@"potx"];
        [dic setValue: [[[[map elementsForName:@"poty"]objectAtIndex:0] attributeForName:@"value"]stringValue]  forKey:@"poty"];
        [self.listHotPoints addObject:dic];
    }
    
    NSArray * arrayattr=  [[[detail elementsForName:@"attractions"]objectAtIndex:0]elementsForName:@"attraction"];
    self.listAttractions = [[NSMutableArray alloc]init];
    for (GDataXMLElement *map in arrayattr) {
        NSMutableDictionary * dic  = [[NSMutableDictionary alloc]init];
        [dic setValue:[[[map elementsForName:@"code"]objectAtIndex:0] stringValue] forKey:@"code"];
        [dic setValue:[[[map elementsForName:@"name"]objectAtIndex:0] stringValue] forKey:@"name"];
        [dic setValue:[NSString stringWithFormat:@"%@/%@",self.pathName,[[[map elementsForName:@"mp3Path"]objectAtIndex:0] stringValue]] forKey:@"mp3Path"];
        [dic setValue:[[[map elementsForName:@"txt"]objectAtIndex:0] stringValue] forKey:@"txt"];
        
//        [dic setValue:[[[map elementsForName:@"txtPath"]objectAtIndex:0] stringValue] forKey:@"txtPath"];
//        [dic setValue:[[[map elementsForName:@"videoPath"]objectAtIndex:0] stringValue] forKey:@"videoPath"];
//        [dic setValue:[[[map elementsForName:@"latitude"]objectAtIndex:0] stringValue] forKey:@"latitude"];
//        [dic setValue:[[[map elementsForName:@"longitude"]objectAtIndex:0] stringValue] forKey:@"longitude"];
        
        NSArray * arraypic=  [[[map elementsForName:@"pictures"]objectAtIndex:0]elementsForName:@"pic"];
        NSMutableArray * pics = [[NSMutableArray alloc]init];
        for (GDataXMLElement *pic in arraypic) {
            [pics addObject:[[[pic elementsForName:@"picPath"]objectAtIndex:0]stringValue]];
        }
        [dic setValue:pics forKey:@"pics"];
        [self.listAttractions addObject:dic];
    }
    
   
}
@end
