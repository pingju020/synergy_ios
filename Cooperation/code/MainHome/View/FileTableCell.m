//
//  FileTableCell.m
//  Cooperation
//
//  Created by Tion on 17/1/22.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "FileTableCell.h"

@implementation FileTableCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    NSString *ID = @"FileTableCell";
    FileTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FileTableCell" owner:nil options:nil] lastObject];
    }
    [cell.DateLabel setTextColor:[UIColor colorWithHexString:@"#7E7E7E"]];
    [cell.FilePeopleName setTextColor:[UIColor colorWithHexString:@"#7E7E7E"]];
    [cell.FilePeopleName setTextAlignment:NSTextAlignmentRight];
    [cell.BottomLineView setBackgroundColor:[UIColor colorWithHexString:@"#F8F8F8"]];
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
