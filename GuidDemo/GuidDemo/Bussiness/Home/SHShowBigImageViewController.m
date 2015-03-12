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
    imageShow = [[UIImageView alloc]init];
    imageShow.frame = [Utility sizeFitImage:image.size];
    imageShow.image = image;
    CGPoint point = CGPointMake(UIScreenWidth/2, self.view.center.y);
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
