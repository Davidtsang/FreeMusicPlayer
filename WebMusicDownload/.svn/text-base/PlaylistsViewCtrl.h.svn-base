//
//  PlaylistsViewCtrl.h
//  WebMusicDownload
//
//  Created by Zen David on 11-10-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddSongToPlaylistViewController.h"


#define kAddPlaylistTextField 1200
#define kPlaylistCellAddlist 350000
#define kPlaylistCellDefault 350001
#define kPlaylistCellTitle 350002
#define kPlaylistCellRecentlyPlayed 350003
#define kPlaylistCellRecentlyAdded 350004

//@class WebMusicDownloadAppDelegate;
@class PlayList;

@interface PlaylistsViewCtrl : UIViewController
<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView *theTableView;
    NSMutableArray *playlists ;
    
@private
    UIAlertView *addPlayListAlertView;
    PlayList *playListObj;
    AddSongToPlaylistViewController *addSongToPlaylistView;
}
@property(nonatomic,retain) UITableView *theTableView;
@property(nonatomic,retain)  NSMutableArray *playlists ;

@end
