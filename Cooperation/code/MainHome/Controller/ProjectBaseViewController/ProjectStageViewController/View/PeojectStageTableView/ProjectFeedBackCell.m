//
//  ProjectFeedBackCell.m
//  Cooperation
//
//  Created by 葛君语 on 2017/1/23.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "ProjectFeedBackCell.h"
#import "ProjectStageModel.h"
#import "ProjectStageFileCell.h"

static CGFloat PS_RB_WIDTH;

@interface ProjectFeedBackCell ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ProjectFeedBackCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

#pragma mark -赋值
- (void)setTaskModel:(ProjectTaskModel *)taskModel
{
    _taskModel = taskModel;
    
    if (!taskModel.taskFeedbacks) {
        return;
    }
    
    self.tableView.height = taskModel.feedBackCellHeight;
    
    [self.tableView reloadData];
}

#pragma mark -UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _taskModel.taskFeedbacks.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //文档数 + 第一行的反馈文本cell + 最后一行的时间cell
    return _taskModel.taskFiles.count + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectFeedbackModel *fbModel = _taskModel.taskFeedbacks[indexPath.section];
    
    if (indexPath.row == 0) { //文本cell用缓存
        return fbModel.contentCellHeight;
    }else{
        return PS_CELL_H;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectStageFileCell *cell =[tableView dequeueReusableCellWithIdentifier:@"fileId"];
    if (!cell) {
        cell = [[ProjectStageFileCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fileId"];
    }
    
    //赋值
    ProjectFeedbackModel *fbModel = _taskModel.taskFeedbacks[indexPath.section];
    
    if (indexPath.row == 0) {    //反馈内容
        [cell setContentWithName:fbModel.createByName text:fbModel.contents];
        
    }else if (indexPath.row == fbModel.taskFeedFiles.count+1){ //时间
        [cell setCreateTime:fbModel.createTime];
        
    }else{ //文件
        ProjectTaskFileModel *fileModel = fbModel.taskFeedFiles[indexPath.row-1];
        
        [cell setFileInfoWithFileType:fileModel.fileType.integerValue title:fileModel.fileName];
        
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     ProjectFeedbackModel *fbModel = _taskModel.taskFeedbacks[indexPath.section];
    ProjectTaskFileModel *fileModel = fbModel.taskFeedFiles[indexPath.row-1];
    
    //点击文档cell才有效果
    if (indexPath.row > 0 && indexPath.row < _taskModel.taskFiles.count + 1) {
        if ([self.delegate respondsToSelector:@selector(projectReadFile:)]) {
            [self.delegate projectReadFile:fileModel.fileUrl];
        }
    }
}

#pragma mark - setUI
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, PS_RB_WIDTH, 100) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        
        [self.contentView addSubview:_tableView];
        
    }
    return _tableView;
}




#pragma mark -万恶的计算高度
+ (CGFloat)getHeightWith:(ProjectTaskModel *)taskModel tableWidth:(CGFloat)tableWidth
{
    /*高度计算规则 cell内部嵌套一个tableView,数据根据ProjectTaskModel.taskFeedbacks来计算
     
     内部的tableView section数量等于taskFeedbacks数量
     
     每个section由反馈人cell+时间cell+若干文档cell
     
     文档cell数量等于ProjectFeedbackModel.taskFeedFiles数量决定
     
     反馈人cell高度需要计算
     
     其余每个cell高度都是PS_CELL_H(35)，所以可以算出
     
     */
    
    
    //记录下cell宽度，方便后续内部tableview搭建
    PS_RB_WIDTH = tableWidth;

    //先判断是否已经有缓存
    if (!taskModel.taskFeedbacks) {
        return 0;
        
    }else if (taskModel.feedBackCellHeight != 0) { //有缓存，直接用
        return taskModel.feedBackCellHeight;
        
        
    }else{     //没有缓存
        
        //总高度
        CGFloat sum = 0;
        
        
        //反馈内容的 label宽度 label距cell左边30 右边10
        CGFloat labelWidth = tableWidth-30-10;
        
        for (ProjectFeedbackModel *fbModel in taskModel.taskFeedbacks) {
            /* 1.计算反馈人cell高度 */
            CGFloat textH = [self getFBContentcellHeightWith:fbModel labelWidth:labelWidth];
            
            /* 2.计算文件内容高度 */
            CGFloat fileH = fbModel.taskFeedFiles.count * PS_CELL_H;
            
            //最后加上底部的时间cell高度35
            sum += (textH + fileH + PS_CELL_H);
            
        }
        
        //缓存下数据
        taskModel.feedBackCellHeight = sum;
        
        return sum;
        
    }
    
}

+ (CGFloat)getFBContentcellHeightWith:(ProjectFeedbackModel *)fbModel labelWidth:(CGFloat)labelWidth
{
    if (fbModel.contentCellHeight != 0) { //先判断是否有缓存
        return fbModel.contentCellHeight;
        
    }else{
        //先获取文本
        NSString *text = [NSString stringWithFormat:@"%@：%@",fbModel.createByName,fbModel.contents];
        
        
        CGRect frame = [text boundingRectWithSize:CGSizeMake(labelWidth, 1000)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil];
        
        CGFloat textH = frame.size.height;
        
        //缓存
        fbModel.contentCellHeight = textH;
        
        return textH;
    }
    
    
    
}



@end
