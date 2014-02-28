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
			lex = [Defines descriptionForConstant:FALSE_];
			theTag = FALSE_;
			tokType = TokenTypeBool;
			break;

		case WordSetupTypeTrue:
			lex = [Defines descriptionForConstant:TRUE_];
			theTag = TRUE_;
			tokType = TokenTypeBool;
			break;

        case WordSetupTypeAnd:
			lex = [Defines descriptionForConstant:AND];
			theTag = AND;
			tokType = TokenTypeBinOp;
			break;
            
        case WordSetupTypeOr:
			lex = [Defines descriptionForConstant:OR];
			theTag = OR;
			tokType = TokenTypeBinOp;
			break;

		case WordSetupTypeNot:
			lex = [Defines descriptionForConstant:NOT];
			theTag = NOT;
			tokType = TokenTypeUnOp;
			break;

		case WordSetupTypeCos:
			lex = [Defines descriptionForConstant:COS];
			theTag = COS;
			tokType = TokenTypeUnOp;
			break;

		case WordSetupTypeSin:
			lex = [Defines descriptionForConstant:SIN];
			theTag = SIN;
			tokType = TokenTypeUnOp;
			break;

		case WordSetupTypeTan:
			lex = [Defines descriptionForConstant:TAN];
			theTag = TAN;
			tokType = TokenTypeUnOp;
			break;

		case WordSetupTypeBool:
			lex = [Defines descriptionForConstant:BOOL_];
			theTag = TYPE;
			tokType = TokenTypeType;
			break;

		case WordSetupTypeFloat:
			lex = [Defines descriptionForConstant:FLOAT];
			theTag = TYPE;
			tokType = TokenTypeType;
			break;

		case WordSetupTypeString:
			lex = [Defines descriptionForConstant:STRING];
			theTag = TYPE;
			tokType = TokenTypeType;
			break;

		case WordSetupTypeInt:
			lex = [Defines descriptionForConstant:INT];
			theTag = TYPE;
			tokType = TokenTypeType;
			break;

		case WordSetupTypeIf:
			lex = [Defines descriptionForConstant:IF];
			theTag = IF;
			tokType = TokenTypeConditional;
			break;

		case WordSetupTypeWhile:
			lex = [Defines descriptionForConstant:WHILE];
			theTag = WHILE;
			tokType = TokenTypeConditional;
			break;

		case WordSetupTypeLet:
			lex = [Defines descriptionForConstant:LET];
			theTag = LET;
			tokType = TokenTypeLet;
			break;

		case WordSetupTypeStdOut:
			lex = [Defines descriptionForConstant:STDOUT];
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
	NSString *str = [NSString stringWithFormat:@"<%@, lexeme:\"%@\", tag:%@, type:%i>", [super description], self.lexeme, [Defines descriptionForConstant:self.tag], self.tokType];
	return str;
}

- (NSString*)codeOutput
{
	return self.lexeme;
}


@end

