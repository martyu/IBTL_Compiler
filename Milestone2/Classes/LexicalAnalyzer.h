//
//  LexicalAnalyzer.h
//  Milestone2
//
//  Created by Marty Ulrich on 1/25/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

@protocol LexicalAnalyzerDataSource <NSObject>

/** Returns the next character in the stream. */
- (char)nextCharacter;

@end


@interface LexicalAnalyzer : NSObject

@property(nonatomic) int line;
@property(weak, nonatomic) id<LexicalAnalyzerDataSource> dataSource;

@end
