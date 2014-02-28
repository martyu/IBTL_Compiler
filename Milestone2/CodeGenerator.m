//
//  CodeGenerator.m
//  Milestone2
//
//  Created by Marty Ulrich on 2/27/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "CodeGenerator.h"
#import "Node.h"

@interface CodeGenerator ()

@property(nonatomic, strong)NSMutableString *generatedCode;

@end

@implementation CodeGenerator

+ (NSString*) generateCodeFromTree:(Node*)treeRoot
{
	CodeGenerator *codeGener = [[CodeGenerator alloc] init];
	codeGener.generatedCode = [NSMutableString string];
	[codeGener parseTreeWithRootNode:treeRoot];

	return codeGener.generatedCode;
}

- (void) parseTreeWithRootNode:(Node*)root
{
	// to recurse child nodes right to left.
	NSArray *childrenReversed = [[root.children reverseObjectEnumerator] allObjects];
	for (Node *child in childrenReversed)
	{
		[self parseTreeWithRootNode:child];
	}

	if (root.token.codeOutput)
		[self.generatedCode appendFormat:@"%@ ", root.token.codeOutput];
}

@end
