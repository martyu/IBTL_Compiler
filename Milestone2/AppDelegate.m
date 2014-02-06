//
//  AppDelegate.m
//  Milestone2
//
//  Created by Marty Ulrich on 1/25/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "AppDelegate.h"
#import "NSString+Utils.h"
#import "LexicalAnalyzer.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //To do: write more tests. Tests that pass, give errors
    //Floats, etc
    //Have lots of tests
    //To do: Have output be translated so token type will show up as the category name as a string
    //To do: Have input be a file by default
	NSString *source = @"int num = 5; if(num == 5)float x = num - 5; myString = (\"hello world\")";

	LexicalAnalyzer *lex = [[LexicalAnalyzer alloc] initWithSource:source];
	Token *token = [lex scan];

	while (token) {
		printf("%s ",  [[token description] UTF8String]);
		token = [lex scan];
	}
}

@end
