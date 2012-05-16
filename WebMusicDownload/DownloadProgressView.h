//
//  DownloadProgressView.h
//  WebMusicDownload
//
//  Created by Zen David on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIProgressDelegate.h"

@interface DownloadProgressView : UIProgressView
<ASIProgressDelegate>
{
    id delegate;
    //NSInteger currentTaskID;
    
}
- (void)setDelegate:(id)aDelegate;//delegate
- (void)setProgress:(float)newProgress;
//- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes;
@end
