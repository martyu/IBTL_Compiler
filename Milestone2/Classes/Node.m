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

+ (instancetype)nodeWithToken:(Token*)tok
{
	return [[[self class] alloc] initWithToken:tok];
}

+ (instancetype)nodeWithProduction:(ProductionType)prodType
{
	return [[[self class] alloc] initWithProduction:prodType];
}

- (void) addChild:(Node*)node
{
	if (node)
		[self.children addObject:node];
	else
		return;
}

- (NSString*)description
{
	if (!self.children.count)
		if (self.production)
			return [self productionDescription];
	
	[self printChildren:0];
	return @" ";
}

- (void) printChildren:(int)depth
{
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
			[node printChildren:depth+1];
		}

		for(int i = 0; i < depth-1; i++)
			printf("\t");
		printf("}\n");

	}
	else if (!self.production)
	{
		for(int i = 0; i < depth; i++)
			printf("\t");
		printf("%s\n", [[self.token description] UTF8String]);

		for(int i = 0; i < depth-1; i++)
			printf("\t");
		printf("}\n");
	}
}

- (void) printChildren
{
	[self printChildren:0];
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
			return @"letstmt";
			break;

		case ProductionTypeWhileStmt:
			return @"whilestmt";
			break;

		case ProductionTypeIfStmt:
			return @"ifstmt";
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

		case ProductionTypeS_:
			return @"S_";
			break;

		default:
			break;
	}
}

@end
