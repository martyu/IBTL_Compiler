//
//  Token.m
//  Milestone2
//
//  Created by Marty Ulrich on 1/25/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Token.h"

@implementation Token

- (instancetype)initWithTag:(int)theTag
{
    self = [super init];
    if (self) {
        _tag = theTag;
    }
    return self;
}

- (instancetype) initWithLexeme:(NSString*)theLexeme attribute:(id)theAttribute
{
    self = [super init];
    if (self) {
		_attribute = theAttribute;
    }
    return self;
}

struct TokenLocation tokenLocationMake(int theLine, int theRow)
{
	struct TokenLocation loc;
	loc.line = theLine;
	loc.row = theRow;

	return loc;
}

@end
