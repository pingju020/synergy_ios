//
//  ProjectMessageCell.h
//  Cooperation
//
//  Created by Tion on 17/1/20.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectMessageCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *MessgaeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *StatusImageView;
@property (weak, nonatomic) IBOutlet UIImageView *MarkImageView;
@property (weak, nonatomic) IBOutlet UILabel *StatusLabel;


@end
