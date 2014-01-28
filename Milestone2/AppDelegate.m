//
//  AppDelegate.m
//  Milestone2
//
//  Created by Marty Ulrich on 1/25/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "AppDelegate.h"
#import "FiniteAutomatas.h"
#import "NSString+Utils.h"
#import "LexicalAnalyzer.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	FiniteAutomata *dfa = [[FiniteAutomata alloc] initWithDFAPlist:@"RelOpDFA"];

	LexicalAnalyzer *lex = [[LexicalAnalyzer alloc] initWithSource:@"test"];

	BOOL accept = [dfa acceptsWord:@"!="];
	NSLog(@"dfa accepts word !=: %@", accept ? @"yes" : @"no");

	accept = [dfa acceptsWord:@">"];
	NSLog(@"dfa accepts word >: %@", accept ? @"yes" : @"no");

	accept = [dfa acceptsWord:@"=="];
	NSLog(@"dfa accepts word ==: %@", accept ? @"yes" : @"no");

	accept = [dfa acceptsWord:@"="];
	NSLog(@"dfa accepts word =: %@", accept ? @"yes" : @"no");


	NSLog(@"%@", [@"a     b     c  d e" stringByRemovingExcessWhitespace]);

}

@end
