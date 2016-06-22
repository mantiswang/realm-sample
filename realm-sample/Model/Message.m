//
//  Message.m
//  realm-sample
//
//  Created by onecat on 16/6/21.
//  Copyright © 2016年 onecat. All rights reserved.
//

#import "Message.h"

@implementation Message

+ (NSString *)primaryKey {
    return @"id";
}
// Specify default values for properties

+ (NSDictionary *)defaultPropertyValues
{
    return @{@"type":@1, @"status":@0};
}


// Specify properties to ignore (Realm won't persist these)

+ (NSArray *)ignoredProperties
{
    return @[@"type", @"status"];
}

@end
