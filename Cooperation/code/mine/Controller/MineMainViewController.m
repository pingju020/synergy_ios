//
//  MineMainViewController.m
//  Cooperation
//
//  Created by yangjuanping on 2017/1/20.
//  Copyright © 2017年 yangjuanping. All rights reserved.
//

#import "MineMainViewController.h"
#import "PJTabBarItem.h"

@interface MineMainViewController ()

@end

@implementation MineMainViewController

AH_BASESUBVCFORMAINTAB_MODULE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(PJTabBarItem*)getTabBarItem{
    //
    PJTabBarItem* itemMainHome = [[PJTabBarItem alloc]init];
    itemMainHome.strTitle = @"我的";
    itemMainHome.strNormalImg = @"mine@2x.png";
    itemMainHome.strSelectImg = @"mine_press@2x.png";
    itemMainHome.viewController = self;
    itemMainHome.tabIndex = 5;
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
