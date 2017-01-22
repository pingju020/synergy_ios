//
//  SelectOperatorViewController.h
//  Cooperation
//
//  Created by Tion on 17/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "BaseViewController.h"

@protocol ChoosePeopleDelegate <NSObject>
-(void)chooseOperatorOrManagerWithName:(NSString*)name AndId:(NSString*)peopleid;
@end


@interface SelectOperatorViewController : BaseViewController
@property(nonatomic,strong) id<ChoosePeopleDelegate>delegate;

- (instancetype)initWithSelectType:(NSString*)type;

@end


