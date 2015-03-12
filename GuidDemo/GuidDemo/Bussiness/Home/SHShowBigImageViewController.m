//
//  SHShowBigImageViewController.m
//  GuidDemo
//
//  Created by Ye Baohua on 15/3/11.
//  Copyright (c) 2015年 Ye Baohua. All rights reserved.
//

#import "SHShowBigImageViewController.h"

@interface SHShowBigImageViewController ()
{
    UIImageView * imageShow;
}

@end

@implementation SHShowBigImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.title = [[SHXmlParser.instance detail]objectForKey:@"parkname"];
    UIImage *image = [self.intent.args objectForKey:@"image"];
//    CGRect  rect = imageShow.frame;
//    rect.origin.x = 0 ;
//    rect.origin.y = 0;
//    imageShow.frame = rect;
    imageShow = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width>UIScreenWidth?UIScreenWidth/2:image.size.width/2, image.size.width>UIScreenHeight?UIScreenHeight/2:image.size.width/2)];
    imageShow.image = image;
    CGPoint point = CGPointMake(UIScreenWidth/2, UIScreenHeight/2);
    imageShow.center = point;
    [mScrollview addSubview:imageShow];
  
    
    
    
    [mScrollview setMinimumZoomScale:1];
    
    [mScrollview setMaximumZoomScale:4];
    
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageShow;
}
-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    imageShow.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                  
                                  scrollView.contentSize.height * 0.5 + offsetY);
}

@end
