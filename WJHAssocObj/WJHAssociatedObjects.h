//
//  WJHAssociatedObjects.h
//  WJHAssocObj
//
//  Created by Jody Hagins on 5/28/12.
//  Copyright (c) 2012 Think Solutions, LLC. All rights reserved.
//

@import Foundation;

/**
 The version number of the framework, as found in the Info.plist with key CFBundleVersion
 */
double WJHAssociatedObjectsVersionNumber();

/**
 The version string of the framework, as found in the Info.plist with key CFBundleShortVersionString
 */
extern unsigned char const * WJHAssociatedObjectsVersionString();

/**
 The value is stored as a strong-pointer association to object, referenced by key.
 @param object The object that holds the associated value
 @param key The unique key used to identify the associated object
 @param value The object being added to the association.  It will be held strongly (i.e., retained) until the association is removed.
 @param atomically Should the association be made atomically
 */
static inline void WJHAssociateStrongly(id object, void const *key, id value, BOOL atomically);

/**
 The value is copied, and the copy is associated to object, referenced by key.
 @param object The object that holds the associated value
 @param key The unique key used to identify the associated object
 @param value The object being added to the association.  It will be a "copy" in the same way that declaring a property with the copy attribute ensures a copy of the object.
 @param atomically Should the association be made atomically
 */
static inline void WJHAssociateCopy(id object, void const *key, id value, BOOL atomically);

/**
 The value is stored as a zeroing weak-pointer association to object, referenced by key.
 @param object The object that holds the associated value
 @param key The unique key used to identify the associated object
 @param value The object being added to the association.  It will be stored as a weak-pointer to the value object.  Thus, it will behave in the same way as any other weak pointer.  When the original object is finally deallocated, the pointer in the association will be zeroed, in effect, removing it from the association.
 @param atomically Should the association be made atomically
 */
void WJHAssociateWeakly(id object, void const *key, id value, BOOL atomically);

/**
 The value is stored as a raw pointer association to object, referenced by key.
 @param object The object that holds the associated value
 @param key The unique key used to identify the associated object
 @param value The pointer being added to the association.  It will be stored as a raw pointer, with no reference-counting participation.  Thus, if what it points to is deallocated, the association will still retain the original raw pointer value.
 @warning Note that WJHGetAssociatedPointer returns NULL if the key can not be found, so be careful about associating a pointer of NULL.
 */
static inline void WJHAssociatePointer(id object, void const *key, void const *value);

/**
 The integer value is stored as an integer association to object, referenced by key.
 @param object The object that holds the associated value
 @param key The unique key used to identify the associated object
 @param value The integer being added to the association.
 @warning Note that WJHGetAssociatedInteger returns 0 if the key can not be found, so be careful about associating an integer of 0.
 */
static inline void WJHAssociateInteger(id object, void const *key, intptr_t value);

/**
 Fetch the object that is associated with the given key.
 @param object The object that holds the association
 @param key The unique key that identifies the associated object
 @return The associated object, or nil if there is no association
 @warning Note that getting an associated weak pointer will return a strong pointer.  The associated object is still weak, but the one returned will be strong, and as such will retain the underlying object.
 */
id WJHGetAssociatedObject(id object, void const *key);


/**
 Fetch the raw pointer that is associated with the given key.
 @param object The object that holds the association
 @param key The unique key that identifies the associated pointer
 @return The associated pointer, or NULL if there is no association
 */
static inline void * WJHGetAssociatedPointer(id object, void const *key);

/**
 Fetch the raw pointer that is associated with the given key.
 @param object The object that holds the association
 @param key The unique key that identifies the associated integer
 @return The associated integer, or 0 if there is no association
 */
static inline intptr_t WJHGetAssociatedInteger(id object, void const *key);


/**
 Remove the association
 @param object The object that holds the association
 @param key The unique key that identifies the associated object
 */
static inline void WJHDisassociate(id object, void const *key);


#import "WJHAssociatedObjects_impl.h"
