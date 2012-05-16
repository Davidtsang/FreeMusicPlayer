//
//  Download.h
//  WebMusicDownload
//
//  Created by Zen David on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "MySqlite.h"

#define kDownloadTaskURL @"URL"
#define kDownloadTaskSavePath @"savePath"
#define kDownloadTaskTempSavePath @"tempSavePath"
#define kDownloadTaskProgressIndicator @"progressIndicator"
#define kDownloadTaskDisplayName @"displayName"
#define kDownloadTaskID @"taskID"
#define kDownloadTaskProgress @"progress"


#define kDownloadStatusBuffering @"Buffering..."
#define kDownloadStatusError @"Error"
#define kDownloadStatusStop @"Stop"
#define kDownloadStatusWaiting @"Waiting"
#define kDownloadStatusPause @"Pause"

#define kDownloadStatusComplete @"Complete"
#define kSongStatusDeleted @"deleted"

#define kNoticeDownloadComplete @"downloadComplete"
#define kNoticeDownloadFailed @"downloadFailed"
#define kNoticeDownloadStart @"downloadStart"


@class WebMusicDownloadAppDelegate;
@class ASIHTTPRequest;

@interface Download : NSObject {
    //NSString *itemURL;
    ASIHTTPRequest *request;
    WebMusicDownloadAppDelegate* appDelegate;
    BOOL failed;
    //id delegate;
    NSMutableDictionary *taskItem;
    BOOL isAutoCancel;
}
//@property(nonatomic,retain)NSString *itemURL;
@property(nonatomic,retain) ASIHTTPRequest *request;
@property(nonatomic,retain) NSMutableDictionary *taskItem;
@property(nonatomic,assign) BOOL isAutoCancel;

+(NSMutableDictionary *)makeTaskItem:(NSString *)taskURLString;
+(NSMutableDictionary *)makeTaskItemFormTID:(NSNumber *)nTID;

-(void)startDownloadTask;
//-(void)setDelegate:(id)aDelegate;
-(void)stopTask;
 

+(BOOL)checkSavePathExist:(NSString *)theSavePath;

@end
