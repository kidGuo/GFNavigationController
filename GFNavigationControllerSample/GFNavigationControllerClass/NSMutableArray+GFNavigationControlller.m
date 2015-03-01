//
//  NSMutableArray+GFNavigationControlller.m
//  GFNavigationControllerSample
//
//  Created by MeTao on 15/3/1.
//  Copyright (c) 2015年 kid. All rights reserved.
//

#import "NSMutableArray+GFNavigationControlller.h"

@implementation NSMutableArray (GFNavigationControlller)

- (void)gf_removeObjectsFromIndex:(NSUInteger)index {
    
    if (self.count > index) {
        NSMutableArray *deletedArray = [NSMutableArray array];
        
        for (NSUInteger startIndex = index + 1; startIndex < self.count; startIndex++) {
            [deletedArray addObject:[self objectAtIndex:startIndex]];
        }
        
        [self removeObjectsInArray:deletedArray];
    }
}

@end
