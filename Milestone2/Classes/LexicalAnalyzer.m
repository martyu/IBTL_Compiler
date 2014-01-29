//
//  LexicalAnalyzer.m
//  Milestone2
//
//  Created by Marty Ulrich on 1/25/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "LexicalAnalyzer.h"
#import "Token.h"

@interface LexicalAnalyzer ()

@property(nonatomic) char peek;
@property(strong, nonatomic) NSMutableDictionary *words;

@end


@implementation LexicalAnalyzer

- (instancetype)init
{
    self = [super init];
    if (self) {
		_peek = ' ';
		_words = [NSMutableDictionary dictionary];
		[self setupReserveWords];

    }
    return self;
}

- (void)setupReserveWords
{
	
}

#pragma mark - Accessors

- (int)line
{
	static int line = 1;
	return line;
}


@end