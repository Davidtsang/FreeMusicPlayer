//
//  Downloader.h
//  WebMusicDownload
//
//  Created by Zen David on 8/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DownloadProgressView.h"


#define kTaskUrl @"url"
#define kTaskSavePath @"savePath"
#define kTaskTempSavePath @"tempSavePath"
#define kTaskProgressIndicator @"progressIndicator"
#define kTaskRequestName @"requestName"
#define kTaskID @"taskID"


@class ASINetworkQueue;
@class WebMusicDownloadAppDelegate;


@interface Downloader : NSObject {

    NSInteger runingTaskCount;
    NSMutableArray *waitingStartTids;
    NSInteger taskLimit;
    //    NSMutableArray *stopTaskList;
    NSMutableDictionary* runingTaskItems;
    NSMutableDictionary* errorTaskItems;
    ASINetworkQueue *networkQueue;
    BOOL failed;
    WebMusicDownloadAppDelegate *appDelegate;
    NSArray* activeItems;

   
}
 
@property(nonatomic,assign) NSInteger runingTaskCount;
@property(nonatomic,retain) NSMutableArray *waitingStartTids;
@property(nonatomic,assign)NSInteger taskLimit;
@property(nonatomic,retain)NSMutableDictionary* runingTaskItems;
@property(nonatomic,retain)NSMutableDictionary*  errorTaskItems;
@property(nonatomic,retain)NSArray* activeItems;

-(NSArray *)makeTaskItem:(NSArray *)UrlItems;
-(void)startDownloadTask:(NSArray *)taskItems;
- (void)addUrlsDownload:(NSArray *)urlItems;
//
-(void)cancelAllTasks;

//- (void)allTaskStop;
//- (void)addNewTask:(NSDictionary *)aTask;
//- (void)startTask:(NSInteger)taskID;
//- (void)stopTask:(NSInteger)taskID;
//- (void)taskContinue:(NSInteger)taskID;
//- (void)deleteTask:(NSInteger)taskID;
//
////--------callback
//-(void)taskcomplete:(id)sender;
//-(void)taskProgress:(id)sender;
//-(void)taskError:(id)sender;

@end
