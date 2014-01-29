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

- (instancetype)initWithType:(WordType)type
{
	NSString *lex;
	int theTag;

	switch (type) {
		case WordTypeAnd:
			lex = @"&&";
			theTag = AND;
			break;

		case WordTypeEq:
			lex = @"==";
			theTag = EQ;
			break;


		default:
			break;
	}
}

@end