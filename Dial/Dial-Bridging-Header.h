#ifndef Dial_Bridging_Header_h
#define Dial_Bridging_Header_h

#import <CoreFoundation/CoreFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#include <hidapi.h>

typedef int CGSConnectionID;
CGError CGSSetConnectionProperty(CGSConnectionID cid, CGSConnectionID targetCID, CFStringRef key, CFTypeRef value);
int _CGSDefaultConnection();

#endif
