//
//  SHGuideViewController.m
//  crowdfunding-arcturus
//
//  Created by lqh77 on 14-5-8.
//  Copyright (c) 2014年 WSheely. All rights reserved.
//

#import "SHGuideViewController.h"
#import "config.h"

@interface SHGuideViewController ()

@end

@implementation SHGuideViewController

@synthesize  scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    if (!IPHONE4) {
         [self.scrollView setContentSize:CGSizeMake(320*3, 568)];
    }else {
         [self.scrollView setContentSize:CGSizeMake(320*3, 480)];
    }
    self.scrollView.delegate=self;
    for (int i = 0 ; i < 3; i++) {
		
		NSString *imageName = @"";
		
		if (!IPHONE5) {
			imageName = @"guide4";
		}else {
			imageName = @"guide0";
		}
        
        imageName = [imageName stringByAppendingFormat:@"%d.png", i + 1];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        
        NSLog(@"%@",imageName);
        
		if (!IPHONE4) {
			imageView.frame = CGRectMake(i * 320, 0, 320, 568);
		}else {
			imageView.frame = CGRectMake(i * 320, 0, 320, 480);
		}
        [self.scrollView addSubview:imageView];
    }
    
    NSLog(@"%@",self.scrollView);
    
    _pageController.numberOfPages=3;
    _pageController.currentPage=0;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma  mark  动画

#pragma mark - uiscrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = self.scrollView.contentOffset;
    _xScrollViewOffSet = point.x;
    
    NSLog(@"%@",[NSValue valueWithCGPoint:point]);
	
	CGFloat pageWidth = self.scrollView.frame.size.width;
    _page = floor((self.scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    
    if (_xScrollViewOffSet > 700)
    {
        [self closeWindow:nil];
    }
}


//- (void) scrollViewDidScroll:(UIScrollView *)sender {
//	CGFloat pageWidth = sender.frame.size.width;
//	_currentPage = floor((sender.contentOffset.x - pageWidth/2)/pageWidth)+1;
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	 [_pageController setCurrentPage:_page];
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGPoint point = self.scrollView.contentOffset;
    NSLog(@"22 point.x=%f",point.x);
}


-(void)closeWindow:(id)sender{
    
    if ([_delegate  respondsToSelector:@selector(guideViewController:viewClosed:)]) {
        
        
        [_delegate  guideViewController:self viewClosed:1];
    }

}


@end
