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
		if(child.production == ProductionTypeOper){
			[self parseOper:child];
		}
		[self parseTreeWithRootNode:child];
	}

	if (root.token.codeOutput)
		[self.generatedCode appendFormat:@"%@ ", root.token.codeOutput];
}

// This method performs typechecking on oper productions and converts them if necessary

//My idea: Simply use this for typechecking. Don't change the current position in the tree/current node.
// Just recurse, do typechecking. If it passes, continue. If not, convert and then continue
- (OpType) parseOper:(Node*)root
{
	//for [binops oper oper] or [:= name oper]
	if([root.children count] == 5){
		// Check if the production is [binops oper oper]
		Node *BinOpTest = [root.children objectAtIndex:1];
		if(BinOpTest.token.tokType == 1){ //@todo: This should be TokenTypeBinop
			//Check the op type of each child and convert if necessary
		} else {
			//it's gotta be [:= name oper]
		}
	} else {
		//It's [a constant or a name]
	}
}

@end
