//
//  NowPlayingViewController.h
//  WebMusicDownload
//
//  Created by Zen David on 11-9-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PlayList.h"


#define kAppWidth 320.0
#define kRectZero 0.0
#define kToolBarSTDHeight 44.0
#define kSongTitleLeftSpace 50.0
#define kSongTitleTopLine 14.0
#define kSongTitleWidth 230.0
#define k12pxFontRealHeight 14.0
#define kSongArtistTopLine 2.0
#define kSongAlbumTopLine 27.0
#define kBottomTrayTopLine 365.0
#define kPlayButtonXPoint 143.0
#define kPlayButtonTopLine 2.0
#define kBackwardButtonXPoint 56.0
#define kForwardButtonXPoint 220.0
#define kVolumeSliderXPoint 26.0
#define kVolumeSliderTopLine 49.0
#define kVolumeSliderWidth 268.0
#define kMinTouchObjectHeight 44.0
#define kRepeatButtonXPoint 9.0
#define kRepeatButtonTopLine 46.0
#define kShuffleButtonXPoint 286.0
#define kSongProgressSliderXPoint 49.0
#define kSongProgressSliderTopLine 6.0
#define kSongProgressSliderWidth 222.0
#define kMiniSpace 2.0
#define kPlayedTimeTopLine 20.0
#define k14pxFontRealHeight 16.0
#define k16pxFontRealHeight 18.0
#define kTimeLableWidth 46.0
#define kRemainningTimeXPoint 274.0
#define kHeaderTrayTitleTopLine 6.0
#define kHeaderTrayTitleXPoint 80.0
#define k11pxFontRealHeight 13.0
#define kHeaderTrayFooterTopLine 48.0
#define kHeaderTrayFooterXPoint 10.0
#define kNavBackButtonXPoint 5.0
#define kNavBackButtonTopLine 7.0
#define kNavListButtonXPoint 284.0
#define kDefPlayerVolume 0.62
#define kTrackBeginSplitTime 0.01
#define kPlayingTempSaveInfo @"PlayingTempSaveInfo"
#define kPlayListName @"playListName"
#define kPlayingIndex @"playingIndex"
#define kPlayingVolume @"playingVolume"
#define kPlayingShuffleStatus @"playingShuffleStatus"
#define kPlayingRepeatFlag @"playingRepeatFlag"
#define kPlayingHeaderTrayStatus @"playingHeaderTrayStatus"
#define kPlayingProgress @"playingProgress"


#define kRepeatOFF 0
#define kRepeatON 1
#define kRepeatON1 2
#define kPlayListTableHeight 368
#define kPlayListCellID 801
#define kPlayListCellTitle 802
#define kPlayListCellTime 803
#define kPlayListCellPlayingFlag 804

@class WebMusicDownloadAppDelegate;

@interface NowPlayingViewController : UIViewController
<AVAudioPlayerDelegate,UITableViewDelegate,UITableViewDataSource>{
    
@private
    UIView *navBarView;
    UIView *bottomTrayView;
    UIView *headerTrayView;
    UIButton *btnRepeat;
    UIImage *repeatOFF;
    UIImage *repeatON1;
    UIImage *repeatON;
    UIButton *btnShuffle;
    UIImage *shuffleOFF;
    UIImage *shuffleON;
    UIButton *playPauseButton;
    BOOL seekToZeroBeforePlay;
    UILabel *lbPlayedTime;
    UILabel *lbRemainningTime;
    UILabel *lbHeaderTrayTitle;
    UILabel *lbHeaderTrayFooter;
    UILabel *lbSongTitle;
    UILabel *lbSongArtist;
    UILabel *lbSongAlbum;
    UISlider *songProgressSlider;
    UISlider *volumeSlider;
  
    AVAudioPlayer *player;
    NSMutableArray *reSortPlayList;
    NSMutableArray *playListOrg;
    WebMusicDownloadAppDelegate *appDelegate;
    NSInteger repeatFlag;
    BOOL shuffleStatus;
    PlayList *playListObj;
    NSTimer *sliderTimer;
    UITableView *playListTable;
    UIImageView *cellBlackImgView;
    UIImageView *cellGreyImgView;
    //NSMutableArray *shuffleIndex;
        
@public
    NSMutableArray *playList;
    NSInteger currentPlayingIndex;
    NSTimeInterval currentPlayingTime;
    NSString *playListName;
    BOOL isChangeToSPSong;
    BOOL inBackground;
    
}
@property(nonatomic,retain) NSMutableArray *playList;
@property(nonatomic,assign) NSInteger currentPlayingIndex;
@property(nonatomic,retain) PlayList *playListObj;
@property(nonatomic,assign) NSTimeInterval currentPlayingTime;
@property(nonatomic,retain) NSString *playListName;
@property(nonatomic,assign) BOOL isChangeToSPSong;
@property(nonatomic,assign) BOOL inBackground;


-(void)playSong:(NSURL *)aSong;
-(void)updataAll;
-(void)stdPlaySongAction;
-(void)stdPlaySongAction:(BOOL)mustPlay;
-(void)initPlaylist;
@end
