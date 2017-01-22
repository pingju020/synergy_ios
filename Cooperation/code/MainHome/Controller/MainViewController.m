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
#import "MeWebViewController.h"
#import "CommonWebViewController.h"
#import "AFNetworking.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "ProjectMessageModel.h"
#import "ProjectMessageCell.h"
#import "ProjectConditionCell.h"
#import "ProjectSearchConditionModel.h"
#import "BankCollectionCell.h"
#import "HttpSessionManager.h"
#import "BaseMainViewController.h"

#import "ProjectSearchViewController.h"
#import "ProjectNewViewController.h"

#import "MemberViewController.h"
#import "FileManagerViewController.h"
@interface MainViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@end



@implementation MainViewController
{
    UIButton* back;
    UIButton* title;
    
    UIView* NoNetView;
    UIImageView* NoNetImage;
    UIButton* ReloadButton;
    UILabel* NoNetLabel;
    UIBarButtonItem *leftItem;
    UIBarButtonItem *rightItem;
    
    //搜索数据的条件
    NSString* StatusCondition;
    NSString* ProgressCondition;
    NSString* BankCondition;
    NSString* BranchBankCondition;
    //4个条件的显示区域
    UIButton* StatusButton;
    UIButton* ProgressButton;
    UIButton* BankButton;
    UIButton* BranchBankButton;
    
    //数据源
    NSMutableArray* Datasource;
    //表
    UITableView* MainTableView;
    
    //数据源--表
    NSMutableArray* StatusDataSource;
    UITableView* StatusList;
    
    NSMutableArray* ProgressDataSource;
    UITableView* ProgressList;
    
    NSMutableArray* BankDataSource;
    UICollectionView* BankCollection;
    
    NSMutableArray* BranchDataSource;
    UICollectionView* BranchBankCollection;
    
    //新增项目
    UIButton* AddButton;

}


AH_BASESUBVCFORMAINTAB_MODULE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.view setBackgroundColor:[UIColor yellowColor]];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F8F8F8"]];
    
    [self SetNavigator];
    
    [self SetTopTabbar];
    
    [self SetBaseDetailsTable];
    
    //获取可选项
    [self ResetSearchCondition];
    
    [self StatusList];
    
    [self GetSelectConditions];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    
    
    
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




#pragma mark 导航栏
- (void)SetNavigator{
    [self removeBackBtn];
    [m_rightBtn setHidden:YES];
    
    UIButton* SearchButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [SearchButton setFrame:CGRectMake(0, DISTANCE_TOP, 56-5, 46-5)];
    [SearchButton setImageEdgeInsets:UIEdgeInsetsMake(10, 20, 10, 10)];
    [SearchButton setBackgroundColor:[UIColor clearColor]];
    [SearchButton setImage:[UIImage imageNamed:@"searchButton.png"] forState:UIControlStateNormal];
    [SearchButton addTarget:self action:@selector(BeginSearch) forControlEvents:UIControlEventTouchUpInside];
    [navigationBG addSubview:SearchButton];
    
    AddButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [AddButton setFrame:CGRectMake(SCREEN_WIDTH-51, DISTANCE_TOP, 56-5, 46-5)];
    [AddButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 20)];
    [AddButton setBackgroundColor:[UIColor clearColor]];
    [AddButton setImage:[UIImage imageNamed:@"addnewButton"] forState:UIControlStateNormal];
    [AddButton addTarget:self action:@selector(AddNewProject) forControlEvents:UIControlEventTouchUpInside];
    [navigationBG addSubview:AddButton];
    
    
    //navigation操作
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#393842"]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    self.navigationController.navigationBar.translucent=NO;
    //左侧button
    leftItem =[[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    leftItem.tintColor=[UIColor whiteColor];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = - 0;
    self.navigationItem.leftBarButtonItems = @[spaceItem, leftItem];
    
    rightItem =[[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    rightItem.tintColor=[UIColor whiteColor];
    //    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = - 0;
    self.navigationItem.rightBarButtonItems = @[spaceItem, rightItem];
    
    self.title=@"项目";
    
}

- (void)backAction{
    //do nothing
}

#pragma mark 表头
- (void)SetTopTabbar{
    UIView* TopTabbar=[[UIView alloc]initWithFrame:CGRectMake(0,STATUS_BAR_HEIGHT+NAVIGATOR_HEIGHT,SCREEN_WIDTH,41)];
    [TopTabbar setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat ArrowWidth=20;
    CGFloat BlankWidth=10;
    CGFloat ButtonWidth=SCREEN_WIDTH/4-20-BlankWidth;
    CGFloat BarHeight=40;
    
    //设定右侧的向下箭头为20宽度
    StatusButton=[[UIButton alloc]initWithFrame:CGRectMake(0,0,ButtonWidth,BarHeight)];
    UIView* Arrow1=[[UIView alloc]initWithFrame:CGRectMake(ButtonWidth, 0, ArrowWidth, BarHeight)];
    UIImageView* Image1=[[UIImageView alloc]initWithFrame:CGRectMake(0,15, 16, 10)];
    [Image1 setImage:[UIImage imageNamed:@"downArrow.png"]];
    [Arrow1 addSubview:Image1];
    [StatusButton setBackgroundColor:[UIColor whiteColor]];
    [StatusButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    StatusButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [StatusButton addTarget:self action:@selector(ShowOrRemoveStatusList) forControlEvents:UIControlEventTouchUpInside];
    [TopTabbar addSubview:StatusButton];
    [TopTabbar addSubview:Arrow1];
    
    ProgressButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4,0,ButtonWidth,BarHeight)];
    UIImageView* Arrow2=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4+ButtonWidth, 0, ArrowWidth, BarHeight)];
    UIImageView* Image2=[[UIImageView alloc]initWithFrame:CGRectMake(0,15, 16, 10)];
    [Image2 setImage:[UIImage imageNamed:@"downArrow.png"]];
    [Arrow2 addSubview:Image2];
    [ProgressButton setBackgroundColor:[UIColor whiteColor]];
    [ProgressButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    ProgressButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [ProgressButton addTarget:self action:@selector(ShowOrRemoveProgressList) forControlEvents:UIControlEventTouchUpInside];
    [TopTabbar addSubview:ProgressButton];
    [TopTabbar addSubview:Arrow2];
    
    BankButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2,0,ButtonWidth,BarHeight)];
    UIImageView* Arrow3=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+ButtonWidth, 0, ArrowWidth, BarHeight)];
    UIImageView* Image3=[[UIImageView alloc]initWithFrame:CGRectMake(0,15, 16, 10)];
    [Image3 setImage:[UIImage imageNamed:@"downArrow.png"]];
    [Arrow3 addSubview:Image3];
    [BankButton setBackgroundColor:[UIColor whiteColor]];
    [BankButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    BankButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [BankButton addTarget:self action:@selector(ShowOrRemoveBankCollection) forControlEvents:UIControlEventTouchUpInside];
    [TopTabbar addSubview:BankButton];
    [TopTabbar addSubview:Arrow3];
    
    BranchBankButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*3/4,0,ButtonWidth,BarHeight)];
    UIImageView* Arrow4=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*3/4+ButtonWidth, 0, ArrowWidth, BarHeight)];
    UIImageView* Image4=[[UIImageView alloc]initWithFrame:CGRectMake(0,15, 16, 10)];
    [Image4 setImage:[UIImage imageNamed:@"downArrow.png"]];
    [Arrow4 addSubview:Image4];
    [BranchBankButton setBackgroundColor:[UIColor whiteColor]];
    [BranchBankButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    BranchBankButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [BranchBankButton addTarget:self action:@selector(ShowOrRemoveBranchBankCollection) forControlEvents:UIControlEventTouchUpInside];
    [TopTabbar addSubview:BranchBankButton];
    [TopTabbar addSubview:Arrow4];
    
    UIView* Line=[[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
    [Line setBackgroundColor:[UIColor colorWithHexString:@"#DEDEDE"]];
    [TopTabbar addSubview:Line];
    
    [self.view addSubview:TopTabbar];
}

#pragma mark 获取数据
//获取上方银行树系
- (void)GetSelectConditions{
    NSMutableDictionary* dic=[NSMutableDictionary new];
    NSUserDefaults *UserDefaults = [NSUserDefaults standardUserDefaults];
    [dic setObject:[UserDefaults objectForKey:@"user"] forKey:@"loginName"];
    [dic setObject:[UserDefaults objectForKey:@"password"] forKey:@"passWord"];
    [HTTP_MANAGER startNormalPostWithParagram:dic Commandtype:@"app/check" successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
        if (isSucceed) {
            //设定status条件
            StatusCondition=@"1";
            //支行分行项---判定是否为空
            if([[succeedResult objectForKey:@"office"]isKindOfClass:[NSNull class]]){
                [BankButton setTitle:@"分行" forState:UIControlStateNormal];
                BankCondition=@"all";
                [BranchBankButton setTitle:@"支行" forState:UIControlStateNormal];
                BranchBankCondition=@"all";
            }
            else{
                //设定分行
                NSArray* arr=[succeedResult objectForKey:@"office"];
                BankDataSource=[[NSMutableArray alloc]init];
                
                ProjectSearchConditionModel* TempModel=[[ProjectSearchConditionModel alloc]init];
                TempModel.MessageInfo=@"全部分行";
                TempModel.Mark=YES;
                TempModel.passParam=@"all";
                [BankDataSource addObject:TempModel];
                
                for(int i=0;i<arr.count;i++){
                    NSDictionary* TempDic=[arr objectAtIndex:i];
                    ProjectSearchConditionModel* TempModel=[[ProjectSearchConditionModel alloc]init];
                    TempModel.MessageInfo=[TempDic objectForKey:@"name"];
                    TempModel.bankId=[TempDic objectForKey:@"id"];
                    TempModel.branchBankArray=[TempDic objectForKey:@"orgViews"];
                    TempModel.passParam=[TempDic objectForKey:@"id"];
                    [BankDataSource addObject:TempModel];
                }
                [self BankList];
                
                //设定分行--未选定时为全部
                [BankButton setTitle:@"分行" forState:UIControlStateNormal];
                BankCondition=@"all";
                //设定支行--未选定分行时无法进行选择
                BranchDataSource=[[NSMutableArray alloc]init];
                [self BranchBankList];
                
                [BranchBankButton setTitle:@"支行" forState:UIControlStateNormal];
                BranchBankCondition=@"all";
            }
            
            //progress项---判定是否为空
            if([[succeedResult objectForKey:@"stageList"] isKindOfClass:[NSNull class]]){
                [ProgressButton setTitle:@"全部阶段" forState:UIControlStateNormal];
                ProgressCondition=@"0";
            }
            else{
                NSArray* arr=[succeedResult objectForKey:@"stageList"];
                ProgressDataSource=[[NSMutableArray alloc]init];
                
                ProjectSearchConditionModel* TempModel=[[ProjectSearchConditionModel alloc]init];
                TempModel.MessageInfo=@"全部阶段";
                TempModel.stageOrder=@"0";
                TempModel.Mark=YES;
                TempModel.passParam=@"0";
                [ProgressDataSource addObject:TempModel];
                for(int i=0;i<arr.count;i++){
                    NSDictionary* TempDic=[arr objectAtIndex:i];
                    ProjectSearchConditionModel* TempModel=[[ProjectSearchConditionModel alloc]init];
                    
                    NSString* name=[TempDic objectForKey:@"name"];
                    TempModel.MessageInfo=name;
                    TempModel.stageOrder=[TempDic objectForKey:@"stageOrder"];
                    TempModel.passParam=[TempDic objectForKey:@"stageOrder"];
                    TempModel.Mark=NO;
                    [ProgressDataSource addObject:TempModel];
                }
                [self ProgressList];
                //设定初始条件
                [ProgressButton setTitle:@"全部阶段" forState:UIControlStateNormal];
                ProgressCondition=@"0";
            }
            
            
            //判断是否可以新增项目
            if([succeedResult objectForKey:@"isAuditButton"]==0)
            {
                //可以新增
                AddButton.hidden=NO;
            }else{
                AddButton.hidden=NO;
            }
            
            [self GetDateWithCondition];
            
        }
        else{
            [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:2];
        }
    } failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
        [PubllicMaskViewHelper showTipViewWith:@"请求失败，请检查网络设置后重试" inSuperView:self.view withDuration:2];
        NSLog(@"second login");
    }];
}

//重置搜索条件
- (void)ResetSearchCondition{
    //初始设定为
    //    StatusCondition=@"正在进行";
    //    ProgressCondition=@"全部阶段";
    //    BankCondition=@"分行";
    //    BranchBankCondition=@"支行";
    
    [StatusButton setTitle:@"正在进行" forState:UIControlStateNormal];
    [ProgressButton setTitle:@"全部阶段" forState:UIControlStateNormal];
    [BankButton setTitle:@"分行" forState:UIControlStateNormal];
    [BranchBankButton setTitle:@"支行" forState:UIControlStateNormal];
    
    //    [self GetDateWithCondition];
}

//锁定条件，获取数据
- (void)GetDateWithCondition{
    NSMutableDictionary* dic=[NSMutableDictionary new];
    //phone page pagesize  state
    //1：进行中，2：已完成，3：已关闭，4：待审核，5：待确认）
    NSUserDefaults *UserDefaults = [NSUserDefaults standardUserDefaults];
    NSString* TempString=[UserDefaults objectForKey:@"user"];
    
    [dic setObject:TempString forKey:@"phone"];
    [dic setObject:@"0" forKey:@"page"];
    [dic setObject:@"1000" forKey:@"pageSize"];
    
    
    [dic setObject:StatusCondition forKey:@"state"];
    [dic setObject:ProgressCondition forKey:@"stage"];
    [dic setObject:BankCondition forKey:@"branch"];
    [dic setObject:BranchBankCondition forKey:@"subbranch"];
    
    
    [HTTP_MANAGER startNormalPostWithParagram:dic Commandtype:@"app/project/getProjectData" successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
        if (isSucceed) {
            Datasource=[[NSMutableArray alloc]init];
            NSLog(@"succeed=%@",succeedResult);
            NSArray* ResultArray=[succeedResult objectForKey:@"data"];
            for(int i=0;i<ResultArray.count;i++){
                NSMutableDictionary* Tempdic=[ResultArray objectAtIndex:i];
                ProjectMessageModel* TempModel=[[ProjectMessageModel alloc]initWithDic:Tempdic];
                [Datasource addObject:TempModel];
            }
            [MainTableView reloadData];
        }
        else{
            [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:2];
        }
    } failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
        [PubllicMaskViewHelper showTipViewWith:@"请求失败，请检查网络设置后重试" inSuperView:self.view withDuration:2];
    }];
    
}

//变更数据，变更页面
- (void)ChangeDetailsTable{
    
}

#pragma mark 基本列表制作
- (void)SetBaseDetailsTable{
    MainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,40+10+STATUS_BAR_HEIGHT+NAVIGATOR_HEIGHT,SCREEN_WIDTH , SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATOR_HEIGHT-40-TAB_BAR_HEIGHT)
                   ];
    //    MainTableView.backgroundColor=[UIColor blackColor];
    MainTableView.separatorStyle = UITableViewCellEditingStyleNone;
    
    Datasource=[[NSMutableArray alloc]init];
    
    MainTableView.delegate=self;
    MainTableView.dataSource=self;
    
    [self.view addSubview:MainTableView];
    
    UIView* TempLine=[[UIView alloc]initWithFrame:CGRectMake(0,40+STATUS_BAR_HEIGHT+NAVIGATOR_HEIGHT,SCREEN_WIDTH,10)];
    [TempLine setBackgroundColor:[UIColor colorWithHexString:@"#D9D9D9"]];
    [self.view addSubview:TempLine];
    //D9D9D9
    
}

#pragma mark 弹出list制作
- (void)StatusList{
    //待审批，已完成，已关闭，正在进行
    StatusList=[[UITableView alloc]initWithFrame:CGRectMake(0,40+STATUS_BAR_HEIGHT+NAVIGATOR_HEIGHT,SCREEN_WIDTH, 160)];
    StatusList.delegate=self;
    StatusList.dataSource=self;
    
    NSMutableArray* TempArray=[[NSMutableArray alloc]initWithObjects:@"正在进行",@"已完成",@"已关闭",@"待审批", nil];
    StatusDataSource=[[NSMutableArray alloc]init];
    for(int i=0;i<TempArray.count;i++){
        if(i==0){
            ProjectSearchConditionModel* TempModel=[[ProjectSearchConditionModel alloc]init];
            TempModel.MessageInfo=[TempArray objectAtIndex:i];
            TempModel.passParam=@"1";
            TempModel.Mark=YES;
            [StatusDataSource addObject:TempModel];
        }
        else{
            ProjectSearchConditionModel* TempModel=[[ProjectSearchConditionModel alloc]init];
            TempModel.MessageInfo=[TempArray objectAtIndex:i];
            TempModel.passParam=[NSString stringWithFormat:@"%d",i+1];
            TempModel.Mark=NO;
            [StatusDataSource addObject:TempModel];
        }
    }
    StatusList.separatorStyle = UITableViewCellEditingStyleNone;
    StatusList.scrollEnabled=NO;
    StatusList.hidden=YES;
    [self.view addSubview:StatusList];
}

- (void)ProgressList{
    //全部阶段，营销中，材料收集，分行审批，总行审批，审批通过，合同签订，已放款
    ProgressList=[[UITableView alloc]initWithFrame:CGRectMake(0,40+STATUS_BAR_HEIGHT+NAVIGATOR_HEIGHT,SCREEN_WIDTH,320)];
    ProgressList.delegate=self;
    ProgressList.dataSource=self;
    //    NSMutableArray* TempArray=[[NSMutableArray alloc]initWithObjects:@"全部阶段",@"营销中",@"材料收集",@"分行审批",@"总行审批",@"审批通过",@"合同签订",@"已放款",nil];
    //    ProgressDataSource=[[NSMutableArray alloc]init];
    //    for(int i=0;i<TempArray.count;i++){
    //        if(i==0){
    //            ProjectSearchConditionModel* TempModel=[[ProjectSearchConditionModel alloc]init];
    //            TempModel.MessageInfo=[TempArray objectAtIndex:i];
    //            TempModel.Mark=YES;
    //            [ProgressDataSource addObject:TempModel];
    //        }
    //        else{
    //            ProjectSearchConditionModel* TempModel=[[ProjectSearchConditionModel alloc]init];
    //            TempModel.MessageInfo=[TempArray objectAtIndex:i];
    //            TempModel.Mark=NO;
    //            [ProgressDataSource addObject:TempModel];
    //        }
    //    }
    ProgressList.separatorStyle = UITableViewCellEditingStyleNone;
    ProgressList.scrollEnabled=NO;
    [self.view addSubview:ProgressList];
    ProgressList.hidden=YES;
}

- (void)BankList{
    //分行名称---接口返回
    //    BankDataSource=[[NSMutableArray alloc]init];
    //    ProjectMessageModel* TempModel=[[ProjectMessageModel alloc]init];
    //    TempModel.MessageInfo=@"南京分行";
    //    TempModel.Mark=YES;
    //    [BankDataSource addObject:TempModel];
    //
    //    for(int i=1;i<8;i++){
    //        ProjectMessageModel* TempModel=[[ProjectMessageModel alloc]init];
    //        TempModel.MessageInfo=@"南京分行";
    //        TempModel.Mark=NO;
    //        [BankDataSource addObject:TempModel];
    //    }
    
    
    CGSize itemSize = CGSizeMake(SCREEN_WIDTH/2, 40);
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = itemSize;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing=0;
    
    
    long TempFrameNumber;
    if(BankDataSource.count%2==0){
        TempFrameNumber=BankDataSource.count/2;
    }
    else{
        TempFrameNumber=BankDataSource.count/2+1;
    }
    BankCollection=[[UICollectionView alloc]initWithFrame:CGRectMake(0,40+STATUS_BAR_HEIGHT+NAVIGATOR_HEIGHT,SCREEN_WIDTH,40*TempFrameNumber) collectionViewLayout:layout];
    BankCollection.backgroundColor=[UIColor whiteColor];
    BankCollection.dataSource=self;
    BankCollection.delegate=self;
    
    NSString* cellID=@"BankCollectionID";
    [BankCollection registerClass:[BankCollectionCell class] forCellWithReuseIdentifier:cellID];
    
    [self.view addSubview:BankCollection];
    BankCollection.hidden=YES;
}

- (void)BranchBankList{
    //支行名称---接口返回
    //分行名称---接口返回
    //    BranchDataSource=[[NSMutableArray alloc]init];
    //    ProjectMessageModel* TempModel=[[ProjectMessageModel alloc]init];
    //    TempModel.MessageInfo=@"苏州分行";
    //    TempModel.Mark=YES;
    //    [BranchDataSource addObject:TempModel];
    //
    //    for(int i=1;i<8;i++){
    //        ProjectMessageModel* TempModel=[[ProjectMessageModel alloc]init];
    //        TempModel.MessageInfo=@"苏州分行";
    //        TempModel.Mark=NO;
    //        [BranchDataSource addObject:TempModel];
    //    }
    
    
    CGSize itemSize = CGSizeMake(SCREEN_WIDTH/2, 40);
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = itemSize;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing=0;
    
    
    long TempFrameNumber;
    if(BranchDataSource.count%2==0){
        TempFrameNumber=BranchDataSource.count/2;
    }
    else{
        TempFrameNumber=BranchDataSource.count/2+1;
    }
    BranchBankCollection=[[UICollectionView alloc]initWithFrame:CGRectMake(0,40+STATUS_BAR_HEIGHT+NAVIGATOR_HEIGHT,SCREEN_WIDTH,40*TempFrameNumber) collectionViewLayout:layout];
    BranchBankCollection.backgroundColor=[UIColor whiteColor];
    BranchBankCollection.dataSource=self;
    BranchBankCollection.delegate=self;
    
    NSString* cellID=@"BranchBankCollectionID";
    [BranchBankCollection registerClass:[BankCollectionCell class] forCellWithReuseIdentifier:cellID];
    
    [self.view addSubview:BranchBankCollection];
    BranchBankCollection.hidden=YES;
}

#pragma mark Table代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView==MainTableView){
        return Datasource.count;
    }
    else if(tableView==StatusList){
        return StatusDataSource.count;
    }else if (tableView==ProgressList){
        return ProgressDataSource.count;
    }
    else{
        return 4;
    }
}


// 创建 tableView 的 cell
- ( UITableViewCell *)tableView:( UITableView *)tableView cellForRowAtIndexPath:( NSIndexPath *)indexPath
{
    if(tableView==MainTableView){
        ProjectMessageCell* cell=[ProjectMessageCell cellWithTableView:tableView];
        
        ProjectMessageModel* TempModel=[Datasource objectAtIndex:indexPath.row];
        
        [cell.MessgaeLabel setText:TempModel.projectName];
        [cell.StatusLabel setText:TempModel.stageName];
        
        return cell;
    }
    else if (tableView==ProgressList){
        ProjectConditionCell* cell=[ProjectConditionCell cellWithTableView:ProgressList];
        
        ProjectSearchConditionModel* model=[ProgressDataSource objectAtIndex:indexPath.row];
        
        NSLog(@"%@",model.MessageInfo);
        [cell.ConditionLabel setText:model.MessageInfo];
        if(model.Mark==YES){
            cell.ConditionSelectImageView.hidden=NO;
            [cell.ConditionLabel setTextColor:[UIColor colorWithHexString:@"#00B6F1"]];
        }
        else{
            cell.ConditionSelectImageView.hidden=YES;
            [cell.ConditionLabel setTextColor:[UIColor darkGrayColor]];
        }
        return cell;
    }
    else{
        ProjectConditionCell* cell=[ProjectConditionCell cellWithTableView:StatusList];
        
        ProjectSearchConditionModel* model=[StatusDataSource objectAtIndex:indexPath.row];
        [cell.ConditionLabel setText:model.MessageInfo];
        if(model.Mark==YES){
            cell.ConditionSelectImageView.hidden=NO;
            [cell.ConditionLabel setTextColor:[UIColor colorWithHexString:@"#00B6F1"]];
        }
        else{
            cell.ConditionSelectImageView.hidden=YES;
            [cell.ConditionLabel setTextColor:[UIColor darkGrayColor]];
        }
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==MainTableView){
        return 80;
    }
    else{
        return 40;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView==MainTableView){
        ProjectMessageModel* TempModel=[Datasource objectAtIndex:indexPath.row];
        //跳转详情页面
        BaseMainViewController* BaseInfoViewController=[[BaseMainViewController alloc]initWithProjretId:TempModel.id Name:TempModel.projectName];
        //传参等待上传
        [self.navigationController pushViewController:BaseInfoViewController animated:NO];
    }
    else if (tableView==ProgressList){
        //设置阶段条件
        //更改数组状态
        for(int i=0;i<ProgressDataSource.count;i++){
            if(i==indexPath.row){
                ProjectSearchConditionModel* TempModel=[ProgressDataSource objectAtIndex:i];
                TempModel.Mark=YES;
            }else{
                ProjectSearchConditionModel* TempModel=[ProgressDataSource objectAtIndex:i];
                TempModel.Mark=NO;
            }
        }
        [ProgressList reloadData];
        ProgressList.hidden=YES;
        ProjectSearchConditionModel* TempModel=[ProgressDataSource objectAtIndex:indexPath.row];
        [ProgressButton setTitle:TempModel.MessageInfo forState:UIControlStateNormal];
        ProgressCondition=TempModel.passParam;
        [self GetDateWithCondition];
        //        [self lookcondition];
    }
    else{
        //设置阶段条件
        //更改数组状态
        for(int i=0;i<StatusDataSource.count;i++){
            if(i==indexPath.row){
                ProjectSearchConditionModel* TempModel=[StatusDataSource objectAtIndex:i];
                TempModel.Mark=YES;
            }else{
                ProjectSearchConditionModel* TempModel=[StatusDataSource objectAtIndex:i];
                TempModel.Mark=NO;
            }
        }
        [StatusList reloadData];
        StatusList.hidden=YES;
        [StatusButton setTitle:StatusCondition forState:UIControlStateNormal];
        ProjectSearchConditionModel* TempModel=[StatusDataSource objectAtIndex:indexPath.row];
        [StatusButton setTitle:TempModel.MessageInfo forState:UIControlStateNormal];
        StatusCondition=TempModel.passParam;
        [self GetDateWithCondition];
        //        [self lookcondition];
    }
}


#pragma mark collection代理和数据源方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView==BankCollection){
        return BankDataSource.count;
    }
    else{
        return BranchDataSource.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView==BankCollection){
        static NSString *identifierCell = @"BankCollectionID";
        BankCollectionCell* cell=[collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
        if(!cell){
            cell=[[BankCollectionCell alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH/2,40)];
        }
        //数据设定
        ProjectMessageModel* TempModel=[BankDataSource objectAtIndex:indexPath.row];
        [cell.titleLabel setText:TempModel.MessageInfo];
        if(TempModel.Mark==YES){
            cell.selectedImageView.hidden=NO;
            [cell.titleLabel setTextColor:[UIColor colorWithHexString:@"#00B6F1"]];
        }
        else{
            [cell.titleLabel setTextColor:[UIColor darkGrayColor]];
            cell.selectedImageView.hidden=YES;
        }
        return cell;
    }else{
        static NSString *identifierCell = @"BranchBankCollectionID";
        BankCollectionCell* cell=[collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
        if(!cell){
            cell=[[BankCollectionCell alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH/2,40)];
        }
        //数据设定
        ProjectMessageModel* TempModel=[BranchDataSource objectAtIndex:indexPath.row];
        [cell.titleLabel setText:TempModel.MessageInfo];
        if(TempModel.Mark==YES){
            cell.selectedImageView.hidden=NO;
            [cell.titleLabel setTextColor:[UIColor colorWithHexString:@"#00B6F1"]];
        }
        else{
            [cell.titleLabel setTextColor:[UIColor darkGrayColor]];
            cell.selectedImageView.hidden=YES;
        }
        return cell;
    }
    
    
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView==BankCollection)
    {
        //设置分行条件
        for(int i=0;i<BankDataSource.count;i++){
            if(i==indexPath.row){
                ProjectSearchConditionModel* TempModel=[BankDataSource objectAtIndex:i];
                TempModel.Mark=YES;
            }else{
                ProjectSearchConditionModel* TempModel=[BankDataSource objectAtIndex:i];
                TempModel.Mark=NO;
            }
        }
        [BankCollection reloadData];
        BankCollection.hidden=YES;
        
        
        //更改支行数组
        ProjectSearchConditionModel* model=[BankDataSource objectAtIndex:indexPath.row];
        NSMutableArray* arr=model.branchBankArray;
        BranchDataSource=[[NSMutableArray alloc]init];
        
        ProjectSearchConditionModel* branchall=[[ProjectSearchConditionModel alloc]init];
        branchall.MessageInfo=@"全部支行";
        branchall.passParam=@"all";
        [BranchDataSource addObject:branchall];
        
        for(int i=0;i<arr.count;i++)
        {
            NSDictionary* dic=[arr objectAtIndex:i];
            ProjectSearchConditionModel* model=[[ProjectSearchConditionModel alloc]init];
            model.MessageInfo=[dic objectForKey:@"name"];
            model.bankId=[dic objectForKey:@"id"];
            model.passParam=[dic objectForKey:@"id"];
            [BranchDataSource addObject:model];
        }
        //更改支行框体
        long TempFrameNumber;
        if(BranchDataSource.count%2==0){
            TempFrameNumber=BranchDataSource.count/2;
        }
        else{
            TempFrameNumber=BranchDataSource.count/2+1;
        }
        BranchBankCollection.frame=CGRectMake(0,40+STATUS_BAR_HEIGHT+NAVIGATOR_HEIGHT,SCREEN_WIDTH,40*TempFrameNumber);
        [BranchBankCollection reloadData];
        
        //分行
        BankCondition=model.passParam;
        [BankButton setTitle:model.MessageInfo forState:UIControlStateNormal];
        //更改支行title
        [BranchBankButton setTitle:@"支行" forState:UIControlStateNormal];
        BranchBankCondition=@"all";
        
        [self GetDateWithCondition];
        //        [self lookcondition];
    }else
    {
        //设置分行条件
        //更改数组状态
        for(int i=0;i<BranchDataSource.count;i++){
            if(i==indexPath.row){
                ProjectSearchConditionModel* TempModel=[BranchDataSource objectAtIndex:i];
                TempModel.Mark=YES;
            }else{
                ProjectSearchConditionModel* TempModel=[BranchDataSource objectAtIndex:i];
                TempModel.Mark=NO;
            }
        }
        [BranchBankCollection reloadData];
        BranchBankCollection.hidden=YES;
        
        ProjectSearchConditionModel* TempModel=[BranchDataSource objectAtIndex:indexPath.row];
        BranchBankCondition=TempModel.passParam;
        [BranchBankButton setTitle:TempModel.MessageInfo forState:UIControlStateNormal];
        [self GetDateWithCondition];
        //        [self lookcondition];
    }

    
}

#pragma mark 点击事件（弹出状态/阶段/分行/支行）
- (void)ShowOrRemoveStatusList{
    StatusList.hidden=!StatusList.hidden;
    ProgressList.hidden=YES;
    BankCollection.hidden=YES;
    BranchBankCollection.hidden=YES;
}

- (void)ShowOrRemoveProgressList{
    ProgressList.hidden=!ProgressList.hidden;
    StatusList.hidden=YES;
    BankCollection.hidden=YES;
    BranchBankCollection.hidden=YES;
}

- (void)ShowOrRemoveBankCollection{
    BankCollection.hidden=!BankCollection.hidden;
    ProgressList.hidden=YES;
    StatusList.hidden=YES;
    BranchBankCollection.hidden=YES;
}

- (void)ShowOrRemoveBranchBankCollection{
    BranchBankCollection.hidden=!BranchBankCollection.hidden;
    ProgressList.hidden=YES;
    BankCollection.hidden=YES;
    StatusList.hidden=YES;
}

- (void)lookcondition{
    //    NSLog(@"status=%@,progress=%@,banl=%@,branch=%@",StatusCondition,ProgressCondition,BankCondition,BranchBankCondition);
}

#pragma mark 跳转搜索/跳转新建
- (void)BeginSearch{
    ProjectSearchViewController* SearchViewController=[[ProjectSearchViewController alloc]init];
//    [self.navigationController pushViewController:SearchViewController animated:NO];
    
    ProjectMessageModel* model=[Datasource objectAtIndex:0];
    
    MemberViewController* member=[[MemberViewController alloc]initWithProjectId:model.id];
    FileManagerViewController* file=[[FileManagerViewController alloc]initWithProjectId:model.id];
    [self.navigationController pushViewController:member animated:NO];
}

- (void)AddNewProject{
    ProjectNewViewController* AddNewViewController=[[ProjectNewViewController alloc]init];
    [self.navigationController pushViewController:AddNewViewController animated:NO];
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
