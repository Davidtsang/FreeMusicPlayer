//
//  AddSongToPlaylistViewController.h
//  WebMusicDownload
//
//  Created by Zen David on 11-10-18.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlayList;
@class WebMusicDownloadAppDelegate;

@interface AddSongToPlaylistViewController : UIViewController 
<UITableViewDelegate,UITableViewDataSource>
{
    WebMusicDownloadAppDelegate *appDelegate;
    PlayList *playlistOBJ ;
    NSString *listTitle ;
    UINavigationBar *navBar;
    UINavigationItem *navItem;
    UITableView *thisTableView;
    NSArray *songsList;
    NSMutableArray *selectedSongs;
    NSInteger pid;
    BOOL isPlaylistAddToThereSelf;
    id delegate;
}
@property(nonatomic,retain)IBOutlet UINavigationBar *navBar;
@property(nonatomic,retain)IBOutlet UITableView *thisTableView;
@property(nonatomic,retain)IBOutlet UINavigationItem *navItem;
@property(nonatomic,retain) NSArray *songsList;
@property(nonatomic,retain) NSMutableArray *selectedSongs;
@property(nonatomic,retain) PlayList *playlistOBJ ;
@property(nonatomic,retain) NSString *listTitle ;
@property(nonatomic,assign) NSInteger pid;
@property(nonatomic,assign) BOOL isPlaylistAddToThereSelf;

-(void)toAddSong:(id)sender;
-(void)toDone;
-(void)doRemoveFromSuperview;
-(void)addSelectedSongBySID:(NSNumber* )songID;

- (void)setDelegate:(id)aDelegate;//delegate


@end
