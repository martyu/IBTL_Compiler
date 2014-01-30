//
//  Token.h
//  Milestone2
//
//  Created by Marty Ulrich on 1/25/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Defines.h"

typedef enum {
	TokenTypeBinOp,
	TokenTypeUnOp,
	TokenTypeTypeDef,
	TokenTypeBool,
	TokenTypeWord,
	TokenTypeReal,
	TokenTypeInt,
	TokenTypeConditional,
	TokenTypeLet,
	TokenTypeStdOut,
	TokenTypeAssign,
	TokenTypeNone
} TokenType;

struct TokenLocation {
	int line;
	int row;
};


struct TokenLocation tokenLocationMake(int theLine, int theRow);
typedef NSString Lexeme;


@interface Token : NSObject

@property (nonatomic, readonly) int tag;
@property (nonatomic) TokenType tokType;

- (instancetype) initWithTag:(int)theTag type:(TokenType)theType;
+ (instancetype) tokenWithTag:(int)theTag type:(TokenType)theType;

@end