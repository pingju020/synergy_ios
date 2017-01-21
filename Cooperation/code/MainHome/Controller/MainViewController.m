//
//  MainViewController.m
//  Cooperation
//
//  Created by yangjuanping on 16/10/25.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import "MainViewController.h"
#import "PJTabBarItem.h"
#import "CycleScrollView.h"
#import "MainDataModel.h"
#import "MainHomeItemLoadContext.h"

@interface MainViewController ()
@end



@implementation MainViewController


AH_BASESUBVCFORMAINTAB_MODULE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor yellowColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(PJTabBarItem*)getTabBarItem{
    //
    PJTabBarItem* itemMainHome = [[PJTabBarItem alloc]init];
    itemMainHome.strTitle = @"项目";
    itemMainHome.strNormalImg = @"project@2x.png";
    itemMainHome.strSelectImg = @"project_press@2x.png";
    itemMainHome.viewController = self;
    itemMainHome.tabIndex = 1;
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
