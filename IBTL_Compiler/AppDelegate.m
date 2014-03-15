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

@property (weak) IBOutlet NSTextField *outputText;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //To do: write more tests. Tests that pass, give errors
    //Floats, etc
    //Have lots of tests
    //To do: Have output be translated so token type will show up as the category name as a string
	//To do: Have input be a file by default

	[self.outputText.cell setScrollable:YES];

//	NSString *path = [[NSBundle mainBundle] pathForResource:@"testcases" ofType:@"txt"];
//	[self startWithURL:[NSURL fileURLWithPath:path]];
//
//
//	path = [[NSBundle mainBundle] pathForResource:@"proftest" ofType:nil];
//	[self startWithURL:[NSURL fileURLWithPath:path]];
//
//	path = [[NSBundle mainBundle] pathForResource:@"proftest" ofType:@"in"];
//	[self startWithURL:[NSURL fileURLWithPath:path]];
//
//	path = [[NSBundle mainBundle] pathForResource:@"proftest4" ofType:@"in"];
//	[self startWithURL:[NSURL fileURLWithPath:path]];



	[self showOpenPanel:nil];
}

- (IBAction)showOpenPanel:(id)sender
{
	NSOpenPanel *open = [[NSOpenPanel alloc] initWithContentRect:NSRectFromCGRect(CGRectMake(0.0, 0.0, 400.0, 400.0)) styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
	open.delegate = self;
	open.allowsMultipleSelection = YES;
	[self.window addChildWindow:open ordered:NSWindowAbove];
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

	while (parser.currentToken)
	{
		[parser parse];
		
		//@debug:
//		[parser.rootNode printChildren];
//		NSLog(@"tokenArray: %@", parser.tokenArray);

		NSString *gforth = [CodeGenerator generateCodeFromTree:parser.rootNode];

		NSString *gforth2 = [NSString stringWithFormat:@"%@ bye", gforth];
		NSString *gforthFilePath = [@"~/milestone5.fs" stringByExpandingTildeInPath];
		[gforth2 writeToFile:gforthFilePath atomically:YES encoding:NSASCIIStringEncoding error:NULL];

		NSMutableString *output = [NSMutableString string];

		FILE *terminal = popen([[NSString stringWithFormat:@"gforth %@", gforthFilePath] UTF8String], "r");
		char buf[256];
		while (fgets(buf, sizeof(buf), terminal) != 0)
		{
			[output appendString:[NSString stringWithFormat:@"%s", buf]];
		}
		pclose(terminal);

		self.outputText.stringValue = [NSString stringWithFormat:@"%@\nGforth code:\n%@\noutput:\n%@\n", self.outputText.stringValue, gforth2, output];

		static int testCount = 1;

		printf("Test %i:\nGforth code:\n%s\noutput:\n%s\n", testCount, [gforth2 UTF8String], [output UTF8String]);

		// get next token so we're ready to parse the next statement.
		[parser getNextToken];
	}
}

@end
