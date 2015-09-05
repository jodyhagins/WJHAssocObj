//
//  NSObject+WJHAssocObj.m
//  WJHAssocObj
//
//  Created by Jody Hagins on 9/5/15.
//  Copyright (c) 2015 Jody Hagins. All rights reserved.
//

#import "NSObject+WJHAssocObj.h"
#import "WJHAssociatedObjects.h"

@implementation NSObject (WJHAssocObj)

- (void)wjh_associateStrongly:(id)object withKey:(const void *)key atomically:(BOOL)atomically {
    WJHAssociateStrongly(self, key, object, atomically);
}

- (void)wjh_associateWeakly:(id)object withKey:(const void *)key atomically:(BOOL)atomically {
    WJHAssociateWeakly(self, key, object);
}

- (void)wjh_associateCopy:(id)object withKey:(const void *)key atomically:(BOOL)atomically {
    WJHAssociateCopy(self, key, object, atomically);
}

- (void)wjh_associatePointer:(const void *)pointer withKey:(const void *)key {
    WJHAssociatePointer(self, key, pointer);
}

- (void)wjh_associateInteger:(intptr_t)integer withKey:(const void *)key {
    WJHAssociateInteger(self, key, integer);
}

- (id)wjh_associatedObjectWithKey:(const void *)key {
    return WJHGetAssociatedObject(self, key);
}

- (intptr_t)wjh_associatedIntegerWithKey:(const void *)key {
    return WJHGetAssociatedInteger(self, key);
}

- (void *)wjh_associatedPointerWithKey:(const void *)key {
    return WJHGetAssociatedPointer(self, key);
}

- (void)wjh_disassociateKey:(const void *)key {
    WJHDisassociate(self, key);
}


+ (void)wjh_associateStrongly:(id)object withKey:(const void *)key atomically:(BOOL)atomically {
    WJHAssociateStrongly(self, key, object, atomically);
}

+ (void)wjh_associateWeakly:(id)object withKey:(const void *)key atomically:(BOOL)atomically {
    WJHAssociateWeakly(self, key, object);
}

+ (void)wjh_associateCopy:(id)object withKey:(const void *)key atomically:(BOOL)atomically {
    WJHAssociateCopy(self, key, object, atomically);
}

+ (void)wjh_associatePointer:(const void *)pointer withKey:(const void *)key {
    WJHAssociatePointer(self, key, pointer);
}

+ (void)wjh_associateInteger:(intptr_t)integer withKey:(const void *)key {
    WJHAssociateInteger(self, key, integer);
}

+ (id)wjh_associatedObjectWithKey:(const void *)key {
    return WJHGetAssociatedObject(self, key);
}

+ (intptr_t)wjh_associatedIntegerWithKey:(const void *)key {
    return WJHGetAssociatedInteger(self, key);
}

+ (void *)wjh_associatedPointerWithKey:(const void *)key {
    return WJHGetAssociatedPointer(self, key);
}

+ (void)wjh_disassociateKey:(const void *)key {
    WJHDisassociate(self, key);
}

@end
