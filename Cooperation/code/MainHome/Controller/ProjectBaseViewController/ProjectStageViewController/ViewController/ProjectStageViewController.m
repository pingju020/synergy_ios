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
#import "ProjectStageSectionView.h"
#import "ProjectStageCell.h"

@interface ProjectStageViewController ()<ProjectStageHeaderDelegate,UITableViewDelegate,UITableViewDataSource>

//UI
@property (nonatomic,strong) ProjectTabScrollView *projectTabScrollView; //左侧滚动条

@property (nonatomic,strong) ProjectStageHeaderView *headerView; //头视图
@property (nonatomic,strong) UITableView *tableView;  //列表


//参数&DATA
@property (nonatomic,copy) NSString *projectId; //项目id

@property (nonatomic,copy) NSString *phone;  //手机号

@property (nonatomic,copy) NSString *stageId; //阶段id

@property (nonatomic,strong) ProjectStageModel *stageModel; //数据包

@property (nonatomic,strong) NSMutableDictionary *caches; //缓存     要清除某个阶段的缓存直接清除stageId对应的value就可以

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
    self.title=@"进展";
}

-(void)backBtnClicked{
    if (_backVC) {
        [_backVC backBtnClicked];
    }
    else{
        [super backBtnClicked];
    }
}


#pragma mark -Request & Data
- (void)requestLeftTabData
{
    
    [self showWaitingView];
    //查询项目阶段
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
    
    //先判断是否有缓存
    if (self.caches[stageId]) { //有缓存，取缓存
        self.stageModel = self.caches[stageId];
        
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
                                       //解析数据
                                       self.stageModel =[ProjectStageModel parsingModelWithDict:succeedResult[@"data"]];
                                       
                                   }else{
                                       [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                                   }
                               }
                                  failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
                                      [self removeWaitingView];
                                      [PubllicMaskViewHelper showTipViewWith:@"网络异常" inSuperView:self.view withDuration:1];
                                  }];
    
}

- (void)setStageModel:(ProjectStageModel *)stageModel
{
    _stageModel = stageModel;
    
    //1.保存缓存
    if (!self.caches[_stageId]) {
        self.caches[_stageId] = stageModel;
    }
        
    //2.构建UI
    //头视图
    self.headerView.model = stageModel;
    self.tableView.tableHeaderView = self.headerView;//iOS8和9部分不写该方法会出现BUG
    
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


#pragma mark -UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _stageModel.projectTasks.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    ProjectTaskModel *taskModel = _stageModel.projectTasks[section];
    
    return taskModel.isOn ? taskModel.taskFeedbacks.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    ProjectTaskModel *taskModel = _stageModel.projectTasks[section];
    
    //计算高度
    return [ProjectStageSectionView getSectionHeightWithModel:taskModel tableWidth:tableView.width];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    ProjectStageSectionView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:PS_SECTION_ID];
    
    ProjectTaskModel *taskModel = _stageModel.projectTasks[section];
    
    view.taskModel = taskModel;
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectTaskModel *taskModel   = _stageModel.projectTasks[indexPath.section];
    ProjectFeedbackModel *fbModel = taskModel.taskFeedbacks[indexPath.row];
    
    //计算高度
    return [ProjectStageCell getCellHeightWithModel:fbModel tableWidth:tableView.width];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectStageCell *cell = [tableView dequeueReusableCellWithIdentifier:PS_CELL_ID forIndexPath:indexPath];
    
    ProjectTaskModel *taskModel = _stageModel.projectTasks[indexPath.section];
    ProjectFeedbackModel *feedBackModel = taskModel.taskFeedbacks[indexPath.row];
    
    cell.feedBackModel = feedBackModel;
    
    return cell;
}


#pragma mark -setUI

#define kTabWidth MAIN_WIDTH*0.15 //左侧tab页宽度

- (ProjectTabScrollView *)projectTabScrollView
{
    if (!_projectTabScrollView) {
        
        _projectTabScrollView = [[ProjectTabScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(navigationBG.frame)+44, kTabWidth, MAIN_HEIGHT-CGRectGetMaxY(navigationBG.frame)-44)];
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(kTabWidth, CGRectGetMaxY(navigationBG.frame)+44, MAIN_WIDTH-kTabWidth, MAIN_HEIGHT-CGRectGetMaxY(navigationBG.frame)-44) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = VcBackgroudColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        //注册sectionView
        [_tableView registerClass:[ProjectStageSectionView class] forHeaderFooterViewReuseIdentifier:PS_SECTION_ID];
        //注册cell
        [_tableView registerClass:[ProjectStageCell class] forCellReuseIdentifier:PS_CELL_ID];
        
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

- (NSMutableDictionary *)caches
{
    if (!_caches) {
        _caches = [NSMutableDictionary dictionary];
    }
    return _caches;
}

@end
