//
//  DownloadProgressView.m
//  WebMusicDownload
//
//  Created by Zen David on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DownloadProgressView.h"
#import "Download.h"
#import "MyUIProgressView.h"
#import "WebMusicDownloadAppDelegate.h"

@implementation DownloadProgressView

- (id)delegate
{
    return delegate;
}
- (void)setDelegate:(id)aDelegate
{
    delegate = aDelegate;
}

- (void)setProgress:(float)newProgress{
    if ([delegate respondsToSelector:@selector(setProgress:)]) {
        [delegate setProgress:newProgress];
    }
    MyUIProgressView* progress =(MyUIProgressView *)delegate;
    NSNumber* taskID =[progress.userInfo objectForKey:kDownloadTaskID];
     //NSLog(@"GET PROGRESS:%f,TID:%@",newProgress,[taskID stringValue]);
    //save to dbs
    //初始化应用程序委托
	WebMusicDownloadAppDelegate *appDelegate =(WebMusicDownloadAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.mysqlite.db executeUpdate:@"UPDATE task_list SET progress=? WHERE fid=?;",
     
     [NSNumber numberWithFloat:newProgress],
     taskID];
    
    if ([appDelegate.mysqlite.db hadError]) {
        NSLog(@"- (void)setProgress:(float)newProgress ->db Error :%@",[appDelegate.mysqlite.db lastErrorMessage]);
    }

}
@end
