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
    UIImage * image = [UIImage imageNamed:@"ditu"];
    imageMap = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width/2, image.size.height/2)];
    imageMap.image = image;
    CGPoint point = CGPointMake(UIScreenWidth/2, UIScreenHeight/2);
    imageMap.center = point;
    [mScrollview addSubview:imageMap];
    UIView * paint = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    paint.layer.cornerRadius = 5;
    paint.center = CGPointMake(250.5, 40);
    paint.alpha = 0.3;
    paint.backgroundColor = [UIColor redColor];
    [imageMap addSubview:paint];
   
    
    [mScrollview setMinimumZoomScale:1];
    
    [mScrollview setMaximumZoomScale:4];

    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [mScrollview addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [mScrollview addGestureRecognizer:twoFingerTapRecognizer];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
