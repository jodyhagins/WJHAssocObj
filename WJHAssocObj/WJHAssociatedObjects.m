//
//  WJHAssociatedObjects.m
//  WJHAssocObj
//
//  Created by Jody Hagins on 5/28/12.
//  Copyright (c) 2012 Think Solutions, LLC. All rights reserved.
//

#import "WJHAssociatedObjects.h"
#import "_WJHAssociatedObjects_WrappedWeakRef.h"
#import <objc/runtime.h>

#define Wrapper _WJHAssociatedObjects_WrappedWeakRef

#pragma mark - Static Initialization
static Class proxyWrapperClass;

__attribute__((constructor))
static void MyModuleInitializer()
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        proxyWrapperClass = [Wrapper class];
    });
}


#pragma mark - Create Associations

void WJHAssociateStrongly(id object, void const *key, id value, BOOL atomically)
{
    objc_setAssociatedObject(object, key, value, atomically ? OBJC_ASSOCIATION_RETAIN : OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

void WJHAssociateCopy(id object, void const *key, id value, BOOL atomically)
{
    objc_setAssociatedObject(object, key, value, atomically ? OBJC_ASSOCIATION_COPY : OBJC_ASSOCIATION_COPY_NONATOMIC);
}

void WJHAssociateWeakly(id object, void const *key, id value)
{
    WJHAssociateStrongly(object, key, [Wrapper wrappedWeakRefTo:value], YES);
}

void WJHAssociatePointer(id object, void const *key, void const *value)
{
    objc_setAssociatedObject(object, key, (__bridge id)(value), OBJC_ASSOCIATION_ASSIGN);
}

void WJHAssociateInteger(id object, void const *key, intptr_t value)
{
    objc_setAssociatedObject(object, key, (__bridge id)((void*)value), OBJC_ASSOCIATION_ASSIGN);
}


#pragma mark - Fetch Associations

id WJHGetAssociatedObject(id object, void const *key)
{
    id value = objc_getAssociatedObject(object, key);
    if (object_getClass(value) == proxyWrapperClass) {
        value = ((Wrapper*)value)->object_;
        if (!value) {
            WJHDisassociate(object, key);
        }
    }
    return value;
}

void * WJHGetAssociatedPointer(id object, void const *key)
{
    return (__bridge void*)objc_getAssociatedObject(object, key);
}

intptr_t WJHGetAssociatedInteger(id object, void const *key)
{
    return (intptr_t)(__bridge void*)objc_getAssociatedObject(object, key);
}


#pragma mark - Break Associations

void WJHDisassociate(id object, void const *key)
{
    objc_setAssociatedObject(object, key, nil, OBJC_ASSOCIATION_ASSIGN);
}
