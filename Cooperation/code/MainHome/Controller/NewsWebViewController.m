//
//  MenuWebViewController.m
//  synergy
//
//  Created by Tion on 17/1/12.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "NewsWebViewController.h"
//#import "NSObject+UIColor_Hex.h"
@interface NewsWebViewController ()

@end

@implementation NewsWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
//    UIImageView* NewsImage=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATOR_HEIGHT-TAB_BAR_HEIGHT)];
//    [NewsImage setImage:[UIImage imageNamed:@"news@3x.png"]];
//    [self.view addSubview:NewsImage];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#393842"]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    
    self.navigationController.navigationBar.translucent=NO;
    
    UIBarButtonItem *leftItem =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    leftItem.tintColor=[UIColor whiteColor];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = - 0;
    self.navigationItem.leftBarButtonItems = @[spaceItem, leftItem];
    
    self.title=@"资讯";
    
}

- (void)backAction{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle

{
    
    return UIStatusBarStyleLightContent;
    
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
