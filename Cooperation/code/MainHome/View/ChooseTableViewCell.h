//
//  ChooseTableViewCell.h
//  Cooperation
//
//  Created by yangjuanping on 2017/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FactorModel;
@protocol ChoosePassValue <NSObject>

- (void)ChoosePassValue:(NSString*)Text;

@end
@interface ChooseTableViewCell : UITableViewCell
@property(nonatomic,strong)FactorModel* model;
@property(nonatomic,strong) id<ChoosePassValue>delegate;
@end
