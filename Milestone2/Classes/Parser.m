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
#import "Tree.h"

@interface Parser ()

@property (strong, nonatomic) LexicalAnalyzer *lex;
@property (strong, nonatomic) Environment *top;
@property (strong, nonatomic) Tree *rootNode;

@end


//@todo: Need to either left factor or use 2 lookaheads

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
    //@todo: Make sure lookAhead always has the next one
    self.lookAhead = [self.lex scan];
    return self.currentToken;
}

// Use getNextToken instead
- (void)move
{
	self.lookAhead = [self.lex scan];
}

- (void)error:(NSString*)errorType
{
	NSLog(@"%@", self.rootNode);
	[NSException raise:errorType format:@"Error near line %i, token %@", [[self.lex class] line], self.currentToken];
}

- (void)match:(int)aTag
{
	if (self.lookAhead.tag == aTag)
		[self move];
	else
		[self error:@"syntax error"];
}


#pragma mark - Productions


/** T -> [S] //This is where we start. */
- (Tree*) T:(Token*)t
{
	Tree *tempTree = [[Tree alloc] init];
	self.rootNode = tempTree;

    if (t.tag == '['){
        [tempTree addChild:[[Tree alloc] initWithToken:t]];
		
        //S
        t = [self getNextToken];
        [tempTree addChild:[self S:t]];
        
        t = [self getNextToken];
        if (t.tag != ']'){
            [self error:@"syntax error"];
        }
        [tempTree addChild:[[Tree alloc] initWithToken:t]];
        return tempTree;
    } else {
        [self error:@"syntax error"];
    }
    return tempTree;
}

/** S -> [ ] | [S] | SS | expr */
- (Tree*) S:(Token*)t
{
    Tree *tempTree = [[Tree alloc] init];
    
    if (t.tag == '[')
	{
        if(self.lookAhead.tokType == TokenTypeBinOp ||
           self.lookAhead.tokType == TokenTypeUnOp ||
           self.lookAhead.tokType == TokenTypeConstant ||
           self.lookAhead.tokType == TokenTypeName ||
           self.lookAhead.tag == IF ||
           self.lookAhead.tag == WHILE ||
           self.lookAhead.tag == STDOUT ||
           self.lookAhead.tag == LET)
		{
            //expr production
            [tempTree addChild:[self expr:t]];
        }
        
        [tempTree addChild:[[Tree alloc] initWithToken:t]];

		t = [self getNextToken];
        if (t.tag == ']'){ //Since we don't tokenize spaces
            [tempTree addChild:[[Tree alloc] initWithToken:t]];
            return tempTree;
        } else {
            // [S] production. Recurse.
            [tempTree addChild:[self S:t]];
            t = [self getNextToken];
            if (t.tag != ']'){
                [self error:@"syntax error"];
            }
            [tempTree addChild:[[Tree alloc] initWithToken:t]];
            
            //Check for another S production (because we can have S -> SS)
            if(self.lookAhead.tag == '['){
                t = [self getNextToken];
                [tempTree addChild:[self S:t]];
            }
            return tempTree;
        }
    }
    
    return tempTree;
}

/** expr -> oper | stmts */
- (Tree*) expr:(Token*)t
{
    Tree *tempTree = [[Tree alloc] init];
    if(self.lookAhead.tag == IF || self.lookAhead.tag == WHILE ||
	   self.lookAhead.tag == STDOUT || self.lookAhead.tag == LET)
	{
        [tempTree addChild:[self stmts:t]];
        return tempTree;
    }
	else if(self.lookAhead.tokType == TokenTypeBinOp || self.lookAhead.tokType == TokenTypeUnOp ||
			self.lookAhead.tokType == TokenTypeConstant || self.lookAhead.tokType == TokenTypeName)
	{
        [tempTree addChild:[self oper:t]];
        return tempTree;
    }
	else
        [self error:@"syntax error"];

    return tempTree;
}

/** oper -> [:= name oper] | [binops oper oper] | [unops oper] | constants | name */
- (Tree*) oper:(Token*)t
{
	Tree *tempTree = [[Tree alloc] init];
	if (t.tokType == TokenTypeConstant)
	{
		[tempTree addChild:[[Tree alloc] initWithToken:t]];
		return tempTree;
	}
    else if (t.tokType == TokenTypeName)
	{
		[tempTree addChild:[[Tree alloc] initWithToken:t]];
		return tempTree;
	}
    else if (t.tag == '[')
	{
        [tempTree addChild:[[Tree alloc] initWithToken:t]];
        
		t = [self getNextToken];
        
        if (t.tokType == TokenTypeBinOp)
        {
            // Production: [binops oper oper]
            [tempTree addChild:[[Tree alloc] initWithToken:t]];
            
            // oper
            t = [self getNextToken];
            [tempTree addChild:[self oper:t]];
            
            // oper
            t = [self getNextToken];
            [tempTree addChild:[self oper:t]];
        }
        else if (t.tokType == TokenTypeUnOp)
        {
            // Production: [unops oper]
            [tempTree addChild:[[Tree alloc] initWithToken:t]];
            
            // oper
            t = [self getNextToken];
            [tempTree addChild:[self oper:t]];
        }
        else if (t.tag == ':' && self.lookAhead.tag == '!')
        {
            // Production: [:= name oper]
            //Add the ':' and the '=' to the tree
            [tempTree addChild:[[Tree alloc] initWithToken:t]];
            t = [self getNextToken];
            [tempTree addChild:[[Tree alloc] initWithToken:t]];
            
            t = [self getNextToken];
            if(t.tokType == TokenTypeName)
            {
                [tempTree addChild:[[Tree alloc] initWithToken:t]];
            } else {
                [self error:@"syntax error"];
            }
            
            //oper
            t = [self getNextToken];
            [tempTree addChild:[self oper:t]];
        } else {
            [self error:@"syntax error"];
        }

        // Finish all of these productions that opened with '['
        t = [self getNextToken];
        if (t.tag != ']'){
            [self error:@"syntax error"];
        }
        [tempTree addChild:[[Tree alloc] initWithToken:t]];
        return tempTree;
	} else {
        [self error:@"syntax error"];
    }
    return tempTree;
}

/** stmts -> ifstmts | whilestmts | letstmts | printsmts */
- (Tree*) stmts:(Token*)t
{
    Tree *tempTree = [[Tree alloc] init];
    t = [self getNextToken];
    if(self.lookAhead.tag == IF){
        [tempTree addChild:[self ifstmts:t]];
    } else if(self.lookAhead.tag == WHILE){
        [tempTree addChild:[self whilestmts:t]];
    } else if(self.lookAhead.tag == LET){
        [tempTree addChild:[self letstmts:t]];
    } else if(self.lookAhead.tag == STDOUT){
        [tempTree addChild:[self printstmts:t]];
    } else {
        [self error:@"syntax error"];
    }
    return tempTree;
}

/** ifstmts -> [if expr expr expr] | [if expr expr] */
- (Tree*) ifstmts:(Token*)t
{
    Tree *tempTree = [[Tree alloc] init];
    if (t.tag == '['){
        [tempTree addChild:[[Tree alloc] initWithToken:t]];
        
		t = [self getNextToken];
        if(t.tag != IF){
            [self error:@"syntax error"];
        }
        [tempTree addChild:[[Tree alloc] initWithToken:t]];
        
        //expr
        t = [self getNextToken];
        [tempTree addChild:[self expr:t]];
        
        //expr
        t = [self getNextToken];
        [tempTree addChild:[self expr:t]];
        
        //Use lookahead to check if there is a third expression
        if(self.lookAhead.tag == '['){
            //expr
            t = [self getNextToken];
            [tempTree addChild:[self expr:t]];
        }
        
        //Finish both productions
        t = [self getNextToken];
        if (t.tag != ']'){
            [self error:@"syntax error"];
        }
        [tempTree addChild:[[Tree alloc] initWithToken:t]];
        return tempTree;
    } else {
        [self error:@"syntax error"];
    }
    return tempTree;
}

/** whilestmts -> [while expr exprlist] */
- (Tree*) whilestmts:(Token*)t
{
    Tree *tempTree = [[Tree alloc] init];
    if (t.tag == '['){
        [tempTree addChild:[[Tree alloc] initWithToken:t]];
        
        //while
		t = [self getNextToken];
        if(t.tag != WHILE){
            [self error:@"syntax error"];
        }
        [tempTree addChild:[[Tree alloc] initWithToken:t]];
        
        //expr
        t = [self getNextToken];
        [tempTree addChild:[self expr:t]];
        
        //exprlist
        t = [self getNextToken];
        [tempTree addChild:[self exprlist:t]];
        
        t = [self getNextToken];
        if (t.tag != ']'){
            [self error:@"syntax error"];
        }
        [tempTree addChild:[[Tree alloc] initWithToken:t]];
        return tempTree;
    } else {
        [self error:@"syntax error"];
    }
    return tempTree;
}

/** letstmts -> [let [varlist]] */
- (Tree*) letstmts:(Token*)t
{
    Tree *tempTree = [[Tree alloc] init];
    if(t.tag == '['){
        [tempTree addChild:[[Tree alloc] initWithToken:t]];
        
        //let
        t = [self getNextToken];
        if(t.tag != LET){
            [self error:@"syntax error"];
        }
        
        t = [self getNextToken];
        if(t.tag != '['){
            [self error:@"syntax error"];
        }
        
        //varlist
        t = [self getNextToken];
        [tempTree addChild:[self varlist:t]];
        
        //Need 2 closing brackets
        t = [self getNextToken];
        if (t.tag != ']'){
            [self error:@"syntax error"];
        }
        [tempTree addChild:[[Tree alloc] initWithToken:t]];
        
        if (t.tag != ']'){
            [self error:@"syntax error"];
        }
        [tempTree addChild:[[Tree alloc] initWithToken:t]];
        return tempTree;
    } else {
        [self error:@"syntax error"];
    }
    return tempTree;
}

/** varlist -> [name type] | [name type] varlist */
- (Tree*) varlist:(Token*)t
{
    Tree *tempTree = [[Tree alloc] init];
    if (t.tag == '['){
        [tempTree addChild:[[Tree alloc] initWithToken:t]];
        
        //name
        t = [self getNextToken];
        if(t.tokType != TokenTypeName){
            [self error:@"syntax error"];
        }
        [tempTree addChild:[[Tree alloc] initWithToken:t]];
        
        //type
        t = [self getNextToken];
        if(t.tokType != TokenTypeType){
            [self error:@"syntax error"];
        }
        [tempTree addChild:[[Tree alloc] initWithToken:t]];
        
        //type
        t = [self getNextToken];
        if(t.tokType != TokenTypeType){
            [self error:@"syntax error"];
        }
        [tempTree addChild:[[Tree alloc] initWithToken:t]];
        
        t = [self getNextToken];
        if (t.tag != ']'){
            [self error:@"syntax error"];
        }
        [tempTree addChild:[[Tree alloc] initWithToken:t]];
        
        //Use the lookahead to determine if there's another varlist
        if(self.lookAhead.tag == '['){
            t = [self getNextToken];
            [tempTree addChild:[self varlist:t]];
        }
        return tempTree;
    } else {
        [self error:@"syntax error"];
    }
    return tempTree;
}

/** printstmts -> [stdout oper] */
- (Tree*) printstmts:(Token*)t
{
    Tree *tempTree = [[Tree alloc] init];
    if (t.tag == '['){
        [tempTree addChild:[[Tree alloc] initWithToken:t]];
        
        //stdout
        t = [self getNextToken];
        if(t.tag != STDOUT){
            [self error:@"syntax error"];
        }
        [tempTree addChild:[[Tree alloc] initWithToken:t]];
        
        //oper
        t = [self getNextToken];
        [tempTree addChild:[self oper:t]];
        
        //Finish production
        t = [self getNextToken];
        if (t.tag != ']'){
            [self error:@"syntax error"];
        }
        [tempTree addChild:[[Tree alloc] initWithToken:t]];
        return tempTree;
    } else {
        [self error:@"syntax error"];
    }
    return tempTree;
}

/** exprlist -> expr | expr exprlist */
- (Tree*) exprlist:(Token*)t
{
    Tree *tempTree = [[Tree alloc] init];
    return tempTree;
}

@end
