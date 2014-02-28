//
//  CodeGenerator.h
//  Milestone2
//
//  Created by Marty Ulrich on 2/27/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Node;

@interface CodeGenerator : NSObject

+ (NSString*) generateCodeFromTree:(Node*)treeRoot;

@end
