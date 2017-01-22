//
//  SumHeader.h
//  Cooperation
//
//  Created by LeonJing on 22/01/2017.
//  Copyright © 2017 Tion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SumHeader : UIView

@property (nonatomic,strong) UIButton* buttonLeft;
@property (nonatomic,strong) UIButton* buttonCenter;
@property (nonatomic,strong) UIButton* buttonRight;
@property (nonatomic,strong) UIImageView* ivArrowLeft;
@property (nonatomic,strong) UIImageView* ivArrowRight;
@property (nonatomic,strong) UILabel* labelDate;
@property (nonatomic,strong) UIImageView* imageDate;

@property (nonatomic,copy) void (^onDidSelectedAtLeft)();
@property (nonatomic,copy) void (^onDidSelectedAtRight)();

@end
