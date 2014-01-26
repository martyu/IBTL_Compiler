//
//  NSString+Utils.m
//  Milestone2
//
//  Created by Marty Ulrich on 1/26/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

- (NSString*)stringByRemovingExcessWhitespace
{
	NSMutableString *newString = [NSMutableString string];
	unichar nextChar;
	unichar currentChar;
	for (int i = 0; i < self.length-1; i++)
	{
		currentChar = [self characterAtIndex:i];
		nextChar = [self characterAtIndex:i+1];
		if ((currentChar == ' ' && nextChar != ' ') || currentChar != ' ')
			[newString appendString:[NSString stringWithCharacters:&currentChar length:1]];

	}

	return [NSString stringWithString:newString];
}

@end
