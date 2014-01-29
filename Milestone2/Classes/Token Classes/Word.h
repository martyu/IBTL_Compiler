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
	WordSetupTypeAnd,
	WordSetupTypeOr,
	WordSetupTypeEq,
	WordSetupTypeNE,
	WordSetupTypeLE,
	WordSetupTypeGE,
	WordSetupTypeMinus,
	WordSetupTypeTrue,
	WordSetupTypeFalse,
	WordSetupTypeTemp,
} WordSetupType;

@interface Word : Token

@property(strong, nonatomic) NSString *lexeme;

- (instancetype)initWithLexeme:(NSString*)theLexeme tag:(int)theTag;
+ (instancetype)wordWithType:(WordSetupType)type;

@end