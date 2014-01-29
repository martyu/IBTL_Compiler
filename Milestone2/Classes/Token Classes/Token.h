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

@interface Token : NSObject

@property (strong, nonatomic) id attribute;
//@property (strong, nonatomic) Lexeme *lexeme;
@property (nonatomic, readonly) int tag;

- (instancetype) initWithLexeme:(NSString*)theLexeme attribute:(id)theAttribute;
- (instancetype)initWithTag:(int)theTag;

@end