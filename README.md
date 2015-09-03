
# WJHAssocObj.framework

[![GitHub version](https://badge.fury.io/gh/jodyhagins%2FWJHAssocObj.svg)](https://github.com/jodyhagins/WJHAssocObj/releases) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/jodyhagins/WJHAssocObj/master/LICENSE.md)

This is a very simple framework composed of C functions that extend the behavior of `objc_setAssociatedObject` and its counterparts.

## Motivation
The main drawback of the existing API is that it does not provide support for zeroing weak pointers.  In addition, with ARC lots of ugly casts are necessary for even simple use cases.  Thus, this library provides zeroing weak pointer support, and also makes it easier to associate both objects and native integral/pointer types.

## Installation
[Carthage](https://github.com/carthage/carthage) is the recommended way to install WJHAssocObj.  Add the following to your Cartfile:

``` ruby
github “jodyhagins/WJHAssocObj”
```

For manual installation, I recommend adding the project as a subproject to your project or workspace ad adding the framework as a target dependency.
 
## Usage 
When using these functions, keep in mind these points (which, by the way, are the same as when using `objc_setAssociatedObject`).


* The `key is a void pointer, and should be unique.  Do not use raw C-strings, as they are not guaranteed to be coalesced into a unique string.  I recommend using the address of a static object, as it is guaranteed to be unique through the lifetime of the program.

    Specifically, I recommend using the following pattern.

        static char const KEY[1];

    The macro `WJHAssociatedKey()` simulates this pattern, and reduces the chance for a typo.
 
* The first parameter is the object that "holds" the association.
 
* You can only have one associated object per unique key.  If you create an association with the same key as an existing association, the previous association will be removed.

* The `atomically` parameter has the same meaning as atomic on property declarations.

### Example

As an example, let’s pretend that we are adding several properties to an arbitrary category on NSObject, a prime use case for associated objects.  The interface declaration may look like this.

    @interface NSObject (Foo)
        @property (atomic, strong) id strongObject;
        @property (weak) id weakObject;
        @property (nonatomic, copy) id copiedObject;
        @property void* rawPointer;
        @property unsigned unsignedInteger;
    @end
 
And the implementation could possibly look like this.

    @implementation NSObject(Foo)

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

    @end
 
### Notes
 
You use either `WJHAssociateStrongly`, `WJHAssociateCopy`, or `WJHAssociateWeakly` to create associations to objects.  Objects must be fetched with `WJHGetAssociatedObject`.
 
Similarly, you use `WJHAssociatePointer` and WJHAssociateInteger` for associating non-objects, and they are to be fetched with `WJHGetAssociatedPointer` and `WJHGetAssociatedInteger` (though, technically, those two can be interchanged).

An association can be broken with `WJHDisassociate`.
