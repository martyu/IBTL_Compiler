//
//  Type.h
//  Milestone2
//
//  Created by Marty Ulrich on 2/13/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Word.h"

@interface Type : Word

@property(nonatomic)int width;

- (instancetype)initWithLexeme:(NSString*)theLexeme
						   tag:(int)theTag
						  type:(TokenType)tokType
						 width:(int)theWidth;

+ (instancetype)Int;
+ (instancetype)Float;
+ (instancetype)Char;
+ (instancetype)Bool;

@end