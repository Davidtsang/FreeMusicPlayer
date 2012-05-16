//
//  FindSongsViewController.h
//  WebMusicDownload
//
//  Created by Zen David on 8/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebMusicDownloadAppDelegate.h"


@interface FindSongsViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource >
{
	NSArray *needDownFiles;
	NSMutableDictionary *selectedFiles;
	UITableView *selectFilesTable;
	//BDMP3BoxAppDelegate *appDelegate;
	UINavigationItem *navItem;
    WebMusicDownloadAppDelegate *appDelegate;

}
@property(nonatomic,retain)NSArray *needDownFiles;
@property(nonatomic,retain)NSMutableDictionary *selectedFiles;
@property(nonatomic,retain)IBOutlet UITableView *selectFilesTable;
@property(nonatomic,retain)IBOutlet UINavigationItem *navItem;

- (void)refreshData;
-(IBAction)beCancel:(id)sender;
-(IBAction)beDone:(id)sender;

@end
