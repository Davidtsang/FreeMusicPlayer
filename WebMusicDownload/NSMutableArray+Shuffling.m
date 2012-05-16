//
//  NSMutableArray+Shuffling.m
//  WebMusicDownload
//
//  Created by Zen David on 11-10-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NSMutableArray+Shuffling.h"


//@implementation NSMutableArray_Shuffling
@implementation NSMutableArray (Shuffling)

- (void)shuffle
{
    
    static BOOL seeded = NO;
    if(!seeded)
    {
        seeded = YES;
        srandom(time(NULL));
    }
    
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = (random() % nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end
