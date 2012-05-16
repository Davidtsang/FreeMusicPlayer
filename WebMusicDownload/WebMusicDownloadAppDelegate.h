
//  WebMusicDownloadAppDelegate.h
//  WebMusicDownload
//
//  Created by Zen David on 8/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//test:
#import "DownloadManage.h"
#import "MySqlite.h"

#define PrayerToJesusLord @"仁慈的救主耶稣基督，求你让我能用这个APP赚300万美金，求你这个APP平平安安，求你让你的儿女不至于缺乏，能在众人面前为你做见证，做盐做光，让我因此能可以移居到基督徒居住的国家，因此可以开展自己的事业，求你成就你的旨意。求你让这个APP运行完美，用你的大能的手托住它。求你赦免我一切所有的罪及不义。主求你赐给我们所需的，因为你说凡是祈求的就得到。也求你赐予我们家人让他们都健康平安。以上这一切的祷告都是奉我主耶稣基督得胜的名求！阿门！"
#define kUnfinishTaskItemData @"unfinishTaskItemData"
#define kStatusBufferingItems @"statusBufferingItems" 
#define kStatusWaitingStartItem @"statusWaitingStartItem" 
#define kStatusErrorItems @"statusErrorItems" 
#define kNoticeAppWillTerminate @"AppWillTerminate"
#define kDownloadThreadLimit 3
#define kNoticeNowPlayingChange @"nowPlayingChange"
#define kUploadMusicInfoSetting @"UploadMusicInfoSetting"

@interface WebMusicDownloadAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {

    //test:
    //Downloader* downloader;
    
    UINavigationController *playerNavigation;
    
    MySqlite* mysqlite;
    //NSMutableDictionary* activeDownloadItems;
    DownloadManage* downloadManage;
    BOOL isAllowUpdateSongInfo;
    NSString *localIP;

    NSInteger nowPlayingSongID;
    NSString *deviceLang;
    
}
@property (nonatomic, assign) NSInteger nowPlayingSongID;

@property (nonatomic, retain) NSString *localIP;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

//@property(nonatomic,retain)Downloader* downloader;

@property(nonatomic,retain) IBOutlet UINavigationController *playerNavigation;

@property(nonatomic,retain) MySqlite* mysqlite;
//@property(nonatomic,retain) NSMutableDictionary* activeDownloadItems;
@property(nonatomic,retain)DownloadManage* downloadManage;

@property(nonatomic,assign) BOOL isAllowUpdateSongInfo;
@property (nonatomic, retain) NSString *deviceLang;

- (void)addURLDownload:(NSString *)URLString;
- (void)addURLsDownload:(NSMutableArray *)URLStrings;
- (NSString *)deviceIPAdress;
-(void) loadUserSettings;
@end
