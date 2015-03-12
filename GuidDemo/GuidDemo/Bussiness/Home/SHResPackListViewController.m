//
//  SHResPackListViewController.m
//  GuidDemo
//
//  Created by Ye Baohua on 15/3/13.
//  Copyright (c) 2015年 Ye Baohua. All rights reserved.
//

#import "SHResPackListViewController.h"

@interface SHResPackListViewController ()

@end

@implementation SHResPackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mList = [self.intent.args objectForKey:@"list"];
    [self showAlertDialog:@"发现多个资源包，请选择景区"];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  mList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = [mList objectAtIndex:indexPath.row];
    SHTableViewGeneralCell * cell  =[tableView dequeueReusableGeneralCell];
    cell.labTitle.text = [dic objectForKey:@"name"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic  =[mList objectAtIndex:indexPath.row];
    [SHXmlParser.instance start:[dic objectForKey:@"path"]];
    if (DELEGATE_IS_READY(resPackListViewControllerDidSelect:detail:)) {
        [self.delegate resPackListViewControllerDidSelect:self detail:dic];
    }
    [SHIntentManager clear];
}

@end
