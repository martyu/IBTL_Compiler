//
//  Type.m
//  Milestone2
//
//  Created by Marty Ulrich on 2/13/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Type.h"

@implementation Type

- (instancetype)initWithLexeme:(NSString*)theLexeme
						   tag:(int)theTag
						  type:(TokenType)tokType
						 width:(int)theWidth;
{
    self = [super initWithLexeme:theLexeme tag:theTag type:tokType];
    if (self) {
        _width = theWidth;
    }
    return self;
}

//+ (instancetype)Int
//{
////	return [[self alloc] initWithLexeme:<#(NSString *)#> tag:<#(int)#> type:<#(TokenType)#> width:<#(int)#>]
//}
//
//+ (instancetype)Float
//{
//
//}
//
//+ (instancetype)Char
//{
//
//}
//
//+ (instancetype)Bool
//{
//
//}


@end
