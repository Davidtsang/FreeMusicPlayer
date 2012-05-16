//
//  DownloadManage.m
//  WebMusicDownload
//
//  Created by Zen David on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DownloadManage.h"
#import "WebMusicDownloadAppDelegate.h"
#import "MySqlite.h"
#import "UploadSongInfo.h"
#import "PlayList.h"

@interface DownloadManage ()
@property(nonatomic,retain) PlayList *playlistObj;
@property(nonatomic,retain) UploadSongInfo *uploadSongInfo;
-(void)updataSongInfo:(NSNumber *)songID ;
-(void)downloadTaskDone:(NSNotification *)notification success:(BOOL)aFlag;
@end

@implementation DownloadManage
@synthesize taskLimit;
@synthesize downloadItems;
@synthesize waitingTaskList;
@synthesize playlistObj;
@synthesize uploadSongInfo;

-(void)updataSongInfo:(NSNumber *)songID  
{
    //GET SONG INFO
    NSMutableDictionary *songInfo = [playlistObj getSongByID:songID];
    
    //UPLOAD
    if (self.uploadSongInfo.isBusy == NO) {
        UploadSongInfo * u =[[UploadSongInfo alloc] init] ;
        [u sendSongInfo:songInfo ];
        
        self.uploadSongInfo =u;
        [u release];
    }
   
}

-(void)removeWaitingFromTID:(NSNumber *)taskID
{
    NSEnumerator *elemantor =[waitingTaskList objectEnumerator];
    NSMutableDictionary *_item;
    
    while ((_item =[elemantor nextObject]))
    {
        if ([[_item objectForKey:kDownloadTaskID] isEqualToNumber:taskID] ) {
            [waitingTaskList removeObject:_item];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNoticeDownloadRemoveWaiting object:nil userInfo:[NSDictionary dictionaryWithObject:taskID forKey:kDownloadTaskID]];
            break;
        }    
    }
    
}

-(BOOL)testWatingStatus:(NSNumber *)taskID{
    NSEnumerator *elemantor =[waitingTaskList objectEnumerator];
    NSMutableDictionary *_item;
    BOOL itemExist =NO;
    while ((_item =[elemantor nextObject]))
    {
        if ([[_item objectForKey:kDownloadTaskID] isEqualToNumber:taskID] ) {
            itemExist =YES;
            break;
        }    
    }
    return itemExist;
}

-(void)stopTask:(NSNumber *)nTID
{
    //Download *thisActiveDownload =  [appDelegate.downloadManage.downloadItems objectForKey:nTid];
    //
    Download *theDownlaod = [downloadItems objectForKey:nTID];
    if(theDownlaod){
        [theDownlaod stopTask];
        //NSLog(@"stop task %d",[nTID integerValue]);
    }
    
}

-(void)stopAllTasks{
    NSEnumerator *enumerator =[downloadItems objectEnumerator];
    Download *aDownload;
    while ((aDownload =[enumerator nextObject])) {
        [aDownload stopTask];
    }
}
 
-(void)pauseAllTasks{
    NSEnumerator *enumerator =[downloadItems objectEnumerator];
    Download *aDownload;
    while ((aDownload =[enumerator nextObject])) {
        aDownload.isAutoCancel =YES;
        [aDownload stopTask];
    }
}

-(NSInteger)getActiveItemNum{
    return [downloadItems count]+[waitingTaskList count];
}
-(void)resumePausedTasks
{
    //get paused ids
    //-----READ FROM DBS
    
    FMResultSet *rs =[appDelegate.mysqlite.db executeQueryWithFormat:@"SELECT fid FROM task_list WHERE task_status =%@;",kDownloadStatusPause];
    
    if ([appDelegate.mysqlite.db hadError]) {
        NSLog(@"resumePausedTasks-> db Error :%@",[appDelegate.mysqlite.db lastErrorMessage]);
    }
    
	while ([rs next]) 
    {
        
        NSInteger tid =[rs intForColumn:@"fid"];
        NSLog(@"RESUME A TASK ID:%d",tid );
        [self resumeTaskFormDBS:[NSNumber numberWithInteger:tid]];
    }
    [rs close];
    //make item
    //add to quesus
    
}
-(void)addURLtoDownload:(NSString *)aURL
{
    NSMutableDictionary* taskItem = [Download makeTaskItem:aURL];
    [self  addTaskToQueue: taskItem];
    //MAKE A TASK AND SEVE TO DBS
     //COMPLETE: CHECK WAITING LIST:IS NO NULL ,START A NEW DOWNLOAD
    //消息中心
    
}
-(void)addTaskToQueue:(NSMutableDictionary *)taskItem{
    if (!self.downloadItems) {
        NSMutableDictionary *_downloadItems =[[NSMutableDictionary alloc] initWithCapacity:self.taskLimit];
        self.downloadItems =_downloadItems;
        [_downloadItems release];
        
    }
    if (!self.waitingTaskList) {
        NSMutableArray * _waitingTaskList =[[NSMutableArray alloc] init ];
        self.waitingTaskList =_waitingTaskList;
        [_waitingTaskList release];
    }
    //CHECK TASK COUNT ,IF <TASKLIMIT,START A NEW DOWNLOAD
    if ([downloadItems count] < self.taskLimit) {
        
        //startDownloadTaskL:
        [self startDownloadFromTask:taskItem];
        
    }
    //- ELSE: ADD TO WAITNG LIST
    else if (![self testWatingStatus:[taskItem objectForKey:kDownloadTaskID]]) {
        [waitingTaskList addObject:taskItem];
        //NSLog(@"ADD A TASK TO WAITING ID:%@",[taskItem objectForKey:kDownloadTaskID]);
        [[NSNotificationCenter defaultCenter]  
         addObserver:self  
         selector:@selector(updateCell:)  
         name:kNoticeDownloadAddWaiting 
         object:nil]; 
    }
    [self setPlayerBadge];            
        
    

    
}
-(void)resumeTaskFormDBS:(NSNumber *)nTID
{
    //get info from dbs ,maka a task
    NSMutableDictionary *taskItem =[Download makeTaskItemFormTID:nTID];
    if (![downloadItems objectForKey:nTID]) {
        [self addTaskToQueue: taskItem];
    }
    

}

-(void)startDownloadFromTask:(NSMutableDictionary *)taskItem
{
    Download *download = [[Download alloc] init];
    NSNumber *taskID = [taskItem objectForKey:kDownloadTaskID];
    [self.downloadItems setObject:download  forKey:taskID];
    
    [download release];
    
    //[[downloadItems objectForKey:taskID] startDownloadTask:taskItem];
    Download *theDownload =[downloadItems objectForKey:taskID] ;
    theDownload.taskItem =taskItem;
    [theDownload startDownloadTask];
}

-(void)waitingTaskCheck
{
    //
    if ([waitingTaskList count]>0) {
        //pop a object
        [self startDownloadFromTask:[waitingTaskList lastObject]];
        NSMutableDictionary *lastOBJ =[waitingTaskList lastObject];
        NSLog(@"GOT A WATING:ID IS %@",[lastOBJ objectForKey:kDownloadTaskID]);
        [waitingTaskList removeLastObject];
        
    }
}
-(void)downloadTaskFailed:(NSNotification *)notification
{
    [self downloadTaskDone:notification success:NO];
    
}
-(void)downloadTaskSuccess:(NSNotification *)notification
{
    [self downloadTaskDone:notification success:YES];
    
}
-(void)downloadTaskDone:(NSNotification *)notification success:(BOOL)aFlag
{
    NSDictionary *_userInfo = [notification userInfo];
    [downloadItems removeObjectForKey:[_userInfo objectForKey:kDownloadTaskID]];
    //NSLog(@"remove item id is:%@",[_userInfo objectForKey:kDownloadTaskID]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoticeDownloadUpdate object:nil userInfo:[NSDictionary dictionaryWithObject:[_userInfo objectForKey:kDownloadTaskID] forKey:kDownloadTaskID]];
    [self setPlayerBadge];
    [self waitingTaskCheck];

    //send data to server;
    appDelegate.isAllowUpdateSongInfo = YES;
    
    if (appDelegate.isAllowUpdateSongInfo == YES && aFlag) {
        [self updataSongInfo:[_userInfo objectForKey:kDownloadTaskID] ];
    }
}

-(void)setPlayerBadge{
    NSString *activeNum =[NSString stringWithFormat:@"%d",[self getActiveItemNum]];
    if ([self getActiveItemNum]== 0) {
        activeNum =nil;
    }
    [(UIViewController *)[appDelegate.tabBarController.viewControllers objectAtIndex:1] tabBarItem].badgeValue = activeNum;
}
#pragma -mark NSObject Base:
-(id)init
{
    self = [super init];
    if (self) {  
 
    //初始化应用程序委托
	appDelegate =(WebMusicDownloadAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //playlistObj 
    PlayList *p =[[PlayList alloc] init];
    self.playlistObj =p;
    [p release];
    
    [[NSNotificationCenter defaultCenter]  
     addObserver:self  
     selector:@selector(downloadTaskFailed:)  
     name:kNoticeDownloadFailed 
     object:nil]; 
    
    [[NSNotificationCenter defaultCenter]  
     addObserver:self  
     selector:@selector(downloadTaskSuccess:)  
     name:kNoticeDownloadComplete 
     object:nil]; 
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [downloadItems release];
    [waitingTaskList release];
    [playlistObj release];
    [uploadSongInfo release];
    
    [super dealloc];
    
}

@end
