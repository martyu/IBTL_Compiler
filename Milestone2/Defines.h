//
//  TagDefines.h
//  Milestone2
//
//  Created by Marty Ulrich on 1/28/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#define NEQ		300
#define LE 		301
#define GE 		302
#define ID		303
#define TRUE_	304
#define FALSE_	305
#define AND		306
#define OR		307
#define FLOAT	308
#define NOT		309
#define SIN		310
#define COS		311
#define TAN		312
#define STDOUT	313
#define IF		314
#define WHILE	315
#define LET		316
#define INT		317
#define STRING	318
#define INTEGER	319
#define BOOL_	320
// not sure why we skipped 321/322...
#define NEG		323 // '-' (negative).  '-' (minus) uses itself as a tag.
#define ASSIGN	324 // ":-"
#define TYPE	325

#define INT_TYPE @"int"
#define FLOAT_TYPE @"float"
#define CHAR_TYPE @"char"
#define BOOL_TYPE @"bool"


@interface Defines : NSObject

+ (NSString*) descriptionForConstant:(int)val;

@end