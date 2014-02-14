//
//  Node.m
//  Milestone2
//
//  Created by Marty Ulrich on 2/13/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Node.h"
#import "LexicalAnalyzer.h"

@interface Node ()

@property(nonatomic)int lexLine;

@end

static int _labels = 0;

@implementation Node

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lexLine = [LexicalAnalyzer line];
    }
    return self;
}

- (int)newLabel
{
	return ++_labels;
}

- (void)emitLabel:(int)i
{
	NSLog(@"L%i:", i);
}

- (void)emit:(NSString*)str
{
	NSLog(@"\t%@", str);
}

- (void)error:(NSString*)errStr
{
	[NSException raise:errStr format:@"near line %i", self.lexLine];
}

+ (int)labels
{
	return _labels;
}

+ (void)setLabels:(int)labelsVal
{
	_labels = labelsVal;
}


@end
