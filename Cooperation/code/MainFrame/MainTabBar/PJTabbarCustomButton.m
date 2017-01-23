//
//  PJTabbarCustomButton.m
//  PJRichText
//
//  Created by yangjuanping on 15/11/18.
//  Copyright © 2015年 yangjuanping. All rights reserved.
//

#import "PJTabbarCustomButton.h"
#import "SystemDefine.h"
#import "ColorDefine.h"

@implementation PJTabbarCustomButton
@synthesize btn = btn;

- (void)dealloc
{
}

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title withUnselectedImg:(NSString *)unSelectedImg withSelectedImg:(NSString *)selecredImg withUnreadType:(UnreadNumType)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.adjustsImageWhenDisabled = NO;
        self.adjustsImageWhenHighlighted = NO;
        self.showsTouchWhenHighlighted = NO;
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.adjustsImageWhenDisabled = NO;
        btn.adjustsImageWhenHighlighted = NO;
        btn.showsTouchWhenHighlighted = NO;

        [btn setFrame:CGRectMake((self.frame.size.width-22)/2,10,22,22)];
        titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0,33, self.frame.size.width, 19)];
        [titleLab setBackgroundColor:[UIColor clearColor]];
        [titleLab setText:title];
        [titleLab setTextAlignment:NSTextAlignmentCenter];
        [titleLab setFont:[UIFont boldSystemFontOfSize:12]];
        [titleLab setTextColor: COMMON_CORLOR_NORMAL];
        [self addSubview:titleLab];
        
        [self addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.userInteractionEnabled = NO;
        [btn setBackgroundImage:[UIImage imageNamed:unSelectedImg] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:selecredImg] forState:UIControlStateSelected];
        
        [self addSubview:btn];
        
    }
    return self;
}


- (void)selected:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if(self.m_delegate &&[self.m_delegate respondsToSelector:@selector(onSelected:)]){
        [self.m_delegate onSelected:self];
    }
}


- (void)setButton:(BOOL)isSelected
{
    // [self setBackgroundColor:isSelected ? UIColorFromRGB(0x52a6e0):[UIColor clearColor]];
    [self setBackgroundColor:[UIColor clearColor]];
    btn.selected = isSelected;
    [titleLab setTextColor: isSelected ? COMMON_CORLOR_HIGHLIGHT :COMMON_CORLOR_NORMAL];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
