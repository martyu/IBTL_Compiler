//
//  Real.h
//  Milestone2
//
//  Created by Marty Ulrich on 1/28/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Token.h"

@interface Real : Token

@property (nonatomic, readonly) float value;

+ (instancetype) realWithValue:(float)val;

@end
