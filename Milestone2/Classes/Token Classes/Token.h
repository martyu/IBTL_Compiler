//
//  Token.h
//  Milestone2
//
//  Created by Marty Ulrich on 1/25/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//


struct TokenLocation {
	int line;
	int row;
};

struct TokenLocation tokenLocationMake(int theLine, int theRow);

typedef NSString Lexeme;
typedef NSString TokenType;

@interface Token : NSObject

@property (strong, nonatomic) id attribute;
@property (strong, nonatomic) Lexeme *lexeme;
@property (nonatomic) struct TokenLocation location;
@property (nonatomic) TokenType *type;

#warning Shouldn't the lexeme be part of attribute?
- (instancetype) initWithLexeme:(NSString*)theLexeme attribute:(id)theAttribute location:(struct TokenLocation)theLocation type:(TokenType*)theType;

@end
