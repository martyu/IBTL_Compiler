//
//  Word.m
//  Milestone2
//
//  Created by Marty Ulrich on 1/28/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Word.h"

@implementation Word

- (instancetype)initWithLexeme:(NSString*)theLexeme tag:(int)theTag type:(TokenType)tokType
{
    self = [super initWithTag:theTag type:tokType];
    if (self) {
        _lexeme = theLexeme;
    }
    return self;
}

+ (instancetype)wordWithType:(WordSetupType)type
{
	NSString *lex;
	int theTag;
	TokenType tokType;

	switch (type) {

		case WordSetupTypeFalse:
			lex = @"false";
			theTag = FALSE_;
			tokType = TokenTypeBool;
			break;

		case WordSetupTypeTrue:
			lex = @"true";
			theTag = TRUE_;
			tokType = TokenTypeBool;
			break;

        case WordSetupTypeAnd:
            lex = @"and";
			theTag = AND;
			tokType = TokenTypeBinOp;
			break;
            
        case WordSetupTypeOr:
            lex = @"or";
			theTag = OR;
			tokType = TokenTypeBinOp;
			break;

		case WordSetupTypeNot:
			lex = @"not";
			theTag = NOT;
			tokType = TokenTypeUnOp;
			break;

		case WordSetupTypeCos:
			lex = @"cos";
			theTag = COS;
			tokType = TokenTypeUnOp;
			break;

		case WordSetupTypeSin:
			lex = @"sin";
			theTag = SIN;
			tokType = TokenTypeUnOp;
			break;

		case WordSetupTypeTan:
			lex = @"tan";
			theTag = TAN;
			tokType = TokenTypeUnOp;
			break;

		case WordSetupTypeBool:
			lex = @"bool";
			theTag = BOOL_;
			tokType = TokenTypeTypeDef;
			break;

		case WordSetupTypeFloat:
			lex = @"float";
			theTag = FLOAT;
			tokType = TokenTypeTypeDef;
			break;

		case WordSetupTypeString:
			lex = @"string";
			theTag = STRING;
			tokType = TokenTypeTypeDef;
			break;

		case WordSetupTypeInt:
			lex = @"int";
			theTag = INT;
			tokType = TokenTypeTypeDef;
			break;

		case WordSetupTypeIf:
			lex = @"if";
			theTag = IF;
			tokType = TokenTypeConditional;
			break;

		case WordSetupTypeWhile:
			lex = @"while";
			theTag = WHILE;
			tokType = TokenTypeConditional;
			break;

		case WordSetupTypeLet:
			lex = @"let";
			theTag = LET;
			tokType = TokenTypeLet;
			break;

		case WordSetupTypeStdOut:
			lex = @"stdout";
			theTag = STDOUT;
			tokType = TokenTypeStdOut;
			break;

		default:
			break;
	}

	return [[[self class] alloc] initWithLexeme:lex tag:theTag type:tokType];
}

-(NSString*)description
{
	NSString *str = [NSString stringWithFormat:@"%@", self.lexeme];
	return str;
}


@end

