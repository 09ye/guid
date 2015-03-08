//
//  SHGuideViewController.h
//  crowdfunding-arcturus
//
//  Created by lqh77 on 14-5-8.
//  Copyright (c) 2014年 WSheely. All rights reserved.
//

//#import "SHViewController.h"

@class SHGuideViewController;

@protocol SHGuideViewControllerDelegate <NSObject>
#pragma mark - 关闭窗口
- (void)guideViewController:(SHGuideViewController*)aguidVC viewClosed:(int)viewClosed;
@end

@interface SHGuideViewController : UIViewController<UIScrollViewDelegate>{

    
    int               _page;                //第几页
    int               _loaded;              //0 首页加载  1 从设置加载
    float             _xScrollViewOffSet;   // x偏移量
    IBOutlet          UIPageControl *_pageController;
}
@property (weak, nonatomic) id<SHGuideViewControllerDelegate>               delegate;
@property (strong, nonatomic) IBOutlet UIScrollView                         *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView                          *imageViewGB;
 
- (IBAction)closeWindow:(id)sender;


@end

