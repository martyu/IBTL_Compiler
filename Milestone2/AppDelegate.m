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
	NSString *source = @"[[+ 1 1]]";

	LexicalAnalyzer *lex = [[LexicalAnalyzer alloc] initWithSource:source];

//	[self printTokensForLex:lex];

    Parser *parser = [[Parser alloc] initWithLexicalAnalyzer:lex];
    Node *t = [parser T:parser.currentToken];
    [t printChildren];
}

- (void)printTokensForLex:(LexicalAnalyzer *)lex
{
	Token *tok = [lex scan];
	while (tok) {
		NSLog(@"%@", tok);
		tok = [lex scan];
	}
}

@end
