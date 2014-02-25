//
//  AppDelegate.m
//  Milestone2
//
//  Created by Marty Ulrich on 1/25/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "AppDelegate.h"
#import "LexicalAnalyzer.h"
#import "Parser.h"
#import "Node.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //To do: write more tests. Tests that pass, give errors
    //Floats, etc
    //Have lots of tests
    //To do: Have output be translated so token type will show up as the category name as a string
	//To do: Have input be a file by default

	[self startWithURL:[NSURL fileURLWithPath:@"/Users/martyulrich/Dropbox/School/Winter 2014/CS 480/Milestone2/Milestone2/testcases.txt"]];

//	NSOpenPanel *open = [[NSOpenPanel alloc] initWithContentRect:NSRectFromCGRect(CGRectMake(0.0, 0.0, 400.0, 400.0)) styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
//	open.delegate = self;
//	[self.window addChildWindow:open ordered:NSWindowAbove];
}

- (BOOL)panel:(id)sender validateURL:(NSURL *)url error:(NSError **)outError
{
	[self startWithURL:url];
	return YES;
}

- (void)startWithURL:(NSURL*)url
{
	NSString *source = [NSString stringWithContentsOfURL:url encoding:NSStringEncodingConversionAllowLossy error:NULL];

	LexicalAnalyzer *lex = [[LexicalAnalyzer alloc] initWithSource:source];

    Parser *parser = [[Parser alloc] initWithLexicalAnalyzer:lex];
	[parser parse];
	[parser.rootNode printChildren];

	/*
	printf("\n\n\n\n");

	[parser parse];
	[parser.rootNode printChildren];
	 */
	return YES;
}

@end
