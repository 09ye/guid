//
//  WebViewController.m
//  offer_neptune
//
//  Created by yebaohua on 14-6-10.
//  Copyright (c) 2014年 sheely.paean.coretest. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

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
    self.title = [self.intent.args valueForKey:@"title"];    
    [mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[self.intent.args valueForKey:@"url"]]]];
    mWebView.delegate = self;
    [mWebView setScalesPageToFit:YES];
}
- (void) webViewDidStartLoad:(UIWebView *)webView
{

}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
