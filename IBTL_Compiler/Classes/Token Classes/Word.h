//
//  Word.h
//  Milestone2
//
//  Created by Marty Ulrich on 1/28/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Token.h"
#import "Defines.h"

typedef enum {
	WordSetupTypeAnd,
	WordSetupTypeOr,
	WordSetupTypeTrue,
	WordSetupTypeFalse,
	WordSetupTypeNot,
	WordSetupTypeSin,
	WordSetupTypeCos,
	WordSetupTypeTan,
	WordSetupTypeLet,
	WordSetupTypeBool,
	WordSetupTypeInt,
	WordSetupTypeFloat,
	WordSetupTypeString,
	WordSetupTypeIf,
	WordSetupTypeWhile,
	WordSetupTypeStdOut,
} WordSetupType;

typedef enum {
	VariableTypeInt,
	VariableTypeFloat,
} VariableType;

@interface Word : Token

@property(strong, nonatomic) NSString *lexeme;
@property(nonatomic) VariableType varType;

- (instancetype)initWithLexeme:(NSString*)theLexeme tag:(int)theTag type:(TokenType)tokType;
+ (instancetype)wordWithType:(WordSetupType)type;

@end