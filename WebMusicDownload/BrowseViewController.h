//
//  BrowseViewController.h
//  WebMusicDownload
//
//  Created by Zen David on 8/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Favorites.h"
#import "FavoritesViewController.h"
#import "WebMusicDownloadAppDelegate.h"
//#import "FindSongsViewController.h"

#define kAppHome @"http://fwmp.iphonebestapp.com/startpage/index.php"

static const CGFloat kNavBarHeight = 52.0f;
//static const CGFloat kDownloadsItemWidth = 30.0f;

static const CGFloat kLabelHeight = 14.0f;
static const CGFloat kMargin = 8.0f;
static const CGFloat kSpacer = 2.0f;
static const CGFloat kLabelFontSize = 12.0f;
static const CGFloat kAddressHeight = 26.0f;

@interface BrowseViewController : UIViewController 
<UIWebViewDelegate,UIActionSheetDelegate>{
    WebMusicDownloadAppDelegate *appDelegate;
    UIWebView* mWebView;
    UIToolbar* mToolbar;
    UIBarButtonItem* mBack;
    UIBarButtonItem* mForward;
    UIBarButtonItem* mRefresh;
//    UIBarButtonItem* mStop;
    //UIBarButtonItem* bDownloads;
    UIBarButtonItem* addToFavorites;
    
    UILabel* mPageTitle;
    UITextField* mAddressField;
    Favorites *favorites;
    FavoritesViewController *favoritesView;
    NSArray* needDownFiles;
    NSString *sheetSelectTempURL;
    //FindSongsViewController *findSongsView;
    BOOL networkActivityIndicatorBusy;
}
@property (nonatomic, retain) IBOutlet UIWebView* webView;
@property (nonatomic, retain) IBOutlet UIToolbar* toolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* back;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* forward;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* refresh;
//@property (nonatomic, retain) IBOutlet UIBarButtonItem* bDownloads;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* addToFavorites;
@property (nonatomic, retain) UILabel* pageTitle;
@property (nonatomic, retain) UITextField* addressField;
@property (nonatomic, retain) Favorites *favorites;
@property (nonatomic, retain) FavoritesViewController *favoritesView;
@property (nonatomic, retain) NSArray* needDownFiles;
@property (nonatomic, retain) NSString *sheetSelectTempURL;
//@property (nonatomic, retain) FindSongsViewController *findSongsView;
@property (nonatomic, assign) BOOL networkActivityIndicatorBusy;

- (void)loadAddress:(id)sender event:(UIEvent*)event;
- (void)updateTitle:(UIWebView*)aWebView;
- (void)updateAddress:(NSURLRequest*)request;
- (void)informError:(NSError*)error;

- (void)aReload:(id)sender;
- (IBAction)addToFavorites:(id)sender;
- (IBAction)actFavorites:(id)sender;
- (void)doBookmarksNav:(NSString*)url;//delegate
-(BOOL)testURL:(NSString *)urlStirng;
-(void)navToURL:(NSString *)urlString;
//- (IBAction)showFoundSongs:(id)sender;
//-(BOOL)testURLExistInItems:(NSString *)URLName withItems:(NSMutableArray *)theItems;
@end
