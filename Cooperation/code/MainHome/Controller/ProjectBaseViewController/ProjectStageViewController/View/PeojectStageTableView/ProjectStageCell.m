//
//  ProjectStageCell.m
//  Cooperation
//
//  Created by 葛君语 on 2017/1/22.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "ProjectStageCell.h"
#import "ProjectStageModel.h"

NSString *const PS_CELL_ID = @"PS_CELL_ID";

static CGFloat kCellWidth; //cell宽度

@implementation ProjectStageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect frame = self.frame;
    }
    return self;
}

#pragma mark -计算高度
+ (CGFloat)getCellHeightWithModel:(ProjectFeedbackModel *)model tableWidth:(CGFloat)tableWidth
{
    kCellWidth = tableWidth;
    
    //先判断高度是否已经计算过
    if (model.cellHeight != -1) { //有缓存，直接取缓存
        return model.cellHeight;
        
    }else{ //没有缓存，需要计算
        CGFloat height = 10;
        
        //保存缓存
        model.cellHeight = height;
        
        return height;
        
    }
}

@end
