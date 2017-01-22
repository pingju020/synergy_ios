//
//  NSDate+LJAdditions.m
//  jialin
//
//  Created by LeonJing on 4/8/16.
//  Copyright © 2016 sanlimi  . All rights reserved.
//

#import "NSDate+LJAdditions.h"

@implementation NSDate (LJAdditions)
- (NSString *) lj_stringWithFormat:(NSString *)format {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    NSString *timestamp_str = [outputFormatter stringFromDate:self];
    return timestamp_str;
}

- (BOOL) lj_isEqualDay:(NSDate*)date
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
#else
    unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
#endif
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:self];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

- (NSDate*) lj_date00
{
    NSDate* date1=nil;
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
#else
    unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
#endif
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    date1 = [calendar dateFromComponents:components];
    
    return date1;
}
- (NSDate*) lj_date24
{
    NSDate* date1=nil;
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
#else
    unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
#endif
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    
    date1 = [calendar dateFromComponents:components];
    
    return date1;
}


-(NSInteger)lj_year {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    unitFlags = NSCalendarUnitYear;
#else
    unitFlags = NSYearCalendarUnit;
#endif
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    
    return [components year];
}


-(NSInteger)lj_month {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    unitFlags = NSCalendarUnitMonth;
#else
    unitFlags = NSMonthCalendarUnit;
#endif
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    
    return [components month];
}

-(NSInteger)lj_day {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    unitFlags = NSCalendarUnitDay;
#else
    unitFlags = NSDayCalendarUnit;
#endif
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    
    return [components day];
}

- (long long) lj_unixSeconds{
    return (long long)[self timeIntervalSince1970];
}

- (long long) lj_unixMilliseconds{
    return [self lj_unixSeconds]*1000L;
}

@end
