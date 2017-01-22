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

- (void)setStageModel:(ProjectStageModel *)stageModel
{
    _stageModel = stageModel;
    
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
    
    return taskModel.taskFeedbacks.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
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
    return 20;
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
