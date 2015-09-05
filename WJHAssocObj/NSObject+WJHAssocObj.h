//
//  NSObject+WJHAssocObj.h
//  WJHAssocObj
//
//  Created by Jody Hagins on 9/5/15.
//  Copyright (c) 2015 Jody Hagins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (WJHAssocObj)

/**
 Associate the object with the receiver using a strong reference.

 @param object The object being added to the association.  It will be held strongly (i.e., retained) until the association is removed or until the receiver deallocs.
 @param key The unique key used to identify the associated object.
 @param atomically Should the association be made atomically
 */
- (void)wjh_associateStrongly:(id)object withKey:(void const *)key atomically:(BOOL)atomically;

/**
 Associate a copy of the object with the receiver.

 @param value The object being added to the association.  It will be a "copy" in the same way that declaring a property with the copy attribute ensures a copy of the object.
 @param key The unique key used to identify the associated object
 @param atomically Should the association be made atomically
 */
- (void)wjh_associateCopy:(id)object withKey:(void const *)key atomically:(BOOL)atomically;

/**
 Associate the object with the receiver using a weak reference.

 @param object The object being added to the association.  It will be stored as a weak reference to the object.  Thus, it will behave in the same way as any other weak reference.  When the original object is finally deallocated, the reference in the association will be zeroed, in effect, removing it from the association.
 @param key The unique key used to identify the associated object.
 @param atomically Should the association be made atomically
 */
- (void)wjh_associateWeakly:(id)object withKey:(void const *)key atomically:(BOOL)atomically;

/**
 Associate a raw pointer with the receiver.

 @param pointer The pointer being added to the association.  It will be stored as a raw pointer, with no reference-counting participation.  Thus, if what it points to is deallocated, the association will still hold the original raw pointer value.
 @param key The unique key used to identify the associated object
 */
- (void)wjh_associatePointer:(void const *)pointer withKey:(void const *)key;

/**
 Associate an integer value with the receiver.

 @param integer The integer being added to the association.
 @param key The unique key used to identify the associated object
 */
- (void)wjh_associateInteger:(intptr_t)integer withKey:(void const *)key;

/**
 Fetch the object that is associated with the given key.

 @param key The unique key that identifies the associated object

 @return The associated object, or nil if there is no association

 @note Note that getting an associated weak pointer will return a strong pointer.  The associated object is still weak, but the one returned will be strong, and as such will retain the underlying object.
 */
- (id)wjh_associatedObjectWithKey:(void const *)key;

/**
 Fetch the raw pointer that is associated with the given key.

 @param key The unique key that identifies the associated pointer

 @return The associated pointer, or NULL if there is no association
 */
- (void*)wjh_associatedPointerWithKey:(void const *)key;

/**
 Fetch the integer that is associated with the given key.

 @param key The unique key that identifies the associated integer

 @return The associated integer, or 0 if there is no association
 */
- (intptr_t)wjh_associatedIntegerWithKey:(void const *)key;

/**
 Remove the association for the specified key

 @param key The unique key that identifies the associated object
 */
- (void)wjh_disassociateKey:(void const *)key;



/**
 Associate the object with the receiving class using a strong reference.

 @param object The object being added to the association.  It will be held strongly (i.e., retained) until the association is removed.
 @param key The unique key used to identify the associated object.
 @param atomically Should the association be made atomically
 */
+ (void)wjh_associateStrongly:(id)object withKey:(void const *)key atomically:(BOOL)atomically;

/**
 Associate a copy of the object with the receiving class.

 @param value The object being added to the association.  It will be a "copy" in the same way that declaring a property with the copy attribute ensures a copy of the object.
 @param key The unique key used to identify the associated object
 @param atomically Should the association be made atomically
 */
+ (void)wjh_associateCopy:(id)object withKey:(void const *)key atomically:(BOOL)atomically;

/**
 Associate the object with the receiving class using a weak reference.

 @param object The object being added to the association.  It will be stored as a weak reference to the object.  Thus, it will behave in the same way as any other weak reference.  When the original object is finally deallocated, the reference in the association will be zeroed, in effect, removing it from the association.
 @param key The unique key used to identify the associated object.
 @param atomically Should the association be made atomically
 */
+ (void)wjh_associateWeakly:(id)object withKey:(void const *)key atomically:(BOOL)atomically;

/**
 Associate a raw pointer with the receiving class.

 @param pointer The pointer being added to the association.  It will be stored as a raw pointer, with no reference-counting participation.  Thus, if what it points to is deallocated, the association will still hold the original raw pointer value.
 @param key The unique key used to identify the associated object
 */
+ (void)wjh_associatePointer:(void const *)pointer withKey:(void const *)key;

/**
 Associate an integer value with the receiving class.

 @param integer The integer being added to the association.
 @param key The unique key used to identify the associated object
 */
+ (void)wjh_associateInteger:(intptr_t)integer withKey:(void const *)key;

/**
 Fetch the object that is associated with the given key.

 @param key The unique key that identifies the associated object

 @return The associated object, or nil if there is no association

 @note Note that getting an associated weak pointer will return a strong pointer.  The associated object is still weak, but the one returned will be strong, and as such will retain the underlying object.
 */
+ (id)wjh_associatedObjectWithKey:(void const *)key;

/**
 Fetch the raw pointer that is associated with the given key.

 @param key The unique key that identifies the associated pointer

 @return The associated pointer, or NULL if there is no association
 */
+ (void*)wjh_associatedPointerWithKey:(void const *)key;

/**
 Fetch the integer that is associated with the given key.

 @param key The unique key that identifies the associated integer

 @return The associated integer, or 0 if there is no association
 */
+ (intptr_t)wjh_associatedIntegerWithKey:(void const *)key;

/**
 Remove the association for the specified key

 @param key The unique key that identifies the associated object
 */
+ (void)wjh_disassociateKey:(void const *)key;

@end
