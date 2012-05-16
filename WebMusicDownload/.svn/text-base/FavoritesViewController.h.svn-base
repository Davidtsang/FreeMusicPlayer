//
//  FavoritesViewController.h
//  WebMusicDownload
//
//  Created by Zen David on 8/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Favorites.h"

//delegate
@interface NSObject (FavoritesViewController)

- (void)doBookmarksNav:(NSString*)url;
// etc...

@end

@interface FavoritesViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *thisTableView;
    NSMutableDictionary *favoritesDict;
    NSMutableArray *favoriteTitles;
    UINavigationItem *navBarItem;
    Favorites* favorites;
    
    id delegate;
    
}
@property (nonatomic, retain) IBOutlet UITableView *thisTableView;
@property (nonatomic, retain) NSMutableDictionary *favoritesDict;
@property (nonatomic, retain) NSMutableArray *favoriteTitles;
@property (nonatomic, retain) IBOutlet UINavigationItem *navBarItem;
@property (nonatomic, retain) Favorites* favorites;

- (IBAction)actEdit:(id)sender;
- (void)actDone:(id)sender;
- (void)getBookmakrsDate;

- (void)setDelegate:(id)aDelegate;//delegate
- (void)navToAddress:(NSString*)url;//delegate
- (id)delegate;



@end
