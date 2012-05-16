//
//  WebMusicDownloadAppDelegate.m
//  WebMusicDownload
//
//  Created by Zen David on 8/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WebMusicDownloadAppDelegate.h"
#import "MacAddress.h"



@implementation WebMusicDownloadAppDelegate


@synthesize window=_window;

@synthesize tabBarController=_tabBarController;

@synthesize playerNavigation;

@synthesize  mysqlite;
//test:
//@synthesize activeDownloadItems;
@synthesize downloadManage;
@synthesize isAllowUpdateSongInfo;
@synthesize localIP;
@synthesize nowPlayingSongID;
@synthesize deviceLang;
//--------------------
-(void) loadUserSettings
{
    NSUserDefaults *defalults =[NSUserDefaults standardUserDefaults];
    self.isAllowUpdateSongInfo =[[defalults objectForKey:kUploadMusicInfoSetting] boolValue];
    
}

- (NSString *)deviceIPAdress {
    char* macAddressString= (char*)malloc(18);
    NSString* macAddress= [[[NSString alloc] initWithCString:getMacAddress(macAddressString,"en0")                                                encoding:NSMacOSRomanStringEncoding] autorelease];
    return macAddress;
}

//test:
- (void)addURLDownload:(NSString *)URLString
{
 
 
    [downloadManage addURLtoDownload:URLString];

}
- (void)addURLsDownload:(NSMutableArray *)URLStrings
{
 
    
    
    NSEnumerator *element =[URLStrings objectEnumerator];
    NSString* oneURL;
    while ((oneURL =[element nextObject])) {
        [downloadManage addURLtoDownload:oneURL];
    }

}

#pragma mark- App Base
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the tab bar controller's current view as a subview of the window
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    //[[[UIApplication sharedApplication] keyWindow] addSubview:self.tabBarController.view];

    //init db
	MySqlite *_mysqlite =[[MySqlite alloc] init];
    self.mysqlite =_mysqlite;
    [self.mysqlite openDB];
    [_mysqlite release];
    
    [self loadUserSettings];
    //download manege
    if (!self.downloadManage) {
        DownloadManage *_downloadManage =[[DownloadManage alloc] init];
        self.downloadManage =_downloadManage;
        self.downloadManage.taskLimit = kDownloadThreadLimit;
        [_downloadManage release];
        
    }
    
    //IP
    self.localIP = [self deviceIPAdress];
    //NSLog(@"self.ip is %@",self.localIP);
    
    //get user lang
    NSString *currentLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    //NSLog(@"user lang:%@",currentLanguage);
    self.deviceLang = currentLanguage;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [downloadManage pauseAllTasks];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoticeAppWillTerminate object:nil userInfo:nil];
    
    NSLog(@"APP WillResignActive!");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    NSLog(@"APP DidEnterBackground!");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    NSLog(@"APP WillEnterForeground!");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [downloadManage resumePausedTasks];
    NSLog(@"APP DidBecomeActive!");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [self.mysqlite.db close];
    NSLog(@"APP WillTerminate!");
}

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    
    //test:
    //[downloader release];
    
    [playerNavigation release];
    [mysqlite release];
    
    //[activeDownloadItems release];
    [downloadManage release];
    [deviceLang release];
    
    [super dealloc];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
