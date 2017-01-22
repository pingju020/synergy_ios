//
//  ProjectStageViewController.m
//  Cooperation
//
//  Created by 葛君语 on 2017/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "ProjectStageViewController.h"
#import "HttpSessionManager.h"
#import "ProjectTabScrollView.h"
#import "ProjectTabModel.h"
#import "ProjectStageModel.h"
#import "ProjectStageHeaderView.h"
#import "ProjectTableViewModel.h"

@interface ProjectStageViewController ()<ProjectStageHeaderDelegate>

//UI
@property (nonatomic,strong) ProjectTabScrollView *projectTabScrollView; //左侧滚动条

@property (nonatomic,strong) ProjectStageHeaderView *headerView; //头视图
@property (nonatomic,strong) UITableView *tableView;  //列表


//参数&DATA
@property (nonatomic,copy) NSString *projectId; //项目id

@property (nonatomic,copy) NSString *phone;  //手机号

@property (nonatomic,copy) NSString *stageId; //状态id

@property (nonatomic,strong) ProjectTableViewModel *tableViewModel; //逻辑层

@end

@implementation ProjectStageViewController

- (instancetype)initWithProjectId:(NSString *)projectId
{
    self = [super init];
    if (self) {
        _projectId = projectId;
        
        _phone = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
        
        //请求左边tab
        [self requestLeftTabData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}


#pragma mark -Request & Data
- (void)requestLeftTabData
{
    
    [self showWaitingView];
    
    [HTTP_MANAGER startNormalPostWithParagram:@{@"phone":_phone,
                                                @"projectId":_projectId}
                                  Commandtype:@"app/project/getProjectStage"
                               successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
                                   [self removeWaitingView];
                                   if (isSucceed) {
                                       //1.解析数据
                                       NSArray *tabList = [ProjectTabModel parsingDataListWithArray:succeedResult[@"data"]];
                                       
                                       if (!tabList) {
                                           return ;
                                       }
                                       
                                       //2.左侧tab页赋值
                                       self.projectTabScrollView.dataList = tabList;
                                       
                                       //3.默认请求第一个
                                       self.stageId = [tabList[0] stageId];
                                       
                                   }else{
                                       [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                                   }
                                   
                               }
                                  failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
                                      [self removeWaitingView];
                                      [PubllicMaskViewHelper showTipViewWith:@"网络异常" inSuperView:self.view withDuration:1];
                                  }];
    
}

- (void)setStageId:(NSString *)stageId
{
    _stageId = stageId;
    
    if (NO) { //先判断是否有缓存
        //取缓存
        
    }else{ //没有缓存重新获取
        [self requestStageData];
    }
}

- (void)requestStageData
{
    [self showWaitingView];
    [HTTP_MANAGER startNormalPostWithParagram:@{@"phone":_phone,
                                                @"projectId":_projectId,
                                                @"stageId":_stageId}
                                  Commandtype:@"app/project/getStageInfo"
                               successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
                                   [self removeWaitingView];
                                   
                                   if (isSucceed) {
                                       //1.解析数据
                                       ProjectStageModel *stageModel =[ProjectStageModel parsingModelWithDict:succeedResult[@"data"]];
                                       
                                       //2.保存缓存
                                       
                                       //3.构建UI
                                       [self refrehViewWithModel:stageModel];
                                       

                                       
                                   }else{
                                       [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                                   }
                               }
                                  failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
                                      [self removeWaitingView];
                                      [PubllicMaskViewHelper showTipViewWith:@"网络异常" inSuperView:self.view withDuration:1];
                                  }];
    
}

- (void)refrehViewWithModel:(ProjectStageModel *)stageModel
{
    //头视图
    self.headerView.model = stageModel;
    self.tableView.tableHeaderView = self.headerView; //iOS8和9部分不写该方法会出现BUG
    //tableView逻辑层
    self.tableViewModel.stageModel = stageModel;
    
    [self.tableView reloadData];
}

#pragma mark -ProjectStageHeaderDelegate
//更改状态
- (void)projectStageHeaderChangeState
{
    [PubllicMaskViewHelper showTipViewWith:@"点击了更改状态" inSuperView:self.view withDuration:1];
}

//新增任务
- (void)projectStageHeaderAddMission
{
    [PubllicMaskViewHelper showTipViewWith:@"点击了新增任务" inSuperView:self.view withDuration:1];
}

#pragma mark -setUI

#define kTabWidth MAIN_WIDTH*0.15 //左侧tab页宽度

- (ProjectTabScrollView *)projectTabScrollView
{
    if (!_projectTabScrollView) {
        
        _projectTabScrollView = [[ProjectTabScrollView alloc]initWithFrame:CGRectMake(0, 64, kTabWidth, MAIN_HEIGHT-64)];
        [self.view addSubview:_projectTabScrollView];
        
        
        typeof(self) __weak weakSelf = self;
        _projectTabScrollView.tabHandle = ^(NSString *stageId) {
            weakSelf.stageId = stageId;
        };
    }
    return _projectTabScrollView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(kTabWidth, 64, MAIN_WIDTH-kTabWidth, MAIN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = VcBackgroudColor;
        
        //代理交由逻辑层处理
        _tableView.delegate = self.tableViewModel;
        _tableView.dataSource = self.tableViewModel;
        
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}

- (ProjectStageHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[ProjectStageHeaderView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH-kTabWidth, 400)];//高度随便定,控件会自己调节
        _headerView.delegate = self;
        
    }
    return _headerView;
}

- (ProjectTableViewModel *)tableViewModel
{
    if (!_tableViewModel) {
        _tableViewModel = [ProjectTableViewModel new];
    }
    return _tableViewModel;
}

@end
