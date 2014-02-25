//
//  Parser.h
//  Milestone2
//
//  Created by Marty Ulrich on 2/12/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "LexicalAnalyzer.h"
@class Node;

@interface Parser : NSObject

@property (strong, nonatomic) Token *lookAhead;
@property (strong, nonatomic) Token *currentToken;
@property (strong, nonatomic) Node *rootNode;

@property (weak) IBOutlet NSTextField *currentTokenLabel;
@property (weak) IBOutlet NSTextField *nextTokenLabel;
@property (weak) IBOutlet NSTextField *tempNodeLabel;
@property (weak) IBOutlet NSTextField *rootNodeLabel;


- (instancetype)initWithLexicalAnalyzer:(LexicalAnalyzer*)theLex;
- (Node*) T:(Token*)t;

- (void) parse;

-(Token *)getNextToken;

@end
