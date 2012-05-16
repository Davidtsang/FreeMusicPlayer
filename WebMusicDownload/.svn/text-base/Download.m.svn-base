//
//  Download.m
//  WebMusicDownload
//
//  Created by Zen David on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Download.h"
#import "WebMusicDownloadAppDelegate.h"

#import "ASIHTTPRequest.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVMetadataItem.h>
#import "DownloadProgressView.h"
#import "MyFunction.h"

@interface Download()

@end
//download a item form a url 
@implementation Download

@synthesize request;
@synthesize taskItem;
@synthesize isAutoCancel;

+(NSString *)renameifExist:(NSString *)savePath withName:(NSString *)theFileName
{
    NSString *theSavePath =[savePath stringByAppendingPathComponent:theFileName];
    NSString *displayName = [ theFileName substringToIndex:([theFileName length]-4)];
    NSString *suffixName =[theFileName substringFromIndex:([theFileName length]-4)];
    NSInteger i =0;
    BOOL fileExists;
    
    while ((fileExists = [Download checkSavePathExist:theSavePath])){
        i=i+1;
        NSString *newName =[NSString stringWithFormat:@"%@(%d)%@",displayName,i,suffixName];
        theSavePath = [savePath stringByAppendingPathComponent:newName];
        //test:
        //NSLog(@"rename to:%@",theSavePath);
    }

    return theSavePath;
 
}
+(BOOL)checkSavePathExist:(NSString *)theSavePath{
    bool theExist =NO;
    //初始化应用程序委托
	WebMusicDownloadAppDelegate *appDelegate =(WebMusicDownloadAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    int rs =[appDelegate.mysqlite.db intForQuery:@"SELECT COUNT(fid)  FROM task_list WHERE save_path =? AND task_status != ?;",theSavePath,kSongStatusDeleted];
    
    if ([appDelegate.mysqlite.db hadError]) {
        NSLog(@"+(BOOL)checkSavePathExist:(NSString *)theSavePath-> db Error :%@",[appDelegate.mysqlite.db lastErrorMessage]);
    }
    
    if (rs > 0) {
        
        theExist =YES;
    }
    
    return theExist;
}
+(NSMutableDictionary *)makeTaskItemFormTID:(NSNumber *)nTID{
    //初始化应用程序委托
	WebMusicDownloadAppDelegate *appDelegate =(WebMusicDownloadAppDelegate *)[[UIApplication sharedApplication] delegate];
    //reuten obj
    NSMutableDictionary *taskItem= [NSMutableDictionary dictionary];
    
    //-----READ FROM DBS
    FMResultSet *rs =[appDelegate.mysqlite.db executeQuery:@"SELECT fid ,url , task_status , save_path , progress ,display_name,file_size ,album_name FROM task_list WHERE fid =?;",nTID];
    
    if ([appDelegate.mysqlite.db hadError]) {
        NSLog(@"+(NSMutableDictionary *)makeTaskItemFormTID:(NSNumber *)nTID-> db Error :%@",[appDelegate.mysqlite.db lastErrorMessage]);
    }
    
	if ([rs next]) {
 
        NSString *taskUrl =[rs stringForColumn:@"url"];
        //NSString *taskStatus =[rs stringForColumn:@"task_status"];
        NSString *taskSavePath =[rs stringForColumn:@"save_path"];
        double taskProgressValue =[rs doubleForColumn:@"progress"];
        NSString *taskName =[rs stringForColumn:@"display_name"];
        //NSString *taskAlbumName =[rs stringForColumn:@"album_name"];
        
        //NSURL* url=[NSURL URLWithString: taskUrl];
        [taskItem setObject:taskUrl forKey:kDownloadTaskURL];
        [taskItem setObject:taskName forKey:kDownloadTaskDisplayName];
        [taskItem setObject:taskSavePath forKey:kDownloadTaskSavePath];
        [taskItem setObject:[NSNumber numberWithDouble:taskProgressValue] forKey:kDownloadTaskProgress];
        
        NSString* tempSavePath =[[NSString alloc] initWithFormat:@"%@.temp" ,taskSavePath];
        [taskItem setObject:tempSavePath forKey:kDownloadTaskTempSavePath];
        
        //progeress
        DownloadProgressView* downloadProgress =[[DownloadProgressView alloc] init];
        [taskItem setObject:downloadProgress forKey:kDownloadTaskProgressIndicator];
        [downloadProgress release];
        [tempSavePath release];
        [taskItem setObject:nTID forKey:kDownloadTaskID];
        
        
    }    
     [rs close];
     return taskItem;

}

+(NSMutableDictionary *)makeTaskItem:(NSString *)taskURLString {
    //初始化应用程序委托
	WebMusicDownloadAppDelegate *appDelegate =(WebMusicDownloadAppDelegate *)[[UIApplication sharedApplication] delegate];
    //reuten obj
    NSMutableDictionary *taskItem= [NSMutableDictionary dictionary];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
 
    NSURL* url=[NSURL URLWithString: taskURLString];
    [taskItem setObject:taskURLString forKey:kDownloadTaskURL];
    
//    NSString *URLPathString = [[taskURLString
//                       stringByReplacingOccurrencesOfString:@"+" withString:@" "]
//                      stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *URLPath =[NSURL URLWithString:URLPathString];
    NSString* _fileName=[url  lastPathComponent]; 
    
    //test % filename
    BOOL isFoundBadString = ([_fileName rangeOfString:@"%" options:NSCaseInsensitiveSearch].location != NSNotFound);
   
    if (_fileName == nil || isFoundBadString){
        //get .->
        NSString *suffix = [taskURLString substringFromIndex:[taskURLString length]-4];
        NSTimeInterval iNow = [[NSDate date] timeIntervalSince1970];
        NSNumber *dateNum = [NSNumber numberWithFloat:iNow];
        _fileName =[NSString stringWithFormat:@"%d%@", [dateNum integerValue],suffix];
 
    }
    //--replece space
    _fileName =[_fileName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    //check file name exists
    NSString *savePath =[[Download renameifExist:documentsDirectory withName:_fileName] retain];
    
    NSString *fileName =[savePath lastPathComponent];
    //NSString* displayName =[fileName substringToIndex:([fileName length]-4)];
    NSString* displayName = fileName ;
    [taskItem setObject:displayName forKey:kDownloadTaskDisplayName];
    
    //NSString* savePath =[[NSString alloc] initWithString: [documentsDirectory stringByAppendingPathComponent: fileName  ]]; 
    [taskItem setObject:savePath forKey:kDownloadTaskSavePath];
    
    NSNumber *nZero = [[NSNumber alloc] initWithFloat:0.0]; 
    
    //add tempsavepath
    NSString* tempSavePath =[[NSString alloc] initWithFormat:@"%@.temp" ,savePath];
    [taskItem setObject:tempSavePath forKey:kDownloadTaskTempSavePath];
    
    DownloadProgressView* downloadProgress =[[DownloadProgressView alloc] init];
    [taskItem setObject:downloadProgress forKey:kDownloadTaskProgressIndicator];
  
    //save to dbs
    [appDelegate.mysqlite.db executeUpdate:@"INSERT INTO task_list (url , task_status , progress ,save_path,display_name)VALUES(?,?,?,?,?);",
         
		 taskURLString,
		 kDownloadStatusStop,
          nZero,
         savePath,
         displayName];
    
    if ([appDelegate.mysqlite.db hadError]) {
        NSLog(@"-(NSMutableDictionary *)makeTaskItem:(NSString *)taskURLString->db Error :%@",[appDelegate.mysqlite.db lastErrorMessage]);
    }else{
        long long int lastIRD =[appDelegate.mysqlite.db lastInsertRowId];
        //NSNumber *nLastIRD =[[NSNumber alloc] initWithLongLong:lastIRD]; 
        NSNumber *nLastIRD =[NSNumber numberWithLongLong:lastIRD];
        [taskItem setObject:nLastIRD forKey:kDownloadTaskID];
        
    }
        
    //release ram
    [nZero release];
    [savePath release];
    [tempSavePath release];
    [downloadProgress release];
    
    return taskItem;
}
-(void)stopTask{
    [request cancel];
    //[request clearDelegatesAndCancel];
}
 

-(void)startDownloadTask
{
    
	failed = NO;
   
    //ASIHTTPRequest *request;

    NSURL* _url=[NSURL URLWithString:[self.taskItem objectForKey:kDownloadTaskURL]];

    
    self.request = [ASIHTTPRequest requestWithURL:_url];
    
  
    NSString* _savePath =[self.taskItem objectForKey:kDownloadTaskSavePath] ;

    
    [request setShowAccurateProgress:YES];
    [request setUserAgent:@"Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A293 Safari/6531.22.7"];
    //[request addRequestHeader:@"Referer" value:[_url host]]; 
    [request setAllowCompressedResponse:YES];
    //[request responseCookies];
    [request setDownloadDestinationPath:_savePath];
    [request setDidFinishSelector:@selector(fileFetchComplete:)];
    [request setDidFailSelector:@selector(fileFetchFailed:)];
    [request setDidReceiveResponseHeadersSelector:@selector(receiveHeader:)];
    //[request setdi
    // This file has part of the download in it already
    [request setTemporaryFileDownloadPath:[self.taskItem objectForKey:kDownloadTaskTempSavePath]];
    [request setAllowResumeForFileDownloads:YES];
    [request setDownloadProgressDelegate:[self.taskItem objectForKey:kDownloadTaskProgressIndicator]];
    
    [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:[self.taskItem objectForKey:kDownloadTaskID],kDownloadTaskID,_savePath,kDownloadTaskSavePath,nil]];
    
    [request setDelegate:self];
    [request startAsynchronous];
    
     
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoticeDownloadStart object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[self.taskItem objectForKey:kDownloadTaskID],kDownloadTaskID,nil]];

    
}

- (void)receiveHeader:(ASIHTTPRequest *)_request
{
    NSLog(@"HEADER:%@" ,[_request.requestHeaders description]);
    NSDictionary* requestInfo =[NSDictionary dictionaryWithDictionary:[_request userInfo]];

    NSNumber *_taskID = [requestInfo objectForKey:kDownloadTaskID];
    unsigned long long contentLength = [_request contentLength];
    NSNumber *nContentLength =[[NSNumber alloc]initWithUnsignedLongLong:contentLength];
    

    if (contentLength) {
        //
        //NSString *sql =[NSString stringWithFormat:<#(NSString *), ...#>
        [appDelegate.mysqlite.db executeUpdate:@"UPDATE task_list SET file_size =? WHERE fid=?;",
         
		 nContentLength,
         _taskID];
        if ([appDelegate.mysqlite.db hadError]) {
            NSLog(@"- (void)reciveHeader:(ASIHTTPRequest *)request->db Error :%@",[appDelegate.mysqlite.db lastErrorMessage]);
        }
        
    }
    [nContentLength release];
    
}
- (void)fileFetchComplete:(ASIHTTPRequest *)_request
{
    
    NSDictionary* requestInfo =[NSDictionary dictionaryWithDictionary:[_request userInfo]];
    //
    //NSString *urlName = [requestInfo objectForKey:@"name"];
    NSNumber *_taskID = [requestInfo objectForKey:kDownloadTaskID];
    
    NSLog(@"request %@ complete!",_taskID);
    //change dbs status
    //GET ID3 TAGS:
    NSURL *fileSavePath = [[NSURL alloc] initFileURLWithPath:[requestInfo objectForKey:kDownloadTaskSavePath]];
    AVAsset *asset = [AVURLAsset URLAssetWithURL:fileSavePath options:nil];
    
    NSArray *metadata = [asset commonMetadata];
    //asset 
//    Title|title
//    Album|albumName
//    Artist|artist
//    Type|type
//    --------------
//    Size|
//    URL|
//    FileName|
    CMTime theSongDuration = asset.duration;
    //CMTimeShow(theSongDuration);
    NSInteger iSongDuration =theSongDuration.value/theSongDuration.timescale;
    //NSLog(@"DURATION IS:%d",iSongDuration);
    //theSongDuration
    NSString *albumName =@"";
    NSString *theSongTitle=@"";
    NSString *theSongArtist=@"";
    NSString *theSongType =@"";
    
    for ( AVMetadataItem* item in metadata ) {
        if ([item.commonKey isEqualToString:AVMetadataCommonKeyAlbumName]) {
            albumName =[item stringValue];
        }
        if ([item.commonKey isEqualToString:AVMetadataCommonKeyTitle]) {
            theSongTitle =[item stringValue];
        }
        if ([item.commonKey isEqualToString:AVMetadataCommonKeyArtist]) {
            theSongArtist =[item stringValue];
        }
        if ([item.commonKey isEqualToString:AVMetadataCommonKeyType]) {
            theSongType =[item stringValue];
        }

       //NSLog(@"key = %@, value = %@", item.commonKey, [item stringValue]);
    }//end for

    [appDelegate.mysqlite.db executeUpdate:@"UPDATE task_list SET task_status =? ,album_name = ? ,title = ?,artist =?,song_type=? ,duration =? WHERE fid =?;",
     
     kDownloadStatusComplete,
     albumName,
     theSongTitle,
     theSongArtist,
     theSongType,
     [NSNumber numberWithInteger:iSongDuration],
     _taskID];
    
    if ([appDelegate.mysqlite.db  hadError]) {
        NSLog(@"- (void)fileFetchComplete:(ASIHTTPRequest *)request->db Error :%@",[appDelegate.mysqlite.db lastErrorMessage]);
    }
    [fileSavePath release];
    
    //notice  downloadMANAGE
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoticeDownloadComplete object:nil userInfo:    [NSDictionary dictionaryWithObjectsAndKeys:_taskID,kDownloadTaskID,nil]];

}

- (void)fileFetchFailed:(ASIHTTPRequest *)_request
{
    NSDictionary* requestInfo =[NSDictionary dictionaryWithDictionary:[_request userInfo]];
    NSNumber *_taskID = [requestInfo objectForKey:kDownloadTaskID];
 
    
    
    NSString *errorType=[NSString string];
    
    NSError *error = [_request error];
    NSLog(@"Error: %@", error);
	if ( failed==NO) {
		if ([[_request error] domain] != NetworkRequestErrorDomain || [[_request error] code] != ASIRequestCancelledErrorType) {
			UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Fetch failed" message:@"Failed to fetch url:" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
			[alertView show];
            errorType = kDownloadStatusError;
		}else{
            errorType = kDownloadStatusStop;
        }
		failed = YES;
	}
    if (self.isAutoCancel ==YES) {
        errorType =kDownloadStatusPause;
    }
    //change dbs status
    [appDelegate.mysqlite.db executeUpdate:@"UPDATE task_list SET  task_status =? WHERE fid =?;",
     
     errorType,
     _taskID];
    
    if ([appDelegate.mysqlite.db  hadError]) {
        NSLog(@"- (void)fileFetchFailed:(ASIHTTPRequest *)request->db Error :%@",[appDelegate.mysqlite.db lastErrorMessage]);
    }
    NSLog(@"requset error:%@",errorType);
    //notice  downloadMANAGE
    self.isAutoCancel =NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoticeDownloadFailed object:nil userInfo:[NSDictionary dictionaryWithObject:_taskID forKey:kDownloadTaskID]];
}

#pragma -mark NSObject Base:
-(id)init
{
    self = [super init];
    if (self) {  
    
 
    //初始化应用程序委托
	appDelegate =(WebMusicDownloadAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)dealloc{
    //[itemURL release];
    [request cancel];
    [request release];
    [taskItem release];
    [super dealloc];
    
}

@end
