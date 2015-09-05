//
//  _WJHAssociatedObjects_WrappedWeakRef.m
//  WJHAssocObj
//
//  Created by Jody Hagins on 5/28/12.
//  Copyright (c) 2012 Think Solutions, LLC. All rights reserved.
//

#import "_WJHAssociatedObjects_WrappedWeakRef.h"

@interface _WJHAssociatedObjects_WrappedWeakRef()
@property (weak, readwrite) id object;
@end


@implementation _WJHAssociatedObjects_WrappedWeakRef

+ (instancetype)wrappedWeakRefTo:(id)object {
    _WJHAssociatedObjects_WrappedWeakRef *result = [[self alloc] init];
    result.object = object;
    return result;
}

@end
