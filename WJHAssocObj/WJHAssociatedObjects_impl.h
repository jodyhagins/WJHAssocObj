//
//  WJHAssociatedObjects_impl.h
//  WJHAssocObj
//
//  Created by Jody Hagins on 8/22/15.
//  Copyright (c) 2015 Jody Hagins. All rights reserved.
//
#import <objc/runtime.h>

extern BOOL _wjhIsProxyClass(id object);

static inline void WJHAssociateStrongly(id object, void const *key, id value, BOOL atomically)
{
    assert(!_wjhIsProxyClass(value));
    objc_setAssociatedObject(object, key, value, atomically ? OBJC_ASSOCIATION_RETAIN : OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static inline void WJHAssociateCopy(id object, void const *key, id value, BOOL atomically)
{
    assert(!_wjhIsProxyClass(value));
    objc_setAssociatedObject(object, key, value, atomically ? OBJC_ASSOCIATION_COPY : OBJC_ASSOCIATION_COPY_NONATOMIC);
}

static inline void WJHAssociatePointer(id object, void const *key, void const *value)
{
    objc_setAssociatedObject(object, key, (__bridge id)(value), OBJC_ASSOCIATION_ASSIGN);
}

static inline void WJHAssociateInteger(id object, void const *key, intptr_t value)
{
    objc_setAssociatedObject(object, key, (__bridge id)((void*)value), OBJC_ASSOCIATION_ASSIGN);
}

static inline void * WJHGetAssociatedPointer(id object, void const *key)
{
    return (__bridge void*)objc_getAssociatedObject(object, key);
}

static inline intptr_t WJHGetAssociatedInteger(id object, void const *key)
{
    return (intptr_t)(__bridge void*)objc_getAssociatedObject(object, key);
}

static inline void WJHDisassociate(id object, void const *key)
{
    objc_setAssociatedObject(object, key, nil, OBJC_ASSOCIATION_ASSIGN);
}
