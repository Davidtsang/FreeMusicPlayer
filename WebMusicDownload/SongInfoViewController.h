//
//  SongInfoViewController.h
//  WebMusicDownload
//
//  Created by Zen David on 11-8-31.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebMusicDownloadAppDelegate.h"

#define kEditAlartTextField 301



@interface SongInfoViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate>
{
    UITableView *thisTableView;
    NSMutableArray *songInfo;
    WebMusicDownloadAppDelegate *appDelegate;
    NSInteger songID;
    BOOL isShowAlert;
    UIAlertView *editAlertView;
    NSString *editAlertTitle;
    
}
@property(nonatomic,retain) IBOutlet UITableView *thisTableView;
@property(nonatomic,retain) NSMutableArray *songInfo;
@property(nonatomic,assign) NSInteger songID;

@end
