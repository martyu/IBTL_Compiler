//
//  FiniteAutomatas.h
//  Milestone2
//
//  Created by Marty Ulrich on 1/25/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Token.h"

typedef NSNumber State;

@interface FiniteAutomata : NSObject

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
 	- use "*" (w/o quotes) as input symbol for wildcard.
*/


- (instancetype)initWithDFAPlist:(NSString*)plistFileName;

- (BOOL)acceptsWord:(NSString*)word;

@end