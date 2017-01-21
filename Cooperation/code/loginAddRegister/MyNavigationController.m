//
//  MyNavigationController.m
//  synergy
//
//  Created by Tion on 17/1/15.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "MyNavigationController.h"
//#import "NSObject+UIColor_Hex.h"
@interface MyNavigationController ()

@end

@implementation MyNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#393842"]];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    
    
    UIView* status=[[UIView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, 20)];
    status.backgroundColor=[UIColor blackColor];
    [self.navigationBar addSubview:status];
    
//    [self.navigationBar setBackgroundImage:<#(nullable UIImage *)#> forBarMetrics:<#(UIBarMetrics)#>
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
