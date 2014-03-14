//
//  Environment.m
//  Milestone2
//
//  Created by Marty Ulrich on 2/12/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Environment.h"

@interface Environment ()

@property (strong, nonatomic) NSMutableDictionary *symTable;
@property (weak, nonatomic) Environment *parentEnv;

@end

@implementation Environment

- (instancetype)initWithParentEnvironment:(Environment*)parent
{
    self = [super init];
    if (self) {
        _parentEnv = parent;
		_symTable = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)get:(Token*)tok
{
	for (Environment *env = self; env; env = env.parentEnv)
	{
		id foundToken = env.symTable[tok];
		if (foundToken)
			return foundToken;
	}

	return nil;
}

@end
