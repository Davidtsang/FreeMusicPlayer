//
//  MyUIProgressView.h
//  WebMusicDownload
//
//  Created by Zen David on 11-8-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyUIProgressView : UIProgressView {
    NSDictionary* userInfo;
}
@property(nonatomic,retain) NSDictionary* userInfo;
@end
