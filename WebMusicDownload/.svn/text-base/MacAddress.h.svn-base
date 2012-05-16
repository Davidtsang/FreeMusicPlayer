//
//  MacAddress.h
//  WebMusicDownload
//
//  Created by Zen David on 11-10-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#include <sys/types.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <net/if_dl.h>
#include <ifaddrs.h>

#if ! defined(IFT_ETHER)
#define IFT_ETHER 0x6/* Ethernet CSMACD */
#endif

char*  getMacAddress(char* macAddress, char* ifName);

//char* macAddressString= (char*)malloc(18);
//NSString* macAddress= [[NSString alloc] initWithCString:getMacAddress(macAddressString,"en0")                                                encoding:NSMacOSRomanStringEncoding];
