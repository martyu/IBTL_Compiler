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
		_token = tok;
    }
    return self;
}

- (instancetype)initWithProduction:(ProductionType)prodType
{
    self = [super init];
    if (self) {
        _production = prodType;
    }
    return self;
}

- (void) addChild:(Node*)node
{
	[self.children addObject:node];
}

- (NSString*)description
{
	if (!self.children.count)
		return @"empty Node";
	
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
		printf("%s\n", [[self productionDescription] UTF8String]);
		for (Node *node in self.children)
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


- (NSString*) productionDescription
{
	switch (self.production) {
		case ProductionTypeExprList:
			return @"expr list";
			break;

		case ProductionTypeExpr:
			return @"expr";
			break;

		case ProductionTypePrintStmts:
			return @"print";
			break;

		case ProductionTypeVarlistStmt:
			return @"varlist";
			break;

		case ProductionTypeLetStmt:
			return @"let";
			break;

		case ProductionTypeWhileStmt:
			return @"while";
			break;

		case ProductionTypeIfStmt:
			return @"if";
			break;

		case ProductionTypeStmts:
			return @"stmts";
			break;

		case ProductionTypeS:
			return @"S";
			break;

		case ProductionTypeOper:
			return @"oper";
			break;

		case ProductionTypeT:
			return @"T";
			break;

		default:
			break;
	}
}

@end
