//
//  ProjectTableViewModel.m
//  Cooperation
//
//  Created by 葛君语 on 2017/1/22.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "ProjectTableViewModel.h"
#import "ProjectStageModel.h"

NSString *const PS_CELL_ID = @"PS_CELL_ID";

@interface ProjectTableViewModel ()

@end

@implementation ProjectTableViewModel

#pragma mark -计算高度
- (CGFloat)getSectionHeightWithSection:(NSInteger)section
{
    ProjectTaskModel *taskModel = _stageModel.projectTasks[section];
    
    if (taskModel.sectionHeight == -1) { // 未计算过
        //计算高度 并且 缓存
        taskModel.sectionHeight = 10;
        return 10;
        
    }else{ //使用之前缓存的值
        return taskModel.sectionHeight;
    }
    
}

- (CGFloat)getCellHeightWithIndexPath:(NSIndexPath *)indexPath
{
    ProjectTaskModel *taskModel = _stageModel.projectTasks[indexPath.section];
    
    ProjectFeedbackModel *fdModel = taskModel.taskFeedbacks[indexPath.row];
    
    if (fdModel.cellHeight == -1) {
        //计算高度 并且 缓存
        fdModel.cellHeight = 10;
        return 10;
        
    }else{ //使用之前缓存的值
        return fdModel.cellHeight;
    }
    
}

#pragma mark -UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _stageModel.projectTasks.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_stageModel.projectTasks) {
        return 0;
    }
    
    ProjectTaskModel *taskModel = _stageModel.projectTasks[section];
    
    return taskModel.isOn ? taskModel.taskFeedbacks.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self getSectionHeightWithSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [UILabel new];
    
    ProjectTaskModel *taskModel = _stageModel.projectTasks[section];
    
    label.text = taskModel.taskContent;
    label.backgroundColor = [UIColor whiteColor];
    
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getCellHeightWithIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PS_CELL_ID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PS_CELL_ID];
        cell.backgroundColor = [UIColor yellowColor];
    }
    
    ProjectTaskModel *taskModel = _stageModel.projectTasks[indexPath.section];
    ProjectFeedbackModel *fdModel = taskModel.taskFeedbacks[indexPath.row];
    
    cell.textLabel.text = fdModel.contents;
    
    return cell;
}

@end
