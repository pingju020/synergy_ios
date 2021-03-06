//
//  SumHeader.m
//  Cooperation
//
//  Created by LeonJing on 22/01/2017.
//  Copyright © 2017 Tion. All rights reserved.
//

#import "SumHeader.h"
#import "UIView+LJAdditions.h"

void LJGCDDelay(NSTimeInterval delayInSeconds, dispatch_block_t handler)
{
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), handler);
}

@implementation SumHeader
- (instancetype) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self commoninit];
    }
    return self;
}

- (void) onButtonLeft:(UIButton*)btn{
    self.ivArrowLeft.image = [UIImage imageNamed:@"汇总-左箭头2"];
    LJGCDDelay(0.3f, ^{
        self.ivArrowLeft.image = [UIImage imageNamed:@"汇总-左箭头1"];
    });
    if (self.onDidSelectedAtLeft) {
        self.onDidSelectedAtLeft();
    }
}
- (void) onButtonCenter:(UIButton*)btn{
    
}

- (void) onButtonRight:(UIButton*)btn{
    self.ivArrowRight.image = [UIImage imageNamed:@"汇总-右箭头2"];
    LJGCDDelay(0.3f, ^{
        self.ivArrowRight.image = [UIImage imageNamed:@"汇总-右箭头1"];
    });

    if (self.onDidSelectedAtRight) {
        self.onDidSelectedAtRight();
    }
}

- (void) commoninit{
    _buttonLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    //_buttonLeft.backgroundColor = [UIColor redColor];
    [_buttonLeft addTarget:self action:@selector(onButtonLeft:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_buttonLeft];
    
    _buttonCenter = [UIButton buttonWithType:UIButtonTypeCustom];
    //_buttonCenter.backgroundColor = [UIColor grayColor];
    [_buttonCenter addTarget:self action:@selector(onButtonCenter:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_buttonCenter];
    
    _buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
    //buttonRight.backgroundColor = [UIColor blueColor];
    [_buttonRight addTarget:self action:@selector(onButtonRight:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_buttonRight];
    
    _ivArrowLeft = [[UIImageView alloc]initWithFrame:(CGRect){0}];
    _ivArrowLeft.image = [UIImage imageNamed:@"汇总-左箭头1"];
    [self addSubview:_ivArrowLeft];
    
    _ivArrowRight = [[UIImageView alloc]initWithFrame:(CGRect){0}];
    _ivArrowRight.image = [UIImage imageNamed:@"汇总-右箭头1"];
    [self addSubview:_ivArrowRight];
    
    _labelDate = [[UILabel alloc]initWithFrame:(CGRect){0}];
    _labelDate.textAlignment = NSTextAlignmentRight;
    _labelDate.font = [UIFont systemFontOfSize:12.f];
    _labelDate.textColor = [UIColor lightGrayColor];
    [self addSubview:_labelDate];
    
    _imageDate = [[UIImageView alloc]initWithFrame:(CGRect){0}];
    _imageDate.image = [UIImage imageNamed:@"日历"];
    [self addSubview:_imageDate];
    
}

- (void) commonlayout{
    _buttonLeft.lj_width = self.lj_width*0.35f;
    _buttonLeft.lj_height = self.lj_height;
    _buttonLeft.lj_left = 0;
    _buttonLeft.lj_top = 0;
    
    _buttonCenter.lj_width = self.lj_width*0.3f;
    _buttonCenter.lj_height = self.lj_height;
    _buttonCenter.lj_left = _buttonLeft.lj_right;
    _buttonCenter.lj_top = 0;
    
    _buttonRight.lj_width = self.lj_width*0.35f;
    _buttonRight.lj_height = self.lj_height;
    _buttonRight.lj_left = _buttonCenter.lj_right;
    _buttonRight.lj_top = 0;
    
    _ivArrowLeft.lj_width = 10;
    _ivArrowLeft.lj_height = 10;
    _ivArrowLeft.lj_right = _buttonLeft.lj_right-10.f;
    _ivArrowLeft.lj_centerY = _buttonLeft.lj_centerY;
    
    _ivArrowRight.lj_width = 10;
    _ivArrowRight.lj_height = 10;
    _ivArrowRight.lj_left = _buttonRight.lj_left+10.f;
    _ivArrowRight.lj_centerY = _buttonRight.lj_centerY;
    
    _imageDate.lj_width = 10;
    _imageDate.lj_height = 10;
    _imageDate.lj_right = _buttonCenter.lj_right-5;
    _imageDate.lj_centerY = _buttonCenter.lj_centerY;
    
    _labelDate.lj_width = _buttonCenter.lj_width - _imageDate.lj_width-5;
    _labelDate.lj_height = _buttonCenter.lj_height;
    _labelDate.lj_right = _imageDate.lj_left;
    _labelDate.lj_centerY = _buttonCenter.lj_centerY;
    
}

- (void) layoutSubviews{
    [super layoutSubviews];
    
    [self commonlayout];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
