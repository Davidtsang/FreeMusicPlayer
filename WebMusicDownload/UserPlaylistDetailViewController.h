//
//  UserPlaylistDetailViewController.h
//  WebMusicDownload
//
//  Created by Zen David on 11-10-18.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlayList;
@class AddSongToPlaylistViewController;

@interface UserPlaylistDetailViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
    NSString *plTitle;
    NSMutableArray *thePlaylist;
    NSInteger pID;
@private
    UITableView *theTableView; 
    BOOL isInEditing;
    PlayList *playlistObj;
    UIBarButtonItem *leftNavBtn;
    NSString *actionSheetType;
    AddSongToPlaylistViewController *addSongToPlaylistView;
    
}

@property(nonatomic,retain) NSString *plTitle;
@property(nonatomic,retain) NSMutableArray *thePlaylist;
@property(nonatomic,assign) NSInteger pID;
@end
