//
//  ProjectStageSectionView.h
//  Cooperation
//
//  Created by 葛君语 on 2017/1/23.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProjectStageSectionDelegate <NSObject>

- (void)projectStageSectionRemove:(NSInteger)section;

@end

#pragma mark - 基类
@interface ProjectStageSectionView : UITableViewHeaderFooterView

@property (nonatomic,assign) NSInteger section;

@property (nonatomic,strong) NSString *title;

@property (nonatomic,weak) id <ProjectStageSectionDelegate>delegate;

@end

