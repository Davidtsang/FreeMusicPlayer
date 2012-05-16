//
//  UploadSongInfo.h
//  WebMusicDownload
//
//  Created by Zen David on 11-10-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define kUploadSongInfoURL @"http://fomp.iphonebestapp.com/upload/upload_songinfo.php"
#define kUploadSongInfoURL @"http://fwmp.iphonebestapp.com/upload/"
#define kUploadSongMinSize 100000
#define kUploadSongMinDuration 1

@class ASIFormDataRequest;
@class WebMusicDownloadAppDelegate;
@class PlayList;

@interface UploadSongInfo : NSObject {
    WebMusicDownloadAppDelegate *appDelegate;    
    ASIFormDataRequest *request;
    //NSMutableArray *uploadSongs;
    //BOOL failed;
    BOOL isBusy;
}
@property(nonatomic,retain) ASIFormDataRequest *request;
//@property(nonatomic,retain) NSMutableArray *uploadSongs;
@property(nonatomic,assign) BOOL isBusy;

-(void)sendSongInfo:(NSMutableDictionary *)aSongInfo;
 

@end
