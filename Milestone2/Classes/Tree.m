//
//  Node.m
//  Milestone2
//
//  Created by Marty Ulrich on 2/13/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Tree.h"
#import "LexicalAnalyzer.h"

@interface Tree ()

@property(nonatomic)int lexLine;

@end

@implementation Tree

- (instancetype)initWithToken:(Token*)tok
{
    self = [super init];
    if (self) {
		_children = [NSMutableArray array];
		_token = tok;
    }
    return self;
}

- (void) addChildNode:(Tree*)node
{
	[self.children addObject:node];
}

- (void) printChildren
{
	if (self.children.count)
	{
		for (Tree *node in self.children)
			[node printChildren];
	}
	else
		NSLog(@"%@", self.token);
}


@end
