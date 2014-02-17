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

@interface Parser ()

@property (strong, nonatomic) LexicalAnalyzer *lex;
@property (strong, nonatomic) Token *lookAhead;
@property (nonatomic) int used;
@property (strong, nonatomic) Environment *top;

@end

@implementation Parser

- (instancetype)initWithLexicalAnalyzer:(LexicalAnalyzer*)theLex
{
    self = [super init];
    if (self) {
        _lex = theLex;
		_used = 0;
		[self move];
    }
    return self;
}

- (void)move
{
	self.lookAhead = [self.lex scan];
}

- (void)error:(NSString*)errorType
{
	[NSException raise:errorType format:@"Error near line %i", [[self.lex class] line]];
}

- (void)match:(int)aTag
{
	if (self.lookAhead.tag == aTag)
		[self move];
	else
		[self error:@"syntax error"];
}


#pragma mark - Productions


- (void) start
{
	
}

/** expr -> oper | stmts */
- (void) expr
{
	[self oper];
	[self stmts];
}

/** oper -> [:= name oper] | [binops oper oper] | [unops oper] | constants | name */
- (void) oper
{
	if (self.lookAhead.tag == '[')
	{
		[self match:'['];

		if (self.lookAhead.tag == ':')
		{
			[self match:':'];
			[self match:'='];
			[self name];
		}
		else if (self.lookAhead.tokType == TokenTypeBinOp)
		{
			[self binOp];
			[self oper];
		}
		else if (self.lookAhead.tokType == TokenTypeUnOp)
		{
			[self unOp];
		}

		[self oper];
		[self match:']'];
	}
	else if (self.lookAhead.tokType == TokenTypeConstant)
	{
		[self constants];
	}
	else if (self.lookAhead.tokType == TokenTypeName)
	{
		[self name];
	}
	else
	{
		[self error:@"syntax error"];
	}
}

- (void) constants
{

}

/** binops -> + | - | * | / | % | ^ | = | > | >= | < | <= | != | or | and */
- (void) binOp
{

}

- (void) unOp
{

}

- (void) name
{

}

/** stmts -> ifstmts | whilestmts | letstmts | printsmts */
- (void) stmts
{
	[self ifstmts];
	[self whilestmts];
    [self letstmts];
    [self printsmts];
}


/** ifstmts -> [if expr expr expr] | [if expr expr] */
-(void) ifstmts
{
    
}

/** whilestmts -> [while expr exprlist] */
-(void) whilestmts
{
    
}

/** letstmts -> [let [varlist]] */
-(void) letstmts
{
    
}

/** varlist -> [name type] | [name type] varlist */
-(void) varlist
{
    
}

/** printstmts -> [stdout oper] */
-(void) printsmts
{
    
}

/** expr | expr exprlist */
-(void) exprlist
{
    
}

//- (void)program
//{
//	Stmt *s = [self block];
//	int begin = [s newLabel];
//	int after = [s newLabel];
//	[s emitLabel:begin];
//	// this is what it looks like to send anonymous arguments.  check gen's signature.
//	[s gen:begin:after];
//	[s emitLabel:after];
//}

@end
