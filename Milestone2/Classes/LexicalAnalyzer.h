//
//  LexicalAnalyzer.h
//  Milestone2
//
//  Created by Marty Ulrich on 1/25/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

@class Token;

@interface LexicalAnalyzer : NSObject

- (instancetype)initWithSource:(NSString*)theSourceCode;
- (Token*)getNextToken;

@end
