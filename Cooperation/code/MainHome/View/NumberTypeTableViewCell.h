//
//  NumberTypeTableViewCell.h
//  Cooperation
//
//  Created by yangjuanping on 2017/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FactorModel;
@protocol NumberPassValue <NSObject>

- (void)NumberPassValue:(NSString*)Text;

@end
@interface NumberTypeTableViewCell : UITableViewCell
@property(nonatomic,strong) id<NumberPassValue>delegate;
@property(nonatomic,strong)FactorModel* model;
@end
