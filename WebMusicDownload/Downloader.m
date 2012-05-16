//
//  Downloader.m
//  WebMusicDownload
//
//  Created by Zen David on 8/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Downloader.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "WebMusicDownloadAppDelegate.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVMetadataItem.h>

@implementation Downloader

@synthesize runingTaskCount;
@synthesize waitingStartTids;
@synthesize taskLimit;
@synthesize runingTaskItems;
@synthesize  errorTaskItems;
@synthesize activeItems;



-(NSString *) urlEncode: (NSString *) url
{
    NSString *result=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

//form url make a task item
-(NSDictionary *)saveTaskItem:(NSArray *)UrlItems{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSMutableDictionary *taskItems =[NSMutableDictionary dictionaryWithCapacity:[UrlItems count]];
    
    NSEnumerator* enumerator = [UrlItems  objectEnumerator];
    NSString* element;
    
    [appDelegate.mysqlite  openDB];
    while((element = [enumerator nextObject]))
    {
        NSURL* url=[NSURL URLWithString:[self urlEncode: element] ];
        NSString* fileName=[url lastPathComponent]; 
        NSString* displayName =[fileName substringToIndex:([fileName length]-4)];
          //sync dbs
        NSNumber *nZero = [[NSNumber alloc] initWithFloat:0.0];
        
        //add savepath
        NSString* savePath =[[NSString alloc] initWithString: [documentsDirectory stringByAppendingPathComponent: fileName  ]];
        //[taskItem setObject:savePath forKey:kTaskSavePath];
        
        [appDelegate.mysqlite.db executeUpdate:@"INSERT INTO task_list (url , task_status , progress ,save_path,display_name)VALUES(?,?,?,?,?);",
         
		 element,
		 @"Waiting",

         nZero,
         savePath,
         displayName];
        
        if ([appDelegate.mysqlite.db hadError]) {
            NSLog(@"-(NSArray *)saveTaskItem:(NSArray *)UrlItems->db Error :%@",[appDelegate.mysqlite.db lastErrorMessage]);
        }else{
            long long int lastIRD =[appDelegate.mysqlite.db lastInsertRowId];
            NSNumber *nLastIRD =[[NSNumber alloc] initWithLongLong:lastIRD]; 
 
            [taskItems setObject:element forKey:nLastIRD];
        }
        
        //release ram
        [nZero release];

                
    }
    [appDelegate.mysqlite.db close];
    return taskItems;

 
}

-(NSArray *)makeTaskItem:(NSArray *)taskIDs
{
    //NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSMutableArray *taskItems =[NSMutableArray array];
    
    NSEnumerator* enumerator = [taskIDs  objectEnumerator];
    NSString* element;
    
    [appDelegate.mysqlite  openDB];
    while((element = [enumerator nextObject]))
    {
        //get info from dbs
        //fid,url , task_status , save_path , progress ,display_name
        FMResultSet *rs =[appDelegate.mysqlite.db executeQuery:@"SELECT  url,save_path   FROM task_list WHERE fid =?;" ,element];
        
        if ([appDelegate.mysqlite.db hadError]) {
            NSLog(@"-(NSArray *)makeTaskItem:(NSArray *)taskIDs-> db Error :%@",[appDelegate.mysqlite.db lastErrorMessage]);
        }
        
        [rs next];
        NSString *taskUrl =[rs stringForColumn:@"url"];
        NSString *savePath =[rs stringForColumn:@"save_path"];
        [rs close];
        
        NSURL* url=[NSURL URLWithString:[self urlEncode: taskUrl] ];
        NSString* fileName=[url lastPathComponent]; 
        NSString* displayName =[fileName substringToIndex:([fileName length]-4)];
        //NSLog(@"display NAME:%@",displayName );
        
        NSMutableDictionary* taskItem =[[NSMutableDictionary alloc] init];
        //add url
        [taskItem setObject:taskUrl forKey:kTaskUrl];
        
//        //add savepath
//        NSString* savePath =[[NSString alloc] initWithString: [documentsDirectory stringByAppendingPathComponent: fileName  ]];
        [taskItem setObject:savePath forKey:kTaskSavePath];
        
        //add tempsavepath
        NSString* tempSavePath =[[NSString alloc] initWithFormat:@"%@.temp" ,savePath];
        [taskItem setObject:tempSavePath forKey:kTaskTempSavePath];
        
        DownloadProgressView* downloadProgress =[[DownloadProgressView alloc] init];
        [taskItem setObject:downloadProgress forKey:kTaskProgressIndicator];
        
        //add taskname
        [taskItem setObject:taskUrl forKey:kTaskRequestName];
        
        //sync dbs
        NSNumber *nZero = [[NSNumber alloc] initWithFloat:0.0];
        [appDelegate.mysqlite.db executeUpdate:@"UPDATE task_list SET  url=? , task_status=? , save_path =? , progress =?,display_name =? WHERE fid =?;",
         
		 taskUrl,
		 @"Waiting...",
		 savePath,
         nZero,
         displayName,
         element];
        
        if ([appDelegate.mysqlite.db hadError]) {
            NSLog(@"-(NSArray *)makeTaskItem:(NSArray *)UrlItems->db Error :%@",[appDelegate.mysqlite.db lastErrorMessage]);
        } 
        [taskItem setObject:element forKey:@"taskID"];
        [taskItems addObject:taskItem];
        
        
        //release ram
        [nZero release];
        [savePath release];
        [tempSavePath release];
        [downloadProgress release];
        [taskItem release];
        
    }
    [appDelegate.mysqlite.db close];
    return taskItems;
}


//-(NSArray *)makeTaskItem:(NSArray *)UrlItems
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//
//    NSMutableArray *taskItems =[NSMutableArray array];
//
//    NSEnumerator* enumerator = [UrlItems  objectEnumerator];
//    NSString* element;
//    
//    [appDelegate.mysqlite  openDB];
//    while((element = [enumerator nextObject]))
//    {
//        NSURL* url=[NSURL URLWithString:[self urlEncode: element] ];
//        NSString* fileName=[url lastPathComponent]; 
//        NSString* displayName =[fileName substringToIndex:([fileName length]-4)];
//        NSLog(@"display NAME:%@",displayName );
//        
//        NSMutableDictionary* taskItem =[[NSMutableDictionary alloc] init];
//        //add url
//        [taskItem setObject:element forKey:kTaskUrl];
//        
//        //add savepath
//        NSString* savePath =[[NSString alloc] initWithString: [documentsDirectory stringByAppendingPathComponent: fileName  ]];
//        [taskItem setObject:savePath forKey:kTaskSavePath];
//        
//        //add tempsavepath
//        NSString* tempSavePath =[[NSString alloc] initWithFormat:@"%@.temp" ,savePath];
//        [taskItem setObject:tempSavePath forKey:kTaskTempSavePath];
//        
//        //add downlaod progress
//        //UIProgressView* downloadProgress =[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault ];
//        DownloadProgressView* downloadProgress =[[DownloadProgressView alloc] init];
//        [taskItem setObject:downloadProgress forKey:kTaskProgressIndicator];
//        
//        //add taskname
//        [taskItem setObject:element forKey:kTaskRequestName];
//
//        //sync dbs
//        NSNumber *nZero = [[NSNumber alloc] initWithFloat:0.0];
//        [appDelegate.mysqlite.db executeUpdate:@"INSERT INTO task_list (url , task_status , save_path , progress ,display_name)VALUES(?,?,?,?,?);",
//         
//		 element,
//		 @"Waiting",
//		 savePath,
//         nZero,
//         displayName];
// 
//        if ([appDelegate.mysqlite.db hadError]) {
//             NSLog(@"-(NSArray *)makeTaskItem:(NSArray *)UrlItems->db Error :%@",[appDelegate.mysqlite.db lastErrorMessage]);
//        }else{
//            long long int lastIRD =[appDelegate.mysqlite.db lastInsertRowId];
//            NSNumber *nLastIRD =[[NSNumber alloc] initWithLongLong:lastIRD]; 
//            [taskItem setObject:nLastIRD forKey:@"taskID"];
//            [taskItems addObject:taskItem];
//        }
//        
//        //release ram
//        [nZero release];
//        [savePath release];
//        [tempSavePath release];
//        [downloadProgress release];
//        [taskItem release];
//
//    }
//    [appDelegate.mysqlite.db close];
//    return taskItems;
//}

-(void)startDownloadTask:(NSArray *)taskItems
{
    if (!networkQueue) {
		networkQueue = [[ASINetworkQueue alloc] init];	
	}
	failed = NO;
	[networkQueue reset];
	//[networkQueue setDownloadProgressDelegate:progressIndicator];
	[networkQueue setRequestDidFinishSelector:@selector(fileFetchComplete:)];
	[networkQueue setRequestDidFailSelector:@selector(fileFetchFailed:)];
    [networkQueue setRequestDidReceiveResponseHeadersSelector:@selector(receiveHeader:)];
    [networkQueue setShouldCancelAllRequestsOnFailure:NO];
	[networkQueue setShowAccurateProgress: YES];
	[networkQueue setDelegate:self];
	
    
    NSEnumerator* enumerator = [taskItems  objectEnumerator];
    NSDictionary* element;
    
    ASIHTTPRequest *request;
    
    [appDelegate.mysqlite  openDB];
    while((element = [enumerator nextObject]))
    {
        //URL
        NSString* urlString = [element objectForKey:kTaskUrl];
        NSURL* _url=[NSURL URLWithString:urlString];
        //NSString* _fileName=[_url lastPathComponent]; 
        
        request = [ASIHTTPRequest requestWithURL:_url];
        
        //savepath NSUTF8StringEncoding
        NSString* _savePath =[element objectForKey:kTaskSavePath] ;
        //[request showAccurateProgress];
        [request setDownloadDestinationPath:_savePath];
        
        // This file has part of the download in it already
        [request setTemporaryFileDownloadPath:[element objectForKey:kTaskTempSavePath]];
        [request setAllowResumeForFileDownloads:YES];
        
        [request setDownloadProgressDelegate:[element objectForKey:kTaskProgressIndicator]];
        
        //[request setUserInfo:[NSDictionary dictionaryWithObject:[element objectForKey:kTaskRequestName] forKey:@"name"]];
        
        [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:[element objectForKey:kTaskID],kTaskID,_savePath,kTaskSavePath,nil]];
        
        //[request setUserInfo:[NSDictionary dictionaryWithObject:_savePath forKey:kTaskSavePath]];
        [networkQueue addOperation:request];
        
        [self.runingTaskItems setObject:element forKey:[element objectForKey:kTaskID]];
        
        //sync to DBS
        //url , task_status , save_path , progress ,display_name 
        [appDelegate.mysqlite.db executeUpdate:@"UPDATE task_list SET task_status=? WHERE fid=?;",
         
		 @"Buffering...",
         [element objectForKey:kTaskID]];
        
        if ([appDelegate.mysqlite.db hadError]) {
                    NSLog(@"-(void)startDownloadTask:(NSArray *)taskItems->db Error :%@",[appDelegate.mysqlite.db lastErrorMessage]);
        }

        //[appDelegate.mysqlite.db 
        
        
        
    }
	[appDelegate.mysqlite.db close];
    
	[networkQueue go];
    
}

- (void)receiveHeader:(ASIHTTPRequest *)request
{
    NSDictionary* requestInfo =[NSDictionary dictionaryWithDictionary:[request userInfo]];
     //NSString *urlName = [requestInfo objectForKey:@"name"];
     NSNumber *_taskID = [requestInfo objectForKey:kTaskID];
    unsigned long long contentLength = [request contentLength];
    NSNumber *nContentLength =[[NSNumber alloc]initWithUnsignedLongLong:contentLength];
    
    [appDelegate.mysqlite  openDB];
    if (contentLength) {
        //
        [appDelegate.mysqlite.db executeUpdate:@"UPDATE task_list SET file_size =? WHERE fid=?;",
         
		 nContentLength,
         _taskID];
        if ([appDelegate.mysqlite.db hadError]) {
            NSLog(@"- (void)reciveHeader:(ASIHTTPRequest *)request->db Error :%@",[appDelegate.mysqlite.db lastErrorMessage]);
        }
 
    }
    [appDelegate.mysqlite.db close];
    
}
- (void)fileFetchComplete:(ASIHTTPRequest *)request
{
    
    NSDictionary* requestInfo =[NSDictionary dictionaryWithDictionary:[request userInfo]];
    //
    //NSString *urlName = [requestInfo objectForKey:@"name"];
    NSNumber *_taskID = [requestInfo objectForKey:kTaskID];
    [self.runingTaskItems removeObjectForKey:_taskID];
    
    NSLog(@"request %@ complete!",_taskID);
    //change dbs status
    //GET ID3 TAGS:
    NSURL *fileSavePath = [[NSURL alloc] initFileURLWithPath:[requestInfo objectForKey:kTaskSavePath]];
    AVAsset *asset = [AVURLAsset URLAssetWithURL:fileSavePath options:nil];
    
    NSArray *metadata = [asset commonMetadata];
    //AVMetadataItem* mataData =[asset metadataForFormat:@"albumName"];
    NSString *albumName =@"";
    for ( AVMetadataItem* item in metadata ) {
        if ([item.commonKey isEqualToString:@"albumName"]) {
            albumName =[item stringValue];
        }
        
        //NSLog(@"key = %@, value = %@", key, value);
    }//end for
        
    [appDelegate.mysqlite  openDB];
    [appDelegate.mysqlite.db executeUpdate:@"UPDATE task_list SET task_status =? ,album_name = ? WHERE fid =?;",
     
     @"Complete",
     albumName,
      _taskID];
    if ([appDelegate.mysqlite.db  hadError]) {
        NSLog(@"- (void)fileFetchComplete:(ASIHTTPRequest *)request->db Error :%@",[appDelegate.mysqlite.db lastErrorMessage]);
    }
    
    [appDelegate.mysqlite.db close];
}

- (void)fileFetchFailed:(ASIHTTPRequest *)request
{
    NSDictionary* requestInfo =[NSDictionary dictionaryWithDictionary:[request userInfo]];
    //romeve form active obj
    //NSString *urlName = [requestInfo objectForKey:@"name"];
    NSNumber *_taskID = [requestInfo objectForKey:kTaskID];
    
    [self.runingTaskItems removeObjectForKey:_taskID];
    
    //add to error list
    [errorTaskItems setObject:requestInfo forKey:_taskID];
    
    //change dbs status
    [appDelegate.mysqlite  openDB];
    [appDelegate.mysqlite.db executeUpdate:@"UPDATE task_list SET  task_status =? WHERE fid =?;",
     
     @"Error",
     _taskID];
    
    if ([appDelegate.mysqlite.db  hadError]) {
        NSLog(@"- (void)fileFetchFailed:(ASIHTTPRequest *)request->db Error :%@",[appDelegate.mysqlite.db lastErrorMessage]);
    }
    
    [appDelegate.mysqlite.db close]; 

    
    NSError *error = [request error];
    NSLog(@"Error: %@", error);
	if (!failed) {
		if ([[request error] domain] != NetworkRequestErrorDomain || [[request error] code] != ASIRequestCancelledErrorType) {
			UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Fetch failed" message:@"Failed to fetch url:" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
			[alertView show];
            
		}
		failed = YES;
	}
}

-(void)addTidsDownload:(NSArray*)tidItems
{
    
    NSInteger tidItemsNum =[tidItems count];
    
    NSArray* startImmediatelyTids =nil;
    NSArray* waitingTids =nil;
    
    //check run download task <3
    NSInteger queueCount = [networkQueue operationCount];
    if (queueCount < self.taskLimit) {
        
        //get the remaining
        NSInteger remainTaskNum = self.taskLimit - queueCount;
        if (tidItemsNum <  remainTaskNum) {
            startImmediatelyTids = tidItems;
        } else{
            NSRange startImmediatelyRange;
            startImmediatelyRange.location =0;
            startImmediatelyRange.length =remainTaskNum;
            startImmediatelyTids = [tidItems subarrayWithRange:startImmediatelyRange];
            
            NSRange waitingRange;
            waitingRange.location =remainTaskNum;
            waitingRange.length =tidItemsNum-remainTaskNum;
            waitingTids = [tidItems subarrayWithRange:waitingRange];            
        }
    }else{
        waitingTids = tidItems; 
    }
    
    if (startImmediatelyTids) {
        NSArray* taskItems =[self makeTaskItem:tidItems];
        //self.runingTaskItems =taskItems;
        self.activeItems =taskItems;
        
        [self startDownloadTask:taskItems];
        
    }
    if (waitingTids ) {
        NSEnumerator * enumerator = [waitingTids  objectEnumerator];
        NSString* element;
        
        while((element = [enumerator nextObject]))
        {
            if (![self.waitingStartTids containsObject:element]) {
                [self.waitingStartTids addObject:element];
            }
            
        }
    }

}
- (void)addUrlsDownload:(NSArray *)_urlItems
{
    //1 .save to dbs and get task id
    NSDictionary* ramNeedDownloadItems =[self saveTaskItem:_urlItems];
    NSArray *tidItems =[ramNeedDownloadItems allKeys];
    [self addTidsDownload:tidItems];
    
}

- (void)downloadManager
{
    //if have remian task the start
    if (self.waitingStartTids || ([self.waitingStartTids count] >0 )) {
        [self addTidsDownload:self.waitingStartTids];
    }
}


-(void)cancelAllTasks{
    if ( networkQueue) {
        [networkQueue cancelAllOperations];
    }
}
#pragma -mark NSObject Base:
-(id)init
{
    if (![super init])
    {
		return nil;
    }
    
    //init code
    self.runingTaskItems =[NSMutableDictionary dictionary];
    //初始化应用程序委托
	appDelegate =(WebMusicDownloadAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return self;
}

- (void)dealloc{
    [runingTaskItems release];
    [waitingStartTids release];
    [errorTaskItems release];
    [activeItems release];
    
    [super dealloc];
    
}

@end
