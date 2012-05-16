//
//  MyFunction.m
//  WebMusicDownload
//
//  Created by Zen David on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyFunction.h"
#import <CommonCrypto/CommonDigest.h>

@implementation MyFunction

+ (NSString*)md5HexDigest:(NSString*)input {
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

//+ (NSData*) encryptString:(NSString*)plaintext withKey:(NSString*)key {
//	return [[plaintext dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:key];
//}
//
//+ (NSString*) decryptData:(NSData*)ciphertext withKey:(NSString*)key {
//	return [[[NSString alloc] initWithData:[ciphertext AES256DecryptWithKey:key]
//								  encoding:NSUTF8StringEncoding] autorelease];
//}

+(NSString *) urlEncode: (NSString *) url
{
    NSString *result=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

+(NSString *)stringFromFileSize:(NSInteger) theSize
{
    
    float floatSize = theSize;
    if (theSize<1023)
        return([NSString stringWithFormat:@"%i bytes",theSize]);
    floatSize = floatSize / 1024;
    if (floatSize<1023)
        return([NSString stringWithFormat:@"%1.1f KB",floatSize]);
    floatSize = floatSize / 1024;
    if (floatSize<1023)
        return([NSString stringWithFormat:@"%1.1f MB",floatSize]);
    floatSize = floatSize / 1024;
    
    return([NSString stringWithFormat:@"%1.1f GB",floatSize]);
}

+(NSString *)convertTimeFromSeconds:(NSInteger)seconds {
    
    // Return variable.
    NSString *result = @"";
    
    // Int variables for calculation.
    //int secs = [seconds intValue];
    int secs =seconds;
    int tempHour    = 0;
    int tempMinute  = 0;
    int tempSecond  = 0;
    
    NSString *hour      = @"";
    NSString *minute    = @"";
    NSString *second    = @"";
    
    // Convert the seconds to hours, minutes and seconds.
    tempHour    = secs / 3600;
    tempMinute  = secs / 60 - tempHour * 60;
    tempSecond  = secs - (tempHour * 3600 + tempMinute * 60);
    
    hour    = [[NSNumber numberWithInt:tempHour] stringValue];
    minute  = [[NSNumber numberWithInt:tempMinute] stringValue];
    second  = [[NSNumber numberWithInt:tempSecond] stringValue];
    
    // Make time look like 00:00:00 and not 0:0:0
    if (tempHour < 10) {
        hour = [@"0" stringByAppendingString:hour];
    } 
    
    if (tempMinute < 10) {
        minute = [@"0" stringByAppendingString:minute];
    }
    
    if (tempSecond < 10) {
        second = [@"0" stringByAppendingString:second];
    }
    
    if (tempHour == 0) {
        
        //NSLog(@"Result of Time Conversion: %@:%@", minute, second);
        result = [NSString stringWithFormat:@"%@:%@", minute, second];
        
    } else {
        
        //NSLog(@"Result of Time Conversion: %@:%@:%@", hour, minute, second); 
        result = [NSString stringWithFormat:@"%@:%@:%@",hour, minute, second];
        
    }
    
    return result;
    
}


@end
