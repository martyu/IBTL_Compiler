//
//  NSString+Utils.h
//  Milestone2
//
//  Created by Marty Ulrich on 1/26/14.
//  Copyright (c) 2014 Marty Ulrich/David Merrick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)

/** Replaces any length of consecutive whitespace with just one */
- (NSString*)stringByRemovingExcessWhitespace;

@end
