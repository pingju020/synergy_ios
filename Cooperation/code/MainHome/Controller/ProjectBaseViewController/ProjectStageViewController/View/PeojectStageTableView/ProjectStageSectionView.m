//
//  ProjectStageSectionView.m
//  Cooperation
//
//  Created by 葛君语 on 2017/1/22.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "ProjectStageSectionView.h"
#import "ProjectStageModel.h"

NSString *const PS_SECTION_ID = @"PS_SECTION_ID";

static CGFloat kSectionWidth; //section宽度

@implementation ProjectStageSectionView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

#pragma mark -计算高度
+ (CGFloat)getSectionHeightWithModel:(ProjectTaskModel *)model tableWidth:(CGFloat)tableWidth
{
    kSectionWidth = tableWidth;
    
    //先判断高度是否已经计算过
    if (model.sectionHeight != -1) { //有缓存，直接取缓存
        return model.sectionHeight;
        
    }else{ //没有缓存，需要计算
        CGFloat height = 20;
        
        //保存缓存
        model.sectionHeight = height;
        
        return height;
        
    }
}

- (void)setTaskModel:(ProjectTaskModel *)taskModel
{
    _taskModel = taskModel;
}


@end
