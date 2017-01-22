//
//  NewMainViewController.m
//  Cooperation
//
//  Created by yangjuanping on 2017/1/20.
//  Copyright © 2017年 yangjuanping. All rights reserved.
//

#import "NewMainViewController.h"
#import "PJTabBarItem.h"
#import "MessageViewController.h"

@interface NewMainViewController ()

@end

@implementation NewMainViewController

AH_BASESUBVCFORMAINTAB_MODULE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MessageViewController *msg = [[MessageViewController alloc]init];
    msg.projectId = @"43163f1cb46f4919bfbb06dbb71ca143";

    [self.navigationController pushViewController:msg animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(PJTabBarItem*)getTabBarItem{
    //
    PJTabBarItem* itemMainHome = [[PJTabBarItem alloc]init];
    itemMainHome.strTitle = @"资讯";
    itemMainHome.strNormalImg = @"news@2x.png";
    itemMainHome.strSelectImg = @"news_press@2x.png";
    itemMainHome.viewController = self;
    itemMainHome.tabIndex = 4;
    //title.text = itemMainHome.strTitle;
    [self setTitle:itemMainHome.strTitle];
    return itemMainHome;
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
