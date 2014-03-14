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
			return @"!=";
			break;

		case LE:
			return @"<=";
			break;

		case GE:
			return @">=";
			break;

		case ID:
			return @"ID";
			break;

		case TRUE_:
			return @"true";
			break;

		case FALSE_:
			return @"false";
			break;

		case AND:
			return @"and";
			break;

		case OR:
			return @"or";
			break;

		case NOT:
			return @"not";
			break;

		case SIN:
			return @"sin";
			break;

		case COS:
			return @"cos";
			break;

		case TAN:
			return @"tan";
			break;

		case STDOUT:
			return @"stdout";
			break;

		case IF:
			return @"if";
			break;

		case WHILE:
			return @"while";
			break;

		case LET:
			return @"let";
			break;

		case INT:
			return @"int";
			break;

		case STRING:
			return @"string";
			break;

		case FLOAT:
			return @"float";
			break;

		case BOOL_:
			return @"bool";
			break;

		case NEG:
			return @"-";
			break;

		case ASSIGN:
			return @":=";
			break;

		case INTEGER:
			return @"integer";
			break;

		case TYPE:
			return @"type";
			break;

		default:
			break;
	}

	if (isascii(val))
	{
		NSString *str = [NSString stringWithFormat:@"%c", (char)val];
		return str;
	}

	return nil;

}

@end