//
//  NSObject+LJAdditions.h
//  jialin
//
//  Created by LeonJing on 4/7/16.
//  Copyright © 2016 sanlimi  . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LJAdditions)

///------------------------------------------------------------------------------------------------
/// @name 关联对象
///------------------------------------------------------------------------------------------------

/**
 *  使用 @c objc_setAssociatedObject 函数根据指定 @c key 关联对象.
 *
 *  @param value 关联的对象.
 *  @param key   关联对象对应的 @c key.
 */
- (void)lj_setValue:( id)value forKey:(NSString *)key;

/**
 *  使用 @c objc_getAssociatedObject 函数获取 @c key 对应的关联对象.
 *
 *  @param key 关联对象的 @c key.
 *
 *  @return @c key 对应的关联对象.
 */
- ( id)lj_valueForKey:(NSString *)key;
@end
