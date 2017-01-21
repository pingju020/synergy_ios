//
//  LibraryWebViewController.m
//  synergy
//
//  Created by Tion on 17/1/12.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "LibraryWebViewController.h"
#import "CommonWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface LibraryWebViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@end

@implementation LibraryWebViewController
{
    UIButton* back;
    UIButton* title;
    
    UIView* NoNetView;
    UIImageView* NoNetImage;
    UIButton* ReloadButton;
    UILabel* NoNetLabel;
    UIBarButtonItem *leftItem;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#393842"]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    
    self.navigationController.navigationBar.translucent=NO;
    
    leftItem =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    leftItem.tintColor=[UIColor whiteColor];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = - 0;
    self.navigationItem.leftBarButtonItems = @[spaceItem, leftItem];
    
//    [self CheckNetWorking];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
}



@end
