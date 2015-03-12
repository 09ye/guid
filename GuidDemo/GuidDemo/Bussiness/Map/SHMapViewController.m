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
}

@end

@implementation SHMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    self.title = [[SHXmlParser.instance detail]objectForKey:@"parkname"];
    NSData *imageData = [NSData dataWithContentsOfFile:[[SHXmlParser.instance detail] objectForKey:@"ditupic"]];
    UIImage *image = [UIImage imageWithData:imageData];
    imageMap = [[UIImageView alloc]init];
    imageMap.image = image;
    // 计算位置
    imageMap.frame = [Utility sizeFitImage:image.size];
    CGPoint point = CGPointMake(UIScreenWidth/2, self.view.center.y);
    imageMap.center = point;
    [mScrollview addSubview:imageMap];
    [mScrollview setMinimumZoomScale:1];
    [mScrollview setMaximumZoomScale:4];
    
    UIView * paint = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    paint.layer.cornerRadius = 5;
    paint.center = CGPointMake(250.5, 40);
    paint.alpha = 0.3;
    paint.backgroundColor = [UIColor redColor];
    [imageMap addSubview:paint];
   
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotationAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
    rotationAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.5, 2.5, 1.0)];
    
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.duration = 1;
    rotationAnimation.autoreverses = YES;
    rotationAnimation.RepeatCount = 100000;//你可以设置到最大的整数值
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [paint.layer addAnimation:rotationAnimation forKey:@"scaling"];

    
//    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
//    doubleTapRecognizer.numberOfTapsRequired = 2;
//    doubleTapRecognizer.numberOfTouchesRequired = 1;
//    [mScrollview addGestureRecognizer:doubleTapRecognizer];
//    
//    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
//    twoFingerTapRecognizer.numberOfTapsRequired = 1;
//    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
//    [mScrollview addGestureRecognizer:twoFingerTapRecognizer];
    // Do any additional setup after loading the view from its nib.
    
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
