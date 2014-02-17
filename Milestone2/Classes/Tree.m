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

- (instancetype)init
{
    self = [super init];
    if (self) {
		_children = [NSMutableArray array];
    }
    return self;

}

- (void) addChild:(Tree*)node
{
	[self.children addObject:node];
}

- (void) printChildren
{
	static int depth = 0;

	if (self.children.count)
	{
		for (Tree *node in self.children)
		{
			depth++;
			[node printChildren];
		}
	}
	else
	{
		for(int i = 0; i < depth; i++)
			printf("\t");
		printf("%s\n", [[self.token description] UTF8String]);
	}

	depth--;
}

@end
