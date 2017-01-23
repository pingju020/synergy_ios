//
//  ProjectStageSectionView.m
//  Cooperation
//
//  Created by 葛君语 on 2017/1/23.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "ProjectStageSectionView.h"

@interface ProjectStageSectionView ()

@property (nonatomic,strong) UILabel *indexLabel;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *removeButton;

@end

@implementation ProjectStageSectionView





#pragma mark -btnAction
- (void)removeClicked
{
    if ([self.delegate respondsToSelector:@selector(projectStageSectionRemove:)]) {
        [self.delegate projectStageSectionRemove:_section];
    }
}


#pragma mark -赋值
- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleLabel.text = title;
}

- (void)setSection:(NSInteger)section
{
    _section = section;
    
    self.indexLabel.text = [NSString stringWithFormat:@"%li",section+1];
}

#pragma mark -setUI
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.indexLabel.frame = CGRectMake(10, (self.height-15)/2, 15, 15);
    
    self.removeButton.frame = CGRectMake(self.width-10-15, (self.height-15)/2, 15, 15);
    
    self.titleLabel.frame = CGRectMake(self.indexLabel.right+5, (self.height-20)/2, self.removeButton.left-5-(_indexLabel.right+5), 20);

}


- (UILabel *)indexLabel
{
    if (!_indexLabel) {
        _indexLabel = [UILabel new];
        _indexLabel.backgroundColor = [UIColor colorWithHexString:@"#516CB8"];
        _indexLabel.font = [UIFont systemFontOfSize:12];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_indexLabel];
    }
    return _indexLabel;
}

- (UIButton *)removeButton
{
    if (!_removeButton) {
        _removeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        _removeButton.backgroundColor = [UIColor greenColor];
        [_removeButton addTarget:self action:@selector(removeClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_removeButton];
    }
    return _removeButton;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.indexLabel.right+5, 0, 10, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
        
    }
    return _titleLabel;
}


@end
