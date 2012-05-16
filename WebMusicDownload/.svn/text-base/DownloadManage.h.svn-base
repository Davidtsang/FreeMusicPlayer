//
//  DownloadManage.h
//  WebMusicDownload
//
//  Created by Zen David on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Download.h"

#define kNoticeDownloadRemoveWaiting @"downloadRemoveWaiting"
#define kNoticeDownloadAddWaiting @"downloadAddWaiting"
#define kNoticeDownloadUpdate @"downloadUpdate"


@class WebMusicDownloadAppDelegate;
@class PlayList;
@class UploadSongInfo;

@interface DownloadManage : NSObject {
    
    NSInteger taskLimit;
    NSMutableDictionary* downloadItems;
    NSMutableArray* waitingTaskList;
    WebMusicDownloadAppDelegate *appDelegate;
    PlayList *playlistObj;
    UploadSongInfo *uploadSongInfo;
}
@property(nonatomic,assign)NSInteger taskLimit;
@property(nonatomic,retain)NSMutableDictionary* downloadItems;
@property(nonatomic,retain)NSMutableArray* waitingTaskList;

-(void)addURLtoDownload:(NSString *)aURL;
-(void)startDownloadFromTask:(NSMutableDictionary *)taskItem;
-(void)stopTask:(NSNumber *)nTID;
-(void)resumeTaskFormDBS:(NSNumber *)nTID;
-(void)addTaskToQueue:(NSMutableDictionary *)taskItem;
-(BOOL)testWatingStatus:(NSNumber *)taskID;
-(void)removeWaitingFromTID:(NSNumber *)nTID;
-(void)stopAllTasks;
-(void)pauseAllTasks;
-(NSInteger)getActiveItemNum;
-(void)setPlayerBadge;
-(void)resumePausedTasks;
@end
