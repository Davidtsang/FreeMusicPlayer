//
//  BrowseViewController.m
//  WebMusicDownload
//
//  Created by Zen David on 8/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BrowseViewController.h"

@interface BrowseViewController()
-(void)disableSomeUIFace;
-(void)enableSomeUIFace;
@end

@implementation BrowseViewController
@synthesize webView = mWebView;
@synthesize toolbar = mToolbar;
@synthesize back = mBack;
@synthesize forward = mForward;
@synthesize refresh = mRefresh;
//@synthesize bDownloads;
@synthesize pageTitle = mPageTitle;
@synthesize addressField = mAddressField;
@synthesize favorites;
@synthesize favoritesView;
@synthesize needDownFiles;
@synthesize sheetSelectTempURL;
//@synthesize findSongsView;
@synthesize  networkActivityIndicatorBusy;
@synthesize addToFavorites;

-(void)enableSomeUIFace
{
    [addToFavorites setEnabled:YES];
}
-(void)disableSomeUIFace
{
    [addToFavorites setEnabled:NO];
}
- (void)updateButtons
{
    self.forward.enabled = self.webView.canGoForward;
    self.back.enabled = self.webView.canGoBack;
    //self.stop.enabled = self.webView.loading;
}

- (void)loadAddress:(id)sender event:(UIEvent *)event
{
    NSString* urlString = self.addressField.text;
    NSURL* url = [NSURL URLWithString:urlString];
    if(!url.scheme)
    {
        NSString* modifiedURLString = [NSString stringWithFormat:@"http://%@", urlString];
        url = [NSURL URLWithString:modifiedURLString];
    }
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)updateTitle:(UIWebView*)aWebView
{
    NSString* pageTitle = [aWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.pageTitle.text = pageTitle;
}

- (void)updateAddress:(NSURLRequest*)request
{
    NSURL* url = [request mainDocumentURL];
    NSString* absoluteString = [url absoluteString];
  
    self.addressField.text = absoluteString;
}

- (void)informError:(NSError *)error
{
    NSString* localizedDescription = [error localizedDescription];
    //NSLog(@"net error:%@ code:%d",localizedDescription ,[error code]);
    if ([error code] == kCFURLErrorNotConnectedToInternet || [error code] == kCFURLErrorNetworkConnectionLost) {
       
        //disable user interface
        [self disableSomeUIFace];
        //notice user
        UIAlertView* alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:localizedDescription delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }

}

- (void)aReload:(id)sender
{
    [self.webView reload];
}

- (IBAction)addToFavorites:(id)sender
{

    [self.favorites saveFavorite:self.addressField.text title:self.pageTitle.text];
    //notice user
    UIAlertView* alertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Success", @"")
                              message:NSLocalizedString(@"Current page is bookmaked!", @"") delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    
    
}

- (IBAction)actFavorites:(id)sender{
    //init fa
    if (self.favoritesView ==nil) {
        FavoritesViewController *_favoView = [[FavoritesViewController alloc] initWithNibName:@"FavoritesView" bundle:nil];
        self.favoritesView =_favoView;
        [_favoView release];
        //NSLog(@"new favoritesView");
     
    }
     
    [self.favoritesView.view setFrame:CGRectMake(0,480.0f, 320.0f, 460.0f)];
    [self.favoritesView getBookmakrsDate];
    [self.favoritesView.thisTableView reloadData];
    [self.favoritesView setDelegate:self];
    [self.tabBarController.view addSubview:self.favoritesView.view];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35];
    [self.favoritesView.view setFrame:CGRectMake(0,20.0f, 320.0f, 460.0f)];
    [UIView commitAnimations];
}

- (void)doBookmarksNav:(NSString*)url
{
        //remove for spuerview
    if (self.favoritesView.view.subviews) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.35];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(removeBookmarksSuperView)];
        [self.favoritesView.view setFrame:CGRectMake(0,480.0f, 320.0f, 460.0f)];
        [UIView commitAnimations];
    }
        //nav to address;
    NSURL* _url = [NSURL URLWithString:url];
    NSURLRequest* request = [NSURLRequest requestWithURL:_url];
    [self.webView loadRequest:request];
}
-(void)removeBookmarksSuperView{
    [self.favoritesView.view removeFromSuperview];
}

-(BOOL)testURL:(NSString *)urlStirng{

    //.mp3
    NSString *lastAlpha = [[urlStirng substringFromIndex:[urlStirng length] - 4] lowercaseString];
    
    //NSLog(@"sub string is %@", ssub);
    if ([lastAlpha isEqualToString:@".mp3"]  ) {
        return YES;
    }
    //aac
    if ([lastAlpha isEqualToString:@".aac"]  ) {
        return YES;
    }
    
    //m4a
    if ([lastAlpha isEqualToString:@".m4a"]  ) {
        return YES;
    }
    //---BAIDU MP3:  .mp3?
    BOOL foundString = ([urlStirng rangeOfString:@".mp3?" options:NSCaseInsensitiveSearch].location != NSNotFound);
  	if (foundString) {
        return YES;
    }
    
	
    return NO;
}

//-(NSArray *)findMusicFiles:(NSString *)docHtml
//{
//	NSMutableArray *resuleMusicFiles = [NSMutableArray array];
//	
//	// find mp3s
//	NSError *error = NULL;
//	//@"href=\"(http://\\S*?\\.mp3)\""
//	//<a href="http://tuanwei.hebeu.edu.cn/ceo/upfile/multimedia/4.mp3" id="org-a" onmousedown="img(this.href, 0);">http://tuanwei.hebeu.edu.cn/...dia/4.mp3</a>
//	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"href=\"(http://\\S*?\\.mp3)\".+?>(.*?)</a>"
//																		   options:NSRegularExpressionCaseInsensitive
//																			 error:&error];
//	NSArray *matches = [regex matchesInString:docHtml
//									  options:0
//										range:NSMakeRange(0, [docHtml length])];
//	NSInteger matchesNum =[matches count];
//	//NSLog(@"matche len is :%d",matchesNum);
//	if (matchesNum > 0) {
//		for (NSTextCheckingResult *match in matches) {
//			//NSRange matchRange = [match range];
//			
//			NSAssert(match.numberOfRanges > 0 ,@"BAD MP3 URL!");
//			NSRange subFileUrlRange =[match rangeAtIndex:1];
//			NSRange urlNameRange =[match rangeAtIndex:2];
//			
//			NSArray *musicFileItem =[[NSArray alloc] initWithObjects:
//									 [docHtml substringWithRange:urlNameRange], 
//									 [docHtml substringWithRange:subFileUrlRange],
//									 nil
//									 ];
//			
//            if ([self testURLExistInItems:[docHtml substringWithRange:subFileUrlRange] withItems:resuleMusicFiles] == NO) {
//                [resuleMusicFiles addObject:musicFileItem];
//            }
//
//			[musicFileItem release];
//		}
//		
//	}//END IF
//	return resuleMusicFiles;
//	
//}//end fun
//-(BOOL)testURLExistInItems:(NSString *)URLName withItems:(NSMutableArray *)theItems
//{
//    NSEnumerator *elemantor =[theItems objectEnumerator];
//    NSArray *_musicFileItem;
//    BOOL itemExist =NO;
//    while ((_musicFileItem =[elemantor nextObject])) {
//        if ([[_musicFileItem objectAtIndex:1] isEqualToString:URLName]) {
//            itemExist =YES;
//        }
//    }
//    return itemExist;
//}

- (void)popDownloadSheet:(NSString *)urlString
{
    self.sheetSelectTempURL =urlString;
    NSString *sheetTitleHeader = NSLocalizedString(@"Select action for the link:", "");
    NSString *sheetTitle =[NSString stringWithFormat:@"%@ %@",sheetTitleHeader,urlString];

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Download", ""),NSLocalizedString(@"Follow the Link", ""),nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    [actionSheet release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0){
       //NSLog(@"ok!add a url");

        [appDelegate addURLDownload:self.sheetSelectTempURL];
        self.sheetSelectTempURL =nil;
    }
    if(buttonIndex == 1)
    {
        [self navToURL:self.sheetSelectTempURL];
    }
    //test
    if (buttonIndex ==2) {
        self.sheetSelectTempURL =nil;
    }
}

-(void)navToURL:(NSString *)urlString
{
    NSURL* _url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:_url];
    [self.webView loadRequest:request];
}

//- (IBAction)showFoundSongs:(id)sender{
//    if (self.findSongsView ==nil) {
//        FindSongsViewController *_findSongsView = [[FindSongsViewController alloc] initWithNibName:@"FindSongs" bundle:nil];
//        self.findSongsView =_findSongsView;
//        [_findSongsView release];
//        //NSLog(@"new favoritesView");
//        
//    }
//    self.findSongsView.needDownFiles =self.needDownFiles;
//    
//    [self.findSongsView.view setFrame:CGRectMake(0,480.0f, 320.0f, 460.0f)];
//    [self.tabBarController.view addSubview:self.findSongsView.view];
//    [findSongsView refreshData];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.35];
//    [self.findSongsView.view setFrame:CGRectMake(0,20.0f, 320.0f, 460.0f)];
//    [UIView commitAnimations];
//    
//}
#pragma mark -  Class base
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
    [mWebView release];
    [mToolbar release];
    [mBack release];
    [mForward release];
    [mRefresh release];
    //[bDownloads release];
    [mPageTitle release];
    [mAddressField release];
    [favorites release];
    [favoritesView release];
    [needDownFiles release];
    [sheetSelectTempURL release];
    //[findSongsView release];
    [addToFavorites release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化应用程序委托
	appDelegate =(WebMusicDownloadAppDelegate *)[[UIApplication sharedApplication] delegate];
    //ADD NAV BAR
    CGRect navBarFrame = self.view.bounds;
    navBarFrame.size.height = kNavBarHeight;
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:navBarFrame];
    navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
   
    //ADD NAV TITLE
    CGRect labelFrame = CGRectMake(kMargin, kSpacer,
                                   navBar.bounds.size.width - 2*kMargin, kLabelHeight);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = UITextAlignmentCenter;
    [navBar addSubview:label];
    self.pageTitle = label;
    [label release];
    
    CGRect addressFrame = CGRectMake(kMargin, kSpacer*2.0 + kLabelHeight,
                                     labelFrame.size.width, kAddressHeight);
    UITextField *address = [[UITextField alloc] initWithFrame:addressFrame];
    address.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    address.borderStyle = UITextBorderStyleRoundedRect;
    address.font = [UIFont systemFontOfSize:16];
    address.keyboardType = UIKeyboardTypeURL;
    address.autocapitalizationType = UITextAutocapitalizationTypeNone;
    address.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [address addTarget:self
                action:@selector(loadAddress:event:)
      forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [navBar addSubview:address];
    self.addressField = address;
    [address release];
    
    [self.view addSubview:navBar];
    [navBar release];
    
    CGRect webViewFrame = self.webView.frame;
    webViewFrame.origin.y = navBarFrame.origin.y + navBarFrame.size.height;
    webViewFrame.size.height = self.toolbar.frame.origin.y - webViewFrame.origin.y;
    self.webView.frame = webViewFrame;
    
    NSAssert(self.back, @"Unconnected IBOutlet 'back'");
    NSAssert(self.forward, @"Unconnected IBOutlet 'forward'");
    NSAssert(self.refresh, @"Unconnected IBOutlet 'refresh'");
    //NSAssert(self.stop, @"Unconnected IBOutlet 'stop'");
    NSAssert(self.webView, @"Unconnected IBOutlet 'webView'");
    
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    NSString *currentLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *appHomeAddress = [NSString stringWithFormat:@"%@?lang=%@",kAppHome,currentLanguage];
    NSURL* url = [NSURL URLWithString:appHomeAddress];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self updateButtons];
    
    Favorites *f_ = [[Favorites alloc] init];
    self.favorites =f_;
    [f_ release];
    
    
    
    
}


- (void)viewDidUnload
{
    self.webView = nil;
    self.toolbar = nil;
    self.back = nil;
    self.forward = nil;
    self.refresh = nil;
    //self.bDownloads = nil;
    self.pageTitle = nil;
    self.addressField = nil;
    self.favorites =nil;
    self.favoritesView =nil;
    self.needDownFiles = nil ;
    self.sheetSelectTempURL =nil;
    //self.findSongsView =nil;
    self.addToFavorites = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


// MARK: -
// MARK: UIWebViewDelegate protocol
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL* url = [request mainDocumentURL];
    NSString* absoluteString = [url absoluteString];
    
    if([self testURL:absoluteString] ==YES && ([absoluteString isEqualToString:self.sheetSelectTempURL] ==NO))
    {
        //pop ask user
        
        [self popDownloadSheet:absoluteString];
        //cancel nav
        return NO;
    } 
        [self updateAddress:request];
        return YES;

}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self disableSomeUIFace];
    if ([UIApplication sharedApplication].networkActivityIndicatorVisible == YES) {
        self.networkActivityIndicatorBusy =YES;
    }else{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        self.networkActivityIndicatorBusy =NO;
    }
    [self updateButtons];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self enableSomeUIFace];
    
    if (self.networkActivityIndicatorBusy !=YES) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
    [self updateButtons];
    [self updateTitle:webView];
    NSURLRequest* request = [webView request];
    [self updateAddress:request];
    
//    //find music url
//    //get html conntent
//	NSString *docHtml = [self.webView stringByEvaluatingJavaScriptFromString: 
//						 @"document.body.innerHTML"];
//	//NSLog(@"docHtml is :%@",docHtml);
//	self.needDownFiles =	[self findMusicFiles:docHtml];
//	
//	//SHOW DOWN BUTTON
//	if ([self.needDownFiles count] > 0) {
//		self.bDownloads.enabled =YES;	
//	}else {
//		self.bDownloads.enabled =NO;
//	}//end find music

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
    [self informError:error];
}

@end
