//
//  Parser.m
//  Milestone2
//
//  Created by Marty Ulrich on 2/12/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Parser.h"
#import "Environment.h"
#import "Stmt.h"
#import "Defines.h"
#import "Word.h"
#import "Node.h"

@interface Parser ()

@property (strong, nonatomic) LexicalAnalyzer *lex;
@property (strong, nonatomic) Environment *top;

@end

@implementation Parser

- (instancetype)initWithLexicalAnalyzer:(LexicalAnalyzer*)theLex
{
    self = [super init];
    if (self) {
        _lex = theLex;
		_lookAhead = [self.lex scan];
		[self getNextToken];
    }
    return self;
}

-(Token *)getNextToken
{
    self.currentToken = self.lookAhead;
    self.lookAhead = [self.lex scan];

	printf("%s\n", [[self.currentToken description] UTF8String]);

    return self.currentToken;
}

- (void)error:(NSString*)errorType
{
	NSLog(@"%@", self.rootNode);
	[NSException raise:errorType format:@"Error on line %i, column %i, token %@", [[self.lex class] line], [[self.lex class] column], self.currentToken];
}

- (void) parse
{
	if (self.currentToken)
		[self T:self.currentToken];
}

#pragma mark - Productions

/** T -> [S] //This is where we start. */
- (Node*) T:(Token*)t
{
	Node *tempNode = [[Node alloc] initWithProduction:ProductionTypeT];
	self.rootNode = tempNode;

    if (t.tag == '[')
	{
		// [
        [tempNode addChild:[[Node alloc] initWithToken:t]];
		
        // S
        t = [self getNextToken];
        [tempNode addChild:[self S:t]];
        
		// ] 
        t = [self getNextToken];
        if (t.tag != ']') {
            [self error:@"syntax error"];
        }
        [tempNode addChild:[[Node alloc] initWithToken:t]];

		// get next token so we're ready to parse the next statement.
		[self getNextToken];

        return tempNode;
    }
	else
	{
        [self error:@"syntax error"];
    }

    return nil;
}

/** S -> expr S_ | []S_ | [S]S_ */
- (Node*) S:(Token*)t
{
    Node *tempNode = [[Node alloc] initWithProduction:ProductionTypeS];

	if(self.lookAhead.tokType == TokenTypeBinOp ||
	   self.lookAhead.tokType == TokenTypeUnOp ||
	   t.tokType == TokenTypeConstant ||
	   t.tokType == TokenTypeName ||
	   self.lookAhead.tokType == TokenTypeAssign ||
	   self.lookAhead.tag == IF ||
	   self.lookAhead.tag == WHILE ||
	   self.lookAhead.tag == STDOUT ||
	   self.lookAhead.tag == LET)
	{
		// S -> expr S_
		[tempNode addChild:[self expr:t]];
		t = [self getNextToken];
		Node *aNode = [self S_:t];
		[tempNode addChild:aNode];
	}
	else if(t.tag == '[' && self.lookAhead.tag == ']')
	{
		// S -> []S_
		[tempNode addChild:[Node nodeWithToken:t]]; // [
		[tempNode addChild:[Node nodeWithToken:[self getNextToken]]]; // ]
		[tempNode addChild:[self S_:[self getNextToken]]]; // S_
	}
	else if (t.tag == '[')
	{
		// S -> [S]S_
		[tempNode addChild:[Node nodeWithToken:t]]; // [
		t = [self getNextToken];
		[tempNode addChild:[self S:t]]; // S
		t = [self getNextToken];
		if (t.tag != ']') {
			[self error:@"syntax error"];
		}
		[tempNode addChild:[Node nodeWithToken:t]]; // ]

		[tempNode addChild:[self S_:[self getNextToken]]]; // S_
	}
	else
		return nil;

	return tempNode;
}

/** S_ -> SS_ | empty */
- (Node*) S_:(Token*)t
{
    Node *tempNode = [[Node alloc] initWithProduction:ProductionTypeS_];

	Node *SNode = [self S:t];
	if (SNode)
	{
		[tempNode addChild:SNode]; // S
		t = [self getNextToken];
		Node *S_Node = [self S_:t];
		if (S_Node)
		{
			[tempNode addChild:S_Node]; // S_
		}
		return tempNode;
	}
	else
		return nil;

	return tempNode;
}

/** expr -> oper | stmts */
- (Node*) expr:(Token*)t
{
    Node *tempNode = [[Node alloc] initWithProduction:ProductionTypeExpr];
    if(self.lookAhead.tag == IF || self.lookAhead.tag == WHILE ||
	   self.lookAhead.tag == STDOUT || self.lookAhead.tag == LET )
	{
        [tempNode addChild:[self stmts:t]];
        return tempNode;
    }
	else if(self.lookAhead.tokType == TokenTypeBinOp || self.lookAhead.tokType == TokenTypeUnOp ||
			t.tokType == TokenTypeConstant || t.tokType == TokenTypeName
            || self.lookAhead.tokType == TokenTypeAssign)
	{
        [tempNode addChild:[self oper:t]];
        return tempNode;
    }
	else
        [self error:@"syntax error"];

    return tempNode;
}

/** oper -> [:= name oper] | [binops oper oper] | [unops oper] | constants | name */
- (Node*) oper:(Token*)t
{
	Node *tempNode = [[Node alloc] initWithProduction:ProductionTypeOper];
	if (t.tokType == TokenTypeConstant)
	{
		[tempNode addChild:[[Node alloc] initWithToken:t]];
		return tempNode;
	}
    else if (t.tokType == TokenTypeName)
	{
		[tempNode addChild:[[Node alloc] initWithToken:t]];
		return tempNode;
	}
    else if (t.tag == '[')
	{
        [tempNode addChild:[[Node alloc] initWithToken:t]];
        
		t = [self getNextToken];
        
        if (t.tokType == TokenTypeBinOp)
        {
            // Production: [binops oper oper]
            [tempNode addChild:[[Node alloc] initWithToken:t]];
            
            // oper
            t = [self getNextToken];
            [tempNode addChild:[self oper:t]];
            
            // oper
            t = [self getNextToken];
            [tempNode addChild:[self oper:t]];
        }
        else if (t.tokType == TokenTypeUnOp)
        {
            // Production: [unops oper]
            [tempNode addChild:[[Node alloc] initWithToken:t]];
            
            // oper
            t = [self getNextToken];
            [tempNode addChild:[self oper:t]];
        }
        else if (t.tokType == TokenTypeAssign)
        {
            // Production: [:= name oper]
            //Add the ':' and the '=' to the Node
            [tempNode addChild:[[Node alloc] initWithToken:t]];
            
            //name
            t = [self getNextToken];
            if(t.tokType != TokenTypeName){
                [self error:@"syntax error"];
            }
            [tempNode addChild:[[Node alloc] initWithToken:t]];
            
            //oper
            t = [self getNextToken];
            [tempNode addChild:[self oper:t]];
        } else {
            [self error:@"syntax error"];
        }

        // Finish all of these productions that opened with '['
        t = [self getNextToken];
        if (t.tag != ']'){
            [self error:@"syntax error"];
        }
        [tempNode addChild:[[Node alloc] initWithToken:t]];
        return tempNode;
	} else {
        [self error:@"syntax error"];
    }
    return tempNode;
}

/** stmts -> ifstmts | whilestmts | letstmts | printsmts */
- (Node*) stmts:(Token*)t
{
    Node *tempNode = [[Node alloc] initWithProduction:ProductionTypeStmts];

    if(self.lookAhead.tag == IF){
        [tempNode addChild:[self ifstmts:t]];
    } else if(self.lookAhead.tag == WHILE){
        [tempNode addChild:[self whilestmts:t]];
    } else if(self.lookAhead.tag == LET){
        [tempNode addChild:[self letstmts:t]];
    } else if(self.lookAhead.tag == STDOUT){
        [tempNode addChild:[self printstmts:t]];
    } else {
        [self error:@"syntax error"];
    }
    return tempNode;
}

/** ifstmts -> [if expr expr expr] | [if expr expr] */
- (Node*) ifstmts:(Token*)t
{
    Node *tempNode = [[Node alloc] initWithProduction:ProductionTypeIfStmt];
    if (t.tag == '['){
        [tempNode addChild:[[Node alloc] initWithToken:t]];
        
		t = [self getNextToken];
        if(t.tag != IF){
            [self error:@"syntax error"];
        }
        [tempNode addChild:[[Node alloc] initWithToken:t]];
        
        //expr
        t = [self getNextToken];
        [tempNode addChild:[self expr:t]];
        
        //expr
        t = [self getNextToken];
        [tempNode addChild:[self expr:t]];
        
        //Use lookahead to check if there is a third expression
        if(self.lookAhead.tag == '['){
            //expr
            t = [self getNextToken];
            [tempNode addChild:[self expr:t]];
        }
        
        //Finish both productions
        t = [self getNextToken];
        if (t.tag != ']'){
            [self error:@"syntax error"];
        }
        [tempNode addChild:[[Node alloc] initWithToken:t]];
        return tempNode;
    } else {
        [self error:@"syntax error"];
    }
    return tempNode;
}

/** whilestmts -> [while expr exprlist] */
- (Node*) whilestmts:(Token*)t
{
    Node *tempNode = [[Node alloc] initWithProduction:ProductionTypeWhileStmt];
    if (t.tag == '['){
        [tempNode addChild:[[Node alloc] initWithToken:t]];
        
        //while
		t = [self getNextToken];
        if(t.tag != WHILE){
            [self error:@"syntax error"];
        }
        [tempNode addChild:[[Node alloc] initWithToken:t]];
        
        //expr
        t = [self getNextToken];
        [tempNode addChild:[self expr:t]];
        
        //exprlist
        t = [self getNextToken];
        [tempNode addChild:[self exprlist:t]];
        
        t = [self getNextToken];
        if (t.tag != ']'){
            [self error:@"syntax error"];
        }
        [tempNode addChild:[[Node alloc] initWithToken:t]];
        return tempNode;
    } else {
        [self error:@"syntax error"];
    }
    return tempNode;
}

/** letstmts -> [let [varlist]] */
- (Node*) letstmts:(Token*)t
{
    Node *tempNode = [[Node alloc] initWithProduction:ProductionTypeLetStmt];
    if(t.tag == '['){
        [tempNode addChild:[[Node alloc] initWithToken:t]];
        
        //let
        t = [self getNextToken];
        if(t.tag != LET){
            [self error:@"syntax error"];
        }
        [tempNode addChild:[[Node alloc] initWithToken:t]];
        
        t = [self getNextToken];
        if(t.tag != '['){
            [self error:@"syntax error"];
        }
        [tempNode addChild:[[Node alloc] initWithToken:t]];
        
        //varlist
		t = [self getNextToken];
        [tempNode addChild:[self varlist:t]];
        
        //Need 2 closing brackets
        t = [self getNextToken];
        if (t.tag != ']'){
            [self error:@"syntax error"];
        }
        [tempNode addChild:[[Node alloc] initWithToken:t]];

        if (t.tag != ']'){
            [self error:@"syntax error"];
        }
        [tempNode addChild:[[Node alloc] initWithToken:t]];
        return tempNode;
    } else {
        [self error:@"syntax error"];
    }
    return tempNode;
}

/** varlist -> [name type] | [name type] varlist */
- (Node*) varlist:(Token*)t
{
    Node *tempNode = [[Node alloc] initWithProduction:ProductionTypeVarlistStmt];
    if (t.tag == '['){
        [tempNode addChild:[[Node alloc] initWithToken:t]];
        
        //name
        t = [self getNextToken];
        if(t.tokType != TokenTypeName){
            [self error:@"syntax error"];
        }
        [tempNode addChild:[[Node alloc] initWithToken:t]];
        
        //type
        t = [self getNextToken];
        if(t.tokType != TokenTypeType){
            [self error:@"syntax error"];
        }
        [tempNode addChild:[[Node alloc] initWithToken:t]];
                
        t = [self getNextToken];
        if (t.tag != ']'){
            [self error:@"syntax error"];
        }
        [tempNode addChild:[[Node alloc] initWithToken:t]];
        
        //Use the lookahead to determine if there's another varlist
        if(self.lookAhead.tag == '['){
            t = [self getNextToken];
            [tempNode addChild:[self varlist:t]];
        }
        return tempNode;
    } else {
        [self error:@"syntax error"];
    }
    return tempNode;
}

/** printstmts -> [stdout oper] */
- (Node*) printstmts:(Token*)t
{
    Node *tempNode = [[Node alloc] initWithProduction:ProductionTypePrintStmts];
    if (t.tag == '['){
        [tempNode addChild:[[Node alloc] initWithToken:t]];
        
        //stdout
        t = [self getNextToken];
        if(t.tag != STDOUT){
            [self error:@"syntax error"];
        }
        [tempNode addChild:[[Node alloc] initWithToken:t]];
        
        //oper
        t = [self getNextToken];
        [tempNode addChild:[self oper:t]];
        
        //Finish production
        t = [self getNextToken];
        if (t.tag != ']'){
            [self error:@"syntax error"];
        }
        [tempNode addChild:[[Node alloc] initWithToken:t]];
        return tempNode;
    } else {
        [self error:@"syntax error"];
    }
    return tempNode;
}

/** exprlist -> expr | expr exprlist */
- (Node*) exprlist:(Token*)t
{
    Node *tempNode = [[Node alloc] initWithProduction:ProductionTypeExprList];
    return tempNode;
}

@end
