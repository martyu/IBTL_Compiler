//
//  Parser.h
//  Milestone2
//
//  Created by Marty Ulrich on 1/25/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

@protocol ParserDelegate <NSObject>

@required
-(void) didFindToken:(NSString*)token;

@end

@interface Parser : NSObject

@property (weak, nonatomic) id<ParserDelegate> delegate;

@end
