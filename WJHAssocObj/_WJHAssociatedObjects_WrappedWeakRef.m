//
//  _WJHAssociatedObjects_WrappedWeakRef.m
//  WJHAssocObj
//
//  Created by Jody Hagins on 5/28/12.
//  Copyright (c) 2012 Think Solutions, LLC. All rights reserved.
//

#import "_WJHAssociatedObjects_WrappedWeakRef.h"

@implementation _WJHAssociatedObjects_WrappedWeakRef

+ (instancetype)wrappedWeakRefTo:(id)object {
    _WJHAssociatedObjects_WrappedWeakRef *result = [self new];
    if (result) {
        result->object_ = object;
    }
    return result;
}

@end
