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
		_words = [NSMutableDictionary dictionary];
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
	[self addKeyword:[Word wordWithType:WordSetupTypeTrue]];
	[self addKeyword:[Word wordWithType:WordSetupTypeFalse]];
	[self addKeyword:[Word wordWithType:WordSetupTypeAnd]];
	[self addKeyword:[Word wordWithType:WordSetupTypeEq]];
	[self addKeyword:[Word wordWithType:WordSetupTypeGE]];
	[self addKeyword:[Word wordWithType:WordSetupTypeLE]];
	[self addKeyword:[Word wordWithType:WordSetupTypeMinus]];
	[self addKeyword:[Word wordWithType:WordSetupTypeNE]];
	[self addKeyword:[Word wordWithType:WordSetupTypeOr]];
	[self addKeyword:[Word wordWithType:WordSetupTypeTemp]];
	[self addKeyword:[Word wordWithType:WordSetupTypeTrue]];
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
            return [Word wordWithType:WordSetupTypePlus];
            break;
        case '-':
            return [Word wordWithType:WordSetupTypeMinus];
            break;
        case '/':
            return [Word wordWithType:WordSetupTypeDivide];
            break;
        case '%':
            return [Word wordWithType:WordSetupTypeMod];
            break;
        case '^':
            return [Word wordWithType:WordSetupTypePower];
            break;
		case '|':
			if ([self readCharacter:'|'])
				return [Word wordWithType:WordSetupTypeOr];
			else
				return [Token tokenWithTag:'|'];
			break;

		case '=':
			if ([self readCharacter:'='])
				return [Word wordWithType:WordSetupTypeEq];
			else
				return [Token tokenWithTag:'='];
			break;

		case '!':
			if ([self readCharacter:'='])
				return [Word wordWithType:WordSetupTypeNE];
			else
				return [Token tokenWithTag:'!'];
			break;

		case '<':
			if ([self readCharacter:'='])
				return [Word wordWithType:WordSetupTypeLE];
			else
				return [Token tokenWithTag:'<'];
			break;

		case '>':
			if ([self readCharacter:'='])
				return [Word wordWithType:WordSetupTypeGE];
			else
				return [Token tokenWithTag:'>'];
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

	if (isalpha(self.peek))
	{
		NSMutableString *buffer = [NSMutableString string];
		do
		{
			[buffer appendFormat:@"%c", self.peek];
			[self readCharacter];
		} while (isalnum(self.peek));

		Word *word = self.words[buffer];
		if (word)
			return word;

		word = [[Word alloc] initWithLexeme:buffer tag:ID];
		self.words[buffer] = word;
		return word;
	}

	if (self.peek == '\0')
		return nil;

	Token *token = [Token tokenWithTag:self.peek];
	self.peek = ' ';
	return token;
}

@end