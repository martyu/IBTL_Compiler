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
		_token = tok;
    }
    return self;
}


- (void) addChild:(Tree*)node
{
	[self.children addObject:node];
}

- (NSString*)description
{
	if (!self.children.count)
		return @"empty tree";
	
	[self printChildren];
	return @" ";
}

- (void) printChildren
{
	static int depth = 0;

	if (self.children.count)
	{
		for(int i = 0; i < depth; i++)
			printf("\t");
		printf("production\n");
		for (Tree *node in self.children)
		{
			for(int i = 0; i < depth; i++)
				printf("\t");
			printf("{\n");
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

	for(int i = 0; i < depth; i++)
		printf("\t");
	printf("}\n");
}


- (NSMutableArray*)children
{
	if (!_children)
		_children =  [NSMutableArray array];

	return _children;
}

@end
