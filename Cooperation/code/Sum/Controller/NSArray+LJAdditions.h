//
//  NSArray+LJAdditions.h
//  jialin
//
//  Created by LeonJing on 4/7/16.
//  Copyright © 2016 sanlimi  . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<ObjectType> (LJAdditions)

///------------------------------------------------------------------------------------------------
/// @name 常用方法
///------------------------------------------------------------------------------------------------

/**
 *  根据相关资源在 mainBundle 中的路径创建数组.路径须带拓展名.
 */
+ (nullable instancetype)lj_arrayWithResourcePath:(NSString *)path;

///------------------------------------------------------------------------------------------------
/// @name 函数式便捷方法
///------------------------------------------------------------------------------------------------

- (instancetype)lj_filter:(BOOL (^)(ObjectType obj))filter;

- (__kindof instancetype)lj_map:(id _Nullable (^)(ObjectType obj, BOOL *stop))map;

- (nullable id)lj_reduceWithInitial:(nullable id)initial
combine:(id _Nullable (^)(id _Nullable current, id ObjectType))combine;

-(id) lj_safeObjectAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
