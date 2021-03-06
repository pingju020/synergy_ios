//
//  NewMainViewController.m
//  Cooperation
//
//  Created by yangjuanping on 2017/1/20.
//  Copyright © 2017年 yangjuanping. All rights reserved.
//

#import "NewMainViewController.h"
#import "PJTabBarItem.h"
#import "UIView+LJAdditions.h"
#import "LJMacros.h"

@interface NewMainViewController ()

@end

@implementation NewMainViewController

AH_BASESUBVCFORMAINTAB_MODULE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self removeBackBtn];
    
    UIImageView* sample = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zixun_sample"]];
    sample.frame = self.view.bounds;
    sample.lj_height = self.view.lj_height-NAVIGATOR_HEIGHT;
    sample.lj_top = NAVIGATOR_HEIGHT+STATUS_BAR_HEIGHT;
    sample.autoresizingMask = UIViewAutoresizingFlexibleAll;
    [self.view addSubview:sample];
    
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
