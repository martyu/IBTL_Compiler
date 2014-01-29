//
//  Num.h
//  Milestone2
//
//  Created by Marty Ulrich on 1/28/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Token.h"

@interface Num : Token

@property(nonatomic, readonly) int value;

+ (instancetype)numWithValue:(int)val;

@end
