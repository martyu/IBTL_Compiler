//
//  Node.h
//  Milestone2
//
//  Created by Marty Ulrich on 2/13/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//


@interface Node : NSObject

+ (int)labels;
+ (void)setLabels:(int)labelsVal;
- (int)newLabel;
- (void)emitLabel:(int)i;
- (void)emit:(NSString*)str;

@end
