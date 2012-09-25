//
//  TodoList.m
//  TodoList
//
//  Created by Nick Lockwood on 15/04/2010.
//  Copyright 2010 Charcoal Design. All rights reserved.
//

#import "TodoList.h"
#import "TodoItem.h"


@implementation TodoList

@synthesize items = _items;


#pragma mark -
#pragma mark Loading and saving

+ (NSString *)documentsDirectory
{	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

+ (TodoList *)sharedList
{	
    static TodoList *sharedList = nil;
	if (sharedList == nil)
    {
        //attempt to load saved file
        NSString *path = [[self documentsDirectory] stringByAppendingPathComponent:@"TodoList.plist"];
        sharedList = [[CryptoCoder unarchiveObjectWithFile:path] retain];
        
        //if that fails, create new list
		if (sharedList == nil)
        {
            sharedList = [[TodoList alloc] init];
		}
	}
	return sharedList;
}

- (id)init
{
    if ((self = [super init]))
    {
        //load default items
        _items = [[NSMutableArray alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"TodoList" ofType:@"plist"];
        for (NSString *label in [NSArray arrayWithContentsOfFile:path])
        {
            [_items addObject:[TodoItem itemWithLabel:label]];
        }
    }
    return self;
}

+ (NSString *)CCPassword
{
    //password
    return @"YsMXOHm2vsoIxTdSZWMILEVnQtgupefHGSROCLmwTnX3wBaCac";
}

- (void)save;
{	
	NSString *path = [[[self class] documentsDirectory] stringByAppendingPathComponent:@"TodoList.plist"];
	[CryptoCoder archiveRootObject:self toFile:path];
}


#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init]))
    {
        self.items = [aDecoder decodeObjectForKey:@"items"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.items forKey:@"items"];
}


#pragma mark -
#pragma mark Cleanup

- (void)dealloc
{
	[_items release];
	[super dealloc];
}

@end
