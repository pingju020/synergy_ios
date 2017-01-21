//
//  SumMainViewController.m
//  Cooperation
//
//  Created by yangjuanping on 2017/1/20.
//  Copyright © 2017年 yangjuanping. All rights reserved.
//

#import "SumMainViewController.h"
#import "PJTabBarItem.h"

@interface SumMainViewController ()

@end

@implementation SumMainViewController

AH_BASESUBVCFORMAINTAB_MODULE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(PJTabBarItem*)getTabBarItem{
    //
    PJTabBarItem* itemMainHome = [[PJTabBarItem alloc]init];
    itemMainHome.strTitle = @"汇总";
    itemMainHome.strNormalImg = @"sum@2x.png";
    itemMainHome.strSelectImg = @"sum_press@2x.png";
    itemMainHome.viewController = self;
    itemMainHome.tabIndex = 2;
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
