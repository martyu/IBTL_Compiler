//
//  CodeGenerator.m
//  Milestone2
//
//  Created by Marty Ulrich on 2/27/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "CodeGenerator.h"
#import "Node.h"
#import "Word.h"

@interface CodeGenerator ()

@property(nonatomic, strong)NSMutableString *generatedCode;
@property(nonatomic, strong)NSMutableDictionary *definedVars;

@end

static int funcCounter = 0;

@implementation CodeGenerator

+ (NSString*) generateCodeFromTree:(Node*)treeRoot
{
	CodeGenerator *codeGener = [[CodeGenerator alloc] init];
	codeGener.generatedCode = [NSMutableString string];
	codeGener.definedVars = [NSMutableDictionary dictionary];
	[codeGener parseTreeFromLeft:treeRoot];
	return codeGener.generatedCode;
}

- (void) parseTreeFromLeft:(Node*)root
{
	for (Node *child in root.children) {
		if (child.production == ProductionTypeS || child.production == ProductionTypeS_)
			[self parseTreeFromLeft:child];
		else
			[self parseTreeWithRootNode:child];
	}
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

		switch (child.production) {
			case ProductionTypeWhileStmt:
				[self parseWhile:child];
				break;

			case ProductionTypeExprList:
				[self parseExprlist:child];
				break;

			case ProductionTypeIfStmt:
				[self parseIf:child];
				break;

			case ProductionTypeLetStmt:
				[self parseLetStmt:child];
				break;

			case ProductionTypeOper:
				[self parseOper:child];
				break;

			case ProductionTypeVarlistStmt:
				[self parseVarlist:child];
				break;

			case ProductionTypePrintStmts:
				[self parsePrint:child];
				break;

			default:
				if (child.production)
					[self parseTreeWithRootNode:child];
				break;
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
	if (root.token.codeOutput)
	{
		// if it's a variable, need to add a '@' to get value.
		Word *wordTok;

		if ([root.token isKindOfClass:[Word class]])
			wordTok = (Word*)root.token;
		NSString *varName;
		if (wordTok)
			varName = self.definedVars[[(Word*)(root.token) lexeme]];

		if (varName)
		{
			if (wordTok.varType == VariableTypeInt)
			{
				[tempOutput appendFormat:@"%@ @", root.token.codeOutput];
				return OpTypeInt;
			}
			else if (wordTok.varType == VariableTypeFloat)
			{
				[tempOutput appendFormat:@"%@ f@", root.token.codeOutput];
				return OpTypeFloat;
			}
		}
		else
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
//			if(!returnType){
				//Need to check both in case one is a name
				if(Oper1Type == OpTypeFloat || Oper2Type == OpTypeFloat){
					returnType = OpTypeFloat;
				} else {
					returnType = OpTypeInt;
				}
//			}

			//Output the children
			[tempOutput appendFormat:@"%@ ", OutputOper1];
			[tempOutput appendFormat:@"%@ ", OutputOper2];
			
			//@todo: can we do mod on 2 floating point numbers?
			//Change binop to be floating point if necessary
			if(returnType == OpTypeFloat){
				//Only add the 'f' on these productions: -, +, *, /, >, >=, <, <=
				if(function.token.tag == '-' || function.token.tag == '+' || function.token.tag == '*' || function.token.tag == '/' ||
				   function.token.tag == '>' || function.token.tag == '<' || function.token.tag == GE || function.token.tag == LE || function.token.tag == '^' )
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
			
			//Grab the name
			Node *nameNode = root.children[2];
			NSString *varName;
			if ([nameNode.token isKindOfClass:[Word class]]) {
				varName = [(Word*)nameNode.token lexeme];
			} else {
				[self reportError:@"expected Word token"];
			}

			// check that the variable's been defined.
			Word *nameTok = self.definedVars[varName];
			if (!nameTok) {
				[self reportError:[NSString stringWithFormat:@"undefined variable \"%@\"", varName]];
			}

			Node *operNode = root.children[3];
			returnType = [self parseOper:operNode];
			if (nameTok.varType == VariableTypeFloat && returnType != OpTypeFloat)
				[self.generatedCode appendString:@"s>f "];

			[self.generatedCode appendFormat:@"%@ ", varName];

			if (returnType == OpTypeFloat || nameTok.varType == VariableTypeFloat)
				[self.generatedCode appendString:@"f"];

			[self.generatedCode appendString:@"! "];

			return returnType;
			
		}
	}

	// [unops oper1]
	if([root.children count] == 4){
		OpType returnType; // The type that we will return from this function
		
		//Typecheck Oper 1
		Node *Oper1 = [root.children objectAtIndex:2];
		NSMutableString *OutputOper1 = [NSMutableString stringWithString:@""];
		OpType OperType1 = [self parseOper:Oper1 output:OutputOper1];
		
		Node *function = [root.children objectAtIndex:1];

		[tempOutput appendFormat:@"%@ ", OutputOper1];

		if (OperType1 == OpTypeFloat)
			[tempOutput appendString:@"f"];

		[tempOutput appendFormat:@"%@ ", function.token.codeOutput];
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

	[self.generatedCode appendFormat:@"endif ; func%i ", funcCounter++];
}

/** [stdout oper]  */
- (void) parsePrint:(Node*)root
{
	Node *operNode = root.children[2];

	OpType type = [self parseOper:operNode];

	// print it.
	if (type == OpTypeFloat)
		[self.generatedCode appendString:@"f. "];
	else if (type == OpTypeInt)
		[self.generatedCode appendString:@". "];
	else
		[self.generatedCode appendString:@"cr "];
}

/** [let [varlist]] */
- (void) parseLetStmt:(Node*)root
{
	Node *varlistNode = root.children[3];
	if (varlistNode.production != ProductionTypeVarlistStmt) {
		[self reportError:@"expected varlist"];
	}
	[self parseVarlist:varlistNode];
}

/** [name type] | [name type] varlist */
- (void) parseVarlist:(Node*)root
{
	// [name type] or [name type] varlist
	Word *var;
	if ([[root.children[1] token] isMemberOfClass:[Word class]]) {
		var = (Word*)[root.children[1] token];
	} else {
		[self reportError:@"variable is not a word."];
	}

	NSString *varName = var.lexeme;
	// check if already defined
	if (!self.definedVars[varName])
	{
		self.definedVars[varName] = var;
		[self.generatedCode appendFormat:@"Variable %@ ", varName];
	}

	Word *type;
	if ([[root.children[2] token] isMemberOfClass:[Word class]]) {
		type = (Word*)[root.children[2] token];
	}

	// add type to var token
	if ([type.lexeme isEqualToString:@"int"]) {
		var.varType = VariableTypeInt;
	} else if ([type.lexeme isEqualToString:@"float"]) {
		var.varType = VariableTypeFloat;
	} else {
		[self reportError:[NSString stringWithFormat:@"wtf type is var \"%@\"?", var]];
	}

	if (root.children.count == 5)
	{
		// [name type] varlist
		Node *varlistNode = root.children[4];
		if (varlistNode.production != ProductionTypeVarlistStmt) {
			[self reportError:@"expected varlist node."];
		}

		[self parseVarlist:varlistNode];
	}
}

/** [while expr exprlist] -> : <func name> begin expr while exprlist repeat ; <func name> */
- (void) parseWhile:(Node*)rootNode
{
	Node *expr = rootNode.children[2];
	Node *exprlist = rootNode.children[3];

	[self.generatedCode appendFormat:@": func%i begin ", funcCounter];
	[self parseTreeWithRootNode:expr];
	[self.generatedCode appendString:@"while "];
	[self parseExprlist:exprlist];
	[self.generatedCode appendFormat:@"repeat ; func%i ", funcCounter++];
}

/** exprlist -> expr | expr exprlist */
- (void) parseExprlist:(Node*)rootNode
{
	[self parseTreeWithRootNode:rootNode.children[0]];

	if (rootNode.children.count == 2)
	{
		// expr exprlist
		[self parseExprlist:rootNode.children[1]];
	}
}

- (void) reportError:(NSString*)errStr
{
	NSLog(@"\n\n");
	[NSException raise:@"Code Generator error" format:@"%@", errStr];
}

@end

