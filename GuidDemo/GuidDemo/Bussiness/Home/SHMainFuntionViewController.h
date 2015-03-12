//
//  SHMainFuntionViewController.h
//  GuidDemo
//
//  Created by Ye Baohua on 15/3/8.
//  Copyright (c) 2015年 Ye Baohua. All rights reserved.
//

#import "SHTableViewController.h"
#import "ZBarSDK.h"
#import "SHIOS7_ScanViewController.h"
#import "QRCodeGenerator.h"
#import "ASIHTTPRequest.h"
#import "SHResPackListViewController.h"


@interface SHMainFuntionViewController : SHTableViewController<ZBarReaderDelegate,UIActionSheetDelegate,ASIHTTPRequestDelegate,SHResPackListViewControllerDeleaget>
{
    __weak IBOutlet UIScrollView *mScrollview;
    __weak IBOutlet UIButton *mbtnSao;
    NSDictionary * dicPack;
    NSMutableArray * listPacks;
    NSString * stringProgress;

   
    int num;
    BOOL upOrdown;
    NSTimer * timer;
}
- (IBAction)btnSaoOntouch:(id)sender;
@property (nonatomic, strong) UIImageView    * line;
@end
