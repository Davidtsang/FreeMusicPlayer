//
//  PlayerSongsViewController.h
//  WebMusicDownload
//
//  Created by Zen David on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "PlayerViewController.h"
#import "NowPlayingViewController.h"
#import "WebMusicDownloadAppDelegate.h"
#import "DownloadProgressView.h"
//#import <MediaPlayer/MediaPlayer.h>

#define kSongItemName 100
#define kSongItemUrl 101
#define kSongItemTID 102
#define kSongItemStatus 103
#define kSongItemProgress 104
#define kSongItemButtonStop 105
#define kSongItemIndicator 106

//#define kSongItemRefStatus @"refStatus"
//#define kSongItemRefProgress @"refProgress"
#define WMDFileManagementError 200

@interface PlayerSongsViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource>
{
    WebMusicDownloadAppDelegate *appDelegate;
    UITableView *thisTableView;
    //PlayerViewController *playerView;
    NowPlayingViewController *nowPlayingView;
    
    
    NSMutableArray* allSongItems;
    //UIBarButtonItem *biStopAllTasks;
    UIBarButtonItem *biEdit;
}
@property(nonatomic,retain) NowPlayingViewController *nowPlayingView;
@property(nonatomic,retain) IBOutlet UITableView *thisTableView;
@property(nonatomic,retain)  UIBarButtonItem *biEdit;


@property(nonatomic,retain) NSMutableArray* allSongItems;
//@property(nonatomic,retain) IBOutlet UIBarButtonItem *biStopAllTasks;

//- (NSArray *)getFinishedSongs;
-(void) stopAllTasks;
-(void) editTasks;
- (void)failWithError:(NSError *)theError;

@end
