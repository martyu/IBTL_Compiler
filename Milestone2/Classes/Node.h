//
//  Node.h
//  Milestone2
//
//  Created by Marty Ulrich on 2/13/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Token Classes/Token.h"

typedef enum {
	ProductionTypeStmts,
	ProductionTypeT,
	ProductionTypeS,
	ProductionTypeExpr,
	ProductionTypeOper,
	ProductionTypeIfStmt,
	ProductionTypeWhileStmt,
	ProductionTypeLetStmt,
	ProductionTypeVarlistStmt,
	ProductionTypePrintStmts,
	ProductionTypeExprList
} ProductionType;

@interface Node : NSObject

@property(nonatomic, strong) NSMutableArray *children;
@property(nonatomic, strong) Token *token;
@property(nonatomic) ProductionType production;

- (void) addChild:(Node*)node;
- (void) printChildren;

- (instancetype)initWithToken:(Token*)tok;
- (instancetype)initWithProduction:(ProductionType)prodType;

@end