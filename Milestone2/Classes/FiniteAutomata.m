//
//  FiniteAutomatas.m
//  Milestone2
//
//  Created by Marty Ulrich on 1/25/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//


#import "FiniteAutomata.h"

@interface FiniteAutomata ()

@property (strong, nonatomic) NSMutableDictionary *dfaInfo;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSMutableArray *finalStates;

@end

@implementation FiniteAutomata

- (instancetype)initWithDFAPlist:(NSString*)plistFileName
{
    self = [super init];
    if (self)
	{
		NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistFileName ofType:@"plist"];
		_dfaInfo = [NSDictionary dictionaryWithContentsOfFile:plistPath];
		_finalStates = [NSMutableArray array];
		[self cleanUpDfaInfoDict];
    }
    return self;
}

- (BOOL)acceptsWord:(NSString*)word
{
	self.state = @"0";

	// split word characters into array.
	NSMutableArray *wordChars = [[NSMutableArray alloc] initWithCapacity:[word length]];
	for (int i=0; i < [word length]; i++)
	{
		NSString *ichar  = [NSString stringWithFormat:@"%c", [word characterAtIndex:i]];
		[wordChars addObject:ichar];
	}

	for (NSString *aChar in wordChars)
	{
		// get next state for input char with current state.
		self.state = [self stateAfterCurrentStateForCharacter:aChar];

		// if state is nil, reject word.
		if (!self.state)
			return NO;
	}

	// accept if current state is final, else reject.
	return [self.finalStates containsObject:self.state];
}

/** 
 	Go thru and check which states have a "!" after it,
 	add them to the final states array, and remove the "!".
 */
- (void)cleanUpDfaInfoDict
{
	for (NSString *keyA in [self.dfaInfo allKeys])
	{
		NSDictionary *stateTransitionInfo = self.dfaInfo[keyA];
		for (NSString *keyB in [stateTransitionInfo allKeys])
		{
			NSString *possibleFinalState = stateTransitionInfo[keyB];
			if ([possibleFinalState rangeOfString:@"!"].location != NSNotFound)
			{
				// it's a final state!
				self.dfaInfo[keyA][keyB] = [possibleFinalState stringByReplacingOccurrencesOfString:@"!" withString:@""];
				[self.finalStates addObject:self.dfaInfo[keyA][keyB]];
			}
		}
	}
}

/**
 	The transition function.  Given the current state and input character "aChar",
 	returns the new state, or nil if current state doesn't allow "aChar".
 */
- (NSString*)stateAfterCurrentStateForCharacter:(NSString*)aChar
{
	NSString *nextState;

	// get transition function info for current state.
	NSDictionary *transitionDictForCurrentState = self.dfaInfo[self.state];

	// check for a next state for the character by using it as a key.
	nextState = transitionDictForCurrentState[aChar];
	if (nextState)
		return nextState;

	// if an alpha character, check for [a-z] key.
	unichar inputChar = [aChar characterAtIndex:0];
	if (isalpha(inputChar))
	{
		nextState = transitionDictForCurrentState[REGEX_ALPHA];
		if (nextState)
			return nextState;
	}

	// if a digit, check for [0-9] key.
	if (isnumber(inputChar))
	{
		nextState = transitionDictForCurrentState[REGEX_NUM];
		if (nextState)
			return nextState;
	}

	// returns state for wildcard if allowed, nil if not.
	// "That wildcard was our last hope."
	return transitionDictForCurrentState[@"~"];
}

- (NSString*)type
{
	return self.dfaInfo[@"type"];
}

@end



