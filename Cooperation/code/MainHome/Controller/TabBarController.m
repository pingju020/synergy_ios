//
//  TabBarController.m
//  synergy
//
//  Created by Tion on 17/1/12.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "TabBarController.h"
#import "ProjectWebViewController.h"
#import "SumWebViewController.h"
#import "LibraryWebViewController.h"
#import "NewsWebViewController.h"
#import "MeWebViewController.h"
#import "MyNavigationController.h"
#import "XTNavigationController.h"
@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self CreateViewController];
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
//    self.viewControllers
//    self.tabBar.hidden=YES;
//    UIViewController *c4=[[UIViewController alloc]init];
//        c4.tabBarItem.title=@"设置";
//         c4.tabBarItem.image=[UIImage imageNamed:@"tab_me_nor"];
//    c4.tabBarItem.selectedImage
}

- (void)CreateViewController{
    //创建子控制器
    //1.汇总2.我的3.项目4.知识库5.菜单
    //1.sum_unselected2.me_unselected3.project_unselected4.library_unselected5.menu_unselected
   
    
    ProjectWebViewController *FirstView=[[ProjectWebViewController alloc]init];
    FirstView.tabBarItem.title=@"项目";
    FirstView.tabBarItem.image=[UIImage imageNamed:@"project@2x.png"];
    FirstView.tabBarItem.selectedImage=[UIImage imageNamed:@"project_press@2x.png"];
    MyNavigationController *FirstNavigator = [[MyNavigationController alloc] initWithRootViewController:FirstView];
//    XTNavigationController *FirstNavigator=[[XTNavigationController alloc]initWithRootViewController:FirstView];
    
    SumWebViewController *SecondView=[[SumWebViewController alloc]init];
    SecondView.tabBarItem.title=@"汇总";
    SecondView.tabBarItem.image=[UIImage imageNamed:@"sum@2x.png"];
    SecondView.tabBarItem.selectedImage=[UIImage imageNamed:@"sum_press@2x.png"];
    MyNavigationController *SecondNavigator = [[MyNavigationController alloc] initWithRootViewController:SecondView];
    
    LibraryWebViewController *ThirdView=[[LibraryWebViewController alloc]init];
    ThirdView.tabBarItem.title=@"知识库";
    ThirdView.tabBarItem.image=[UIImage imageNamed:@"knowledge@2x.png"];
    ThirdView.tabBarItem.selectedImage=[UIImage imageNamed:@"knowledge@2x.png"];
    MyNavigationController *ThirdNavigator = [[MyNavigationController alloc] initWithRootViewController:ThirdView];
    
    NewsWebViewController *FourthView=[[NewsWebViewController alloc]init];
    FourthView.tabBarItem.title=@"资讯";
    FourthView.tabBarItem.image=[UIImage imageNamed:@"news@2x.png"];
    FourthView.tabBarItem.selectedImage=[UIImage imageNamed:@"news_press@2x.png"];
    MyNavigationController *FourthNavigator = [[MyNavigationController alloc] initWithRootViewController:FourthView];
    
    MeWebViewController *FifthView=[[MeWebViewController alloc]init];
    FifthView.tabBarItem.title=@"我的";
    FifthView.tabBarItem.image=[UIImage imageNamed:@"mine@2x.png"];
    FifthView.tabBarItem.selectedImage=[UIImage imageNamed:@"mine_press@2x.png"];
    MyNavigationController *FifthNavigator = [[MyNavigationController alloc] initWithRootViewController:FifthView];
//    preferredStatusBarStyle
    
    self.viewControllers=[NSArray arrayWithObjects:FirstNavigator,SecondNavigator,ThirdNavigator,FourthNavigator,FifthNavigator,nil];
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    self.selectedIndex=0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
