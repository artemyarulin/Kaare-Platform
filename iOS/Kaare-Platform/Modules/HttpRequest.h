#import "ReactiveCocoa.h"

@interface HttpRequest : NSObject

+(RACSignal*)httpRequest:(NSString*)url options:(NSDictionary*)options;

@end
