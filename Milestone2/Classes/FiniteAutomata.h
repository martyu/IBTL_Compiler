//
//  FiniteAutomatas.h
//  Milestone2
//
//  Created by Marty Ulrich on 1/25/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Token.h"

#define REGEX_ALPHA		@"[a-z]"
#define REGEX_NUM		@"[0-9]"

@interface FiniteAutomata : NSObject

// if DFA accepts word, this is the token type it will be.
@property (nonatomic, readonly) NSString *type;

/**
 The plist should be a dictionary with this structure:

 root dict {
 		dict for state x {
 			[input symbol] : [go to state]
 			[input symbol] : [go to state]
			...
		}
		dict for state y {
			[input symbol] : [go to state]
			[input symbol] : [go to state]
			...
		}
 }

 - "go to state" type is NSString.
 - add a "!" (w/o quotes) to final states.
 - use "~" (w/o quotes) as input symbol for wildcard.
 - use [0-9]
 */
- (instancetype)initWithDFAPlist:(NSString*)plistFileName;

- (BOOL)acceptsWord:(NSString*)word;

@end