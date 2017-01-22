//
//  FolderTableCell.h
//  Cooperation
//
//  Created by Tion on 17/1/22.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FolderTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *FoldImageView;
@property (weak, nonatomic) IBOutlet UILabel *FoldNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *FoldNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ArrowRightImageView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
