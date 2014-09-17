//
//  TodoItem.m
//  TodoList
//
//  Created by Nick Lockwood on 08/04/2010.
//  Copyright 2010 Charcoal Design. All rights reserved.
//

#import "TodoItem.h"


@implementation TodoItem

@synthesize label = _label, checked = _checked;

+ (TodoItem *)itemWithLabel:(NSString *)label
{
    TodoItem *item = [[self alloc] init];
    item.label = label;
    return item;
}

#pragma mark -
#pragma mark NSCoding

- (instancetype)initWithCoder:(NSCoder *)decoder
{    
    if ((self = [super init]))
    {
        self.label = [decoder decodeObjectForKey:@"label"];
        self.checked = [[decoder decodeObjectForKey:@"checked"] boolValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.label forKey:@"label"];
    [encoder encodeObject:@(self.checked) forKey:@"checked"];
}

#pragma mark -
#pragma mark Cleanup


@end
