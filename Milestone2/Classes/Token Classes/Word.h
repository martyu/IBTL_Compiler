//
//  Word.h
//  Milestone2
//
//  Created by Marty Ulrich on 1/28/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Token.h"
#import "Defines.h"


typedef enum {
	WordTypeStdOut,
	WordTypeLet,

} WordType;

/** Class for reserved words and identifiers. */
@interface Word : Token

@property(strong, nonatomic) NSString *lexeme;
@property(nonatomic) WordType type;

- (instancetype)initWithLexeme:(NSString*)theLexeme tag:(int)theTag;
+ (instancetype)wordWithType:(WordType)type;

@end