//
//  _WJHAssociatedObjects_WrappedWeakRef.h
//  WJHAssocObj
//
//  Created by Jody Hagins on 5/28/12.
//  Copyright (c) 2012 Think Solutions, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface _WJHAssociatedObjects_WrappedWeakRef : NSObject {
    @public
    __weak id object_;
}

+ (id)wrappedWeakRefTo:(id)object;
@end
