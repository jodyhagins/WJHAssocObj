//
//  WJHAssocObj.m
//  WJHAssocObj
//
//  Created by Jody Hagins on 9/14/15.
//  Copyright (c) 2015 Jody Hagins. All rights reserved.
//

#import "WJHAssocObj.h"
#import "_WJHAssociatedObjects_WrappedWeakRef.h"

static double versionNumber;
double WJHAssocObjVersionNumber()
{
    return versionNumber;
}

static char * versionString;
unsigned char const * WJHAssocObjVersionString()
{
    return (unsigned char *)versionString;
}

__attribute__((constructor))
static void init()
{
    @autoreleasepool {
        NSBundle *bundle = [NSBundle bundleForClass:[_WJHAssociatedObjects_WrappedWeakRef class]];
        NSString *buildVersion = [bundle objectForInfoDictionaryKey:@"CFBundleVersion"];
        NSString *releaseVersion = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        releaseVersion = [NSString stringWithFormat:@"%@ (%@)", releaseVersion, buildVersion];

        versionNumber = [buildVersion doubleValue];
        versionString = strdup([releaseVersion cStringUsingEncoding:NSUTF8StringEncoding]);
    }
}

__attribute__((destructor))
static void fini()
{
    if (versionString) {
        free(versionString);
        versionString = NULL;
    }
}
