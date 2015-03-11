//
//  WebViewController.h
//  offer_neptune
//
//  Created by yebaohua on 14-6-10.
//  Copyright (c) 2014年 sheely.paean.coretest. All rights reserved.
//

#import "SHViewController.h"

@interface WebViewController : SHViewController<UIWebViewDelegate>
{
    
    __weak IBOutlet UIWebView *mWebView;
}

@end
