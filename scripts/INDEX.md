
# WJHAssocObj.framework

[![GitHub version](https://badge.fury.io/gh/jodyhagins%2FWJHAssocObj.svg)](https://github.com/jodyhagins/WJHAssocObj/releases) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/jodyhagins/WJHAssocObj/master/LICENSE.md)

This is a very simple framework composed of C functions that extend the behavior of `objc_setAssociatedObject` and its counterparts.  Some folks see C APIs as anathema, so I have also included a category on `NSObject` that provides the same capabilities.

Really, there is no reason for something this small to warrant its own framework, but I wanted to experiment with both appledoc and carthage, and this provided that opportunity.

Furthermore, [this blog post](http://cocoaandgrits.blogspot.com/2015/08/associated-objects.html) explains in more depth the motivation and implementation of this associated objects API.
