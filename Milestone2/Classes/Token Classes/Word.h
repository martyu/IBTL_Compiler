//
//  Word.h
//  Milestone2
//
//  Created by Marty Ulrich on 1/28/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Token.h"

typedef enum {
	WordTypeAnd,
	WordTypeOr,
	WordTypeEq,
	WordTypeNE,
	WordTypeLE,
	WordTypeGE,
	WordTypeMinus,
	WordTypeTrue,
	WordTypeFalse,
	WordTypeTemp,
} WordType;

@interface Word : Token

@property(strong, nonatomic) NSString *lexeme;

- (instancetype)initWithLexeme:(NSString*)theLexeme tag:(int)theTag;

@end
