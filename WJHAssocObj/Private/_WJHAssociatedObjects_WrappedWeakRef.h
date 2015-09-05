//
//  _WJHAssociatedObjects_WrappedWeakRef.h
//  WJHAssocObj
//
//  Created by Jody Hagins on 5/28/12.
//  Copyright (c) 2012 Think Solutions, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Wrap a zeroing-weak reference
 */
@interface _WJHAssociatedObjects_WrappedWeakRef : NSObject

/**
 The referenced object.
 */
@property (weak, readonly) id object;

/**
 Wrap an object with a weak reference.
 
 @param object a weak reference to this object will be obtained and kept by the wrapper
 @return a wrapper instance, wrapping the @a object
 */
+ (instancetype)wrappedWeakRefTo:(id)object;
@end
