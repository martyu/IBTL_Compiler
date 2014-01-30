//
//  Token.m
//  Milestone2
//
//  Created by Marty Ulrich on 1/25/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Token.h"

@implementation Token

- (instancetype) initWithTag:(int)theTag type:(TokenType)theType
{
    self = [super init];
    if (self) {
        _tag = theTag;
    }
    return self;
}

+ (instancetype) tokenWithTag:(int)theTag type:(TokenType)theType
{
	return [[[self class] alloc] initWithTag:theTag type:theType];
}


- (NSString*)description
{
	return [NSString stringWithFormat:@"<%@, tag:%i>", [self class], self.tag];
}

struct TokenLocation tokenLocationMake(int theLine, int theRow)
{
	struct TokenLocation loc;
	loc.line = theLine;
	loc.row = theRow;

	return loc;
}

@end
