//
//  Node.h
//  Milestone2
//
//  Created by Marty Ulrich on 2/13/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Token Classes/Token.h"

@interface Node : NSObject

@property(nonatomic, strong) NSMutableArray *children;
@property(nonatomic, strong) Token *token;

- (void) addChildNode:(Node*)node;
- (void) printChildren;

- (instancetype)initWithToken:(Token*)tok;

@end
