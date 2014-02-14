//
//  Parser.m
//  Milestone2
//
//  Created by Marty Ulrich on 2/12/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Parser.h"

@interface Parser ()

@property (strong, nonatomic) LexicalAnalyzer *lex;
@property (nonatomic) int used;


@end

@implementation Parser

- (instancetype)initWithLexicalAnalyzer:(LexicalAnalyzer*)theLex
{
    self = [super init];
    if (self) {
        _lex = theLex;
    }
    return self;
}

- (void)move
{

}

@end
