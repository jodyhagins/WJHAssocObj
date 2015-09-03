//
//  WJHAssocObjTests.m
//  WJHAssocObjTests
//
//  Created by Jody Hagins on 5/28/12.
//  Copyright (c) 2012 Think Solutions, LLC. All rights reserved.
//

@import WJHAssocObj;
#import <XCTest/XCTest.h>

@class Blarg, MutableBlarg;
@interface Blarg : NSObject<NSCopying, NSMutableCopying>
@end
@interface MutableBlarg : Blarg<NSMutableCopying>
@end

@implementation Blarg {
    @protected
    int x;
}
- (instancetype)init {
    if (self = [super init]) {
        static int xx;
        x = ++xx;
    }
    return self;
}
- (int)x {
    return self->x;
}
- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[Blarg class]] && x == ((Blarg*)object)->x;
}
- (id)copyWithZone:(NSZone *)zone {
    Blarg *result = [[Blarg allocWithZone:zone] init];
    result->x = x;
    return result;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    Blarg *result = [[MutableBlarg allocWithZone:zone] init];
    result->x = x;
    return result;
}
@end

@implementation MutableBlarg
- (void)setX:(int)value {
    x = value;
}
@end


@interface WJHAssocObjTests : XCTestCase
@end

@implementation WJHAssocObjTests {
    id OBJECT;
    NSMutableString *STRING;
}

static char const KEY[1];

- (void)setUp {
    [super setUp];

    OBJECT = self;
    STRING = [NSMutableString stringWithFormat:@"Foo"];
    XCTAssertNil(WJHGetAssociatedObject(OBJECT, KEY), @"Should start out nil");
}

- (void)runSameTestOnClass:(SEL)sel {
    if (OBJECT == self) {
        OBJECT = [self class];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:sel];
#pragma clang diagnostic pop
    }
}
#define RunSameTestOnClass() ([self runSameTestOnClass:_cmd])


#pragma mark - Strong Association

- (void)testBasicStrongAssociation {
    WJHAssociateStrongly(OBJECT, KEY, STRING, YES);
    XCTAssertEqual(WJHGetAssociatedObject(OBJECT, KEY), STRING, @"fetch what we set");
    RunSameTestOnClass();
}

- (void)testBreakStrongAssociation {
    WJHAssociateStrongly(OBJECT, KEY, STRING, YES);
    XCTAssertEqual(WJHGetAssociatedObject(OBJECT, KEY), STRING, @"Set");
    WJHDisassociate(OBJECT, KEY);
    XCTAssertNil(WJHGetAssociatedObject(OBJECT, KEY), @"Should be clear");
    RunSameTestOnClass();
}

- (void)testStrongAssociationRemainsUntilReleased {
    __weak id weakValue;
    @autoreleasepool {
        @autoreleasepool {
            NSMutableString *value = [STRING mutableCopy];
            weakValue = value;
            WJHAssociateStrongly(OBJECT, KEY, value, YES);
            XCTAssertEqual(WJHGetAssociatedObject(OBJECT, KEY), value, @"Set");
        }
        // value has been auto-released, but the object should be held alive by the strong association.
        XCTAssertNotNil(weakValue, @"should still be alive");
        XCTAssertEqual(WJHGetAssociatedObject(OBJECT, KEY), weakValue, @"should still hold strong ref");
        WJHDisassociate(OBJECT, KEY);
    }
    XCTAssertNil(weakValue, @"should now be dead");
    XCTAssertNil(WJHGetAssociatedObject(OBJECT, KEY), @"should be gone now");
    RunSameTestOnClass();
}

- (void)testStrongAssociationReturnsProperARC {
    // Make sure that we strongly associate, then grab a pointer through the API.  We will then disassociate and make sure we still have a reference.  In essence, we are making sure that the fetch API returns an incremented shared pointer.
    __weak id weakValue;
    id strongValue;
    @autoreleasepool {
        @autoreleasepool {
            @autoreleasepool {
                // Create an object, and strongly associate it with OBJECT.  When this autoreleasepool exits, the only reference should be in the association.
                Blarg * tmp = [[Blarg alloc] init];
                weakValue = tmp;
                XCTAssertEqual(tmp, weakValue, @"pointers should be same");
                XCTAssertNotNil(weakValue, @"object should still be allocated");
                WJHAssociateStrongly(OBJECT, KEY, tmp, YES);
            }
            // tmp has gone out of scope of the autorelease pool, but it should still be allocated because of the strong association.
            XCTAssertNotNil(weakValue, @"object should still be allocated");
            strongValue = WJHGetAssociatedObject(OBJECT, KEY);
            XCTAssertEqual(strongValue, weakValue, @"pointers should be same");
            WJHDisassociate(OBJECT, KEY);
            XCTAssertNotNil(weakValue, @"object should still be allocated");
            // If ARC properly increments reference count for the object retrieved by WJHGetAssociatedObject, then the object should survive this autoreleasepool.
        }
        // This association has been broken, but <strongValue> should still hold a strong reference.
        XCTAssertNil(WJHGetAssociatedObject(OBJECT, KEY), @"association should be gone now");
        XCTAssertNotNil(weakValue, @"The tmp object should still be around");
        strongValue = nil; // it should go away after this autoreleasepool
    }
    XCTAssertNil(weakValue, @"The tmp object should still be around");

    RunSameTestOnClass();
}


#pragma mark - Copy Association

- (void)testBasicCopyAssociation {
    WJHAssociateCopy(OBJECT, KEY, STRING, YES);
    id fetched = WJHGetAssociatedObject(OBJECT, KEY);
    XCTAssertEqualObjects(fetched, STRING, @"fetch what we set");
    XCTAssertTrue(STRING != fetched, @"Should be copy with same data but different objects");
    RunSameTestOnClass();
}

- (void)testBreakCopyAssociation {
    WJHAssociateCopy(OBJECT, KEY, STRING, YES);
    id fetched = WJHGetAssociatedObject(OBJECT, KEY);
    XCTAssertEqualObjects(fetched, STRING, @"fetch what we set");
    XCTAssertTrue(STRING != fetched, @"Should be copy with same data but different objects");
    WJHDisassociate(OBJECT, KEY);
    XCTAssertNil(WJHGetAssociatedObject(OBJECT, KEY), @"association should be broken");
    RunSameTestOnClass();
}

- (void)testCopyAssociationRemainsUntilReleased {
    __weak id weakValue;
    __weak id weakFound;
    @autoreleasepool {
        @autoreleasepool {
            MutableBlarg *value = [[MutableBlarg alloc] init];
            weakValue = value;
            WJHAssociateCopy(OBJECT, KEY, value, YES);
            id found = WJHGetAssociatedObject(OBJECT, KEY);
            weakFound = found;
            XCTAssertNotEqual(value, found, @"copy should not be identical");
            XCTAssertEqualObjects(value, found, @"copy should be equivalent");
            [value setX:42];
            XCTAssertThrows([found setX:42], @"trying to mutate copy");
        }
        // value has been auto-released, but the object should be held alive by the strong association.
        XCTAssertNil(weakValue, @"original should be gone because we held copy in association");
        XCTAssertNotNil(weakFound, @"associated value should still be alive");
        id found = WJHGetAssociatedObject(OBJECT, KEY);
        XCTAssertEqual(found, weakFound, @"should still be the same");

        // Break the association.
        WJHDisassociate(OBJECT, KEY);
        XCTAssertNil(WJHGetAssociatedObject(OBJECT, KEY));
    }
    XCTAssertNil(weakValue, @"should now be dead");
    XCTAssertNil(weakFound, @"should now be dead");
    XCTAssertNil(WJHGetAssociatedObject(OBJECT, KEY), @"should be gone now");
    RunSameTestOnClass();
}


#pragma mark - Weak Association

- (void)testBasicWeakAssociation {
    WJHAssociateWeakly(OBJECT, KEY, STRING);
    id fetched = WJHGetAssociatedObject(OBJECT, KEY);
    XCTAssertEqualObjects(fetched, STRING, @"fetch what we set");
    XCTAssertTrue(STRING == fetched, @"Should be identical");
    RunSameTestOnClass();
}

- (void)testBreakWeakAssociation {
    WJHAssociateWeakly(OBJECT, KEY, STRING);
    XCTAssertTrue(STRING == WJHGetAssociatedObject(OBJECT, KEY), @"Set");
    WJHDisassociate(OBJECT, KEY);
    XCTAssertNil(WJHGetAssociatedObject(OBJECT, KEY), @"Should be clear");
    RunSameTestOnClass();
}

- (void)testWeakAssociationIsZeroingAndNonRetaining {
    __weak id weakValue;
    @autoreleasepool {
        id strongValue;
        @autoreleasepool {
            NSMutableString *value = [STRING mutableCopy];
            weakValue = value;
            WJHAssociateWeakly(OBJECT, KEY, value);
            XCTAssertTrue(value == WJHGetAssociatedObject(OBJECT, KEY), @"Set");
            strongValue = WJHGetAssociatedObject(OBJECT, KEY);
        }
        XCTAssertNotNil(weakValue, @"assigning from WJHGet retains");
        XCTAssertEqual(weakValue, strongValue, @"assiging from WJHGet retains");
    }
    XCTAssertNil(weakValue, @"weak association does not retain and gets nilled");
    XCTAssertNil(WJHGetAssociatedObject(OBJECT, KEY), @"should not find it either");
    RunSameTestOnClass();
}


#pragma mark - Pointer Association

- (void)testBasicPointerAssociation {
    void *ptrValue = (__bridge void*)STRING;
    WJHAssociatePointer(OBJECT, KEY, ptrValue);
    void *fetched = WJHGetAssociatedPointer(OBJECT, KEY);
    XCTAssertTrue(ptrValue == fetched, @"Should be identical");
    RunSameTestOnClass();
}

- (void)testBreakPointerAssociation {
    void *ptrValue = (__bridge void*)STRING;
    WJHAssociatePointer(OBJECT, KEY, ptrValue);
    void *fetched = WJHGetAssociatedPointer(OBJECT, KEY);
    XCTAssertTrue(ptrValue == fetched, @"Should be identical");
    WJHDisassociate(OBJECT, KEY);
    XCTAssertTrue(WJHGetAssociatedPointer(OBJECT, KEY) == 0, @"Should be gone");
    RunSameTestOnClass();
}

- (void)testPointerAssociationStaysUntilDisassociated {
    __weak id weakValue;
    void *ptrValue;
    @autoreleasepool {
        NSMutableString *value = [STRING mutableCopy];
        weakValue = value;
        ptrValue = (__bridge void*)value;
        WJHAssociatePointer(OBJECT, KEY, ptrValue);
        XCTAssertTrue(ptrValue == WJHGetAssociatedPointer(OBJECT, KEY), @"Set");
    }
    XCTAssertNil(weakValue, @"pointer association does not retain object");
    XCTAssertTrue(ptrValue == WJHGetAssociatedPointer(OBJECT, KEY), @"value should still be there");
    RunSameTestOnClass();
}


#pragma mark - Integer Associations

- (void)testBasicIntegerAssociation {
    WJHAssociateInteger(OBJECT, KEY, 42);
    intptr_t fetched = WJHGetAssociatedInteger(OBJECT, KEY);
    XCTAssertTrue(42 == fetched, @"Should be identical");
    RunSameTestOnClass();
}

- (void)testBreakIntegerAssociation {
    WJHAssociateInteger(OBJECT, KEY, -42);
    intptr_t fetched = WJHGetAssociatedInteger(OBJECT, KEY);
    XCTAssertTrue(-42 == fetched, @"Should be identical");
    WJHDisassociate(OBJECT, KEY);
    XCTAssertTrue(WJHGetAssociatedInteger(OBJECT, KEY) == 0, @"Should be gone");
    RunSameTestOnClass();
}

@end