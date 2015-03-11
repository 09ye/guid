//
//  SHLeftViewController.m
//  GuidDemo
//
//  Created by Ye Baohua on 15/3/8.
//  Copyright (c) 2015年 Ye Baohua. All rights reserved.
//

#import "SHLeftViewController.h"


@interface SHLeftViewController ()
{
    
}

@end

@implementation SHLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mSegment.tintColor =[SHSkin.instance colorOfStyle:@"ColorBase"];
    mList = [SHXmlParser.instance listAttractions];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHTableViewGeneralCell * cell = [tableView dequeueReusableGeneralCell];
    NSDictionary * dic  =[mList objectAtIndex:indexPath.row];
    cell.labTitle.text = [dic objectForKey:@"name"];
    cell.labTitle.userstyle = @"labmiddark";
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary * dic  =[mList objectAtIndex:indexPath.row];
    SHIntent * intent =[[SHIntent alloc]init];
    if (mSegment.selectedSegmentIndex ==  0) {
        intent.target = @"SHGuidIntroduceViewController";
    }else{
        intent.target = @"SHShowVideoViewController";
    }
    [intent.args setValue:[dic objectForKey:@"name"] forKey:@"title"];
    intent.container = self.navigationController;
    [[UIApplication sharedApplication]open:intent];
    
    
}

- (IBAction)segmentValueChangeOntouch:(UISegmentedControl *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        if (sender.selectedSegmentIndex == 0) {
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.tableView cache:YES];
            mList = [SHXmlParser.instance listAttractions];
        }else{
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.tableView cache:YES];
            mList = [SHXmlParser.instance listVideos];
            
        }
        [self.tableView reloadData];
    } completion:^(BOOL finished) {
        
    }];
}



@end
