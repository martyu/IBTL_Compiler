//
//  Num.m
//  Milestone2
//
//  Created by Marty Ulrich on 1/28/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Num.h"

@implementation Num

- (instancetype)initWithValue:(int)val
{
    self = [super initWithTag:INTEGER type:TokenTypeConstant];
    if (self) {
        _value = val;
    }
    return self;
}

+ (instancetype)numWithValue:(int)val
{
	return [[[self class] alloc] initWithValue:val];
}

-(NSString*)description
{
	NSString *str = [NSString stringWithFormat:@"<%@, val:%i, tag:%@, type:%i>", [super description], self.value, [Defines descriptionForConstant:self.tag], self.tokType];
	return str;
}

@end