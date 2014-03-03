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
#import "CodeGenerator.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSTextField *currentTokenLabel;
@property (weak) IBOutlet NSTextField *nextTokenLabel;
@property (weak) IBOutlet NSTextField *tempNodeLabel;
@property (weak) IBOutlet NSTextField *rootNodeLabel;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //To do: write more tests. Tests that pass, give errors
    //Floats, etc
    //Have lots of tests
    //To do: Have output be translated so token type will show up as the category name as a string
	//To do: Have input be a file by default

	NSString *path = [[NSBundle mainBundle] pathForResource:@"testcases" ofType:@"txt"];
	[self startWithURL:[NSURL fileURLWithPath:path]];

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
	parser.currentTokenLabel = self.currentTokenLabel;
	parser.nextTokenLabel = self.nextTokenLabel;
	parser.tempNodeLabel = self.tempNodeLabel;
	parser.rootNodeLabel = self.rootNodeLabel;

	while (parser.currentToken)
	{
		[parser parse];
		
		//@debug:
//		[parser.rootNode printChildren];
//		NSLog(@"tokenArray: %@", parser.tokenArray);

		NSString *gforth = [CodeGenerator generateCodeFromTree:parser.rootNode];
		
		//@todo: Make this actually execute the forth code and show the output.
		printf("%s\n", [gforth UTF8String]);

		// get next token so we're ready to parse the next statement.
		[parser getNextToken];
	}
}

@end
