//
//  MyFunction.h
//  WebMusicDownload
//
//  Created by Zen David on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyFunction : NSObject {
    
}
+(NSString *) urlEncode: (NSString *) url;
+(NSString *)stringFromFileSize:(NSInteger) theSize;
+(NSString *)convertTimeFromSeconds:(NSInteger)seconds; 
//+ (NSData*) encryptString:(NSString*)plaintext withKey:(NSString*)key;
//+ (NSString*) decryptData:(NSData*)ciphertext withKey:(NSString*)key;
+ (NSString*)md5HexDigest:(NSString*)input;
@end
