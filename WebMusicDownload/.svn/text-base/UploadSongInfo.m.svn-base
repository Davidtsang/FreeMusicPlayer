//
//  UploadSongInfo.m
//  WebMusicDownload
//
//  Created by Zen David on 11-10-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UploadSongInfo.h"
#import "WebMusicDownloadAppDelegate.h"
//#import "NSString+AESCrypt.h"
#import "ASIFormDataRequest.h"
#import "MyFunction.h"
#import "PlayList.h"
#import "NSData-AES.h"
#import "Base64.h"

@interface UploadSongInfo()
//-(NSString *)loadUUID;
-(void)uploadComplete:(id)sender;
-(void)uploadFailed:(id)sender;

@end

@implementation UploadSongInfo

@synthesize request;
@synthesize isBusy;

//-(NSString *)loadUUID{
//    NSString *uuid = nil;
//    CFUUIDRef theUUID = CFUUIDCreate(kCFAllocatorDefault);
//    if (theUUID) {
//        uuid = NSMakeCollectable(CFUUIDCreateString(kCFAllocatorDefault, theUUID));
//        [uuid autorelease];
//        CFRelease(theUUID);
//    }
//    return uuid;
//}

-(void)uploadComplete:(id)sender
{
    self.isBusy = NO;
    NSLog(@"Upload song ok!");
}

-(void)uploadFailed:(id)sender
{
    //NSString *errorType;
    // not url
//     Error: Error Domain=ASIHTTPRequestErrorDomain Code=1 "A connection failure occurred" UserInfo=0x9780300 {NSUnderlyingError=0x1c3b80 "The operation couldn’t be completed. (kCFErrorDomainCFNetwork error 2.)", NSLocalizedDescription=A connection failure occurred}
    
    NSError *error = [request error];
    NSLog(@"Error: %@", error);
//	if ( failed==NO) {
//		if ([[request error] domain] != NetworkRequestErrorDomain || [[request error] code] != ASIRequestCancelledErrorType) {
//			UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Fetch failed" message:@"Failed to fetch url:" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
//			[alertView show];
//            errorType = kDownloadStatusError;
//		}else{
//            errorType = kDownloadStatusStop;
//        }
//		failed = YES;
//	}
    self.isBusy= NO;
    
}

//ASIHTTPRequest *request;
-(void)sendSongInfo:(NSMutableDictionary *)aSongInfo
{
    //if "duration" =0 size <100000

    
    NSNumber *songSize =[aSongInfo objectForKey:kSongSize];
    NSNumber *songDuration =[aSongInfo objectForKey:kSongDuration];
    if ([songSize intValue] >kUploadSongMinSize && [songDuration intValue ] > kUploadSongMinDuration ) {
    
    self.isBusy = YES;
    
    NSURL *_url=[NSURL URLWithString:kUploadSongInfoURL];
    self.request = [ASIFormDataRequest requestWithURL:_url];

    [request setDidFinishSelector:@selector(uploadComplete:)];
    [request setDidFailSelector:@selector(uploadFailed:)];
    //[request setDidReceiveResponseHeadersSelector:@selector(receiveHeader:)];
    //[request addRequestHeader:@"Referer" value:@"http://allseeing-i.com/"];
    
    //Key = MD5(password + salt)
    //IV = MD5(Key + password + salt)
    // mac +date +salt =authCode
    //get mac 
    
    NSString *theSalt =@"JesusPlsBlessThisAppAndMe.";
    //NSString *password =@"Hallelujah!";
    
    //NSString *keyString =[NSString stringWithFormat:@"%@%@",theSalt,password];
    //NSString *aKey =[MyFunction md5HexDigest:keyString];
    //NSString *aKey =@"a16byteslongkey!a16byteslongkey!";
        
    //key:e77e03ad23b9ff40287d1a57046b6723
    //    a16byteslongkey!a16byteslongkey!
    //NSLog(@"key:%@",aKey);
    NSString *aKey =@"e77e03ad23b9ff40287d1a57046b6723" ;
    NSString* macAddress = appDelegate.localIP;
    //date

    //NSDate *nowDate =[[NSData alloc] init ];
    NSTimeInterval iNow = [[NSDate date] timeIntervalSince1970];
    NSString *dateString =[NSString stringWithFormat:@"%f", iNow];
    
    
    NSString *authString =[NSString stringWithFormat:@"%@---%@---%@", macAddress,dateString,theSalt];
    //NSData *authData =[MyFunction encryptString:authString withKey:aKey];
    
    //NSString* theAuthString = [NSString stringWithUTF8String:[authData bytes]];
    //NSString* theAuthString = [authString AES256EncryptWithKey:aKey] ;
    
//NSString *password = @"a16byteslongkey!a16byteslongkey!";
  //      NSString *str = @"18:E7:F4:93:9E:94---1320611651.753571---JesusPlsBlessThisApp!"; // It does not work with UTF8 like @"こんにちは世界"
        
        // 1) Encrypt
        //NSLog(@"encrypting string = %@",authString);
        
        NSData *data = [authString dataUsingEncoding: NSASCIIStringEncoding];
        NSData *encryptedData = [data AESEncryptWithPassphrase:aKey];
        
        // 2) Encode Base 64
        // If you need to send over internet, encode NSData -> Base64 encoded string
        [Base64 initialize];
        NSString *theAuthString = [Base64 encode:encryptedData];
        
        //NSLog(@"Base 64 encoded = %@",b64EncStr);

        
        
        
        
        //NSString* orgStr =[theAuthString AES256DecryptWithKey:aKey];
    //NSLog(@"auth str:%@",theAuthString);
    //    NSLog(@"org str:%@",orgStr);
        
    [request setPostValue:macAddress forKey:@"mac"];
    [request setPostValue:theAuthString forKey:@"code"];
    //[theAuthString release];
    
    
    //date
    [request setPostValue:dateString forKey:@"date"];

    //songTitle
    [request setPostValue:[aSongInfo objectForKey:kSongTitle]  forKey:@"songTitle"];
    //songURL
    [request setPostValue:[aSongInfo objectForKey:kSongURL] forKey:@"songURL"];
    //songAlbum
    [request setPostValue:[aSongInfo objectForKey:kSongAlbum] forKey:@"songAlbum"];
    //songArtist
    [request setPostValue:[aSongInfo objectForKey:kSongArtist] forKey:@"songArtist"];
    //songSize
    [request setPostValue:[NSString stringWithFormat:@"%d",[songSize intValue]] forKey:@"songSize"];
    //songDuration
    [request setPostValue:[NSString stringWithFormat:@"%d",[songDuration intValue]] forKey:@"songDuration"];
 
        //APP NAME/VERSION
    [request setPostValue:@"full-1.0.1" forKey:@"appVersion"];

    

//[request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:[self.taskItem objectForKey:kDownloadTaskID],kDownloadTaskID,_savePath,kDownloadTaskSavePath,nil]];

    [request setDelegate:self];
    [request startAsynchronous];

//[[NSNotificationCenter defaultCenter] postNotificationName:kNoticeDownloadStart object:nil userInfo:[NSDictionary dictionaryWithObject:[self.taskItem objectForKey:kDownloadTaskID] forKey:kDownloadTaskID]];
    }else{
        NSLog(@"not is song ,not upload info");
    }
}

#pragma -mark NSObject Base:
-(id)init
{
    self = [super init];
    if (self) {
    
    
    //初始化应用程序委托
	appDelegate =(WebMusicDownloadAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)dealloc{
    
    [request cancel];
    [request release];
    //[uploadSongs release];
    
    [super dealloc];
    
}


@end
