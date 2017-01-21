//
//  ProjectWebViewController.m
//  synergy
//
//  Created by Tion on 17/1/12.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "ProjectWebViewController.h"
#import "MeWebViewController.h"
#import "CommonWebViewController.h"
#import "AFNetworking.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "ProjectMessageModel.h"
#import "ProjectMessageCell.h"
#import "ProjectConditionCell.h"
#import "ProjectSearchConditionModel.h"
#import "BankCollectionCell.h"


@interface ProjectWebViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation ProjectWebViewController
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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F8F8F8"]];
    
    [self SetNavigator];
    
    [self SetTopTabbar];
    
    [self ResetSearchCondition];
    
    
    [self SetBaseDetailsTable];
    
    [self StatusList];
    
    [self ProgressList];
    
    [self BankList];
    
    [self BranchBankList];
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

#pragma mark 导航栏
- (void)SetNavigator{
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
    UIView* TopTabbar=[[UIView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,41)];
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
    [StatusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
    [ProgressButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
    [BankButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
    [BranchBankButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
//重置搜索条件
- (void)ResetSearchCondition{
    //初始设定为
    StatusCondition=@"正在进行";
    ProgressCondition=@"阶段";
    BankCondition=@"分行";
    BranchBankCondition=@"支行";
    
    [StatusButton setTitle:StatusCondition forState:UIControlStateNormal];
    [ProgressButton setTitle:ProgressCondition forState:UIControlStateNormal];
    [BankButton setTitle:BankCondition forState:UIControlStateNormal];
    [BranchBankButton setTitle:BranchBankCondition forState:UIControlStateNormal];
    
    [self GetDateWithCondition];
}

//锁定条件，获取数据
- (void)GetDateWithCondition{
    
}

//变更数据，变更页面
- (void)ChangeDetailsTable{
    
}

#pragma mark 基本列表制作
- (void)SetBaseDetailsTable{
    MainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,40+10,SCREEN_WIDTH , SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATOR_HEIGHT-40-TAB_BAR_HEIGHT)
                   ];
//    MainTableView.backgroundColor=[UIColor blackColor];
    MainTableView.separatorStyle = UITableViewCellEditingStyleNone;
    
    Datasource=[[NSMutableArray alloc]init];
    ProjectMessageModel* model1=[[ProjectMessageModel alloc]init];
    for(int i=0;i<3;i++){
        [Datasource addObject:model1];
    }
    
    
    MainTableView.delegate=self;
    MainTableView.dataSource=self;
    
    [self.view addSubview:MainTableView];
}

#pragma mark 弹出list制作
- (void)StatusList{
    //待审批，已完成，已关闭，正在进行
    StatusList=[[UITableView alloc]initWithFrame:CGRectMake(0,40,SCREEN_WIDTH, 160)];
    StatusList.delegate=self;
    StatusList.dataSource=self;
    
    NSMutableArray* TempArray=[[NSMutableArray alloc]initWithObjects:@"待审批",@"正在进行",@"已完成",@"已关闭", nil];
    StatusDataSource=[[NSMutableArray alloc]init];
    for(int i=0;i<TempArray.count;i++){
        if(i==0){
            ProjectSearchConditionModel* TempModel=[[ProjectSearchConditionModel alloc]init];
            TempModel.MessageInfo=[TempArray objectAtIndex:i];
            TempModel.Mark=YES;
            [StatusDataSource addObject:TempModel];
        }
        else{
            ProjectSearchConditionModel* TempModel=[[ProjectSearchConditionModel alloc]init];
            TempModel.MessageInfo=[TempArray objectAtIndex:i];
            TempModel.Mark=NO;
            [StatusDataSource addObject:TempModel];
        }
    }
    StatusList.separatorStyle = UITableViewCellEditingStyleNone;
    StatusList.scrollEnabled=NO;
    [self.view addSubview:StatusList];
    StatusList.hidden=YES;
}

- (void)ProgressList{
    //全部阶段，营销中，材料收集，分行审批，总行审批，审批通过，合同签订，已放款
    ProgressList=[[UITableView alloc]initWithFrame:CGRectMake(0,40,SCREEN_WIDTH,320)];
    ProgressList.delegate=self;
    ProgressList.dataSource=self;
    NSMutableArray* TempArray=[[NSMutableArray alloc]initWithObjects:@"全部阶段",@"营销中",@"材料收集",@"分行审批",@"总行审批",@"审批通过",@"合同签订",@"已放款",nil];
    ProgressDataSource=[[NSMutableArray alloc]init];
    for(int i=0;i<TempArray.count;i++){
        if(i==0){
            ProjectSearchConditionModel* TempModel=[[ProjectSearchConditionModel alloc]init];
            TempModel.MessageInfo=[TempArray objectAtIndex:i];
            TempModel.Mark=YES;
            [ProgressDataSource addObject:TempModel];
        }
        else{
            ProjectSearchConditionModel* TempModel=[[ProjectSearchConditionModel alloc]init];
            TempModel.MessageInfo=[TempArray objectAtIndex:i];
            TempModel.Mark=NO;
            [ProgressDataSource addObject:TempModel];
        }
    }
    ProgressList.separatorStyle = UITableViewCellEditingStyleNone;
    ProgressList.scrollEnabled=NO;
    [self.view addSubview:ProgressList];
    ProgressList.hidden=YES;
}

- (void)BankList{
    //分行名称---接口返回
    BankDataSource=[[NSMutableArray alloc]init];
    ProjectMessageModel* TempModel=[[ProjectMessageModel alloc]init];
    TempModel.MessageInfo=@"南京分行";
    TempModel.Mark=YES;
    [BankDataSource addObject:TempModel];
    
    for(int i=1;i<8;i++){
        ProjectMessageModel* TempModel=[[ProjectMessageModel alloc]init];
        TempModel.MessageInfo=@"南京分行";
        TempModel.Mark=NO;
        [BankDataSource addObject:TempModel];
    }
    
    
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
    BankCollection=[[UICollectionView alloc]initWithFrame:CGRectMake(0,40,SCREEN_WIDTH,40*TempFrameNumber) collectionViewLayout:layout];
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
    BranchDataSource=[[NSMutableArray alloc]init];
    ProjectMessageModel* TempModel=[[ProjectMessageModel alloc]init];
    TempModel.MessageInfo=@"苏州分行";
    TempModel.Mark=YES;
    [BranchDataSource addObject:TempModel];
    
    for(int i=1;i<8;i++){
        ProjectMessageModel* TempModel=[[ProjectMessageModel alloc]init];
        TempModel.MessageInfo=@"苏州分行";
        TempModel.Mark=NO;
        [BranchDataSource addObject:TempModel];
    }
    
    
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
    BranchBankCollection=[[UICollectionView alloc]initWithFrame:CGRectMake(0,40,SCREEN_WIDTH,40*TempFrameNumber) collectionViewLayout:layout];
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
        
        [cell.MarkImageView setBackgroundColor:[UIColor blackColor]];
        [cell.StatusImageView setBackgroundColor:[UIColor orangeColor]];
        [cell.MessgaeLabel setText:@"南京全聚德"];
        
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
            [cell.ConditionLabel setTextColor:[UIColor blackColor]];
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
            [cell.ConditionLabel setTextColor:[UIColor blackColor]];
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


#pragma mark collection代理和数据源方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return BankDataSource.count;
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
            [cell.titleLabel setTextColor:[UIColor blackColor]];
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
            [cell.titleLabel setTextColor:[UIColor blackColor]];
            cell.selectedImageView.hidden=YES;
        }
        return cell;
    }
    
    
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
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

#pragma mark system方法
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
}


@end
