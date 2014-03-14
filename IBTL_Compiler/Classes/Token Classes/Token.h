//
//  Token.h
//  Milestone2
//
//  Created by Marty Ulrich on 1/25/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Defines.h"

typedef enum {
	TokenTypeBinOp = 1,
	TokenTypeUnOp,
	TokenTypeBool,
	TokenTypeName,
    TokenTypeConstant,
	TokenTypeConditional,
	TokenTypeLet,
	TokenTypeStdOut,
	TokenTypeAssign,
	TokenTypeType,
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
/** The string to use for this token in the gforth output. */
@property (nonatomic, readonly) NSString *codeOutput;


- (instancetype) initWithTag:(int)theTag type:(TokenType)theType;
+ (instancetype) tokenWithTag:(int)theTag type:(TokenType)theType;

@end