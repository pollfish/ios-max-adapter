#import <TargetConditionals.h>
#if !TARGET_OS_IOS
#warning "PollfishMaxAdapter only supports the iOS platform"
#endif