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

@interface SHMainFuntionViewController ()<TapImageViewDelegate>
{
    NSInteger currentIndex;
    NSArray * arryMore;
   UIView *imgView;
   UIView *markView;
   UIScrollView *imgScrollview;
   NSMutableArray *mListImage;
   NSArray *_urls;
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
    self.title = [[SHXmlParser.instance detail]objectForKey:@"parkname"];
    mbtnSao.layer.cornerRadius = 5.0;
    mbtnSao.layer.masksToBounds = YES;
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"side"] target:self action:@selector(btnLeftOntouch)];

    UIBarButtonItem * button1 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more"] target:self action:@selector(btnMore)];
    UIBarButtonItem * button2 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"map"] target:self action:@selector(btnShowMap)];
    [self.navigationItem setRightBarButtonItems:@[button1,button2]];

    arryMore =  [[SHXmlParser.instance detail]objectForKey:@"more"];
    _urls = @[@"http://img.ycwb.com/news/attachement/jpg/site2/20120511/90fba60187191116b78506.jpg", @"http://img.ycwb.com/news/attachement/jpg/site2/20120511/90fba60187191116b78506.jpg", @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1d0vyj20pf0gytcj.jpg", @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg", @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg", @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg", @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr3xvtlj20gy0obadv.jpg", @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg", @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg"];

    
    mListImage = [[NSMutableArray alloc]init];
    [mScrollview setContentSize:CGSizeMake(UIScreenWidth*_urls.count, UIScreenHeight-49)];
//    mScrollview.delegate=self;
    UIImage *placeholder = [UIImage imageNamed:@"timeline_image_loading.png"];
    for (int i = 0 ; i < 4; i++) {
        
        NSString *imageName = @"";
        imageName = @"guid";
        imageName = [imageName stringByAppendingFormat:@"%d.png", i + 1];
        if (i == 3) {
            imageName = @"media_player_progress_button";
        }
        UIImage * image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc] init];
        [mScrollview addSubview:imageView];
        [mListImage addObject:image];
        // 计算位置
        imageView.frame = CGRectMake(0, 0, image.size.width>UIScreenWidth?UIScreenWidth:image.size.width, image.size.width>UIScreenHeight?UIScreenHeight:image.size.width);
        NSLog(@"%f===%f==%f",UIScreenWidth,self.view.frame.size.width,self.view.center.x);
        CGPoint point = CGPointMake(UIScreenWidth/2+UIScreenWidth*i, self.view.center.y);
        imageView.center = point;
        
        // 下载图片
        imageView.image  = image;
//        [imageView setImageURLStr:_urls[i] placeholder:placeholder];
        
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
    int count = 3;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<mListImage.count; i++) {
        // 替换为中等尺寸图片
        NSString *url = [_urls[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        MJPhoto *photo = [[MJPhoto alloc] init];
//        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.image  = [mListImage objectAtIndex:i];
//        photo.srcImageView = self.view.subviews[i]; // 来源于哪个UIImageView
         photo.srcImageView=mScrollview.subviews[i];
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
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
        NSData *testData = [result dataUsingEncoding: NSUTF8StringEncoding];
        NSMutableDictionary * dic = [NSJSONSerialization JSONObjectWithData:testData options:NSJSONReadingMutableContainers error:nil];
        [self.tableView reloadData];
        
    }];
}




@end
