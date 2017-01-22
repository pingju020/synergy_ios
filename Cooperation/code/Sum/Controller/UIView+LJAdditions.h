//
//  UIView+LJAdditions.h
//  jialin
//
//  Created by LeonJing on 4/7/16.
//  Copyright © 2016 sanlimi  . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIView (LJAdditions)

@property (nonatomic, assign) CGSize  lj_size;
@property (nonatomic, assign) CGFloat lj_width;
@property (nonatomic, assign) CGFloat lj_height;

@property (nonatomic, assign) CGPoint lj_origin;
@property (nonatomic, assign) CGFloat lj_originX;
@property (nonatomic, assign) CGFloat lj_originY;

@property (nonatomic, assign) CGFloat lj_centerX;
@property (nonatomic, assign) CGFloat lj_centerY;

@property (nonatomic, assign) CGFloat lj_top;
@property (nonatomic, assign) CGFloat lj_left;
@property (nonatomic, assign) CGFloat lj_bottom;
@property (nonatomic, assign) CGFloat lj_right;


/**
 *  @c self.layer.cornerRadius
 */
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
/**
 *  @c self.layer.borderWidth
 */
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
/**
 *  @c self.layer.borderColor
 */
@property (nullable, nonatomic, strong) IBInspectable UIColor *borderColor;

///------------------------------------------------------------------------------------------------
/// @name UINib 相关方法
///------------------------------------------------------------------------------------------------

/**
 *  返回 @c UINib 对象.即 @c [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil].
 */
+ (UINib *)lj_nib;

/**
 *  返回类名字符串.即 @c NSStringFromClass([self class]).
 */
+ (NSString *)lj_nibName;

/**
 *  使用和类名同名的 @c xib 文件实例化视图.
 *
 *  @see +lj_instantiateFromNibWithOwner:options:
 */
+ (instancetype)lj_instantiateFromNib;

/**
 *  使用和类名同名的 @c xib 文件实例化视图.
 */
+ (instancetype)lj_instantiateFromNibWithOwner:(nullable id)ownerOrNil
                                       options:(nullable NSDictionary *)optionsOrNil;

///------------------------------------------------------------------------------------------------
/// @name 其他
///------------------------------------------------------------------------------------------------

/**
 *  获取视图所属的视图控制器,即响应链上最近的 @c UIViewController.
 */
- (nullable __kindof UIViewController *)lj_viewController;

/**
 *  获取视图所属的导航控制器,即响应链上最近的 @c UINavigationController.
 */
- (nullable __kindof UINavigationController *)lj_navigationController;

/**
 *  获取视图所属的选项卡控制器,即响应链上最近的 @c UITabBarController.
 */
- (nullable __kindof UITabBarController *)lj_tabBarController;

/**
 *  执行晃动动画.
 */
- (void)lj_shakeAnimation;
/**
 *  执行缩放动画
 */
- (void)lj_scaleAnimation;

/**
 *  获取父级tablecell
 *
 *  @return cell
 */
- (UITableViewCell *)lj_containingUITableViewCell;

@end
NS_ASSUME_NONNULL_END