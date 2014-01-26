//
//  Token.m
//  Milestone2
//
//  Created by Marty Ulrich on 1/25/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Token.h"

@implementation Token

- (instancetype)initWithLexeme:(NSString *)theLexeme
{
    self = [super init];
    if (self) {
        _lexeme = theLexeme;


    }
    return self;
}

@end
