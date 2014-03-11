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

static int funcCounter = 0;

@implementation CodeGenerator

+ (NSString*) generateCodeFromTree:(Node*)treeRoot
{
	CodeGenerator *codeGener = [[CodeGenerator alloc] init];
	codeGener.generatedCode = [NSMutableString string];
	[codeGener parseTreeWithRootNode:treeRoot];
	[codeGener.generatedCode appendString:@"bye"];
	return codeGener.generatedCode;
}

- (OpType) parseTreeWithRootNode:(Node*)root
{
	OpType type = OpTypeNone;

	// to recurse child nodes right to left.
	NSArray *childrenReversed = [[root.children reverseObjectEnumerator] allObjects];
	for (Node *child in childrenReversed)
	{
		if ([child isTrig] && type == OpTypeInt)
		{
			[self.generatedCode appendString:@"s>f "];
			type = OpTypeFloat;
		}

		if(child.production == ProductionTypeOper)
		{
			type = [self parseOper:child];
		}
		else if (child.production == ProductionTypeIfStmt)
		{
			// IF statement
			[self parseIf:child];
		}
		else if (child.production == ProductionTypePrintStmts)
		{
			[self parsePrint:child];
		}
		else
		{
			[self parseTreeWithRootNode:child];
		}
	}

	if (root.token.codeOutput)
		[self.generatedCode appendFormat:@"%@ ", root.token.codeOutput];

	return type;
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
		[tempOutput appendFormat:@"%@", root.token.codeOutput];
		if(root.token.tag == FLOAT){
			[tempOutput appendString:@"e"];
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
		if(function.token.tokType == TokenTypeBinOp){
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
					[OutputOper2 appendString:@" s>f"];
				} else if (Oper1Type == OpTypeInt && Oper2Type == OpTypeFloat){
					//Convert Oper1 to float
					[OutputOper1 appendString:@" s>f"];
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
				//Only add the 'f' on these productions: -, +, *, /, >, >=, <, <=
				if(function.token.tag == '-' || function.token.tag == '+' || function.token.tag == '*' || function.token.tag == '/' ||
				   function.token.tag == '>' || function.token.tag == '<' || function.token.tag == GE || function.token.tag == LE )
				{
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

	// [unops oper1]
	if([root.children count] == 4){
		OpType returnType; // The type that we will return from this function
		
		//Typecheck Oper 1
		Node *Oper1 = [root.children objectAtIndex:2];
		NSMutableString *OutputOper1 = [NSMutableString stringWithString:@""];
		OpType OperType1 =[self parseOper:Oper1 output:OutputOper1];
		
		Node *function = [root.children objectAtIndex:1];
		if(function.token.tag == NEG){
			//need to have '-' right in front of the oper
			[tempOutput appendFormat:@"%@", function.token.codeOutput];
		} else if ([function isTrig]) {
			
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

/** [if expr1 expr2]  or  [if expr1 expr2 expr3]  ->  : func[i] expr1 if expr2 . [else expr3 .] endif ; func[i] */
- (void) parseIf:(Node*)root
{
	// [if expr1 expr2]
	Node *_if = root.children[1];
	Node *expr1 = root.children[2];
	Node *expr2 = root.children[3];

	[self.generatedCode appendFormat:@": func%i ", funcCounter];
	[self parseTreeWithRootNode:expr1];
	[self.generatedCode appendFormat:@"%@ ", _if.token.codeOutput];
	[self parseTreeWithRootNode:expr2];
	if (root.children.count == 6)
	{
		Node *expr3 = root.children[4];
		[self.generatedCode appendFormat:@"else "];
		[self parseTreeWithRootNode:expr3];
	}

	[self.generatedCode appendFormat:@"endif ; func%i ", funcCounter];
}

/** [stdout oper] -> oper [f]. */
- (void) parsePrint:(Node*)root
{
	Node *operNode = root.children[2];

	OpType type = [self parseTreeWithRootNode:operNode];

	// print it.
	if (type == OpTypeFloat)
		[self.generatedCode appendString:@"f. "];
	else
		[self.generatedCode appendString:@". "];
}

@end

