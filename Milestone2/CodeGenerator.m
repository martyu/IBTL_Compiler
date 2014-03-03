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
		} else {
			[self parseTreeWithRootNode:child];
		}
	}

	if (root.token.codeOutput)
		[self.generatedCode appendFormat:@"%@ ", root.token.codeOutput];
}

// This method performs typechecking on oper productions and converts them if necessary
// It takes in an optional output stream for storing the output of the oper production
// That way we can add conversion to that output if we need to
//Remember:
/** oper -> [:= name oper] | [binops oper oper] | [unops oper] | constants | name */
- (OpType) parseOper:(Node*)root
{
	NSMutableString *tempOutput = [NSMutableString stringWithString:@""];
	OpType tempType = [self parseOper:root output:tempOutput];
	[self.generatedCode appendFormat:@"%@ ", tempOutput];
	return tempType;
}

- (OpType) parseOper:(Node*)root output:(NSMutableString *)tempOutput
{
	//Skip over nonterminal oper stuff
	if([root.children count] == 1){
		return [self parseOper:[root.children objectAtIndex:0] output:tempOutput];
	}
	
	//oper -> constant | oper -> name
	if (root.token.codeOutput){
		//@todo: This doesn't add a space. So make sure to clean up output elsewhere
		[tempOutput appendFormat:@"%@", root.token.codeOutput];
		if(root.token.tag == FLOAT){
			return OpTypeFloat;
		} else if(root.token.tag == INTEGER){
			return OpTypeInt;
		} else {
			return OpTypeName;
		}
	}
	
	//[:= name oper] and [binops oper oper]
	if([root.children count] == 5){
		// Check if the production is [binops oper oper]
		Node *function = [root.children objectAtIndex:1];
		if(function.token.tokType == 1){ //@todo: This should be TokenTypeBinop
			//[binops oper oper]
			
			OpType returnType; // The type that we will return from this function
			
			//Typecheck Oper 2
			Node *Oper2 = [root.children objectAtIndex:3];
			NSMutableString *OutputOper2 = [NSMutableString stringWithString:@""];
			OpType Oper2Type =[self parseOper:Oper2 output:OutputOper2];
			
			//Typecheck Oper 1
			Node *Oper1 = [root.children objectAtIndex:2];
			NSMutableString *OutputOper1 = [NSMutableString stringWithString:@""];
			OpType Oper1Type =[self parseOper:Oper1 output:OutputOper1];
			
			//Compare them
			if(Oper1Type != Oper2Type){
				if(Oper1Type == OpTypeFloat && Oper2Type == OpTypeInt){
					//Convert Oper2 to float
					[OutputOper2 appendString:@"e"];
				} else if (Oper1Type == OpTypeInt && Oper2Type == OpTypeFloat){
					//Convert Oper1 to float
					[OutputOper1 appendString:@"e"];
				}
				returnType = OpTypeFloat;
			}
			
			//Set return type appropriately if it's not already set
			if(!returnType){
				//Need to check both in case one is a name
				if(Oper1Type == OpTypeFloat || Oper2Type == OpTypeFloat){
					returnType = OpTypeFloat;
				} else {
					returnType = OpTypeInt;
				}
			}
			
			//Output the children in reverse order
			[tempOutput appendFormat:@"%@ ", OutputOper2];
			[tempOutput appendFormat:@"%@ ", OutputOper1];
			
			//@todo: can we do mod on 2 floating point numbers?
			//Change binop to be floating point if necessary
			if(returnType == OpTypeFloat){
				//Only add the 'f' on these productions: -, +, *, /
				if(function.token.tag == '-' || function.token.tag == '+' || function.token.tag == '*' || function.token.tag == '/'){
					[tempOutput appendString:@"f"];
				}
			}
			
			[tempOutput appendFormat:@"%@ ", function.token.codeOutput];
			return returnType;
		} else {
			//@todo: is this where we use the symbol table? Do we need to check if the variable is defined and what type it is?
			//[:= name oper]
			OpType returnType; // The type that we will return from this function
			
			//Typecheck the Oper
			Node *Oper2 = [root.children objectAtIndex:3];
			NSMutableString *OutputOper2 = [NSMutableString stringWithString:@""];
			OpType Oper2Type =[self parseOper:Oper2 output:OutputOper2];
			
			//Grab the name
			Node *theName = [root.children objectAtIndex:2];
			
			//Output the children in reverse order
			[tempOutput appendFormat:@"%@ ", OutputOper2];
			[tempOutput appendFormat:@"%@ ", theName.token.codeOutput];
			[tempOutput appendFormat:@"%@ ", function.token.codeOutput];
			
			returnType = Oper2Type;
			return returnType;
			
		}
	}
		
	// [unops oper]
	if([root.children count] == 4){
		OpType returnType; // The type that we will return from this function
		
		//Typecheck Oper 1
		Node *Oper1 = [root.children objectAtIndex:2];
		NSMutableString *OutputOper1 = [NSMutableString stringWithString:@""];
		OpType OperType1 =[self parseOper:Oper1 output:OutputOper1];
		
		Node *function = [root.children objectAtIndex:1];
		//need to have '-' right in front of the oper
		if(function.token.tag == '-'){
			[tempOutput appendFormat:@"%@", function.token.codeOutput];
		} else {
			//Otherwise add a space
			[tempOutput appendFormat:@"%@ ", function.token.codeOutput];
		}
		[tempOutput appendFormat:@"%@ ", OutputOper1];
		returnType = OperType1;
		return returnType;
	}
	
	return OpTypeFloat;
}

@end
