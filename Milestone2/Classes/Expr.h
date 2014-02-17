//
//  Expr.h
//  Milestone2
//
//  Created by Marty Ulrich on 2/13/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Tree.h"

@class Token;

@interface Expr : Tree

@property(nonatomic, strong) Token *op;
//@property(nonatomic, strong) Type type;

@end
