//
//  NSDate+LJAdditions.h
//  jialin
//
//  Created by LeonJing on 4/8/16.
//  Copyright © 2016 sanlimi  . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LJAdditions)

- (NSString*) lj_stringWithFormat:(NSString *)format;

- (BOOL) lj_isEqualDay:(NSDate*)date;

- (NSDate*) lj_date00;

- (NSDate*) lj_date24;

- (NSInteger) lj_year;

- (NSInteger) lj_month;

- (NSInteger) lj_day;

- (long long) lj_unixSeconds;

- (long long) lj_unixMilliseconds;

@end
