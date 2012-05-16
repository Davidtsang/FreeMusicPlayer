//
//  NowPlayingViewController.m
//  WebMusicDownload
//
//  Created by Zen David on 11-9-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NowPlayingViewController.h"
#import "WebMusicDownloadAppDelegate.h"
#import "MySqlite.h"
#import "MyFunction.h"
#import "NSMutableArray+Shuffling.h"
#import "PlaylistsViewCtrl.h"

@interface NowPlayingViewController()
@property(nonatomic,retain) UIView *navBarView;
@property(nonatomic,retain) UIView *bottomTrayView;
@property(nonatomic,retain) UIView *headerTrayView;
@property(nonatomic,retain) UIButton *btnRepeat;
@property(nonatomic,retain) UIImage *repeatOFF;
@property(nonatomic,retain) UIImage *repeatON1;
@property(nonatomic,retain) UIImage *repeatON;
@property(nonatomic,retain) UIButton *btnShuffle;
@property(nonatomic,retain) UIImage *shuffleOFF;
@property(nonatomic,retain) UIImage *shuffleON;
@property(nonatomic,retain) UILabel *lbPlayedTime;
@property(nonatomic,retain) UILabel *lbRemainningTime;
@property(nonatomic,retain) UILabel *lbHeaderTrayTitle;
@property(nonatomic,retain) UILabel *lbHeaderTrayFooter;
@property(nonatomic,retain) UILabel *lbSongTitle;
@property(nonatomic,retain) UILabel *lbSongArtist;
@property(nonatomic,retain) UILabel *lbSongAlbum;
@property(nonatomic,retain) UISlider *songProgressSlider;
@property(nonatomic,retain) UIButton *playPauseButton;
@property(nonatomic,retain) AVAudioPlayer *player;
@property(nonatomic,retain) NSMutableArray *reSortPlayList;
@property(nonatomic,retain) UISlider *volumeSlider;
@property(nonatomic,assign) NSInteger repeatFlag;
@property(nonatomic,assign) BOOL shuffleStatus;
@property(nonatomic,assign) NSTimer *sliderTimer;
@property(nonatomic,retain) NSMutableArray *playListOrg;
@property(nonatomic,retain) UITableView *playListTable;
@property(nonatomic,retain) UIImageView *cellBlackImgView;
@property(nonatomic,retain) UIImageView *cellGreyImgView;
//@property(nonatomic,retain) NSMutableArray *shuffleIndex;
-(void)playOrPause;
-(void)playingToListBegin;
-(void)playingToListEnd;
-(void)toBackward:(id)sender;
-(void)toForward:(id)sender;
-(void)toRepeat:(id)sender;
-(void)toShuffle:(id)sender;
-(void)volumeValueChange:(id)sender;
//-(void)songProgressChange:(id)sender;
-(void)toNavBack:(id)sender;
-(void)loadStatusSave;
-(void)savePlayingStatus;
-(void)songSliderChanged:(UISlider *)sender;
-(void)updateSlider;
-(void)updateSongLabels;

-(void)toShowTopTray:(id)sender;
-(void)configPlayList:(NSString *)thePlayListName;
-(void)playTheSPSong;
-(void)updatePlayButton;
-(void)toPlaylists;
- (void)setInBackgroundFlag;
- (void)clearInBackgroundFlag;
- (void)registerForBackgroundNotifications;
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)p;
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)p;

//- (void)shufflePlayer;
- (void)nextIndexCheck;

@end

@implementation NowPlayingViewController

@synthesize bottomTrayView;
@synthesize headerTrayView;
@synthesize btnRepeat;
@synthesize repeatOFF;
@synthesize repeatON1;
@synthesize repeatON;
@synthesize btnShuffle;
@synthesize shuffleOFF;
@synthesize shuffleON;
@synthesize lbPlayedTime;
@synthesize lbRemainningTime;
@synthesize lbHeaderTrayTitle;
@synthesize lbHeaderTrayFooter;
@synthesize lbSongTitle;
@synthesize lbSongArtist;
@synthesize lbSongAlbum;
@synthesize navBarView;
@synthesize songProgressSlider;
@synthesize playPauseButton;
@synthesize player;
@synthesize playList;
@synthesize currentPlayingIndex;
@synthesize reSortPlayList;
@synthesize volumeSlider;
@synthesize repeatFlag;
@synthesize shuffleStatus;
@synthesize playListObj;
@synthesize currentPlayingTime;
@synthesize sliderTimer;
@synthesize playListOrg;
@synthesize playListTable;
@synthesize cellGreyImgView;
@synthesize cellBlackImgView;
@synthesize playListName;
@synthesize isChangeToSPSong;
@synthesize inBackground;
//@synthesize shuffleIndex;

- (void)nextIndexCheck
{
    if (self.repeatFlag != kRepeatON1) {
        if (self.currentPlayingIndex == ([playList count]-1)) {
            //is play list end
            if (self.repeatFlag == kRepeatON) {
                self.currentPlayingIndex =0;
            }else{
                [self playingToListEnd];
            }
        }else{//is repeatOFF
            self.currentPlayingIndex =self.currentPlayingIndex+1;
        }
    }// is repeatON1
}
 
-(void)updataAll
{
    [self updatePlayButton];
    [self updateSongLabels];
    [self.playListTable reloadData];
    
}
#pragma mark AudioSession handlers

void RouteChangeListener(void * inClientData,
                         AudioSessionPropertyID        inID,
                         UInt32 inDataSize,
                         const void * inData){
    NowPlayingViewController* This = (NowPlayingViewController*)inClientData;
    
    if (inID == kAudioSessionProperty_AudioRouteChange) {
        
        CFDictionaryRef routeDict = (CFDictionaryRef)inData;
        NSNumber* reasonValue = (NSNumber*)CFDictionaryGetValue(routeDict, CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
        
        int reason = [reasonValue intValue];
        
        if (reason == kAudioSessionRouteChangeReason_OldDeviceUnavailable) {
            [This.player stop];
        }
    }
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)p
{
    NSLog(@"Interruption begin. Updating UI for new state");
    // the object has already been paused,        we just need to update UI
//    if (inBackground)
//    {
//        //[self updateViewForPlayerStateInBackground:p];
//    }
//    else
//    {
//        [self updateViewForPlayerState:p];
//    }
    [self updatePlayButton];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)p
{
    NSLog(@"Interruption ended. Resuming playback");
    //[self startPlaybackForPlayer:p];
}

#pragma mark background notifications
- (BOOL) canBecomeFirstResponder {
    
    
    NSLog(@"first responder");
    return YES;
    
}
- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    NSLog(@"recive ui event!");
    
    
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        
        
        switch (receivedEvent.subtype) {
                
                
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                
                [self playOrPause];
                
                break;
                
                
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                
                [self toBackward:nil];
                
                break;
                
                
                
            case UIEventSubtypeRemoteControlNextTrack:
                
                [self toForward:nil];
                
                break;
                
                
                
            default:
                
                break;
                
        }
        
    }
    
}

- (void)registerForBackgroundNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setInBackgroundFlag)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearInBackgroundFlag)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)setInBackgroundFlag
{
    inBackground = YES;
    //NSLog(@"setInBackgroundFlag");
}

- (void)clearInBackgroundFlag
{
    inBackground = NO;
    //NSLog(@"clearInBackgroundFlag");
}

#pragma mark - Functions
-(void)updatePlayButton
{
    if (self.player.playing == YES) {
        [playPauseButton setBackgroundImage:[UIImage imageNamed:@"BtnStop.png"] forState:UIControlStateNormal];
        [playPauseButton setBackgroundImage:[UIImage imageNamed:@"BtnStopPressed.png"] forState:UIControlStateHighlighted];
        
    }
    else {
        [playPauseButton setBackgroundImage:[UIImage imageNamed:@"BtnPlay.png"] forState:UIControlStateNormal];
        [playPauseButton setBackgroundImage:[UIImage imageNamed:@"BtnPlayPressed.png"] forState:UIControlStateHighlighted];
    }

}//end 

-(void)playTheSPSong{
    [self configPlayList:self.playListName];
    [self stdPlaySongAction:YES];
    self.isChangeToSPSong =NO;
    
}
-(void)configPlayList:(NSString *)thePlayListName
{
    self.playList =[playListObj getPlayList:thePlayListName];
    //INIT PLAYLIST
    //NSArray* reversedArray = [[startArray reverseObjectEnumerator] allObjects];
    
    [self initPlaylist];
}

-(void)initPlaylist
{
    //NSArray* reversedArray =[[playList reverseObjectEnumerator] allObjects];
    self.playListOrg =[NSMutableArray arrayWithArray:self.playList];
    self.reSortPlayList =[NSMutableArray arrayWithArray:self.playList];
    [reSortPlayList shuffle];
    self.playList =self.playListOrg;
}
-(void)toShowTopTray:(id)sender{
    //NSLog(@"toShowTopTray:");
    if (self.headerTrayView.hidden ==NO) {
        self.headerTrayView.hidden =YES;
    }else{
        self.headerTrayView.hidden =NO;
    }
}
- (void)songSliderChanged:(UISlider *)sender {
    // Fast skip the music when user scroll the UISlider
    //[player stop];
    [player setCurrentTime: (NSTimeInterval)self.songProgressSlider.value];
    //[player prepareToPlay];
    //[player play];
}
 
-(void)updateSongLabels{
    if ([playList count] > 0) {
        self.lbHeaderTrayTitle.text=[NSString stringWithFormat:@"%d of %d",self.currentPlayingIndex+1,[playList count]];
        NSDictionary *songItem = [playList objectAtIndex:self.currentPlayingIndex];
        self.lbSongAlbum.text = [songItem objectForKey:@"album_name"];
        self.lbSongTitle.text = [songItem objectForKey:@"title"];
        self.lbSongArtist.text =[songItem objectForKey:@"artist"];
        [self.playListTable reloadData];
    }

}

-(void)updateSlider{
    // Update the slider about the music time
    self.songProgressSlider.value =self.player.currentTime;
    self.lbPlayedTime.text =[MyFunction convertTimeFromSeconds:self.player.currentTime];
    NSString *remainningTime =[MyFunction convertTimeFromSeconds:(self.player.duration- self.player.currentTime)];
    self.lbRemainningTime.text =[NSString stringWithFormat:@"-%@",remainningTime];
    
                                 
}
-(void)loadStatusSave{
    //get save
    //save status data =listdata and index value
    //save path= sys playingStatus dict

    
    NSDictionary* playingTempSaveInfo =[NSMutableDictionary dictionaryWithDictionary:
                                         [[NSUserDefaults standardUserDefaults] dictionaryForKey:kPlayingTempSaveInfo] 
                                         ];
    
    //if not
    if ([playingTempSaveInfo count]==0) {
        //get def list and def songindex
        //def list = all song desc by id ,def index =lastsong id
        self.currentPlayingIndex = 0;
        self.playListName =kPlayListDefault;
        
        //self.playList =[playListObj getPlayList:self.playListName];
        
    }else{
        //if yes
        //set playlist and index
        NSString *thePlayListName =[playingTempSaveInfo objectForKey: kPlayListName];
        if (thePlayListName == nil ) thePlayListName =kPlayListDefault;
        
        self.playListName =thePlayListName;
        
        self.currentPlayingIndex =[[playingTempSaveInfo objectForKey:kPlayingIndex] integerValue];
        //self.currentPlayingIndex =thePlayListName;
        //playing progress
        NSNumber *playingProgress =[playingTempSaveInfo objectForKey: kPlayingProgress];
        self.songProgressSlider.value = [playingProgress floatValue];
        
        //value
        NSNumber *volume = [playingTempSaveInfo objectForKey:kPlayingVolume];
        self.volumeSlider.value = [volume floatValue];
        
        //shuffle flag
        NSNumber *theShuffleStatus =[playingTempSaveInfo objectForKey: kPlayingShuffleStatus];
        self.shuffleStatus = [theShuffleStatus boolValue];
        
        //repeat flag
        NSNumber *theRepeatFlag =[playingTempSaveInfo objectForKey: kPlayingRepeatFlag];
        self.repeatFlag = [theRepeatFlag integerValue];
        
        //header tray hidden/show
        NSNumber *headerTrayStatus =[playingTempSaveInfo objectForKey: kPlayingHeaderTrayStatus];        
        self.headerTrayView.hidden =[headerTrayStatus boolValue];
        
    }
    //self.playList =[playListObj getPlayList:self.playListName];
    [self configPlayList:self.playListName];
}

-(void)savePlayingStatus{
    
    //playlist name
    
    //playing index
    NSNumber *playingIndex =[NSNumber numberWithInteger:self.currentPlayingIndex];
    
    //playing progress
    NSNumber *playingProgress =[NSNumber numberWithFloat:self.songProgressSlider.value];
    
    //value
    NSNumber *volume = [NSNumber numberWithFloat:self.volumeSlider.value];
    
    //shuffle flag
    NSNumber *theShuffleStatus =[NSNumber numberWithBool:shuffleStatus];
    
    //repeat flag
    NSNumber *theRepeatFlag =[NSNumber numberWithInteger:self.repeatFlag];
    
    //header tray hidden/show
    NSNumber *headerTrayStatus =[NSNumber numberWithBool:self.headerTrayView.hidden];
    
    NSDictionary *playStatus =[[NSDictionary alloc] initWithObjectsAndKeys:
                               
                               playingIndex ,kPlayingIndex,
                               playingProgress,kPlayingProgress,
                               volume,kPlayingVolume,
                               theShuffleStatus,kPlayingShuffleStatus,
                               theRepeatFlag,kPlayingRepeatFlag,
                               headerTrayStatus,kPlayingHeaderTrayStatus,
                               self.playListName,kPlayListName,
                               nil ] ;
    [[NSUserDefaults standardUserDefaults] setObject:playStatus forKey:kPlayingTempSaveInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [playStatus release];
    
}

-(void)playingToListBegin
{
    NSLog(@"Playlist to begin!");
}
-(void)playingToListEnd
{
     NSLog(@"Playlist to end!");
}

-(void)playSong:(NSURL *)aSong{
 


     
    NSError *err;

	self.player = [AVAudioPlayer alloc];
	if([player initWithContentsOfURL:aSong error:&err]) {
		[player autorelease];
	}
	else {
		[player release];
		player = nil;
	}

    [self registerForBackgroundNotifications];
    OSStatus result = AudioSessionInitialize(NULL, NULL, NULL, NULL);
    if (result)
        NSLog(@"Error initializing audio session! %ld", result);
    
    [[AVAudioSession sharedInstance] setDelegate: self];
    NSError *setCategoryError = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryError];
    if (setCategoryError)
        NSLog(@"Error setting category! %@", setCategoryError);
    
    result = AudioSessionAddPropertyListener (kAudioSessionProperty_AudioRouteChange, RouteChangeListener, self);
    if (result) 
        NSLog(@"Could not add property listener! %ld", result);
    [[AVAudioSession sharedInstance] setActive: YES error: nil];

    
    [player setDelegate:self];
    [player setVolume:self.volumeSlider.value];
    [player setCurrentTime:(NSTimeInterval)self.songProgressSlider.value];
    sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
    // Set the maximum value of the UISlider
    self.songProgressSlider.maximumValue =player.duration;
    self.lbPlayedTime.text =[MyFunction convertTimeFromSeconds:self.player.currentTime];
    [player prepareToPlay];
    if(![player play]) {
        NSLog(@"Error playing audio %@", [err localizedDescription]);
    }
}
-(void)playOrPause {
    if ([playList count] >0) {
        
        
        if (self.player.playing  == YES) {//is playing
            [player pause];//stop
            
            //show playing img
            [playPauseButton setBackgroundImage:[UIImage imageNamed:@"BtnPlay.png"] forState:UIControlStateNormal];
            [playPauseButton setBackgroundImage:[UIImage imageNamed:@"BtnPlayPressed.png"] forState:UIControlStateHighlighted];
            
        }
        else {
            if (self.player != nil) {
                [player play];
            }else{
                [self stdPlaySongAction:YES];
            }
            [playPauseButton setBackgroundImage:[UIImage imageNamed:@"BtnStop.png"] forState:UIControlStateNormal];
            [playPauseButton setBackgroundImage:[UIImage imageNamed:@"BtnStopPressed.png"] forState:UIControlStateHighlighted];
        }
    }//end playlist count
}
-(void)stdPlaySongAction{
    [self stdPlaySongAction:NO];
}
-(void)stdPlaySongAction:(BOOL)mustPlay{
    if ([playList count] > 0) {
        NSDictionary *nextSong =[playList objectAtIndex:self.currentPlayingIndex];
        NSInteger songSID = [[nextSong objectForKey:kSongID] integerValue];
        appDelegate.nowPlayingSongID = songSID;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNoticeNowPlayingChange object:nil userInfo:[NSDictionary dictionaryWithObject:[nextSong objectForKey:kSongID] forKey:kSongID]];
        
        NSURL *nextURL =[nextSong objectForKey:kSongSavePath];
        
        [self updateSongLabels];
        
        
        self.songProgressSlider.value = 0;
        if ([player isPlaying]) {
            [player stop];
            //[player release];
            self.player =nil;
            //[self playSong:nextURL];
            mustPlay =YES;
        }
        if (mustPlay) {
            [self playSong:nextURL];
        }
        [self updatePlayButton];

    }//end if
}
-(void)toBackward:(id)sender{
    //begin or backward
    if ([playList count] >0) {
    float playingPercent =self.player.currentTime/self.player.duration;
    if (playingPercent < kTrackBeginSplitTime || self.player.playing == NO) {
        //need backward
        if (self.currentPlayingIndex > 0) {
            self.currentPlayingIndex =self.currentPlayingIndex-1;
        }else if(self.repeatFlag == kRepeatON){
            self.currentPlayingIndex =[playList count]-1;
        }
        else{
            [self playingToListBegin];
        }
        
    }
    [self stdPlaySongAction]; 
    }
}

-(void)toForward:(id)sender{
    if ([playList count] >0) {
    if (self.currentPlayingIndex == ([playList count]-1)) {
        //is play list end
        if (self.repeatFlag == kRepeatON) {
            self.currentPlayingIndex =0;
        }else{
            [self playingToListEnd];
        }
    }else{//is repeatOFF
        self.currentPlayingIndex =self.currentPlayingIndex+1;
    }

    [self stdPlaySongAction]; 
    }
}


-(void)toRepeat:(id)sender{
    if (self.repeatFlag == kRepeatOFF) {
        [btnRepeat setBackgroundImage:self.repeatON forState:UIControlStateNormal];
        self.repeatFlag = kRepeatON;
    }else if(self.repeatFlag == kRepeatON){
        [btnRepeat setBackgroundImage:self.repeatON1 forState:UIControlStateNormal];
        self.repeatFlag=kRepeatON1;
    }else if (self.repeatFlag == kRepeatON1){
        [btnRepeat setBackgroundImage:self.repeatOFF forState:UIControlStateNormal];
        self.repeatFlag=kRepeatOFF;
    }
}
-(void)toShuffle:(id)sender{
    if (self.shuffleStatus ==NO) {//if now is off
        [btnShuffle setBackgroundImage:self.shuffleON forState:UIControlStateNormal];
        self.shuffleStatus =YES;
        [self.reSortPlayList shuffle];
        self.playList =self.reSortPlayList;
        
        
    }else{// is on
        [btnShuffle setBackgroundImage:self.shuffleOFF forState:UIControlStateNormal];
        self.shuffleStatus =NO;
        self.playList =self.playListOrg;
        
    }
}
-(void)volumeValueChange:(id)sender{
    if (self.player) {
        player.volume = self.volumeSlider.value;
    }
    
}

-(void)toNavBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)toPlaylists
{
    PlaylistsViewCtrl *p =[[PlaylistsViewCtrl alloc] init];
    [self.navigationController pushViewController:p animated:YES];
    [p release];
    
    
}
#pragma mark - Class Base

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [navBarView release];
    [bottomTrayView release];
    [headerTrayView release];
    [repeatOFF release];
    [repeatON1 release];
    [repeatON release];
    [shuffleOFF release];
    [shuffleON release];
    [lbPlayedTime release];
    [lbRemainningTime release];
    [lbHeaderTrayTitle release];
    [lbHeaderTrayFooter release];
    [lbSongTitle release];
    [lbSongArtist release];
    [lbSongAlbum release];
    [songProgressSlider release];
    //[player release];
    [playPauseButton release];
    [volumeSlider release];
    [playListObj release];
    [sliderTimer release];
    [playListOrg release];
    [playListTable release];
    [cellGreyImgView release];
    [cellBlackImgView release];
    [playListName release];
    //[shuffleIndex release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(void)initUI
{
    // --------------init ui
    UIView *contentView =[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view =contentView;
    contentView.backgroundColor =[UIColor whiteColor];
    //contentView.alpha =0.5;
    [contentView release];
    
    UIImage *navBarImage = [UIImage imageNamed:@"NowPlayingNavBar.png"] ;
    CGRect navBarRect = CGRectMake(kRectZero, kRectZero,kAppWidth,kToolBarSTDHeight);
    UIView *_navBarView =[[UIView alloc] initWithFrame:navBarRect];
    UIImageView *navBarImageView =[[UIImageView alloc] initWithImage:navBarImage];
    [_navBarView addSubview:navBarImageView];
    self.navBarView =_navBarView;
    
    [navBarImageView release];
    [_navBarView release];
    
    // BACK BUTTON
    UIImage *btnNavBackImage = [UIImage imageNamed:@"NavBackButton.png"];
    CGRect btnNavBackRect = CGRectMake(kNavBackButtonXPoint, kNavBackButtonTopLine, btnNavBackImage.size.width, btnNavBackImage.size.height); 
    
    UIButton *btnNavBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNavBack.frame = btnNavBackRect;
    [btnNavBack setBackgroundImage:btnNavBackImage forState:UIControlStateNormal];
    // add targets and actions
    [btnNavBack addTarget:self action:@selector(toNavBack:) forControlEvents:UIControlEventTouchUpInside]; 
    [self.navBarView addSubview:btnNavBack];
    //[btnNavBack release];
    //[myButton setTitle:@"Hello!" forState:UIControlStateHighlighted];
    
    // nav list
    UIImage *btnNavListImage = [UIImage imageNamed:@"NowPlayingAlbumInfo.png"];
    CGRect btnNavListRect = CGRectMake(kNavListButtonXPoint, kNavBackButtonTopLine, btnNavListImage.size.width, btnNavListImage.size.height); 
    
    UIButton *btnNavList  = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNavList.frame = btnNavListRect;
    [btnNavList setBackgroundImage:btnNavListImage forState:UIControlStateNormal];
    // add targets and actions
    [btnNavList addTarget:self action:@selector(toPlaylists) forControlEvents:UIControlEventTouchUpInside]; 
    [self.navBarView addSubview:btnNavList];    
    
    //label artist
    CGRect lbSongArtistRect =CGRectMake(kSongTitleLeftSpace, kSongArtistTopLine,kSongTitleWidth, k12pxFontRealHeight);
    
    UILabel *_lbSongArtist =[[UILabel alloc] initWithFrame:lbSongArtistRect];
    _lbSongArtist.text = @"";
    _lbSongArtist.backgroundColor =[UIColor clearColor];
    _lbSongArtist.textColor =[UIColor grayColor];
    _lbSongArtist.shadowColor =[UIColor blackColor];
    _lbSongArtist.shadowOffset =CGSizeMake(0, -1);
    _lbSongArtist.textAlignment = UITextAlignmentCenter;
    _lbSongArtist.font =[UIFont boldSystemFontOfSize:12];
    self.lbSongArtist =_lbSongArtist;
    [_lbSongArtist release];
    [self.navBarView addSubview:self.lbSongArtist]; 
    
    //label title
    CGRect lbSongTitleRect =CGRectMake(kSongTitleLeftSpace, kSongTitleTopLine,kSongTitleWidth, k12pxFontRealHeight);
    UILabel *_lbSongTitle =[[UILabel alloc] initWithFrame:lbSongTitleRect];
    _lbSongTitle.text =@"";
    _lbSongTitle.backgroundColor =[UIColor clearColor];
    _lbSongTitle.textColor =[UIColor whiteColor];
    _lbSongTitle.shadowColor =[UIColor blackColor];
    _lbSongTitle.shadowOffset =CGSizeMake(0, -1);
    _lbSongTitle.textAlignment = UITextAlignmentCenter;
    _lbSongTitle.font =[UIFont boldSystemFontOfSize:12];
    self.lbSongTitle =_lbSongTitle;
    [_lbSongTitle release];
    [self.navBarView addSubview:self.lbSongTitle]; 
    
    //label album
    CGRect lbSongAlbumRect =CGRectMake(kSongTitleLeftSpace, kSongAlbumTopLine,kSongTitleWidth, k12pxFontRealHeight);
    UILabel *_lbSongAlbum =[[UILabel alloc] initWithFrame:lbSongAlbumRect];
    _lbSongAlbum.text =@"";
    _lbSongAlbum.backgroundColor =[UIColor clearColor];
    _lbSongAlbum.textColor =[UIColor grayColor];
    _lbSongAlbum.shadowColor =[UIColor blackColor];
    _lbSongAlbum.shadowOffset =CGSizeMake(0, -1);
    _lbSongAlbum.textAlignment = UITextAlignmentCenter;
    _lbSongAlbum.font =[UIFont boldSystemFontOfSize:12];
    
    self.lbSongAlbum =_lbSongAlbum;
    [_lbSongAlbum release];
    [navBarView addSubview:self.lbSongAlbum]; 
    
    
    CGRect btnShowTopTrayRect = CGRectMake(100.0, kRectZero, 120.0, 44.0);
    UIButton *btnShowTopTray =[UIButton buttonWithType:UIButtonTypeCustom];
    [btnShowTopTray setFrame:btnShowTopTrayRect];
    [btnShowTopTray addTarget:self action:@selector(toShowTopTray:) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:btnShowTopTray];
    
    UIImage *bottomTrayImage = [UIImage imageNamed:@"NowPlayingBottomTray.png"] ;
    CGRect bottomTrayRect = CGRectMake(kRectZero, kBottomTrayTopLine,bottomTrayImage.size.width, bottomTrayImage.size.height);
    UIView *_bottomTrayView =[[UIView alloc] initWithFrame:bottomTrayRect];
    UIImageView *bottomTrayImageView =[[UIImageView alloc] initWithImage:bottomTrayImage];
    [_bottomTrayView addSubview:bottomTrayImageView];
    //self.bottomTrayView =_bottomTrayView;
    bottomTrayImageView.alpha =0.9;
    [bottomTrayImageView release];
    
    // Add our custom add button as the nav bar's custom right view
    UIButton *_btnPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _btnPlayButton.frame = CGRectMake(kPlayButtonXPoint, kPlayButtonTopLine, kMinTouchObjectHeight, kMinTouchObjectHeight);
    [_btnPlayButton addTarget:self action:@selector(playOrPause) 
             forControlEvents:UIControlEventTouchUpInside];
    self.playPauseButton = _btnPlayButton;
    [_bottomTrayView addSubview:self.playPauseButton];
    //[_btnPlayButton release];
    
    UIImage *btnBackwardImage = [UIImage imageNamed:@"BtnBackward.png"];
    UIImage *btnBackwardPressedImage =[UIImage imageNamed:@"BtnBackwardPressed.png"];
    UIButton *_btnBackwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnBackwardButton setBackgroundImage:btnBackwardImage forState:UIControlStateNormal];
    [_btnBackwardButton setImage:btnBackwardPressedImage forState:UIControlStateHighlighted];
    
    _btnBackwardButton.frame = CGRectMake(kBackwardButtonXPoint, kPlayButtonTopLine, btnBackwardImage.size.width, btnBackwardImage.size.height);
    [_btnBackwardButton addTarget:self action:@selector(toBackward:) 
                 forControlEvents:UIControlEventTouchUpInside];
    //self.btnBackwardButton =_btnBackwardButton;
    [_bottomTrayView addSubview:_btnBackwardButton];
    //[_btnBackwardButton release];
    
    UIImage *btnForwardImage = [UIImage imageNamed:@"BtnForward.png"];
    UIImage *btnForwardPressedImage =[UIImage imageNamed:@"BtnForwardPressed.png"];
    UIButton *_btnForwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnForwardButton setBackgroundImage:btnForwardImage forState:UIControlStateNormal];
    [_btnForwardButton setBackgroundImage:btnForwardPressedImage forState:UIControlStateHighlighted];
    _btnForwardButton.frame = CGRectMake(kForwardButtonXPoint, kPlayButtonTopLine, btnForwardImage.size.width, btnForwardImage.size.height);
    [_btnForwardButton addTarget:self action:@selector(toForward:) 
                forControlEvents:UIControlEventTouchUpInside];
    //self.btnForwardButton =_btnForwardButton;
    [_bottomTrayView addSubview:_btnForwardButton];
    //[_btnForwardButton release];
    
    //
    CGRect fxVolumeSliderRect = CGRectMake(kVolumeSliderXPoint, kVolumeSliderTopLine, kVolumeSliderWidth, kMinTouchObjectHeight);
    UISlider *_fxVolumeSlider =[[UISlider alloc] initWithFrame:fxVolumeSliderRect];
    
    UIImage *minImage = [UIImage imageNamed:@"theLeftTrack.png"];
    UIImage *maxImage = [UIImage imageNamed:@"theRightTrack.png"];
    UIImage *tumbImage= [UIImage imageNamed:@"theWhiteslide.png"];
    minImage=[minImage stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
    maxImage=[maxImage stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
    // Setup the FX slider
    [_fxVolumeSlider setMinimumTrackImage:minImage forState:UIControlStateNormal];
    [_fxVolumeSlider setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    [_fxVolumeSlider setThumbImage:tumbImage forState:UIControlStateNormal];
    
    [_fxVolumeSlider addTarget:self action:@selector(volumeValueChange:) forControlEvents:UIControlEventValueChanged];
    _fxVolumeSlider.maximumValue =1.0;
    _fxVolumeSlider.minimumValue =0.0;
    _fxVolumeSlider.value =kDefPlayerVolume;
    
    self.volumeSlider =_fxVolumeSlider;
    [_bottomTrayView addSubview:self.volumeSlider];
    
    
    self.bottomTrayView =_bottomTrayView;
    
    
    //HEADER TRAY
    //UIImageView *bottomTray =[[UIImageView alloc] initWithImage:@"NowPlayingBottomTray.png"] ];
    UIImage *headerTrayImage = [UIImage imageNamed:@"NowPlayingHeaderTray.png"] ;
    CGRect headerTrayRect = CGRectMake(kRectZero,kToolBarSTDHeight,headerTrayImage.size.width, headerTrayImage.size.height);
    UIView *_headerTrayView =[[UIView alloc] initWithFrame:headerTrayRect];
    UIImageView *headerTrayImageView =[[UIImageView alloc] initWithImage:headerTrayImage];
    [_headerTrayView addSubview:headerTrayImageView];
    //self.bottomTrayView =_bottomTrayView;
    headerTrayImageView.alpha =0.9;
    
    //header tray button
    //repeat off
    self.repeatOFF = [UIImage imageNamed:@"repeat_off.png"];
    
    // repeat on
    self.repeatON = [UIImage imageNamed:@"repeat_on.png"];
    UIButton *_btnRepeatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnRepeatButton setBackgroundImage:self.repeatOFF forState:UIControlStateNormal];
    _btnRepeatButton.frame = CGRectMake(kRepeatButtonXPoint, kRepeatButtonTopLine, self.repeatOFF.size.width, self.repeatOFF.size.height);
    [_btnRepeatButton addTarget:self action:@selector(toRepeat:) 
               forControlEvents:UIControlEventTouchUpInside];
    self.btnRepeat =_btnRepeatButton;
    //self.repeatON.hidden =NO;
    [_headerTrayView addSubview:self.btnRepeat];    
    
    // repeat on1
    self.repeatON1 = [UIImage imageNamed:@"repeat_on_1.png"];
    
    //shuffle off
    self.shuffleOFF = [UIImage imageNamed:@"shuffle_off.png"];
    UIButton *_btnShuffleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnShuffleButton setBackgroundImage:self.shuffleOFF forState:UIControlStateNormal];
    
    _btnShuffleButton.frame = CGRectMake(kShuffleButtonXPoint, kRepeatButtonTopLine, self.shuffleOFF.size.width, self.shuffleOFF.size.height);
    [_btnShuffleButton addTarget:self action:@selector(toShuffle:) 
                forControlEvents:UIControlEventTouchUpInside];
    self.btnShuffle =_btnShuffleButton;
    //self.shuffleOFF.hidden =YES;
    //[btnShuffle setClipsToBounds:NO];
    
    //theLeftTrack
    self.shuffleStatus =NO;
    
    [_headerTrayView addSubview:self.btnShuffle];
    
    
    //shuffle on
    self.shuffleON = [UIImage imageNamed:@"shuffle_on.png"];
    
    
    //progress slider
    CGRect songProgressSliderRect = CGRectMake(kSongProgressSliderXPoint,kSongProgressSliderTopLine, kSongProgressSliderWidth, kMinTouchObjectHeight);
    UISlider *_songProgressSlider =[[UISlider alloc] initWithFrame:songProgressSliderRect];
    
    //UIImage *minImage = [UIImage imageNamed:@"theRightTrack.png"];
    //UIImage *maxImage = [UIImage imageNamed:@"theLeftTrack.png"];
    UIImage *songProgressTumbImage= [UIImage imageNamed:@"theWhiteslideLite.png"];
    UIImage *songProgressTumbPressedImage= [UIImage imageNamed:@"theWhiteslideLitePressed.png"];
    [_songProgressSlider setMinimumTrackImage:minImage forState:UIControlStateNormal];
    [_songProgressSlider setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    [_songProgressSlider setThumbImage:songProgressTumbImage forState:UIControlStateNormal];
    [_songProgressSlider setThumbImage:songProgressTumbPressedImage forState:UIControlEventTouchDown];
    [_songProgressSlider addTarget:self action:@selector(songSliderChanged:) forControlEvents:UIControlEventValueChanged];
    self.songProgressSlider =_songProgressSlider;
    
    [_headerTrayView addSubview:self.songProgressSlider];
    [_songProgressSlider release];
    
    //label played time
    CGRect lbPlayedTimeRect =CGRectMake(kMiniSpace, kPlayedTimeTopLine,kTimeLableWidth, k14pxFontRealHeight);
    UILabel *_lbPlayedTime =[[UILabel alloc] initWithFrame:lbPlayedTimeRect];
    _lbPlayedTime.text =@"0:00";
    _lbPlayedTime.backgroundColor =[UIColor clearColor];
    _lbPlayedTime.textColor =[UIColor whiteColor];
    _lbPlayedTime.shadowColor =[UIColor blackColor];
    _lbPlayedTime.shadowOffset =CGSizeMake(0, -1);
    _lbPlayedTime.textAlignment = UITextAlignmentRight;
    _lbPlayedTime.font =[UIFont boldSystemFontOfSize:14];
    self.lbPlayedTime =_lbPlayedTime;
    [_lbPlayedTime release];
    
    [_headerTrayView addSubview:self.lbPlayedTime];
    
    //label REMAINNING time
    CGRect lbRemainningTimeRect =CGRectMake(kRemainningTimeXPoint, kPlayedTimeTopLine,kTimeLableWidth, k14pxFontRealHeight);
    UILabel *_lbRemainningTime =[[UILabel alloc] initWithFrame:lbRemainningTimeRect];
    _lbRemainningTime.text =@"-0:00";
    _lbRemainningTime.backgroundColor =[UIColor clearColor];
    _lbRemainningTime.textColor =[UIColor whiteColor];
    _lbRemainningTime.shadowColor =[UIColor blackColor];
    _lbRemainningTime.shadowOffset =CGSizeMake(0, -1);
    _lbRemainningTime.textAlignment = UITextAlignmentLeft;
    _lbRemainningTime.font =[UIFont boldSystemFontOfSize:14];
    self.lbRemainningTime =_lbRemainningTime;
    [_lbRemainningTime release];
    [_headerTrayView addSubview:self.lbRemainningTime]; 
    
    
    //label HeaderTrayTitle
    CGRect lbHeaderTrayTitleRect =CGRectMake(kHeaderTrayTitleXPoint, kHeaderTrayTitleTopLine,kAppWidth - kHeaderTrayTitleXPoint*2 , k12pxFontRealHeight);
    UILabel *_lbHeaderTrayTitle =[[UILabel alloc] initWithFrame:lbHeaderTrayTitleRect];
    _lbHeaderTrayTitle.text =@"0 of 0";
    _lbHeaderTrayTitle.backgroundColor =[UIColor clearColor];
    _lbHeaderTrayTitle.textColor =[UIColor whiteColor];
    _lbHeaderTrayTitle.textAlignment = UITextAlignmentCenter;
    _lbHeaderTrayTitle.font =[UIFont boldSystemFontOfSize:12];
    self.lbHeaderTrayTitle =_lbHeaderTrayTitle;
    [_lbHeaderTrayTitle release];
    [_headerTrayView addSubview:self.lbHeaderTrayTitle]; 
    
    //Slide your finger down to adjust the scrubbing rate.
    CGRect lbHeaderTrayFooterRect =CGRectMake(kHeaderTrayFooterXPoint, kHeaderTrayFooterTopLine,kAppWidth - kHeaderTrayFooterXPoint*2, k11pxFontRealHeight);
    UILabel *_lbHeaderTrayFooter =[[UILabel alloc] initWithFrame:lbHeaderTrayFooterRect];
    _lbHeaderTrayFooter.text =@"Slide your finger down to adjust the scrubbing rate.";
    _lbHeaderTrayFooter.backgroundColor =[UIColor clearColor];
    _lbHeaderTrayFooter.textColor =[UIColor whiteColor];
    _lbHeaderTrayFooter.textAlignment = UITextAlignmentCenter;
    _lbHeaderTrayFooter.font =[UIFont boldSystemFontOfSize:11];
    self.lbHeaderTrayFooter =_lbHeaderTrayFooter;
    self.lbHeaderTrayFooter.hidden =YES;
    [_lbHeaderTrayFooter release];
    [_headerTrayView addSubview:self.lbHeaderTrayFooter]; 
    _headerTrayView.hidden =YES;
    self.headerTrayView =_headerTrayView;
    
    //playlist table
    UIImageView *playlistTableBackground=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PlayingTableBackground.png"]];
    
    CGRect playlistTableRect =CGRectMake(kRectZero, kToolBarSTDHeight, kAppWidth, kPlayListTableHeight);
    UITableView *thePlayListTable =[[UITableView alloc] initWithFrame:playlistTableRect];
    [thePlayListTable setDelegate:self];
    [thePlayListTable setDataSource:self];
    thePlayListTable.backgroundColor =[UIColor clearColor];
    thePlayListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    self.playListTable = thePlayListTable;
    [thePlayListTable release];
    
    //last part
    [playlistTableBackground setFrame:playlistTableRect];
    [self.view addSubview:playlistTableBackground];
    
    [self.view addSubview:self.playListTable];
    [self.view addSubview:self.navBarView];
    [self.view addSubview:self.bottomTrayView];
    [self.view addSubview:self.headerTrayView];
    
    [headerTrayImageView release];
    [playlistTableBackground release];
    [_headerTrayView release];
    [_fxVolumeSlider release];
    [_bottomTrayView release];    
    
    //load state save
    
    
    //playlist cell image init
    UIImageView *theCellBlackImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBlack.png"]];
    self.cellBlackImgView = theCellBlackImageView;
    [theCellBlackImageView release];
    
    UIImageView *theCellGeryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellGery.png"]];
    self.cellGreyImgView = theCellGeryImageView;
    [theCellGeryImageView release]; 
    
    
    
    [self updatePlayButton];
}
#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    //[self.view  setUserInteractionEnabled:YES]; 
    PlayList *thePlayListObj = [[PlayList alloc] init];
    self.playListObj =thePlayListObj;
    [thePlayListObj release];
    
    //初始化应用程序委托
	appDelegate =(WebMusicDownloadAppDelegate *)[[UIApplication sharedApplication] delegate];

    //----inti ui
    [self initUI];
    
    //is NowPlaying button in/ SPEC song in
    if (self.playListName ==nil && self.currentPlayingIndex ==0) {
        //is NowPlaying button in
        [self loadStatusSave];
    } else{
        //sepc song in
        [self playTheSPSong];
        
    }
    //[self stdPlaySongAction];
    
    
    //check backbround task
    UIDevice* device = [UIDevice currentDevice];
    
    //BOOL backgroundSupported = NO;
    
    if ([device respondsToSelector:@selector(isMultitaskingSupported)]){
        
        //backgroundSupported = device.multitaskingSupported;    
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
 
        [self becomeFirstResponder];

    }
    //notice
    [[NSNotificationCenter defaultCenter]  
     addObserver:self  
     selector:@selector(savePlayingStatus)  
     name:kNoticeAppWillTerminate
     object:nil]; 
    
    //make shuffle list
   // [self makeShuffleIndex];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    //check sp song in
    //[self.playListTable reloadData];
    if (isChangeToSPSong) {
        [self playTheSPSong];
        
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
    //[self savePlayingStatus];
    
}
/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.navBarView =nil;
    self.bottomTrayView =nil;
    self.headerTrayView =nil;
    self.repeatOFF =nil;
    self.repeatON1  =nil;
    self.repeatON  =nil;
    self.shuffleOFF  =nil;
    self.shuffleON  =nil;
    self.lbPlayedTime =nil;
    self.lbRemainningTime =nil;
    self.lbHeaderTrayTitle=nil;
    self.lbHeaderTrayFooter=nil;
    self.lbSongTitle=nil;
    self.lbSongArtist=nil;
    self.lbSongAlbum=nil;
    self.songProgressSlider =nil;
    self.player =nil;
    self.playPauseButton =nil;
    self.volumeSlider =nil;
    self.playListObj =nil;
    self.sliderTimer =nil;
    self.playListOrg = nil;
    self.playListTable =nil;
    self.cellGreyImgView =nil;
    self.cellBlackImgView = nil;
    self.playListName =nil;
    //self.shuffleIndex = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark AVAudioPlayer Delegate Methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)playedPlayer successfully:(BOOL)flag {
    if (flag) {
        NSDictionary *aSong =[playList objectAtIndex:currentPlayingIndex];
        [playListObj saveRecentlyPlayed:[aSong objectForKey:kSongID]];
    }
    //repeat
//    if (self.repeatFlag != kRepeatON1) {
//        if (self.currentPlayingIndex == ([playList count]-1)) {
//            //is play list end
//            if (self.repeatFlag == kRepeatON) {
//                self.currentPlayingIndex =0;
//            }else{
//                [self playingToListEnd];
//            }
//        }else{//is repeatOFF
//            self.currentPlayingIndex =self.currentPlayingIndex+1;
//        }
//    }// is repeatON1
    //self.currentPlayingIndex = [self nextIndexCheck:self.currentPlayingIndex];
    //[self shufflePlayer];
    [self nextIndexCheck];
    
    [self stdPlaySongAction:YES];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.playList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row =[indexPath row];
    NSUInteger r = row % 2;
    //----------
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        //----custum cell
        UIImageView *theCellBlackImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBlack.png"]];
        theCellBlackImageView.alpha =0.45;
        
        UIImageView *theCellGeryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellGery.png"]];
        theCellGeryImageView.alpha =0.45;
        //cell.alpha =0.4;
        if (r == 0) {
            //cell.contentView.backgroundColor = [UIColor grayColor];
           [cell.contentView addSubview:theCellBlackImageView];
        }else{
            [cell setBackgroundView:theCellGeryImageView];
        }
        
        [theCellBlackImageView release];
        [theCellGeryImageView release];
        
        //id label
        CGRect PIDLabelRect = CGRectMake(3.0, 12.0,32.0, k16pxFontRealHeight);
        UILabel *PIDLabel = [[UILabel alloc] initWithFrame:PIDLabelRect ];
        PIDLabel.textAlignment =UITextAlignmentLeft ;
        PIDLabel.tag = kPlayListCellID;
        PIDLabel.font = [UIFont boldSystemFontOfSize:16];
        PIDLabel.backgroundColor =[UIColor clearColor];
        PIDLabel.textColor =[UIColor whiteColor];
        [cell.contentView addSubview:PIDLabel];
        [PIDLabel release];
 
        //title label
        CGRect titleLabelRect = CGRectMake(66.0, 12.0,186.0, k16pxFontRealHeight);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleLabelRect ];
        titleLabel.textAlignment =UITextAlignmentLeft ;
        titleLabel.tag = kPlayListCellTitle;
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        titleLabel.backgroundColor =[UIColor clearColor];
        titleLabel.textColor =[UIColor whiteColor];
        [cell.contentView addSubview:titleLabel];
        [titleLabel release];
        
        //time label
        CGRect timeLabelRect = CGRectMake(260.0, 12.0,54.0, k16pxFontRealHeight);
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:timeLabelRect ];
        timeLabel.textAlignment =UITextAlignmentRight ;
        timeLabel.tag = kPlayListCellTime;
        timeLabel.font = [UIFont boldSystemFontOfSize:16];
        timeLabel.backgroundColor =[UIColor clearColor];
        timeLabel.textColor =[UIColor whiteColor];
        [cell.contentView addSubview:timeLabel];
        [timeLabel release]; 
        
        //playing flag
        UIImage *playingFlagImg =[UIImage imageNamed:@"playingFlag.png"];
        CGRect playingFlagRect = CGRectMake(38.0, 16.0,playingFlagImg.size.width, playingFlagImg.size.height);
        UIImageView *playingFlagView =[[UIImageView alloc] initWithImage:playingFlagImg];
        [playingFlagView setFrame:playingFlagRect];
        playingFlagView.tag =kPlayListCellPlayingFlag;
        playingFlagView.hidden =YES;
        [cell.contentView addSubview:playingFlagView];
        [playingFlagView release];
        
     }
    
    // Configure the cell...
    
    NSDictionary * songItem = [self.playListOrg objectAtIndex:row];
    //cell.textLabel.text =[songItem objectForKey:kSongTitle];
    //THE TID
    UILabel *thePID = (UILabel *)[cell.contentView viewWithTag:kPlayListCellID];
    NSString *thePIDString =[NSString stringWithFormat:@"%d.", row+1];
    thePID.text = thePIDString;
    //NSLog(@"thi pid :%@",thePIDString);
    //THE TID
    UILabel *theTitle = (UILabel *)[cell.contentView viewWithTag:kPlayListCellTitle];
    theTitle.text = [songItem objectForKey:kSongTitle];

    //THE Time 
    UILabel *theTime = (UILabel *)[cell.contentView viewWithTag:kPlayListCellTime];
    NSNumber *songDuration =[songItem objectForKey:kSongDuration];
    
    theTime.text = [MyFunction convertTimeFromSeconds:[songDuration integerValue]];
    //THE Time
    
    UIImageView *thePlayingFlag = (UIImageView *)[cell.contentView viewWithTag:kPlayListCellPlayingFlag];
    
    //songid = 
    NSNumber *theSongID =[songItem objectForKey:kSongID];
    NSNumber *nowPlayingSID= [[self.playList objectAtIndex:self.currentPlayingIndex] objectForKey:kSongID];
    //if ([theSongID isEqualToNumber:nowPlayingSID ]  && row == self.currentPlayingIndex) {
    if ( [theSongID isEqualToNumber:nowPlayingSID ]) {
        
        //NSNumber *songDuration =[songItem objectForKey:kSongDuration];
        thePlayingFlag.hidden = NO;
    }else{
        thePlayingFlag.hidden = YES;
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	NSUInteger row =[indexPath row];
    self.currentPlayingIndex = row;
    self.playList =playListOrg;
    [self stdPlaySongAction:YES];
    if (self.shuffleStatus == YES) {
        self.playList = self.reSortPlayList;
    }
    //get url
      
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 42.0;
}

@end
