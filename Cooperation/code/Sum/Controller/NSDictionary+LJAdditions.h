//
//  NSDictionary+LJAdditions.h
//  jialin
//
//  Created by LeonJing on 4/7/16.
//  Copyright © 2016 sanlimi  . All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary<KeyType, ObjectType> (LJAdditions)

///------------------------------------------------------------------------------------------------
/// @name 函数式便捷方法
///------------------------------------------------------------------------------------------------

- (NSArray *)lj_map:(id _Nullable (^)(KeyType key, ObjectType obj))map;

- (instancetype)lj_filter:(BOOL (^)(KeyType key, ObjectType obj))filter;

- (nullable id)lj_reduceWithInitial:(nullable id)initial
combine:(id _Nullable (^)(id _Nullable current, KeyType key, ObjectType obj))combine;

- (NSNumber*) lj_numberForKey:(NSString*)key;
- (NSNumber *)lj_numberForKey:(id)key default:(NSNumber *_Nullable)defaultValue;

- (NSString *)lj_stringForKey:(id)key;
- (NSString *)lj_stringForKey:(id)key default:(NSString *)defaultValue;

- (NSArray *)lj_arrayForKey:(id)key default:(NSArray *)defaultValue;
- (NSArray *)lj_arrayForKey:(id)key;

- (NSDictionary *)lj_dictionaryForKey:(id)key default:(NSDictionary *)defaultValue;
- (NSDictionary *)lj_dictionaryForKey:(id)key;

- (NSDate *)lj_dateForKey:(id)key default:(NSDate*_Nullable)defaultValue;
- (NSDate *)lj_dateForKey:(id)key;

@end

