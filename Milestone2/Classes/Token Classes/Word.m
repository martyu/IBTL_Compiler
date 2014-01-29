//
//  Word.m
//  Milestone2
//
//  Created by Marty Ulrich on 1/28/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Word.h"

@implementation Word

- (instancetype)initWithLexeme:(NSString*)theLexeme tag:(int)theTag
{
    self = [super initWithTag:theTag];
    if (self) {
        _lexeme = theLexeme;
    }
    return self;
}

+ (instancetype)wordWithType:(WordSetupType)type
{
	NSString *lex;
	int theTag;

	switch (type) {
		case WordSetupTypeAnd:
			lex = @"&&";
			theTag = AND;
			break;

		case WordSetupTypeEq:
			lex = @"==";
			theTag = EQ;
			break;

		case WordSetupTypeFalse:
			lex = @"false";
			theTag = FALSE_;
			break;

		case WordSetupTypeGE:
			lex = @">=";
			theTag = GE;
			break;

		case WordSetupTypeLE:
			lex = @"<=";
			theTag = LE;
			break;

		case WordSetupTypeMinus:
			lex = @"-";
			theTag = MINUS;
			break;

		case WordSetupTypeNE:
			lex = @"!=";
			theTag = NE;
			break;

		case WordSetupTypeOr:
			lex = @"||";
			theTag = OR;
			break;

		case WordSetupTypeTemp:
			lex = @"t";
			theTag = TEMP;
			break;

		case WordSetupTypeTrue:
			lex = @"true";
			theTag = TRUE_;
			break;

		default:
			break;
	}

	return [[[self class] alloc] initWithLexeme:lex tag:theTag];
}

@end

