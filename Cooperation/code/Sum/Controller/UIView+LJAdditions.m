//
//  UIView+LJAdditions.m
//  jialin
//
//  Created by LeonJing on 4/7/16.
//  Copyright © 2016 sanlimi  . All rights reserved.
//

#import "UIView+LJAdditions.h"

@implementation UIView (LJAdditions)
///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - size

- (void)setLj_size:(CGSize)lj_size
{
    CGRect frame = self.frame;
    frame.size   = lj_size;
    self.frame   = frame;
}

- (CGSize)lj_size
{
    return self.frame.size;
}

- (void)setLj_width:(CGFloat)lj_width
{
    CGRect frame     = self.frame;
    frame.size.width = lj_width;
    self.frame       = frame;
}

- (CGFloat)lj_width
{
    return CGRectGetWidth(self.frame);
}

- (void)setLj_height:(CGFloat)lj_height
{
    CGRect frame      = self.frame;
    frame.size.height = lj_height;
    self.frame        = frame;
}

- (CGFloat)lj_height
{
    return CGRectGetHeight(self.frame);
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - origin

- (void)setLj_origin:(CGPoint)lj_origin
{
    CGRect frame = self.frame;
    frame.origin = lj_origin;
    self.frame   = frame;
}

- (CGPoint)lj_origin
{
    return self.frame.origin;
}

- (void)setLj_originX:(CGFloat)lj_originX
{
    CGRect frame   = self.frame;
    frame.origin.x = lj_originX;
    self.frame     = frame;
}

- (CGFloat)lj_originX
{
    return CGRectGetMinX(self.frame);
}

- (void)setLj_originY:(CGFloat)lj_originY
{
    CGRect frame   = self.frame;
    frame.origin.y = lj_originY;
    self.frame     = frame;
}

- (CGFloat)lj_originY
{
    return CGRectGetMinY(self.frame);
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - center

- (void)setLj_centerX:(CGFloat)lj_centerX
{
    self.center = CGPointMake(lj_centerX, self.center.y);
}

- (CGFloat)lj_centerX
{
    return self.center.x;
}

- (void)setLj_centerY:(CGFloat)lj_centerY
{
    self.center = CGPointMake(self.center.x, lj_centerY);
}

- (CGFloat)lj_centerY
{
    return self.center.y;
}

#pragma mark - position

- (CGFloat)lj_left {
    return self.frame.origin.x;
}

- (void)setLj_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)lj_top {
    return self.frame.origin.y;
}

- (void)setLj_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)lj_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setLj_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)lj_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setLj_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - 图层圆角/边框宽度/边框颜色

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor
{
    CGColorRef color = self.layer.borderColor;
    return color ? [UIColor colorWithCGColor:color] : nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Nib 相关方法

+ (UINib *)lj_nib
{
    return [UINib nibWithNibName:NSStringFromClass(self) bundle:nil];
}

+ (NSString *)lj_nibName
{
    return NSStringFromClass(self);
}

+ (instancetype)lj_instantiateFromNib
{
    return [self lj_instantiateFromNibWithOwner:nil options:nil];
}

+ (instancetype)lj_instantiateFromNibWithOwner:(nullable id)ownerOrNil
                                       options:(nullable NSDictionary *)optionsOrNil
{
    NSArray *views = [[self lj_nib] instantiateWithOwner:ownerOrNil options:optionsOrNil];
    for (UIView *view in views) {
        if ([view isMemberOfClass:self]) {
            return view;
        }
    }
    NSAssert(NO, @"文件不存在 => %@", [NSString stringWithFormat:@"%@.xib", [self lj_nibName]]);
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - 获取视图所属的控制器

- (nullable __kindof UIViewController *)lj_viewController
{
    UIResponder *nextResponder = [self nextResponder];
    
    /* 该方法的目的是获取视图控制器,所以只要是 UIViewController 子类就应该认为成立.
     注释的条件是查找 UIViewController 子类但不是 UINavigationController 或 UITabBarController 子类的控制器.
     
     while (nextResponder &&
     (![nextResponder isKindOfClass:[UIViewController class]] ||
     [nextResponder isKindOfClass:[UINavigationController class]] ||
     [nextResponder isKindOfClass:[UITabBarController class]])) {
     nextResponder = nextResponder.nextResponder;
     }
     */
    while (nextResponder && ![nextResponder isKindOfClass:[UIViewController class]]) {
        nextResponder = nextResponder.nextResponder;
    }
    
    return (UIViewController *)nextResponder;
}

- (nullable __kindof UINavigationController *)lj_navigationController
{
    UIResponder *nextResponder = [self nextResponder];
    
    while (nextResponder && ![nextResponder isKindOfClass:[UINavigationController class]]) {
        nextResponder = nextResponder.nextResponder;
    }
    
    return (UINavigationController *)nextResponder;
}

- (nullable __kindof UITabBarController *)lj_tabBarController
{
    UIResponder *nextResponder = [self nextResponder];
    
    while (nextResponder && ![nextResponder isKindOfClass:[UITabBarController class]]) {
        nextResponder = nextResponder.nextResponder;
    }
    
    return (UITabBarController *)nextResponder;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - 晃动动画

- (void)lj_shakeAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    
    animation.keyPath  = @"position.x";
    animation.values   = @[ @0, @10, @-10, @10, @0 ];
    animation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
    animation.duration = 0.4;
    animation.additive = YES;
    
    [self.layer addAnimation:animation forKey:@"shake"];
}
- (void)lj_scaleAnimation
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.removedOnCompletion = YES;
    animation.duration = 0.4;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.layer addAnimation:animation forKey:@"scale"];
}

- (UITableViewCell *)lj_containingUITableViewCell
{
    if (!self.superview)
        return nil;
    
    if ([self.superview isKindOfClass:[UITableViewCell class]])
        return (UITableViewCell *)self.superview;
    
    return [self.superview lj_containingUITableViewCell];
}

@end
