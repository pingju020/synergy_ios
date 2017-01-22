//
//  KnowledgeMainViewController.m
//  Cooperation
//
//  Created by yangjuanping on 2017/1/20.
//  Copyright © 2017年 yangjuanping. All rights reserved.
//

#import "KnowledgeMainViewController.h"
#import "PJTabBarItem.h"

@interface KnowledgeMainViewController ()

@end

@implementation KnowledgeMainViewController
{
    CGFloat margin;
    
    UIButton* TempButton1;
    UIButton* TempButton2;
    UIButton* TempButton3;
    UIButton* TempButton4;
}
AH_BASESUBVCFORMAINTAB_MODULE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    margin=20;
    
    [self SettingTopBar];
    
    [self SettingWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

-(PJTabBarItem*)getTabBarItem{
    //
    PJTabBarItem* itemMainHome = [[PJTabBarItem alloc]init];
    itemMainHome.strTitle = @"知识库";
    itemMainHome.strNormalImg = @"knowledge@2x.png";
    itemMainHome.strSelectImg = @"knowledge_press@2x.png";
    itemMainHome.viewController = self;
    itemMainHome.tabIndex = 3;
    //title.text = itemMainHome.strTitle;
    [self setTitle:itemMainHome.strTitle];
    return itemMainHome;
}

#pragma mark Tab设定（顶部控制切换webview的url）
-(void)SettingTopBar{
    UIView* BackGround=[[UIView alloc]initWithFrame:CGRectMake(0,STATUS_BAR_HEIGHT+NAVIGATOR_HEIGHT,SCREEN_WIDTH,50)];
    [self.view addSubview:BackGround];
    CGFloat averageWidth=SCREEN_WIDTH/4-margin/2;
    NSArray* arr=[NSArray arrayWithObjects:@"投行周报",@"消息推送",@"市场快报",@"产品说明", nil];
    
    TempButton1=[[UIButton alloc]initWithFrame:CGRectMake(0,margin,averageWidth,48)];
    [TempButton1 setTitle:@"投行周报" forState:UIControlStateNormal];
    [TempButton1 setTag:0];
    [TempButton1 addTarget:self action:@selector(ClickTabView:) forControlEvents:UIControlEventTouchUpInside];
    [BackGround addSubview:TempButton1];
    
    TempButton2=[[UIButton alloc]initWithFrame:CGRectMake(0,margin+averageWidth,averageWidth,48)];
    [TempButton2 setTitle:@"消息推送" forState:UIControlStateNormal];
    [TempButton2 setTag:1];
    [TempButton2 addTarget:self action:@selector(ClickTabView:) forControlEvents:UIControlEventTouchUpInside];
    [BackGround addSubview:TempButton2];
    
    TempButton3=[[UIButton alloc]initWithFrame:CGRectMake(0,margin,averageWidth,48)];
    [TempButton3 setTitle:@"市场快报" forState:UIControlStateNormal];
    [TempButton3 setTag:2];
    [TempButton3 addTarget:self action:@selector(ClickTabView:) forControlEvents:UIControlEventTouchUpInside];
    [BackGround addSubview:TempButton3];
    
    TempButton4=[[UIButton alloc]initWithFrame:CGRectMake(0,margin,averageWidth,48)];
    [TempButton4 setTitle:@"产品说明" forState:UIControlStateNormal];
    [TempButton4 setTag:3];
    [TempButton4 addTarget:self action:@selector(ClickTabView:) forControlEvents:UIControlEventTouchUpInside];
    [BackGround addSubview:TempButton4];
    
    
    
}

-(void)ClickTabView:(UIButton*)btn
{
//    NSLog(@"%d",SelectNumber);
}

#pragma mark webview

-(void)SettingWebView{
    
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
