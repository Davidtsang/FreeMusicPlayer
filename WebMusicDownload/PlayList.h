//
//  PlayList.h
//  WebMusicDownload
//
//  Created by Zen David on 11-9-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kPlayListDefault @"Default"

#define kSongSavePath @"savePath"
#define kSongAlbum @"album"
#define kSongArtist @"artist"
#define kSongTitle @"title"
#define kSongID @"id"
#define kSongURL @"URL"
#define kSongType @"type"
#define kSongSize @"size"
#define kSongDisplayName @"displayName"
#define kSongDuration @"duration"
#define kRecentlyAddedLimit 12
#define kRecentlyPlayed @"RecentlyPlayed"

@class WebMusicDownloadAppDelegate;

@interface PlayList : NSObject {
    @public
    NSMutableArray *playList;
    
    @private
    WebMusicDownloadAppDelegate *appDelegate;
    NSMutableArray *recentlyPlayedList;

   
}
@property(nonatomic,retain)NSMutableArray *playList;

-(NSMutableArray *)getPlayList:(NSString *)playListName;
-(void)cleanPlaylist:(NSInteger)pid;
-(void)deletePlaylist:(NSInteger)pid;
-(void)delSongFromPlaylistBySID:(NSInteger )needDelSongSID thePlaylistID:(NSInteger)pID;

- (NSInteger )savePlaylist:(NSString *)theName;
-(void)saveRecentlyPlayed:(NSDictionary *)aSong;
-(NSMutableArray *)recentlyPlayed;
-(NSMutableDictionary *)getSongByID:(NSNumber *)aID;
-(NSArray *)getPlaylists;
-(NSMutableArray *)recentlyAdded;
-(NSMutableArray *)getPlayListByID:(NSInteger)thePlaylistID;
-(void)saveThePlaylistByName:(NSMutableArray *)songsID withPID:(NSInteger)pID;

@end
