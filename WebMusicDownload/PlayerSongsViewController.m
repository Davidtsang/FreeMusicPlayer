//
//  PlayerSongsViewController.m
//  WebMusicDownload
//
//  Created by Zen David on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlayerSongsViewController.h"
#import "MyFunction.h" 
#import "MyUIProgressView.h"  
#import "SongInfoViewController.h"

@interface PlayerSongsViewController ()
-(void)editDone;
-(void)toNowPlaying:(NSString *)playListName atIndex:(NSInteger)theIndex;
@end

@implementation PlayerSongsViewController
@synthesize nowPlayingView;
@synthesize thisTableView;


@synthesize allSongItems;
//@synthesize biStopAllTasks;
@synthesize biEdit;

+ (BOOL)removeFileAtPath:(NSString *)path error:(NSError **)err
{
    NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
    
    if ([fileManager fileExistsAtPath:path]) {
        NSError *removeError = nil;
        [fileManager removeItemAtPath:path error:&removeError];
        if (removeError) {
            if (err) {
                *err = [NSError errorWithDomain:@"info.davidtsang.WebMusicDownload" code:WMDFileManagementError userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Failed to delete file at path '%@'",path],NSLocalizedDescriptionKey,removeError,NSUnderlyingErrorKey,nil]];
            }
            return NO;
        }
    }
    return YES;
}

- (BOOL)removeFile:(NSString *)path
{
	NSError *err = nil;
	if (path) {
		if (![[self class] removeFileAtPath:path error:&err]) {
			[self failWithError:err];
		}
		
	}
	return (!err);
}

- (void)failWithError:(NSError *)theError
{
    NSLog(@"ERROR:%@",[theError localizedDescription]);
}

-(void) editTasks{
    [appDelegate.downloadManage stopAllTasks];
    [self.thisTableView setEditing:YES animated:YES];
    
    UIBarButtonItem *biDone =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editDone)];
    //self.biEdit =biDone;
    self.navigationItem.leftBarButtonItem = biDone;
    [biDone release];
}
-(void)editDone{
    [self.thisTableView setEditing:NO animated:YES];
    self.navigationItem.leftBarButtonItem=self.biEdit;
}
-(void)theTaskStop:(id)sender{
    UIButton *button =(UIButton *)sender;
    UIView *cellView = button.superview;
    UILabel *_tid = (UILabel *)[cellView viewWithTag:kSongItemTID];
    NSString *tid =_tid.text;
    NSNumber *nTid =[NSNumber numberWithInteger:[tid integerValue]];
    //stop task
    [appDelegate.downloadManage  stopTask:nTid];
    
    //NSLog(@"ok!!!stop!%@",tid);
    
}
-(void)theTaskStart:(id)sender{
    UIButton *button =(UIButton *)sender;
    UIView *cellView = button.superview;
    UILabel *_tid = (UILabel *)[cellView viewWithTag:kSongItemTID];
    NSString *tid =_tid.text;
    NSNumber *nTid =[NSNumber numberWithInteger:[tid integerValue]];
    [appDelegate.downloadManage  resumeTaskFormDBS:nTid];
    //NSLog(@"ok!!!start!");
}

//removeTaskWaiting
-(void)removeTaskWaiting:(id)sender{
    UIButton *button =(UIButton *)sender;
    UIView *cellView = button.superview;
    UILabel *_tid = (UILabel *)[cellView viewWithTag:kSongItemTID];
    NSString *tid =_tid.text;
    NSNumber *nTid =[NSNumber numberWithInteger:[tid integerValue]];
    [appDelegate.downloadManage  removeWaitingFromTID:nTid];
    //NSLog(@"ok!!!romve for waiting:%@",tid);
}
-(void)toNowPlaying{
    [self toNowPlaying:nil atIndex:0];
}
-(void)toNowPlaying:(NSString *)playListName atIndex:(NSInteger)theIndex
{
    if (!self.nowPlayingView) {
        NowPlayingViewController *_nowPlayingView =[[NowPlayingViewController alloc] init];
        self.nowPlayingView  = _nowPlayingView;
        [_nowPlayingView release];
        
        
    }
    self.nowPlayingView.hidesBottomBarWhenPushed =YES;
    self.nowPlayingView.playListName =playListName;
    self.nowPlayingView.currentPlayingIndex =theIndex;
    if (playListName ==nil && theIndex ==0)
        self.nowPlayingView.isChangeToSPSong =NO;
    else
        self.nowPlayingView.isChangeToSPSong =YES;
    
    //[self.navigationController pushViewController:self.nowPlayingView animated:YES];
    [appDelegate.playerNavigation pushViewController:self.nowPlayingView animated:YES];
    
}

- (void)getAllItemsFromDBS{
    
	
	//fid,url , task_status , save_path , progress ,display_name
    NSString *sql =[NSString stringWithFormat:@"SELECT fid ,url , task_status , save_path , progress ,display_name,file_size ,album_name FROM task_list  WHERE task_status != '%@' ORDER BY fid DESC;" ,kSongStatusDeleted];
    
	FMResultSet *rs =[appDelegate.mysqlite.db executeQuery:sql];
    //NSLog(@"sql:%@",[rs query]);
    if ([appDelegate.mysqlite.db hadError]) {
        NSLog(@"- (void)getAllItemsFromDBS-> db Error :%@",[appDelegate.mysqlite.db lastErrorMessage]);
    }
    [allSongItems removeAllObjects]; 
	while ([rs next]) {
        NSInteger iFid = [rs intForColumn:@"fid"];
        NSString *taskUrl =[rs stringForColumn:@"url"];
        NSString *taskStatus =[rs stringForColumn:@"task_status"];
        NSString *taskSavePath =[rs stringForColumn:@"save_path"];
        double taskProgressValue =[rs doubleForColumn:@"progress"];
        NSString *taskName =[rs stringForColumn:@"display_name"];
        
        NSString *taskAlbumName =[rs stringForColumn:@"album_name"];
        if (!taskAlbumName) {
            taskAlbumName =@"";
        }
        //long taskSize =;
        NSNumber *nTaskSize =[[NSNumber alloc] initWithLongLong: [rs  longLongIntForColumn:@"file_size"]];
        NSMutableDictionary* SongItem = [[NSMutableDictionary alloc] init];
        [SongItem setObject:taskUrl forKey:@"url"];
        
        //NSURL* url=[NSURL URLWithString:taskUrl];
        //NSString* fileName=[url lastPathComponent];
        NSNumber* nFid =[[NSNumber alloc]initWithInteger:iFid];
        [SongItem setObject:nFid forKey:@"fid"];
        [SongItem setObject:taskName forKey:@"name"];
        [SongItem setObject:taskSavePath forKey:@"savePath"];
        [SongItem setObject:taskStatus forKey:@"status"];
        [SongItem setObject:taskAlbumName forKey:@"albumName"];
        
        NSNumber *nTaskProgressValue =[[NSNumber alloc] initWithDouble:taskProgressValue];
        [SongItem setObject:nTaskProgressValue forKey:@"progressValue"];
        
        //file size:
        [SongItem setObject:nTaskSize forKey:@"fileSize"];
        
        //[SongItem setObject:nil forKey:@"bufferingStateFlag"];
        [allSongItems addObject:SongItem ];
        
        [SongItem release];
        [nTaskProgressValue release];
        [nFid release];
        [nTaskSize release];
        
    }
	//NSString *taskUrl =[rs stringForColumn:@"url"] ;
	
	[rs close];
	//NSLog(@"task name is %@,and url is %@",[rs stringForColumn:@"url"],taskName);
    
}

-(IBAction) stopAllTasks{
    //[appDelegate.downloader cancelAllTasks];
}

-(void)updateCell:(NSNotification *)notification
{
    //    NSString *noticeName =[notification name];
    //    NSDictionary *_userInfo = [notification userInfo];
    //    NSNumber* taskID =[_userInfo objectForKey:kDownloadTaskID];
    //    NSEnumerator * enumerator =[allSongItems objectEnumerator];
    //    NSMutableDictionary *dict;
    //    while ((dict =[enumerator nextObject])) {
    //        if ([[dict objectForKey:@"fid"] isEqualToNumber:taskID]) {
    //            UILabel *lbStatus =[dict objectForKey:kSongItemRefStatus];
    //            NSString * statusNow;
    //            //HIDE PROGRESS
    //            if ([noticeName isEqualToString:kNoticeDownloadComplete]) {
    //                UIProgressView* _progress =[dict objectForKey:kSongItemRefProgress];
    //                _progress.hidden =YES;
    //                statusNow =[appDelegate.mysqlite.db stringForQuery:@"SELECT album_name  FROM task_list WHERE fid =?;",taskID];
    //                
    //                //update itemsdata
    //                [dict setObject:statusNow forKey:@"albumName"];
    //                [dict setObject:@"Complete" forKey:@"status"];
    //                
    //            }else{
    //                statusNow =[appDelegate.mysqlite.db stringForQuery:@"SELECT task_status  FROM task_list WHERE fid =?;",taskID];
    //                //update itemsdata
    //                [dict setObject:statusNow forKey:@"status"];
    //                
    //            }
    //            
    //            //GET NEW CELL VALUE
    //            
    //            //UPDATA
    //            
    //            lbStatus.text =statusNow;
    //            
    //        }
    //    }
    //    NSInteger numberOfNewItems =[appDelegate.downloadManage getActiveItemNum];
    //    if ( numberOfNewItems == 0){
    //        self.tabBarItem.badgeValue = nil;
    //        
    //    }
    //    else{        
    //        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", numberOfNewItems];
    //    }
    [self getAllItemsFromDBS];
    [thisTableView reloadData];
}


#pragma mark- Class Base
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
    
    [nowPlayingView release];
    [thisTableView release];
    
    [allSongItems release];
    //[biStopAllTasks release];
    [biEdit release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"Player", "player title");;
    // Add our custom add button as the nav bar's custom right view
    UIImage *buttonImage = [UIImage imageNamed:@"biNow-Playing.png"];
    UIButton *forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forwardButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    forwardButton.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [forwardButton addTarget:self action:@selector(toNowPlaying) 
            forControlEvents:UIControlEventTouchUpInside];
	
    UIBarButtonItem *biNowPlaying = [[UIBarButtonItem alloc] 
                                     initWithCustomView:forwardButton];
    self.navigationItem.rightBarButtonItem = biNowPlaying;	
    [biNowPlaying release];
    
    //初始化应用程序委托
	appDelegate =(WebMusicDownloadAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //get cell items:
    self.allSongItems =[NSMutableArray array];
    
    
    //EDIT BUTTON
    UIBarButtonItem *_biEdit =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTasks)];
    //self.biEdit =biDone;
    self.biEdit =_biEdit;
    self.navigationItem.leftBarButtonItem = self.biEdit;
    [_biEdit release];
    
    [[NSNotificationCenter defaultCenter]  
     addObserver:self  
     selector:@selector(updateCell:)  
     name:kNoticeDownloadUpdate 
     object:nil]; 
    
    [[NSNotificationCenter defaultCenter]  
     addObserver:self  
     selector:@selector(updateCell:)  
     name:kNoticeDownloadStart 
     object:nil]; 
    
    [[NSNotificationCenter defaultCenter]  
     addObserver:self  
     selector:@selector(updateCell:)  
     name:kNoticeDownloadRemoveWaiting
     object:nil]; 
    
    [[NSNotificationCenter defaultCenter]  
     addObserver:self  
     selector:@selector(updateCell:)  
     name:kNoticeDownloadAddWaiting
     object:nil]; 
    
    [[NSNotificationCenter defaultCenter]  
     addObserver:self  
     selector:@selector(updateCell:)  
     name:kNoticeNowPlayingChange
     object:nil]; 
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    //[self makeAllItemsData];
    //[thisTableView reloadData];
    [self getAllItemsFromDBS];
    [thisTableView reloadData];
    
}
- (void)viewDidUnload
{
    self.nowPlayingView =nil ;
    self.thisTableView =nil;
    
    
    self.allSongItems =nil;
    //self.biStopAllTasks =nil;
    self.biEdit=nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    return [allSongItems count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        //draw cell
        //name label
        CGRect nameLabelRect = CGRectMake(8, 4,260, 20);
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameLabelRect ];
        nameLabel.textAlignment =UITextAlignmentLeft ;
        nameLabel.tag = kSongItemName;
        nameLabel.font = [UIFont boldSystemFontOfSize:18];
        //nameLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:18];
        [cell.contentView addSubview:nameLabel];
        [nameLabel release];
        
        //url lable
        CGRect URILabelRect = CGRectMake(8, 26, 260, 12);
        UILabel *URILabel = [[UILabel alloc] initWithFrame:URILabelRect ];
        URILabel.textAlignment =UITextAlignmentLeft ;
        URILabel.tag = kSongItemUrl;
        //URILabel.font = [UIFont fontWithName:@"TrebuchetMS" size:12];
        URILabel.font =[UIFont systemFontOfSize:12];
        
        [cell.contentView addSubview:URILabel];
        [URILabel release];
        
        //TID lable
        CGRect TIDLabelRect = CGRectMake(0, 0, 100, 10);
        UILabel *TIDLabel = [[UILabel alloc] initWithFrame:TIDLabelRect ];
        TIDLabel.textAlignment =UITextAlignmentLeft ;
        TIDLabel.tag = kSongItemTID;
        TIDLabel.font =[UIFont systemFontOfSize:8];
        [cell.contentView addSubview:TIDLabel];
        [TIDLabel release];
        
        //stop/start button
        CGRect theButtonRect = CGRectMake(276,9, 44, 44);
        //UILabel *albumNameLabel = [[UILabel alloc] initWithFrame:theButtonRect ];
        UIButton *theButton =[[UIButton alloc] initWithFrame:theButtonRect];
        //[theButton setImage:[UIImage imageNamed:@"btDownloadStop.png"] forState:UIControlStateNormal];
        //[theButton addTarget:self action:@selector(theTaskStop:) forControlEvents:UIControlEventTouchUpInside];
        
        theButton.tag =kSongItemButtonStop;
        [cell.contentView addSubview:theButton];
        [theButton release];
        
        //status label
        CGRect statusLabelRect = CGRectMake(8, 40, 260, 16);
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:statusLabelRect ];
        statusLabel.textAlignment =UITextAlignmentLeft ;
        statusLabel.tag = kSongItemStatus;
        //statusLabel.font =   [UIFont fontWithName:@"TrebuchetMS" size:14];
        statusLabel.font =[UIFont systemFontOfSize:14];
        statusLabel.textColor =[UIColor grayColor];
        [cell.contentView addSubview:statusLabel];
        [statusLabel release];
        
        
        CGRect progressViewRect = CGRectMake(88, 44, 180,16);
        MyUIProgressView *progressView = [[MyUIProgressView alloc] initWithFrame:progressViewRect ];
        progressView.tag = kSongItemProgress;
        [cell.contentView addSubview:progressView];
        [progressView release];
        
        
        //nowPlayingIndicator
        UIImage *nowPlayingIndicatorImg =[UIImage imageNamed:@"littleSpeaker.png"];
        CGRect nowPlayingIndicatorRect =CGRectMake(264, 25, nowPlayingIndicatorImg.size.width, nowPlayingIndicatorImg.size.height);
        UIImageView *nowPlayingIndicatorImgView =[[UIImageView alloc] initWithImage:nowPlayingIndicatorImg];
        [nowPlayingIndicatorImgView setFrame:nowPlayingIndicatorRect];
        nowPlayingIndicatorImgView.tag = kSongItemIndicator ;
        [cell.contentView addSubview:nowPlayingIndicatorImgView];
        [nowPlayingIndicatorImgView release];
        
        
    }
    
    // Configure the cell...
    NSUInteger row =[indexPath row];
 	NSMutableDictionary *rowData =[self.allSongItems objectAtIndex:row];
    
    NSNumber *theTaskID = [rowData objectForKey:@"fid"];
    NSString *theTaskName = [rowData objectForKey:@"name"];
    //task status
    NSString *theTaskStatus =[rowData objectForKey:@"status"];
    
    //THE TID
    UILabel *_TID = (UILabel *)[cell.contentView viewWithTag:kSongItemTID];
    _TID.text = [theTaskID stringValue];
    _TID.hidden =YES;
    
    //progress
    
    //nowPlayingIndicator
    UILabel *_status = (UILabel *)[cell.contentView viewWithTag:kSongItemStatus];
    
    UIImageView *nowPlayingIndicator =(UIImageView *)[cell.contentView viewWithTag:kSongItemIndicator];
    nowPlayingIndicator.hidden =YES;
    if (appDelegate.nowPlayingSongID == [theTaskID integerValue]) {
        nowPlayingIndicator.hidden =NO ;
    }
    
    MyUIProgressView* _progress =(MyUIProgressView *)[cell.contentView viewWithTag:kSongItemProgress];
    if (![theTaskStatus isEqualToString:@"Complete"]) {
        _progress.hidden =NO;
        Download *thisActiveDownload =  [appDelegate.downloadManage.downloadItems objectForKey:theTaskID];
        if(thisActiveDownload){
            
            DownloadProgressView *downloadProgress = [thisActiveDownload.taskItem objectForKey:kDownloadTaskProgressIndicator];
            [downloadProgress setDelegate:_progress];
            NSNumber *nProgressValue =[rowData objectForKey:@"progressValue"];
            [_progress setProgress:[nProgressValue doubleValue]];
            
            _progress.userInfo =[NSDictionary dictionaryWithObjectsAndKeys:theTaskID,kDownloadTaskID, nil];
            
            //change status
            //[rowData setObject:kDownloadStatusBuffering forKey:@"status"];
            theTaskStatus =kDownloadStatusBuffering;
            //NSLog(@"show progress:tid ->%@,name->%@",theTaskID,theTaskName);
        }else//test waiting status
            if ([appDelegate.downloadManage testWatingStatus:theTaskID]) {
                theTaskStatus =kDownloadStatusWaiting;
            }
        cell.accessoryType =UITableViewCellAccessoryNone;
    }else{
        theTaskStatus =[rowData objectForKey:@"albumName"] ;
        _progress.hidden =YES;
        cell.accessoryType =UITableViewCellAccessoryDetailDisclosureButton;
    }
    //[rowData setObject:_progress forKey:kSongItemRefProgress];
    _status.text =  theTaskStatus ;
    
    
    //the button
    UIButton *_theButton = (UIButton *)[cell.contentView viewWithTag:kSongItemButtonStop];
    _theButton.hidden =NO;
    if ([theTaskStatus isEqualToString:kDownloadStatusBuffering]) {
        [_theButton setImage:[UIImage imageNamed:@"btDownloadStop.png"] forState:UIControlStateNormal];
        [_theButton addTarget:self action:@selector(theTaskStop:) forControlEvents:UIControlEventTouchUpInside];
    }else if([theTaskStatus isEqualToString:kDownloadStatusError] || [theTaskStatus isEqualToString:kDownloadStatusStop]){
        [_theButton setImage:[UIImage imageNamed:@"btDownloadStart.png"] forState:UIControlStateNormal];
        [_theButton addTarget:self action:@selector(theTaskStart:) forControlEvents:UIControlEventTouchUpInside ];
    }else if ([theTaskStatus isEqualToString:kDownloadStatusWaiting]) {
        [_theButton setImage:[UIImage imageNamed:@"btDownloadStop.png"] forState:UIControlStateNormal];
        [_theButton addTarget:self action:@selector(removeTaskWaiting:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        _theButton.hidden =YES;
    }
    //name
    UILabel *_name = (UILabel *)[cell.contentView viewWithTag:kSongItemName];
    _name.text = theTaskName;
    
    //url
    NSNumber *_fileSize =  [rowData objectForKey:@"fileSize"] ;
    NSString *fileSizeFormat =[MyFunction stringFromFileSize:[_fileSize integerValue]];
    NSString *theURLString =[rowData objectForKey:@"url"];
    
    NSURL *theURL =[NSURL URLWithString:theURLString] ;
    
    UILabel *_url = (UILabel *)[cell.contentView viewWithTag:kSongItemUrl];
    _url.text =  [NSString stringWithFormat:@"%@ - %@",fileSizeFormat,theURL.host] ;
    
    //    UILabel *_albumName = (UILabel *)[cell.contentView viewWithTag:kSongItemAlbumName];
    //    _albumName.text =  [rowData objectForKey:@"albumName"] ; 
    
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row =[indexPath row];
    //get fid
    NSMutableDictionary *rowData =[self.allSongItems objectAtIndex:row];
    NSInteger iTid =[[rowData objectForKey:@"fid"] integerValue];
    SongInfoViewController *songInfoViewController =[[SongInfoViewController alloc] initWithNibName:@"SongInfoView" bundle:nil];
    songInfoViewController.songID =iTid;
    [self.navigationController pushViewController:songInfoViewController animated:YES];
    [songInfoViewController release];
    
    
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
    
    NSMutableDictionary *rowData =[self.allSongItems objectAtIndex:row];
    
    NSNumber *theTaskID = [rowData objectForKey:@"fid"];
    //is complete?
    NSString *completeStatus =[appDelegate.mysqlite.db stringForQuery:@"SELECT task_status FROM task_list WHERE fid =?", theTaskID];
    if ([completeStatus isEqualToString:kDownloadStatusComplete]) {
        //if yes,then play this song
        [self toNowPlaying:kPlayListDefault atIndex:row];
    }
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //del file
    //i .get fid
    //indexPath.row
    NSMutableDictionary *rowData =[self.allSongItems objectAtIndex:indexPath.row];
    NSNumber *tid =[rowData objectForKey:@"fid"];
    
    //stop task
    //[appDelegate.downloadManage stopTask:tid];
    //content dbs getinfo
    NSString *sql =[NSString stringWithFormat:@"SELECT save_path FROM task_list WHERE fid = %d;",[tid integerValue]];
    NSString *savePath =[appDelegate.mysqlite.db stringForQuery:sql];
    
    NSString *tempSavePath =[NSString stringWithFormat:@"%@.temp" ,savePath];
    //del path
    if ( [self removeFile:savePath]){
        //updata dbs status dele 
        [self removeFile:tempSavePath];
    }
    sql =[NSString stringWithFormat:@"UPDATE task_list SET task_status='%@' WHERE fid = %d;",
          
          kSongStatusDeleted,
          [tid integerValue]];
    [appDelegate.mysqlite.db executeUpdate:sql];
    
    if ([appDelegate.mysqlite.db hadError]) {
        NSLog(@"-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath ->db Error :%@",[appDelegate.mysqlite.db lastErrorMessage]);
    }
    NSLog(@"del a song!");
    
    
    [self updateCell:nil];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 62.0;
}


@end
