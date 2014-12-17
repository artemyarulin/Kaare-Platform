#import "KaarePlatform.h"
#import "HttpRequest.h"
#import "XPath.h"

@implementation Kaare (KaarePlatform)

-(KaarePlatform*)platform
{
    static dispatch_once_t pred;
    static KaarePlatform* sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[KaarePlatform alloc] initWithKaare:self];
    });
    return sharedInstance;
}

@end

@implementation KaarePlatform

-(instancetype)initWithKaare:(Kaare*)kaare
{
    if (self = [super init])
    {
        [kaare registerCommand:@"platform.httpRequest" handler:^RACSignal* (NSArray *params) {
            return [HttpRequest httpRequest:params[0] options:params.count == 2 ? params[1]: nil];
        }];
        
        [kaare registerCommand:@"platform.xPath" handler:^RACSignal* (NSArray *params) {
            return [XPath xPath:params[0] query:params[1] isHTML:params.count == 3 ? (BOOL)params[2] : YES];
        }];
    }
    return self;
}

@end
