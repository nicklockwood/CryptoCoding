//
//  TodoList.h
//  TodoList
//
//  Created by Nick Lockwood on 15/04/2010.
//  Copyright 2010 Charcoal Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CryptoCoding.h"


@interface TodoList : NSObject <CryptoCoding>

@property (nonatomic, strong) NSMutableArray *items;

+ (TodoList *)sharedList;
- (void)save;
    
@end
