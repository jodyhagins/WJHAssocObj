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

static Class proxyWrapperClass;

__attribute__((constructor))
static void MyModuleInitializer()
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        proxyWrapperClass = [Wrapper class];
    });
}

BOOL _wjhIsProxyClass(id object)
{
    return object_getClass(object) == proxyWrapperClass;
}

void WJHAssociateWeakly(id object, void const *key, id value, BOOL atomically)
{
    assert(!_wjhIsProxyClass(value));
    objc_setAssociatedObject(object, key, [Wrapper wrappedWeakRefTo:value], atomically ? OBJC_ASSOCIATION_RETAIN : OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

id WJHGetAssociatedObject(id object, void const *key)
{
    id value = objc_getAssociatedObject(object, key);
    if (object_getClass(value) == proxyWrapperClass) {
        value = ((Wrapper*)value).object;
        if (!value) {
            WJHDisassociate(object, key);
        }
    }
    return value;
}
