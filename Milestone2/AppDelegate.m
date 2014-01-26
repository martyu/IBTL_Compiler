//
//  AppDelegate.m
//  Milestone2
//
//  Created by Marty Ulrich on 1/25/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "AppDelegate.h"
#import "FiniteAutomatas.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	FiniteAutomata *dfa = [[FiniteAutomata alloc] initWithDFAPlist:@"RelOpDFA"];

	BOOL accept = [dfa acceptsWord:@"!="];
	NSLog(@"dfa accepts word !=: %@", accept ? @"yes" : @"no");

	accept = [dfa acceptsWord:@">"];
	NSLog(@"dfa accepts word >: %@", accept ? @"yes" : @"no");

	accept = [dfa acceptsWord:@"=="];
	NSLog(@"dfa accepts word ==: %@", accept ? @"yes" : @"no");

	accept = [dfa acceptsWord:@"="];
	NSLog(@"dfa accepts word =: %@", accept ? @"yes" : @"no");

}

@end
