//
//  AddButtonTableViewCell.h
//  Cooperation
//
//  Created by yangjuanping on 2017/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FactorModel;
@protocol AddPassValue <NSObject>

- (void)AddPassValue:(NSString*)Text;

@end
@interface AddButtonTableViewCell : UITableViewCell
@property(nonatomic,strong)FactorModel* model;
@property(nonatomic,strong) id<AddPassValue>delegate;
@end
