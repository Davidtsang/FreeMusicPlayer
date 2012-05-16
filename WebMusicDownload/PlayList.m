//
//  PlayList.m
//  WebMusicDownload
//
//  Created by Zen David on 11-9-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PlayList.h"
#import "WebMusicDownloadAppDelegate.h"
@interface PlayList()
@property(nonatomic,retain) NSMutableArray *recentlyPlayedList;


-(NSMutableArray *)getDefaultList:(NSString *)theType;
-(NSMutableArray *)getSongFromDB:(NSString *)sql;
@end

@implementation PlayList
@synthesize playList;
@synthesize recentlyPlayedList ;

//----------------------
-(void)delSongFromPlaylistBySID:(NSInteger )needDelSongSID thePlaylistID:(NSInteger)pID
{
    NSString *sql =[NSString stringWithFormat:@"DELETE FROM playlist WHERE pid = %d AND fid = %d" ,pID,needDelSongSID];
    [appDelegate.mysqlite.db beginTransaction];
    [appDelegate.mysqlite.db executeUpdate:sql];
    [appDelegate.mysqlite.db commit];
    if ([appDelegate.mysqlite.db hadError]) {
        NSLog(@"-(void)delSongFromPlaylistBySID:(NSInteger )needDelSongSID thePlaylistID:(NSInteger)pID ->db Error :%@",[appDelegate.mysqlite.db lastErrorMessage]);
    }//if
}

-(void)cleanPlaylist:(NSInteger)pid
{
    NSString *sql =[NSString stringWithFormat:@"DELETE FROM playlist WHERE pid = %d" ,pid];
    [appDelegate.mysqlite.db beginTransaction];
    [appDelegate.mysqlite.db executeUpdate:sql];
    [appDelegate.mysqlite.db commit];
    if ([appDelegate.mysqlite.db hadError]) {
        NSLog(@"-cleanPlaylist:(NSInteger)pid ->db Error :%@",[appDelegate.mysqlite.db lastErrorMessage]);
    }//if
}
-(void)deletePlaylist:(NSInteger)pid
{
    NSString *sql =[NSString stringWithFormat:@"DELETE FROM playlist_name WHERE pid = %d" ,pid];
    [appDelegate.mysqlite.db executeUpdate:sql];
    
    if ([appDelegate.mysqlite.db hadError]) {
        NSLog(@"-(void)deletePlaylist:(NSInteger)pid ->db Error :%@",[appDelegate.mysqlite.db lastErrorMessage]);
    }//if
}
-(void)saveThePlaylistByName:(NSMutableArray *)songsID withPID:(NSInteger)pID
{
    for (NSNumber *aID in  songsID) {
        // INSERT INTO playlist (pid,fid) VALUES (?,?)
        [appDelegate.mysqlite.db executeUpdate:@"INSERT INTO playlist (pid,fid) VALUES (?,?)",[NSNumber numberWithInteger:pID],aID];
        
        if ([appDelegate.mysqlite.db hadError]) {
            NSLog(@"-(void)saveThePlaylistByName:(NSMutableArray *)songsID withPID:(NSInteger)pID ->db Error :%@",[appDelegate.mysqlite.db lastErrorMessage]);
        }//
    }
}

-(void)saveRecentlyPlayed:(NSDictionary *)aSong
{
    if (self.recentlyPlayedList == nil) {
        NSMutableArray * _recentlyPlayedList =[[NSMutableArray alloc] initWithCapacity:kRecentlyAddedLimit];
        self.recentlyPlayedList = _recentlyPlayedList;
        [_recentlyPlayedList release];
        
    }
    if ([recentlyPlayedList count] <kRecentlyAddedLimit) {
        [recentlyPlayedList addObject:aSong];
    }else{
        [recentlyPlayedList removeObjectsAtIndexes:0];
        [recentlyPlayedList addObject:aSong];
    }
    [[NSUserDefaults standardUserDefaults] setObject:recentlyPlayedList forKey:kRecentlyPlayed];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(NSMutableArray *)recentlyPlayed{
    NSMutableArray *result =[NSMutableArray array];
    
    NSArray* songIDs =[[NSUserDefaults standardUserDefaults] objectForKey:kRecentlyPlayed];
    if ( songIDs && [songIDs count] > 0) {
        for (NSNumber *theID in songIDs) {
            NSMutableDictionary *aSong =[self getSongByID:theID];
            if (aSong != nil) {
                [result addObject:aSong];

            }            
        }
    }

    self.recentlyPlayedList =result ;
    return recentlyPlayedList;
}

-(NSMutableDictionary *)getSongByID:(NSNumber *)aID
{
    NSMutableDictionary *resultSong;
    NSString *sql = [NSString stringWithFormat:@"SELECT fid ,url ,save_path,display_name,album_name,title,artist, duration,file_size FROM task_list WHERE task_status = '%@' AND fid = %d;" , kDownloadStatusComplete, [aID intValue]];
    NSMutableArray *songList =[ self getSongFromDB:sql];
    if ([songList count] == 1) {
        resultSong =[songList objectAtIndex:0];
    }else{
        resultSong = nil;
    }
    return resultSong;
}

-(NSMutableArray *)getSongFromDB:(NSString *)sql
{
    
    NSMutableArray *theSongs =[NSMutableArray array];
    
    FMResultSet *rs =[appDelegate.mysqlite.db executeQuery:sql];
    //NSLog(@"sql is %@",[rs query]);
    if ([appDelegate.mysqlite.db hadError]) {
        NSLog(@"-(NSMutableArray *)getSongFromDB:(NSString *)sql-> db Error :%@",[appDelegate.mysqlite.db lastErrorMessage]);
    }
    
    while ([rs next]) {
        int songID =[rs intForColumn:@"fid"];
        NSString *songURL =[rs stringForColumn:@"url"];
        NSString *songSavePath =[rs stringForColumn:@"save_path"];
        NSURL *songSavePathURL =[NSURL URLWithString:songSavePath];
        NSString *songDisplayName =[rs stringForColumn:@"display_name"];
        NSString *songAlbumName =[rs stringForColumn:@"album_name"];
        NSString *songTitle =[rs stringForColumn:@"title"];
        NSString *songArtist =[rs stringForColumn:@"artist"];
        //file_size
        int songSize =[rs intForColumn:@"file_size"];
        int songDuration =[ rs intForColumn:@"duration"];
        //NSLog(@"song title:%@",songTitle);
        if ([songTitle isEqualToString:@""]) {
            songTitle = songDisplayName;
        }
        
        NSDictionary *theSongItem =[NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:songID],kSongID,
                                    songURL,kSongURL,
                                    songSavePathURL,kSongSavePath,
                                    songDisplayName,kSongDisplayName,
                                    songAlbumName,kSongAlbum,
                                    songTitle,kSongTitle,
                                    songArtist,kSongArtist,
                                    [NSNumber numberWithInt:songDuration],kSongDuration,
                                    [NSNumber numberWithInt:songSize],kSongSize,
                                    nil];
        
        [theSongs addObject:theSongItem];
        
        
    }
    [rs close];
   
    return theSongs;
}
-(NSMutableArray *)recentlyAdded
{
    NSString *sql =[NSString stringWithFormat:@"SELECT fid ,url ,save_path,display_name,album_name,title,artist, duration ,file_size FROM task_list WHERE task_status = '%@' ORDER BY fid DESC LIMIT %d;" ,kDownloadStatusComplete,kRecentlyAddedLimit];
    self.playList  =[self getSongFromDB:sql];
    return self.playList;
}
-(NSArray *)getPlaylists
{
    NSMutableArray *theList =[NSMutableArray array];
    FMResultSet *rs =[appDelegate.mysqlite.db executeQuery:@"SELECT  pid,name FROM playlist_name;" ];
    
    if ([appDelegate.mysqlite.db hadError]) {
        NSLog(@"-(NSArray *)getPlaylists-> db Error :%@",[appDelegate.mysqlite.db lastErrorMessage]);
    }
    
    while ([rs next]) {
        int pID =[rs intForColumn:@"pid"];
        NSString *listName =[rs stringForColumn:@"name"];
 
        NSArray *theListItem =[NSArray arrayWithObjects:listName ,[NSNumber numberWithInt:pID], nil];
        [theList addObject:theListItem];
        
        
    }
    [rs close];

    if ([theList count] >0) {
        return [NSArray arrayWithArray:theList];
    }
    return nil;
}

- (NSInteger )savePlaylist:(NSString *)theName
{
    [appDelegate.mysqlite.db executeUpdate:@"INSERT INTO playlist_name (name) VALUES (?) ;",theName];
    
    if ([appDelegate.mysqlite.db hadError]) {
        NSLog(@"-(void)savePlaylist:(NSString *)theName ->db Error :%@",[appDelegate.mysqlite.db lastErrorMessage]);
    }
    NSInteger pid = [appDelegate.mysqlite.db lastInsertRowId];
    return pid;
}

#pragma mark - Class Base
- (id)init
{
	
    self = [super init];
    if (self) {
        /* class-specific initialization goes here */
        appDelegate =(WebMusicDownloadAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}// end init
-(NSMutableArray *)getDefaultList:(NSString *)theType{
    NSString *sql =[NSString stringWithFormat:@"SELECT fid ,url ,save_path,display_name,album_name,title,artist, duration ,file_size FROM task_list WHERE task_status = '%@' ORDER BY %@ DESC;" ,kDownloadStatusComplete,theType];
    if ([theType isEqualToString:@"title"]) {
        sql = [NSString stringWithFormat:@"SELECT fid ,url ,save_path,display_name,album_name,title,artist, duration ,file_size FROM task_list WHERE task_status = '%@' ORDER BY %@ ASC;" ,kDownloadStatusComplete,theType];
    }
    self.playList  =[self getSongFromDB:sql];
    return self.playList;

}
-(NSMutableArray *)getPlayListByID:(NSInteger)thePlaylistID
{
 
        NSString *sql =[NSString stringWithFormat:@"SELECT task_list.fid ,task_list.url ,task_list.save_path,task_list.display_name,task_list.album_name,task_list.title,task_list.artist, task_list.duration ,task_list.file_size FROM task_list ,playlist WHERE  task_list.fid = playlist.fid AND task_list.task_status = '%@' AND playlist.pid =%d ORDER BY playlist.id ASC;" ,kDownloadStatusComplete ,thePlaylistID];
    
        self.playList = [self getSongFromDB:sql];
        return self.playList;
 
}
-(NSMutableArray *)getPlayList:(NSString *)playListName
{
    //title :by title ,desc
    NSMutableArray *resultPlayList=[NSMutableArray array];
    
    
    if ([playListName isEqualToString:kPlayListDefault]) {
        resultPlayList =[self getDefaultList:@"fid"];
        
    }else if([playListName isEqualToString:@"Title"]){
        resultPlayList =[self getDefaultList:@"title"];
    }
 
    return resultPlayList;
}

- (void)dealloc{
    [playList release];
    [recentlyPlayedList release];
    [super dealloc];
    
}

@end
