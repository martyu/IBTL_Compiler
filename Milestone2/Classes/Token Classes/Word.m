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

+ (instancetype)wordWithType:(WordType)theType
{
	NSString *lex;
	int theTag;

	switch (theType) {
			
		default:
			break;
	}

	return [[[self class] alloc] initWithLexeme:lex tag:theTag];
}

-(NSString*)description
{
	NSString *str = [NSString stringWithFormat:@"<%@, lex:%@, tag:%i>", [self class], self.lexeme, self.tag];
	return str;
}


@end

