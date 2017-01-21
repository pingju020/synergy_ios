//
//  ChangeInfoLabel.m
//  Cooperation
//
//  Created by yangjuanping on 2017/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "ChangeInfoLabel.h"

@implementation ChangeInfoLabel

-(id)initWithFrame:(CGRect)frame ChangeInfo:(ChangeInfoModel*)changeInfo{
    if (self = [super initWithFrame:frame]) {
        NSMutableAttributedString* att = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ 将", changeInfo.handlers]];
        
        [att appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"(借款人:%@)",changeInfo.originalName] attributes:@{NSForegroundColorAttributeName:COMMON_CORLOR_HIGHLIGHT}]];
        [att appendAttributedString:[[NSAttributedString alloc]initWithString:@"变更为"]];
        [att appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"(借款人:%@)\r\n",changeInfo.name] attributes:@{NSForegroundColorAttributeName:COMMON_CORLOR_HIGHLIGHT}]];
        
        [att appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"(借款额度:%@)",changeInfo.originalAmount] attributes:@{NSForegroundColorAttributeName:COMMON_CORLOR_HIGHLIGHT}]];
        [att appendAttributedString:[[NSAttributedString alloc]initWithString:@"变更为"]];
        [att appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"(借款额度:%@)\r\n",changeInfo.amount] attributes:@{NSForegroundColorAttributeName:COMMON_CORLOR_HIGHLIGHT}]];
        [att appendAttributedString:[[NSAttributedString alloc]initWithString:changeInfo.time attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}]];
        
        self.attributedText = att;
        self.font = [UIFont systemFontOfSize:14];
        self.numberOfLines = 0;
        self.textAlignment = NSTextAlignmentLeft;
        self.textColor = COMMON_CORLOR_NORMAL;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
