//
//  Environment.h
//  Milestone2
//
//  Created by Marty Ulrich on 2/12/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Token Classes/Token.h"

@interface Environment : NSObject

- (instancetype)initWithParentEnvironment:(Environment*)parent;
- (id)get:(Token*)tok;

@end
