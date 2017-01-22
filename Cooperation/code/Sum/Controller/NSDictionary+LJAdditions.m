//
//  NSDictionary+LJAdditions.m
//  jialin
//
//  Created by LeonJing on 4/7/16.
//  Copyright © 2016 sanlimi  . All rights reserved.
//

#import "NSDictionary+LJAdditions.h"

@implementation NSDictionary (LJAdditions)

#pragma mark - 函数式便捷方法

- (NSArray *)lj_map:(id _Nullable (^)(id _Nonnull, id _Nonnull))map
{
    NSMutableArray *array = [NSMutableArray new];
    
    if (self.count == 0) {
        return array;
    }
    
    [self enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key,
                                              id _Nonnull obj,
                                              BOOL * _Nonnull stop) {
        id result = map(key, obj);
        if (result) {
            [array addObject:result];
        }
    }];
    return array; // 出于性能考虑就不 copy 了.
}

- (instancetype)lj_filter:(BOOL (^)(id _Nonnull, id _Nonnull))filter
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    if (self.count == 0) {
        return dict;
    }
    
    [self enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key,
                                              id _Nonnull obj,
                                              BOOL * _Nonnull stop) {
        if (filter(key, obj)) {
            dict[key] = obj;
        }
    }];
    
    return dict; // 出于性能考虑就不 copy 了.
}

- (id)lj_reduceWithInitial:(id)initial
                   combine:(id _Nullable (^)(id _Nullable, id _Nonnull, id _Nonnull))combine
{
    __block id result = initial;
    
    if (self.count == 0) {
        return result;
    }
    
    [self enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key,
                                              id _Nonnull obj,
                                              BOOL * _Nonnull stop) {
        result = combine(result, key, obj);
    }];
    return result;
}

#pragma mark - log 增强


- (NSNumber*) lj_numberForKey:(NSString*)key
{
    return [self lj_numberForKey:key default:nil];
}

- (NSNumber *)lj_numberForKey:(id)key default:(NSNumber *_Nullable)defaultValue{
    NSNumber *ret = nil;
    if (key) {
        id object = [self objectForKey:key];
        if ([object isKindOfClass:[NSNumber class]]) {
            ret = object;
        }
        else if ([object isKindOfClass:[NSString class]]){
            NSNumberFormatter *f = [[NSNumberFormatter alloc]init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            ret = [f numberFromString:object];
        }
        
    }
    ret = ret?:defaultValue;
    return ret;
}

- (id)objectForKey:(id)key ofType:(Class)type default:(id)defaultValue;
{
    id value = [self objectForKey:key];
    
    return [value isKindOfClass:type] ? value : defaultValue;
}

- (NSArray *)lj_arrayForKey:(id)key default:(NSArray *)defaultValue;
{
    return [self objectForKey:key ofType:[NSArray class] default:defaultValue];
}

- (NSArray *)lj_arrayForKey:(id)key;
{
    return [self lj_arrayForKey:key default:[NSArray array]];
}

- (NSString *)lj_stringForKey:(id)key default:(NSString *)defaultValue;
{
    NSString* ret = [self objectForKey:key ofType:[NSString class] default:nil];

    if (nil == ret) {
        NSNumber* ns = [self objectForKey:key ofType:[NSNumber class] default:nil];
        if (ns) {
            ret = [ns stringValue];
        }
    }
    return ret?:defaultValue;
}

- (NSString *)lj_stringForKey:(id)key;
{
    return [self lj_stringForKey:key default:@""];
}

- (NSDictionary *)lj_dictionaryForKey:(id)key default:(NSDictionary *)defaultValue
{
    return [self objectForKey:key ofType:[NSDictionary class] default:defaultValue];
}
- (NSDictionary *)lj_dictionaryForKey:(id)key
{
    return [self lj_dictionaryForKey:key default:@{}];
}

- (NSDate *)lj_dateForKey:(id)key default:(NSDate*_Nullable)defaultValue{
    return [self objectForKey:key ofType:[NSDate class] default:defaultValue];
}
- (NSDate *)lj_dateForKey:(id)key{
    return [self lj_dateForKey:key default:nil];
}

@end
