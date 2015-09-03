//
//  WJHAssociatedObjects.h
//  WJHAssocObj
//
//  Created by Jody Hagins on 5/28/12.
//  Copyright (c) 2012 Think Solutions, LLC. All rights reserved.
//

/**
 Object association functions.
 
 These functions provide similar capability to objc_setAssociatedObject and their counterparts.  The main drawback of that API is that it does not provide support for weak pointers.
 
 Furthermore, these library additions make it easier to store both objects and native data as an association.
 
 When using these functions, keep in mind these points (which, by the way, are the same as when using objc_setAssociatedObject).
 
 - The key is a void pointer, and should be unique.  Do not use raw C-strings, as they are not guaranteed to be coallesced into a unique string.  I recommend using the address of a static object.

 - The first parameter is the object that "holds" the association.

 - You can only have oe associated object per unique key.  If you create an association with the same key as an existing association, the previous association will be removed.
 
 - The atomically parameter has the same meaning as atomic on property declarations.
 
 As an example, the following code adds several properties to an arbitrary category on NSObject.  First, the interface declaration.
 
    \@interface NSObject (Foo)
    \@property (atomic, strong) id strongObject;
    \@property (weak) id weakObject;
    \@property (nonatomic, copy) id copiedObject;
    \@property void* rawPointer;
    \@property unsigned unsignedInteger;
    \@end
 
 And now, the implementation of the properties.
 
    \@implementation NSObject(Foo)

    #define kStrongKey (@selector(strongObject))
    WJHAssociatedKey(kStrongKey);
    - (id)strongObject {
        return WJHGetAssociatedObject(self, kStrongKey);
    }
    - (void)setStrongObject:(id)strongObject {
        WJHAssociateStrongly(self, kStrongKey, strongObject, YES);
    }
 
    #define kWeakKey (@selector(weakObject))
    - (id)weakObject {
        return WJHGetAssociatedObject(self, kWeakKey);
    }
    - (void)setWeakObject:(id)weakObject {
        WJHAssociateWeakly(self, kWeakKey, weakObject);
    }
 
    #define kCopyKey (@selector(copiedObject))
    - (id)copiedObject {
        return WJHGetAssociatedObject(self, kCopyKey);
    }
    - (void)setCopiedObject:(id)objectToCopy {
        WJHAssociateCopy(self, kCopyKey, objectToCopy, NO);
    }
 
    #define kPointerKey (@selector(rawPointer))
    - (void*)rawPointer {
        return WJHGetAssociatedPointer(self, kPointerKey);
    }
    - (void)setRawPointer:(void *)rawPointer {
        WJHAssociatePointer(self, kPointerKey, rawPointer);
    }
 
    #define kIntegerKey (@selector(unsignedInteger))
    - (unsigned)unsignedInteger {
        return (unsigned)WJHGetAssociatedInteger(self, kIntegerKey);
    }
    - (void)setUnsignedInteger:(unsigned int)unsignedInteger {
        WJHAssociateInteger(self, kIntegerKey, (intptr_t)unsignedInteger);
    }

    \@end
 
 @warning Be careful to use the proper methods for objects, and non-objects.
 
 You must use either WJHAssociateStrongly, WJHAssociateCopy, or WJHAssociateWeakly to create associations to objects.  Objects must be fetched with WJHGetAssociatedObject.
 
 Similarly, you use WJHAssociatePointer and WJHAssociateInteger for associating non-objects, and they are to be fetched with WJHGetAssociatedPointer and WJHGetAssociatedInteger (though, technically, those two can be interchanged).
 */

@import Foundation;

/** The value is stored as a strong-pointer association to object, referenced by key.
    @param object The object that holds the associated value
    @param key The unique key used to identify the associated object
    @param value The object being added to the association.  It will be held strongly (i.e., retained) until the association is removed.
    @param atomically Should the association be made atomically
 */
void WJHAssociateStrongly(id object, void const *key, id value, BOOL atomically);

/** The value is copied, and the copy is associated to object, referenced by key.
    @param object The object that holds the associated value
    @param key The unique key used to identify the associated object
    @param value The object being added to the association.  It will be a "copy" in the same way that declaring a property with the copy attribute ensures a copy of the object.
    @param atomically Should the association be made atomically
 */
void WJHAssociateCopy(id object, void const *key, id value, BOOL atomically);

/** The value is stored as a zeroing weak-pointer association to object, referenced by key.
    @param object The object that holds the associated value
    @param key The unique key used to identify the associated object
    @param value The object being added to the association.  It will be stored as a weak-pointer to the value object.  Thus, it will behave in the same way as any other weak pointer.  When the original object is finally deallocated, the pointer in the association will be zeroed, in effect, removing it from the association.
 */
void WJHAssociateWeakly(id object, void const *key, id value);

/** The value is stored as a raw pointer association to object, referenced by key.
    @param object The object that holds the associated value
    @param key The unique key used to identify the associated object
    @param value The pointer being added to the association.  It will be stored as a raw pointer, with no reference-counting participation.  Thus, if what it points to is deallocated, the association will still retain the original raw pointer value.
    @warning Note that WJHGetAssociatedPointer returns NULL if the key can not be found, so be careful about associating a pointer of NULL.
 */
void WJHAssociatePointer(id object, void const *key, void const *value);

/** The integer value is stored as an integer association to object, referenced by key.
    @param object The object that holds the associated value
    @param key The unique key used to identify the associated object
    @param value The integer being added to the association.
    @warning Note that WJHGetAssociatedInteger returns 0 if the key can not be found, so be careful about associating an integer of 0.
 */
void WJHAssociateInteger(id object, void const *key, intptr_t value);

/** Fetch the object that is associated with the given key.
    @param object The object that holds the association
    @param key The unique key that identifies the associated object
    @return The associated object, or nil if there is no association
    @warning Note that getting an associated weak pointer will return a strong pointer.  The associated object is still weak, but the one returned will be strong, and as such will retain the underlying object.
 */
id WJHGetAssociatedObject(id object, void const *key);

/** Fetch the raw pointer that is associated with the given key.
    @param object The object that holds the association
    @param key The unique key that identifies the associated pointer
    @return The associated pointer, or NULL if there is no association
 */
void * WJHGetAssociatedPointer(id object, void const *key);

/** Fetch the raw pointer that is associated with the given key.
    @param object The object that holds the association
    @param key The unique key that identifies the associated integer
    @return The associated integer, or 0 if there is no association
 */
intptr_t WJHGetAssociatedInteger(id object, void const *key);

/** Remove the association
    @param object The object that holds the association
    @param key The unique key that identifies the associated object
 */
void WJHDisassociate(id object, void const *key);


#import "WJHAssociatedObjects_impl.h"
