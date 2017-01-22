//
//  FileTableCell.h
//  Cooperation
//
//  Created by Tion on 17/1/22.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *FileImageView;
@property (weak, nonatomic) IBOutlet UILabel *FileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *DateLabel;
@property (weak, nonatomic) IBOutlet UILabel *FilePeopleName;
@property (weak, nonatomic) IBOutlet UIView *BottomLineView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
