//
//  TagDefines.m
//  Milestone2
//
//  Created by Marty Ulrich on 1/28/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Defines.h"

@implementation Defines

+ (NSString*) descriptionForConstant:(int)val
{
	switch (val) {
		case NEQ:
			return @"NEQ";
			break;

		case LE:
			return @"LE";
			break;

		case GE:
			return @"GE";
			break;

		case ID:
			return @"ID";
			break;

		case TRUE_:
			return @"TRUE";
			break;

		case FALSE_:
			return @"FALSE";
			break;

		case AND:
			return @"AND";
			break;

		case OR:
			return @"OR";
			break;

		case NOT:
			return @"NOT";
			break;

		case SIN:
			return @"SIN";
			break;

		case COS:
			return @"COS";
			break;

		case TAN:
			return @"TAN";
			break;

		case STDOUT:
			return @"STDOUT";
			break;

		case IF:
			return @"IF";
			break;

		case WHILE:
			return @"WHILE";
			break;

		case LET:
			return @"LET";
			break;

		case INT:
			return @"INT";
			break;

		case STRING:
			return @"STRING";
			break;

		case FLOAT:
			return @"FLOAT";
			break;

		case BOOL_:
			return @"BOOL";
			break;

		case NEG:
			return @"NEG";
			break;

		case ASSIGN:
			return @"ASSIGN";
			break;

		default:
			break;
	}

	if (isascii(val))
	{
		NSString *str = [NSString stringWithFormat:@"'%c'", (char)val];
		return str;
	}

	return nil;

}

@end