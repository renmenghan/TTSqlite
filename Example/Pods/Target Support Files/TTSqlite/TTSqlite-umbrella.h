#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "TTModelProtocol.h"
#import "TTModelTool.h"
#import "TTSqliteModelTool.h"
#import "TTSqliteTool.h"
#import "TTTableTool.h"

FOUNDATION_EXPORT double TTSqliteVersionNumber;
FOUNDATION_EXPORT const unsigned char TTSqliteVersionString[];

