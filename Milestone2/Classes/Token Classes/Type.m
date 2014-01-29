//
//  Type.m
//  Milestone2
//
//  Created by Marty Ulrich on 1/28/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Type.h"

@implementation Type

- (instancetype)initWithLexeme:(NSString *)theLexeme tag:(int)theTag width:(int)theWidth
{
    self = [super initWithLexeme:theLexeme tag:theTag];
    if (self) {
		_width = theWidth;
    }
    return self;
}

+ (instancetype)typeWithWordType:(WordType)theType
{
	int wid;
	NSString *lex;

	switch (theType) {
		case WordTypeBool:
			wid = 1;
			lex = @"bool";
			break;

		case WordTypeChar:
			wid = 1;
			lex = @"char";
			break;

		case WordTypeFloat:
			wid = 8;
			lex = @"float";
			break;

		case WordTypeInt:
			wid = 4;
			lex = @"int";
			break;

		default:
			break;
	}

	return [[[self class] alloc] initWithLexeme:lex tag:BASIC width:wid];
}

+ (BOOL)typeIsNumeric:(Type*)p
{
	if ([p.lexeme isEqualToString:INT_TYPE] || [p.lexeme isEqualToString:FLOAT_TYPE] || [p.lexeme isEqualToString:CHAR_TYPE] )
		return true;

	return false;
}

+ (Type*)max:(Type*)p1 :(Type*)p2
{
	if ( ![Type typeIsNumeric:p1] || ![Type typeIsNumeric:p2])
		return nil;

	if ([p1.lexeme isEqualToString:FLOAT_TYPE] || [p2.lexeme isEqualToString:FLOAT_TYPE])
		return [Type typeWithWordType:WordTypeFloat];

	if ([p1.lexeme isEqualToString:INT_TYPE] || [p2.lexeme isEqualToString:INT_TYPE])
		return [Type typeWithWordType:WordTypeInt];

	return [Type typeWithWordType:WordTypeChar];
}

@end
