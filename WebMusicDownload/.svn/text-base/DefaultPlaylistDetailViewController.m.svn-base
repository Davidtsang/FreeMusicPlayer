//
//  DefaultPlaylistDetailViewController.m
//  WebMusicDownload
//
//  Created by Zen David on 11-10-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "DefaultPlaylistDetailViewController.h"
#import "PlayList.h"
#import "NowPlayingViewController.h"

@interface DefaultPlaylistDetailViewController()
@property(nonatomic,retain)UITableView *theTableView;
-(void)initUI;
@end

@implementation DefaultPlaylistDetailViewController
@synthesize plTitle;
@synthesize thePlaylist;
@synthesize theTableView;

-(void)initUI
{
    UIView *contentView =[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view =contentView;
    contentView.backgroundColor =[UIColor whiteColor];
    //contentView.alpha =0.5;
    [contentView release];
    
    UITableView *t =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 436) style:UITableViewStylePlain];
    [t setDelegate:self];
    [t setDataSource:self];
    self.theTableView =t;
    [self.view addSubview:self.theTableView];
    [t release];
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
    [plTitle release];
    [thePlaylist release];
    [theTableView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{

    [self initUI];
    self.title = self.plTitle;
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
    self.plTitle =nil;
    self.thePlaylist = nil ;
    self.theTableView = nil;
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
//    NSInteger n;
//    if ([thePlaylist count]>1) {
//        n = [thePlaylist count]+1 ;
//    }else{
//        n =[thePlaylist count];
//    }
    return [thePlaylist count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //----------
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    
//        //--------cusetum cell
//        //playing flag
//        UIImage *shuffleImg =[UIImage imageNamed:@"shuffle_list_icon.png"];
//        CGRect shuffleRect = CGRectMake(126.0, 87.0,shuffleImg.size.width, shuffleImg.size.height);
//        UIImageView *shuffleImgView =[[UIImageView alloc] initWithImage:shuffleImg];
//        [shuffleImgView setFrame:shuffleRect];
//        shuffleImgView.tag =kShuffleImgView;
//        shuffleImgView.hidden =YES;
//        [cell.contentView addSubview:shuffleImgView];
//        [shuffleImgView release];
    }
    
    // Configure the cell...
    NSUInteger row =[indexPath row];
    
//    if ([self.thePlaylist count] >1 ) {
//        UIImageView *shuffleImg = (UIImageView *)[cell.contentView viewWithTag:kShuffleImgView];
//        if (row == 0) {
//            
//            shuffleImg.hidden =NO ;
//            cell.textLabel.text =@"Shuffle";
//            cell.detailTextLabel.text =nil;
//        }else{
//            shuffleImg.hidden = YES;
//            NSMutableDictionary *aSong = [thePlaylist objectAtIndex:row-1];
//            cell.textLabel.text =[aSong objectForKey:kSongTitle];
//            cell.detailTextLabel.text =[aSong objectForKey:kSongAlbum];
//            cell.tag =[[aSong objectForKey:kSongID] intValue];
//        }
//    }else{
        NSMutableDictionary *aSong = [thePlaylist objectAtIndex:row];
        cell.textLabel.text =[aSong objectForKey:kSongTitle];
        cell.detailTextLabel.text =[aSong objectForKey:kSongAlbum];
        cell.tag =[[aSong objectForKey:kSongID] intValue];
//    }
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
    
    //GET NOWPLAYIN REF
    NSArray* views = [self.navigationController viewControllers];
    NowPlayingViewController *nowPlayingView =(NowPlayingViewController *)[views objectAtIndex:1];
    nowPlayingView.playList = [NSMutableArray arrayWithArray:self.thePlaylist];
    nowPlayingView.currentPlayingIndex =row;
    [nowPlayingView initPlaylist];
    //SET PLAYLIST
    //SET INDEX
    //PUST TO NOWPLAYING
    [self.navigationController popToViewController:nowPlayingView animated:YES];
    [nowPlayingView updataAll];
    [nowPlayingView stdPlaySongAction:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44.0;
}


@end
