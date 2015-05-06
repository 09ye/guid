//
//  SHMapViewController.m
//  GuidDemo
//
//  Created by Ye Baohua on 15/3/10.
//  Copyright (c) 2015年 Ye Baohua. All rights reserved.
//

#import "SHMapViewController.h"

@interface SHMapViewController ()
{
    UIImageView * imageMap ;
    AppDelegate * app;
    UIView * paintRed;
    NSArray * listHotPoints;
    float  scalePaint;
}

@end

@implementation SHMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notification:) name:NOTIFICATION_LOCATION_CHANGE object:nil];
    self.title = [[SHXmlParser.instance detail]objectForKey:@"parkname"];
    app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSData *imageData = [NSData dataWithContentsOfFile:[[SHXmlParser.instance detail] objectForKey:@"ditupic"]];
    UIImage *image = [UIImage imageWithData:imageData];
    imageMap = [[UIImageView alloc]init];
    imageMap.image = image;
    // 计算位置
    imageMap.bounds = [Utility sizeFitImage:image.size];
    CGPoint point = CGPointMake(UIScreenWidth/2, (UIScreenHeight-110)/2);
    imageMap.center = point;
    float width1 = imageMap.frame.size.width;
    float width2 = image.size.width;
    scalePaint = (float)width1/width2;
    [mScrollview addSubview:imageMap];
    [mScrollview setMinimumZoomScale:1];
    [mScrollview setMaximumZoomScale:4];
    
    [self drawPointRed];
    listHotPoints = [SHXmlParser.instance listHotPoints];
    
    NSDictionary * dic  = [app distanceFromCurrentLocationPoint];
    if (dic && ![[dic objectForKey:@"potx"] isEqualToString:@""]) {
        paintRed.center = CGPointMake(imageMap.frame.origin.x+[[dic objectForKey:@"potx"]integerValue]*scalePaint, imageMap.frame.origin.y*2+[[dic objectForKey:@"poty"]integerValue]*scalePaint);
    }
    
}
-(void)drawPointRed
{
    paintRed = [[UIView alloc]initWithFrame:CGRectMake(375, 432+62*2, 10, 10)];
    paintRed.layer.cornerRadius = 5;
    paintRed.center = CGPointMake(imageMap.frame.origin.x,imageMap.frame.origin.y*2);
    paintRed.alpha = 0.3;
    paintRed.backgroundColor = [UIColor redColor];
    [imageMap addSubview:paintRed];
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotationAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
    rotationAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.5, 2.5, 1.0)];
    
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.duration = 1;
    rotationAnimation.autoreverses = YES;
    rotationAnimation.repeatCount = FLT_MAX;//你可以设置到最大的整数值
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [paintRed.layer addAnimation:rotationAnimation forKey:@"scaling"];
}
-(void)notification:(NSNotification*)noti
{
    NSDictionary * dic  = [app distanceFromCurrentLocationPoint];
    if (dic) {
        paintRed.center = CGPointMake([[dic objectForKey:@"potx"]integerValue]*scalePaint, [[dic objectForKey:@"poty"]integerValue]*scalePaint);
    }
}
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
    if (mScrollview.zoomScale ==mScrollview.maximumZoomScale) {
        [mScrollview setZoomScale:1 animated:YES];
        return;
    }
    CGFloat newZoomScale = mScrollview.zoomScale * 2.0f;
    newZoomScale = MIN(newZoomScale, mScrollview.maximumZoomScale);
    [mScrollview setZoomScale:newZoomScale animated:YES];
}
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer {
    // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
   
    [mScrollview setZoomScale:1 animated:YES];
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageMap;
}
-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    imageMap.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                            
                            scrollView.contentSize.height * 0.5 + offsetY);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
