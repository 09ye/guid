//
//  SHMainFuntionViewController.m
//  GuidDemo
//
//  Created by Ye Baohua on 15/3/8.
//  Copyright (c) 2015年 Ye Baohua. All rights reserved.
//

#import "SHMainFuntionViewController.h"
#import "SHLeftViewController.h"
#import "ImgScrollView.h"
#import "TapImageView.h"
#import "SHXmlParser.h"
#import "ZipArchive.h"


@interface SHMainFuntionViewController ()<TapImageViewDelegate>
{
    NSInteger currentIndex;
    NSArray * arryMore;
   UIView *imgView;
   UIView *markView;
   UIScrollView *imgScrollview;
   NSArray *listImages;
    MMProgressHUD * progressDialog;
}

@end

@implementation SHMainFuntionViewController
- (float)leftSContentOffset
{
    return  215;
}
- (CGFloat)rightSContentOffset
{
    return  0;
}
- (void)viewDidLoad {
    
    SHLeftViewController * controller = [[SHLeftViewController alloc ]init];
    controller.navigationController = self.navigationController;
    UINavigationController * nacontroller = [[UINavigationController alloc]initWithRootViewController: controller];
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [nacontroller.navigationBar setTitleTextAttributes:attributes];
    nacontroller.navigationBar.translucent = NO;
    
    nacontroller.navigationBar.tintColor = [UIColor whiteColor];
    if(!iOS7){
        nacontroller.navigationBar.clipsToBounds = YES;
    }

    nacontroller.navigationBar.barTintColor = [SHSkin.instance colorOfStyle:@"ColorBase"];
    nacontroller.view.frame = [UIScreen mainScreen].bounds;
    
    self.leftViewController = (SHViewController*)nacontroller;
    [super viewDidLoad];
    
    [self loadCacheList];
    
    
//    [self unZipPack:[[SHFileManager getTargetFloderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",@"6"]]];
//   [self requestDateZip:@"http://travel.team4.us/service/iperson_ticket_check?ticket_id=141"];
//    NSData * decode =[Utility  AES256DecryptWithKey:[Base64 decode:@"jXLZeWHQd4MXkK96vrkDAaodEsNVXFIlthpqkol4PUv00Yr9KhHEGi0fn1gkwHT8wNt8SW9PsuhGeexFsdMYjg=="] key:@"1234567890123456"];
//    NSString * url  = [[NSString alloc]initWithData:decode encoding:NSUTF8StringEncoding];
//    [self requestDateZip:url];
//   [self beginRequest:@"http://dl.haima.me/download/haimapc/haimawan.exe"];
    mbtnSao.layer.cornerRadius = 5.0;
    mbtnSao.layer.masksToBounds = YES;
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"side"] target:self action:@selector(btnLeftOntouch)];

    UIBarButtonItem * button1 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more"] target:self action:@selector(btnMore)];
    UIBarButtonItem * button2 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"map"] target:self action:@selector(btnShowMap)];
    [self.navigationItem setRightBarButtonItems:@[button1,button2]];
    
    [self requestDataDrawUI];
    
}

//图片导航
-(void) requestDataDrawUI
{
    self.title = [[SHXmlParser.instance detail]objectForKey:@"parkname"];
    arryMore =  [[SHXmlParser.instance detail]objectForKey:@"more"];
    listImages  = [SHXmlParser.instance listPics];
    [mScrollview setContentSize:CGSizeMake(UIScreenWidth*listImages.count, UIScreenHeight-49)];
    for (int i = 0 ; i < listImages.count; i++) {
        NSDictionary *dic  = [listImages objectAtIndex:i];
        NSData *imageData = [NSData dataWithContentsOfFile:[dic objectForKey:@"fpath"]];
        UIImage *image = [UIImage imageWithData:imageData];
        UIImageView *imageView = [[UIImageView alloc] init];
        [mScrollview addSubview:imageView];
        // 计算位置
        imageView.frame = [Utility sizeFitImage:image.size];
        CGPoint point = CGPointMake(UIScreenWidth/2+UIScreenWidth*i, self.view.center.y);
        imageView.center = point;
        // 下载图片
        imageView.image  = image;
        // 事件监听
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        // 内容模式
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    
}


-(void) btnLeftOntouch
{
    [self leftItemClick4ViewController];
}
-(void)btnShowMap
{
    SHIntent * intent = [[SHIntent alloc]init];
    intent.target = @"SHMapViewController";
    intent.container  = self.navigationController;
    [[UIApplication sharedApplication]open:intent];
}
-(void)btnMore
{
    AppDelegate* app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:[[arryMore objectAtIndex:0]objectForKey:@"name"], [[arryMore objectAtIndex:1]objectForKey:@"name"], nil];
    [choiceSheet showInView:app.viewController.view];
}
- (IBAction)btnSaoOntouch:(id)sender {
    [self scannerAction:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex == 0) {
        
        SHIntent *intent = [[SHIntent alloc]init];
        [intent.args setValue:[actionSheet buttonTitleAtIndex:0] forKey:@"title"];
        [intent.args setValue:[[arryMore objectAtIndex:0]objectForKey:@"path"] forKey:@"url"];
        intent.target = @"WebViewController";
        intent.container = self.navigationController;
        [[UIApplication sharedApplication]open:intent];
    }else if(buttonIndex == 1){
        
        SHIntent *intent = [[SHIntent alloc]init];
        [intent.args setValue:[actionSheet buttonTitleAtIndex:1] forKey:@"title"];
        [intent.args setValue:[[arryMore objectAtIndex:0]objectForKey:@"path"] forKey:@"url"];
        intent.target = @"WebViewController";
        intent.container = self.navigationController;
        [[UIApplication sharedApplication]open:intent];
        
    }
}

#pragma   图片浏览
- (void)tapImage:(UITapGestureRecognizer *)tap
{
    UIImageView * imageview = (UIImageView *)tap.view;
    SHIntent * intent  = [[SHIntent alloc]init];
    intent.target = @"SHShowBigImageViewController";
    [intent.args setValue:imageview.image forKey:@"image"];
    intent.container = self.navigationController;
    [[UIApplication sharedApplication]open:intent];

    
    
//    int count = 3;
//    // 1.封装图片数据
//    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
//    for (int i = 0; i<mListImage.count; i++) {
//        // 替换为中等尺寸图片
//        NSString *url = [_urls[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
//        MJPhoto *photo = [[MJPhoto alloc] init];
////        photo.url = [NSURL URLWithString:url]; // 图片路径
//        photo.image  = [mListImage objectAtIndex:i];
////        photo.srcImageView = self.view.subviews[i]; // 来源于哪个UIImageView
//         photo.srcImageView=mScrollview.subviews[i];
//        [photos addObject:photo];
//    }
//    
//    // 2.显示相册
//    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
//    browser.photos = photos; // 设置所有的图片
//    [browser show];
}


#pragma  mark   ===========================
#pragma  mark  二维码扫描

- (void)scannerAction:(id)sender {
    
    num = 0;
    
    AppDelegate* app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if(!iOS7)
    {
        SHIOS7_ScanViewController * rt = [[SHIOS7_ScanViewController alloc]init];
        [app.viewController presentViewController:rt animated:YES completion:^{
            
        }];
    }
    else
    {
        
        upOrdown = NO;
        //初始话ZBar
        __autoreleasing ZBarReaderViewController * reader = [[ZBarReaderViewController alloc]init];
        //设置代理
        reader.readerDelegate = self;
        
        //支持界面旋转
        reader.supportedOrientationsMask = ZBarOrientationMaskAll;
        reader.showsHelpOnFail = NO;
        reader.showsZBarControls=NO;
        reader.showsCameraControls=NO;
        
        reader.scanCrop = CGRectMake(0.1, 0.2, 0.8, 0.8);//扫描的感应框
        ZBarImageScanner * scanner = reader.scanner;
        [scanner setSymbology:ZBAR_I25
                       config:ZBAR_CFG_ENABLE
                           to:0];
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        view.backgroundColor = [UIColor clearColor];
        reader.cameraOverlayView = view;
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
        label.text = @"请将扫描的二维码至于下面的框内\n谢谢！";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = 1;
        label.lineBreakMode = 0;
        label.numberOfLines = 2;
        label.backgroundColor = [UIColor clearColor];
        [view addSubview:label];
        
        UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pick_bg.png"]];
        image.frame = CGRectMake(20, 80, 280, 280);
        [view addSubview:image];
        
        UIButton  *b=[UIButton  buttonWithType:UIButtonTypeCustom];
        [b setFrame:CGRectMake(0, 440, 320, 35)];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [b  setTitle:@"取消" forState:UIControlStateNormal];
        [b  addTarget:self action:@selector(cancelMe) forControlEvents:UIControlEventTouchUpInside];
        [view bringSubviewToFront:b];
        [view addSubview:b];
        
        _line = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 220, 2)];
        _line.image = [UIImage imageNamed:@"line.png"];
        [image addSubview:_line];
        
        //定时器，设定时间过1.5秒，
        timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
        
        [app.viewController presentViewController:reader animated:YES completion:^{
            
        }];
    }
    
}

-(void)cancelMe{
    
    [timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    
    AppDelegate* app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [app.viewController  dismissViewControllerAnimated:YES completion: nil ];
    
}
-(void)animation1
{
    
    
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(30, 10+2*num, 220, 2);
        if (2*num == 260) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(30, 10+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
}

#pragma mark   ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark   zbar 委托 方法

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    
    
    AppDelegate* app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.viewController  dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
    }];
    
    //    [picker dismissViewControllerAnimated:YES completion:^{
    //          [picker removeFromParentViewController];
    //    }];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //初始化
        ZBarReaderController * read = [ZBarReaderController new];
        //设置代理
        read.readerDelegate = self;
        CGImageRef cgImageRef = image.CGImage;
        ZBarSymbol * symbol = nil;
        id <NSFastEnumeration> results = [read scanImage:cgImageRef];
        for (symbol in results)
        {
            break;
        }
        NSString * result;
        if ([symbol.data canBeConvertedToEncoding:NSShiftJISStringEncoding])
            
        {
            result = [NSString stringWithCString:[symbol.data cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        }
        else
        {
            result = symbol.data;
        }
        NSLog(@" 二维码<<<<  %@",result);
        
        NSData * decode =[Utility  AES256DecryptWithKey:[Base64 decode:result] key:@"1234567890123456"];
        NSString * url  = [[NSString alloc]initWithData:decode encoding:NSUTF8StringEncoding];
        NSLog(@"encode ===%@==",url);
        [self requestDateZip:url];
        
    
    }];
}
-(void) requestDateZip:(NSString * )url
{
    SHHttpTask * post  = [[SHHttpTask alloc]init];
    post.URL = url;
    post.delegate = self;
    [post start:^(SHTask *task) {
        NSError * error ;
        NSDictionary * network = nil;
        if([task result] != nil){
            network  = [NSJSONSerialization JSONObjectWithData:[task result] options:(NSJSONReadingOptions)NSJSONWritingPrettyPrinted error:&error];
        }
        if ([[network objectForKey:@"success"]boolValue]) {
            NSArray * list = [network objectForKey:@"package"];
            if (list.count>0) {
              dicPack =  [list objectAtIndex:0];
                for(NSDictionary * dicfile in listPacks){
                    if ([[dicfile objectForKey:@"name"] isEqualToString:[dicPack objectForKey:@"name"]]) {
                        [self showAlertDialog:@"您已经下载过该资源"];
                        return ;
                    }
                    
                }
              [self beginRequest:[dicPack objectForKey:@"dir"]];
            }
        }else{
            [self showAlertDialog:[network objectForKey:@"msg"]];
        }
    } taskWillTry:^(SHTask *task) {
        
    } taskDidFailed:^(SHTask *task) {
        
    }];
}
#pragma  download
-(void)beginRequest:(NSString* )url
{
    ////    如果不存在则创建临时存储目录
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:[SHFileManager getTargetFloderPath]])
    {
        [fileManager createDirectoryAtPath:[SHFileManager getTargetFloderPath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    stringProgress = @"0%";
    NSString * zipPath = [[SHFileManager getTargetFloderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dicPack objectForKey:@"name"]]];
    

    [MMProgressHUD showProgressWithStyle:MMProgressHUDProgressStyleRadial title:@"正在下载.." status:nil];

    
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    request.delegate=self;
    [request setDownloadDestinationPath:[NSString stringWithFormat:@"%@.zip",zipPath]];
    [request setTemporaryFileDownloadPath:[NSString stringWithFormat:@"%@.temp",zipPath]];
    [request setDownloadProgressDelegate:self];
    [request setAllowResumeForFileDownloads:YES];//支持断点续传
    [request setTimeOutSeconds:120];
    [request setNumberOfTimesToRetryOnTimeout:3];
    [request setUserInfo:[NSDictionary dictionaryWithObject:zipPath forKey:@"path"]];//设置上下文的文件基本信息
    [request startAsynchronous];
}
//遍历资源包
-(void) loadCacheList
{
    NSFileManager *filemgr =[NSFileManager defaultManager];
    NSString * filePath = [SHFileManager getTargetFloderPath];
    NSArray* directoryContents = [[NSFileManager defaultManager] directoryContentsAtPath:filePath];
    listPacks = [[NSMutableArray alloc]init];
    for (NSString *url in directoryContents) {
        NSMutableDictionary * dic  =[[NSMutableDictionary alloc]init];
        [dic setValue:[NSString stringWithFormat:@"%@/%@/medias",filePath,url] forKey:@"path"];
        [dic setValue:url forKey:@"name"];
        BOOL isDir;
        if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",filePath,url]  isDirectory:&isDir] && isDir){// 目录
            [listPacks addObject:dic];
        }
        
    }
    if(listPacks.count ==0){
        [self showAlertDialog:@"您还没有下载资源包，快去扫一扫下载吧"];
    }else if (listPacks.count ==1){
        NSDictionary * dic  = [listPacks objectAtIndex:0];
        [SHXmlParser.instance start:[dic objectForKey:@"path"]];
    }else {
        SHIntent * intent  = [[SHIntent alloc]init];
        [intent.args setValue:listPacks forKey:@"list"];
        intent.delegate = self;
        intent.target = @"SHResPackListViewController";
        [[UIApplication sharedApplication]open:intent];
    }
    
}
#pragma ASIHttpRequest回调委托

//出错了，如果是等待超时，则继续下载
-(void)requestFailed:(ASIHTTPRequest *)request
{
    [MMProgressHUD dismissWithError:@"下载失败!"];
    [self dismissWaitDialog];
    [self showAlertDialog:@"下载失败!"];
    

    
}

-(void)requestStarted:(ASIHTTPRequest *)request
{
    NSLog(@"开始了!");
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
   NSString * path = [request.userInfo objectForKey:@"path"];
    [self unZipPack:path];
    
}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {
    
    NSLog(@"didReceiveResponseHeaders-%@",[responseHeaders valueForKey:@"Content-Length"]);
    NSLog(@"收到回复了！");
}
-(void)setProgress:(float)newProgress
{
    [MMProgressHUD updateProgress:newProgress];
}
-(void) unZipPack:(NSString *)path
{
    ZipArchive *za = [[ZipArchive alloc]init];
    if ([za UnzipOpenFile:[NSString stringWithFormat:@"%@.zip",path]]) {
        BOOL ret = [za UnzipFileTo:path overWrite: YES];
        if (ret){
            [za UnzipCloseFile];
            [SHFileManager deleteFileOfPath:[NSString stringWithFormat:@"%@.zip",path]];
            [MMProgressHUD dismissWithSuccess:@"下载成功!"];
        }else{
            
             [MMProgressHUD dismissWithError:@"下载失败!"];
            [self showAlertDialog:@"下载失败!"];
        }
    }else{
        [MMProgressHUD dismissWithError:@"下载失败!"];
        [self showAlertDialog:@"下载失败!"];
    }
     [self dismissWaitDialog];
//    NSString *imageFilePath = [path stringByAppendingPathComponent:@"photo.png"];
//    NSString *textFilePath = [path stringByAppendingPathComponent:@"text.txt"];
//    NSData *imageData = [NSData dataWithContentsOfFile:imageFilePath options:0 error:nil];
//    UIImage *img = [UIImage imageWithData:imageData];
//    NSString *textString = [NSString stringWithContentsOfFile:textFilePath
//                                                     encoding:NSASCIIStringEncoding error:nil];
}

-(void)resPackListViewControllerDidSelect:(SHResPackListViewController *)controller detail:(NSDictionary *)detail
{
    [self requestDataDrawUI];
}

@end
