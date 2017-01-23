//
//  ProjectFeedBackCell.m
//  Cooperation
//
//  Created by 葛君语 on 2017/1/23.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "ProjectFeedBackCell.h"
#import "ProjectStageModel.h"

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

+ (CGFloat)getHeightWith:(ProjectTaskModel *)taskModel tableWidth:(CGFloat)tableWidth
{
    /*高度计算规则 cell内部嵌套一个tableView,数据根据ProjectTaskModel.taskFeedbacks来计算
     
     内部的tableView section数量等于taskFeedbacks数量
     
     每个section由反馈人cell+时间cell+若干文档cell
     
     文档cell数量等于ProjectFeedbackModel.taskFeedFiles数量决定
     
     反馈人cell高度需要计算
     
     其余每个cell高度都是PS_CELL_H(35)，所以可以算出

     */
    
    
    //先判断是否已经有缓存
    if (taskModel.feedBackCellHeight != -1) { //有缓存，直接用
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
    if (fbModel.contentCellHeight != -1) { //先判断是否有缓存
        return fbModel.contentCellHeight;
        
    }else{
        //先获取文本
        NSString *text = [NSString stringWithFormat:@"%@:%@",fbModel.createByName,fbModel.contents];
        
        
        CGRect frame = [text boundingRectWithSize:CGSizeMake(labelWidth, 1000)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil];
        
        CGFloat textH = frame.size.height;
        
        //缓存
        fbModel.contentCellHeight = textH;
        
        return textH;
    }
    
    

}



@end
