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
#import "ProjectStageFileCell.h"
#import "ProjectStageDateCell.h"

@interface ProjectStageViewController ()<ProjectStageHeaderDelegate,UITableViewDelegate,UITableViewDataSource,ProjectStageSectionDelegate,ProjectStageDateDelegate>

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
    
    //结束记得清缓存再刷新
//    [self.caches removeObjectForKey:_stageId];
//    [self requestStageData];
}

//新增任务
- (void)projectStageHeaderAddMission
{
    [PubllicMaskViewHelper showTipViewWith:@"点击了新增任务" inSuperView:self.view withDuration:1];
    
        //结束记得清缓存再刷新
    //    [self.caches removeObjectForKey:_stageId];
    //    [self requestStageData];
}

#pragma mark -ProjectStageSectionDelegate
//删除任务
- (void)projectStageSectionRemove:(NSInteger)section
{
    [PubllicMaskViewHelper showTipViewWith:@"点击了删除任务" inSuperView:self.view withDuration:1];
    
        //结束记得清缓存再刷新
    //    [self.caches removeObjectForKey:_stageId];
    //    [self requestStageData];
}

#pragma mark -ProjectStageDateDelegate
- (void)projectStageWrite:(NSString *)taskId
{
        [PubllicMaskViewHelper showTipViewWith:@"点击了反馈" inSuperView:self.view withDuration:1];
    //结束记得清缓存再刷新
    //    [self.caches removeObjectForKey:_stageId];
    //    [self requestStageData];
}

- (void)projectStageFinish:(NSString *)taskId
{
        [PubllicMaskViewHelper showTipViewWith:@"点击了完成" inSuperView:self.view withDuration:1];
    //结束记得清缓存再刷新
    //    [self.caches removeObjectForKey:_stageId];
    //    [self requestStageData];
}

#pragma mark -UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _stageModel.projectTasks.count; //section数量根据任务数量来定
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    ProjectTaskModel *taskModel = _stageModel.projectTasks[section];
    
    //cell数量是 附件数量 + 日期栏 + 反馈列表(要判断打开还是关闭)
    return taskModel.taskFiles.count + 1 + (taskModel.isOn ? 1 : 0) ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    ProjectStageSectionView *sectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"sectionHeader"];
    
    if (!sectionHeader) {
        sectionHeader = [[ProjectStageSectionView alloc]initWithReuseIdentifier:@"sectionHeader"];
    }
    
    
    ProjectTaskModel *taskModel   = _stageModel.projectTasks[section];
    
    sectionHeader.title     = taskModel.taskContent;
    sectionHeader.section   = section;
    sectionHeader.delegate  = self;
    
    return sectionHeader;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectTaskModel *taskModel   = _stageModel.projectTasks[indexPath.section];
    
    //cell 由文件列表+时间cell+反馈Cell构成
    
    if (indexPath.row >= taskModel.taskFiles.count + 1) { //反馈
        return 50;
    }else{
        return 35;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectTaskModel *taskModel   = _stageModel.projectTasks[indexPath.section];
    
    
    //文件列表
    if (indexPath.row < taskModel.taskFiles.count) {
        ProjectStageFileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fileId"];
        if (!cell) {
            cell = [[ProjectStageFileCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fileId"];
        }
        
        //赋值
        ProjectTaskFileModel *fileModel = taskModel.taskFiles[indexPath.row];

        [cell setInfoWithFileType:fileModel.fileType.integerValue title:fileModel.fileName];
        
        return cell;
        
        
    }else if (indexPath.row == taskModel.taskFiles.count){ //时间栏
        ProjectStageDateCell *cell =[tableView dequeueReusableCellWithIdentifier:@"time_id"];
        if (!cell) {
            cell = [[ProjectStageDateCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"time_id"];
        }
        cell.taskModel = taskModel;
        
        cell.delegate = self;
        
        return cell;
        
        
    }else{ //反馈栏
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"feedback_id"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"feedback_id"];
            cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        }
        cell.textLabel.text = @"这是反馈cell,编写中";
        return cell;
        
    }
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectTaskModel *taskModel   = _stageModel.projectTasks[indexPath.section];
    //文件列表
    if (indexPath.row < taskModel.taskFiles.count) {
        ProjectTaskFileModel *fileModel = taskModel.taskFiles[indexPath.row];
        
        [PubllicMaskViewHelper showTipViewWith:[NSString stringWithFormat:@"点击了文件:%@",fileModel.fileUrl] inSuperView:self.view withDuration:1] ;
    
    }else{
        taskModel.isOn ^= 1;
        
        [tableView reloadSections:[[NSIndexSet alloc]initWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];

    }
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
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;

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
