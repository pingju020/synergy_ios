//
//  ProjectConditionCell.h
//  Cooperation
//
//  Created by Tion on 17/1/20.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectConditionCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *ConditionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ConditionSelectImageView;
@property (weak, nonatomic) IBOutlet UIView *LineView;

@end
