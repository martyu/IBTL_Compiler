//
//  Parser.h
//  Milestone2
//
//  Created by Marty Ulrich on 2/12/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "LexicalAnalyzer.h"
@class Tree;

@interface Parser : NSObject

@property (strong, nonatomic) Token *lookAhead;
@property (strong, nonatomic) Token *currentToken;

- (instancetype)initWithLexicalAnalyzer:(LexicalAnalyzer*)theLex;
- (Tree*) T:(Token*)t;

@end
