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
#import "Float.h"
#import "Defines.h"


#define END_OF_FILE ';'

@interface SourceServer : NSObject
@end

static int _column = -2;

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

- (char)prevCharacter
{
	if (self.index >= self.sourceText.length)
		return '\0';

	char prev = [self.sourceText characterAtIndex:--self.index-1];

	return prev;
}

@end



//////////////////////////////////////////////////////////////////////



@interface LexicalAnalyzer ()

@property(nonatomic) char peek;
@property(strong, nonatomic) SourceServer *sourceServer;

@end

static int _line;

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

	_column++;

	//Keep track of what line number we're on
	if (self.peek == '\n') {
		_line++;
		_column = -2;
	}
}

- (void)pushBack
{
	self.peek = [self.sourceServer prevCharacter];
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
		if (self.peek == ' ' || self.peek == '\t' || self.peek == '\n') {
            //Skip spaces and tabs and newlines
            continue;
        } else if(self.peek == '/'){
            //Skip over comments formatted like /* comment */
            [self readCharacter];
            if(self.peek != '*')
			{
                [self pushBack];
				break;
            }
			else
			{
                [self readCharacter];
                while(self.peek != '\0')
				{
                    if(self.peek == '*')
					{
                        [self readCharacter];
                        if(self.peek == '/')
						{
                            break;
						}
                    }
                    [self readCharacter];
                }
				[self readCharacter];
            }
        } else {
			break;
        }
	}

	switch (self.peek) {

        case '+':
		case '*':
		case '/':
		case '%':
		case '^':
		case '=':
		{
			Token *tok = [Token tokenWithTag:self.peek type:TokenTypeBinOp];
			// just to move index ahead 1.
			[self readCharacter];
			return tok;
			break;
		}
		case '[':
		case ']':
		{
			Token *tok = [Token tokenWithTag:self.peek type:TokenTypeNone];
			// just to move index ahead 1.
			[self readCharacter];
			return tok;
			break;
		}
		case '-':
		{
			[self readCharacter];
			if (isnumber(self.peek) || self.peek == '.')
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
        case '"':
			{
                NSMutableString *buffer = [NSMutableString stringWithFormat:@"%c", self.peek];
				[self readCharacter];

				while (self.peek != '"' && self.peek != '\0') // '\0' condition to prevent potential infinite loop
				{
					[buffer appendFormat:@"%c", self.peek];
					[self readCharacter];
				}

				[buffer appendFormat:@"%c", self.peek];
				[self readCharacter];
				Token *word = self.words[buffer];
				if (!word) {
					word = [[Word alloc] initWithLexeme:buffer tag:ID type:TokenTypeName];
				}

				return word;
			}
			break;

		default:
			break;
	}

	if (isdigit(self.peek) || self.peek == '.')
	{
		float v = 0;
		while (isdigit(self.peek))
		{
			v = 10 * v + atoi(&_peek);
			[self readCharacter];
		}

		float d = 10.0;

		if (self.peek == '.')
		{
			[self readCharacter];
			while (isdigit(self.peek))
			{
				v = v + atoi(&_peek) / d;
				d *= 10.0;
				[self readCharacter];
			}

			if (self.peek != 'e'){
				return [Float floatWithValue:v];
			} else if(self.peek == '.'){ //in the case of like [-10.1.1]
				//Push back
				[self pushBack];
				return [Float floatWithValue:v];
			}
		}

		if (self.peek == 'e')
		{
			[self readCharacter];
			float expSign = 1.0;
			if (self.peek == '-')
			{
				expSign = -1.0;
				[self readCharacter];
			}
			else if (self.peek == '+')
				[self readCharacter];

			NSMutableString *exp = [NSMutableString string];

			if (!isdigit(self.peek))
				[self reportError];

			while (isdigit(self.peek))
			{
				[exp appendFormat:@"%c", self.peek];
				[self readCharacter];
			}

			v *= pow(10.0, expSign * atof([exp UTF8String]));

			return [Float floatWithValue:v];
		}

		return [Num numWithValue:v];
	}


	if (isalpha(self.peek) || self.peek == '_')
	{
		NSMutableString *buffer = [NSMutableString string];
		do
		{
			[buffer appendFormat:@"%c", self.peek];
			[self readCharacter];
		} while (isalnum(self.peek) || self.peek == '_');

		//To do: optimize this so there's no lookup. Write our own lookup function.
        //Could use the DFA idea here.
        Token *word = self.words[buffer];
		if (word)
			return word;

		word = [[Word alloc] initWithLexeme:buffer tag:ID type:TokenTypeName];
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
	NSLog(@"Syntax error on line %i", _line);
}

+ (int)line
{
	return _line;
}

+ (void)setLine:(int)line
{
	_line = line;
}

+ (int)column
{
	return _column;
}

@end