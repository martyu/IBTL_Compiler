//
//  LexicalAnalyzer.h
//  Milestone2
//
//  Created by Marty Ulrich on 1/25/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import "Token.h"

@interface LexicalAnalyzer : NSObject

@property(strong, nonatomic) NSMutableDictionary *words;

- (instancetype)initWithSource:(NSString*)source;

- (Token*)scan;

+ (int)line;
+ (void)setLine:(int)newLine;

@end
