//
//  CodeGenerator.h
//  Milestone2
//
//  Created by Marty Ulrich on 2/27/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Classes/Node.h"

//For typechecking the oper production
typedef enum {
	OpTypeNone = -1,
	OpTypeFloat,
	OpTypeInt,
	OpTypeName
} OpType;

@interface CodeGenerator : NSObject

+ (NSString*) generateCodeFromTree:(Node*)treeRoot;

@end
