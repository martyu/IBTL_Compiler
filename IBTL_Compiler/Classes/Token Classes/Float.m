//
//  Float.m
//  Milestone2
//
//  Created by Marty Ulrich on 1/28/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Float.h"

@implementation Float

- (instancetype)initWithValue:(float)val
{
    self = [super initWithTag:FLOAT type:TokenTypeConstant];
    if (self) {
        _value = val;
    }
    return self;
}

+ (instancetype) floatWithValue:(float)val
{
	return [[[self class] alloc] initWithValue:val];
}

-(NSString*)description
{
	NSString *str = [NSString stringWithFormat:@"<%@, val:%f, type:%i>", [super description], self.value, self.tokType];
	return str;
}

- (NSString*)codeOutput
{
	return [NSString stringWithFormat:@"%f", self.value];
}

@end