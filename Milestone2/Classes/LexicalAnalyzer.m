//
//  LexicalAnalyzer.m
//  Milestone2
//
//  Created by Marty Ulrich on 1/25/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "LexicalAnalyzer.h"
#import "Word.h"
#import "Num.h"
#import "Real.h"
#import "Defines.h"


@interface SourceServer : NSObject
@end

@interface SourceServer ()

@property(strong, nonatomic)NSString *sourceText;
@property(nonatomic)int index;

@end

@implementation SourceServer

- (instancetype)initWithSource:(NSString*)theSourceText
{
    self = [super init];
    if (self) {
		_sourceText = theSourceText;
    }
    return self;
}

- (char)nextCharacter
{
	if (self.index >= self.sourceText.length)
		return '\0';

	char next = [self.sourceText characterAtIndex:self.index++];
	return next;
}

@end



//////////////////////////////////////////////////////////////////////



@interface LexicalAnalyzer ()

@property(nonatomic) char peek;
@property(strong, nonatomic) SourceServer *sourceServer;

@end


@implementation LexicalAnalyzer

- (instancetype)init
{
    self = [super init];
    if (self) {
		_peek = ' ';
		_line = 1;
		[self setupReserveWords];

    }
    return self;
}

- (instancetype)initWithSource:(NSString*)source
{
	self = [self init];

	if (self) {
		_sourceServer = [[SourceServer alloc] initWithSource:source];
	}

	return self;
}

- (void)setupReserveWords
{
	self.words = [NSMutableDictionary dictionary];

	Word *keyword = [Word wordWithType:WordSetupTypeOr];
	self.words[keyword.lexeme] = keyword;
	keyword = [Word wordWithType:WordSetupTypeAnd];
	self.words[keyword.lexeme] = keyword;
	keyword = [Word wordWithType:WordSetupTypeTrue];
	self.words[keyword.lexeme] = keyword;
	keyword = [Word wordWithType:WordSetupTypeFalse];
	self.words[keyword.lexeme] = keyword;
	keyword = [Word wordWithType:WordSetupTypeTan];
	self.words[keyword.lexeme] = keyword;
	keyword = [Word wordWithType:WordSetupTypeSin];
	self.words[keyword.lexeme] = keyword;
	keyword = [Word wordWithType:WordSetupTypeCos];
	self.words[keyword.lexeme] = keyword;
	keyword = [Word wordWithType:WordSetupTypeNot];
	self.words[keyword.lexeme] = keyword;
	keyword = [Word wordWithType:WordSetupTypeBool];
	self.words[keyword.lexeme] = keyword;
	keyword = [Word wordWithType:WordSetupTypeFloat];
	self.words[keyword.lexeme] = keyword;
	keyword = [Word wordWithType:WordSetupTypeString];
	self.words[keyword.lexeme] = keyword;
	keyword = [Word wordWithType:WordSetupTypeInt];
	self.words[keyword.lexeme] = keyword;
	keyword = [Word wordWithType:WordSetupTypeIf];
	self.words[keyword.lexeme] = keyword;
	keyword = [Word wordWithType:WordSetupTypeWhile];
	self.words[keyword.lexeme] = keyword;
	keyword = [Word wordWithType:WordSetupTypeLet];
	self.words[keyword.lexeme] = keyword;
	keyword = [Word wordWithType:WordSetupTypeStdOut];
	self.words[keyword.lexeme] = keyword;

}

- (void)addKeyword:(Word*)keyword
{
	self.words[keyword.lexeme] = keyword;
}

- (void)readCharacter
{
	self.peek = [self.sourceServer nextCharacter];
}

- (BOOL)readCharacter:(char)c
{
	[self readCharacter];
	if (self.peek != c)
		return false;

	self.peek = ' ';
	return true;
}

- (Token*)scan
{
	for (;;[self readCharacter])
	{
		if (self.peek == ' ' || self.peek == '\t')
			continue;
		else if (self.peek == '\n')
			self.line++;
		else
			break;
	}

	switch (self.peek) {

        case '+':
		case '*':
		case '/':
		case '%':
		case '^':
		case '=':
		case '[':
		case ']':
		{
			Token *tok = [Token tokenWithTag:self.peek type:TokenTypeBinOp];
			// just to move index ahead 1.
			[self readCharacter];
			return tok;
			break;
		}
		case '-':
		{
			[self readCharacter];
			if (isnumber(self.peek))
				return [Token tokenWithTag:NEG type:TokenTypeUnOp];
			else
				return [Token tokenWithTag:'-' type:TokenTypeBinOp];
		}
		case '!':
			if ([self readCharacter:'='])
				return [Token tokenWithTag:NEQ type:TokenTypeBinOp];
			else
			{
				[self reportError];
				return [Token tokenWithTag:'!' type:TokenTypeNone];
			}
			break;

		case '<':
			if ([self readCharacter:'='])
				return [Token tokenWithTag:LE type:TokenTypeBinOp];
			else
				return [Token tokenWithTag:'<' type:TokenTypeBinOp];
			break;

		case '>':
			if ([self readCharacter:'='])
				return [Token tokenWithTag:GE type:TokenTypeBinOp];
			else
				return [Token tokenWithTag:'>' type:TokenTypeBinOp];
			break;

		case ':':
			if ([self readCharacter:'='])
				return [Token tokenWithTag:ASSIGN type:TokenTypeAssign];
			else
			{
				[self reportError];
				return [Token tokenWithTag:':' type:TokenTypeNone];
			}
			break;

		default:
			break;
	}

	if (isdigit(self.peek))
	{
		int v = 0;
		do
		{
			v = 10 * v + atoi(&_peek);
			[self readCharacter];
		} while (isdigit(self.peek));

		if (self.peek != '.')
			return [Num numWithValue:v];

		float x = v, d = 10.0;
		while (YES)
		{
			[self readCharacter];
			if (!isdigit(self.peek))
				break;
			x = x + atoi(&_peek) / d;
			d *= 10.0;
		}
		return [Real realWithValue:v];
	}


	if (isalpha(self.peek) || self.peek == '_')
	{
		NSMutableString *buffer = [NSMutableString string];
		do
		{
			[buffer appendFormat:@"%c", self.peek];
			[self readCharacter];
		} while (isalnum(self.peek) || self.peek == '_'	);

		Token *word = self.words[buffer];
		if (word)
			return word;

		word = [[Word alloc] initWithLexeme:buffer tag:ID type:TokenTypeWord];
		self.words[buffer] = word;
		return word;
	}

	// End of stream.
	if (self.peek == '\0')
		return nil;

	Token *token = [Token tokenWithTag:self.peek type:TokenTypeNone];
	self.peek = ' ';
	return token;
}

- (void)reportError
{
	NSLog(@"Syntax error on line %i", self.line);
}

@end