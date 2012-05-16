//
//  MyUIProgressView.m
//  WebMusicDownload
//
//  Created by Zen David on 11-8-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MyUIProgressView.h"


@implementation MyUIProgressView
@synthesize userInfo;

- (void)dealloc{
    [userInfo release];
    [super dealloc];
    
}

@end
