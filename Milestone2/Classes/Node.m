//
//  Node.m
//  Milestone2
//
//  Created by Marty Ulrich on 2/13/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Node.h"
#import "LexicalAnalyzer.h"

@interface Node ()

@property(nonatomic)int lexLine;

@end


@implementation Node

- (instancetype)initWithToken:(Token*)tok
{
    self = [super init];
    if (self) {
		_children = [NSMutableArray array];
		_token = tok;
    }
    return self;
}


- (void) addChildNode:(Node*)node
{
	[self.children addObject:node];
}

- (void) printChildren
{
	if (self.children.count)
	{
		for (Node *node in self.children)
			[node printChildren];
	}
	else
		NSLog(@"%@", self.token);
}


@end
