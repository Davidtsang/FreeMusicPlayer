//
//  PeopleViewController.h
//  WebMusicDownload
//
//  Created by Zen David on 11-10-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebMusicDownloadAppDelegate.h"
//#import "FindSongsViewController.h"

#define kPeopleHomeURL @"http://fwmp.iphonebestapp.com/people/"

static const CGFloat kNavBarHeight = 52.0f;
//static const CGFloat kDownloadsItemWidth = 30.0f;

static const CGFloat kLabelHeight = 14.0f;
static const CGFloat kMargin = 8.0f;
static const CGFloat kSpacer = 2.0f;
static const CGFloat kLabelFontSize = 12.0f;
static const CGFloat kAddressHeight = 26.0f;

@interface PeopleViewController : UIViewController
<UIWebViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    WebMusicDownloadAppDelegate *appDelegate;
    UIWebView* mWebView;
    UIToolbar* mToolbar;
    UIBarButtonItem* mBack;
    UIBarButtonItem* mForward;
    UIBarButtonItem* mRefresh;
    //    UIBarButtonItem* mStop;
    //UIBarButtonItem* bDownloads;
    
    UILabel* mPageTitle;
    UITextField* mAddressField;
    //Favorites *favorites;
    //FavoritesViewController *favoritesView;
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
@property (nonatomic, retain) UILabel* pageTitle;
@property (nonatomic, retain) UITextField* addressField;
//@property (nonatomic, retain) Favorites *favorites;
//@property (nonatomic, retain) FavoritesViewController *favoritesView;
@property (nonatomic, retain) NSArray* needDownFiles;
@property (nonatomic, retain) NSString *sheetSelectTempURL;
//@property (nonatomic, retain) FindSongsViewController *findSongsView;
@property (nonatomic, assign) BOOL networkActivityIndicatorBusy;

- (void)loadAddress:(id)sender event:(UIEvent*)event;
//- (void)updateTitle:(UIWebView*)aWebView;
//- (void)updateAddress:(NSURLRequest*)request;
- (void)informError:(NSError*)error;

- (void)aReload:(id)sender;
//- (IBAction)addToFavorites:(id)sender;
//- (IBAction)actFavorites:(id)sender;
//- (void)doBookmarksNav:(NSString*)url;//delegate
-(BOOL)testURL:(NSString *)urlStirng;
-(void)navToURL:(NSString *)urlString;
//- (IBAction)showFoundSongs:(id)sender;
-(IBAction)gotoHome:(id)sender;
//-(BOOL)testURLExistInItems:(NSString *)URLName withItems:(NSMutableArray *)theItems;

@end
