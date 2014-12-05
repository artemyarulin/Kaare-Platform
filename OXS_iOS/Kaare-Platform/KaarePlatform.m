#import "KaarePlatform.h"
#import "HttpRequest.h"
#import "XPath.h"

@implementation Kaare (KaarePlatform)

+(KaarePlatform*)platform
{
    return [KaarePlatform shared];
}

@end

@implementation KaarePlatform

-(RACSignal*)httpRequest:(NSString *)url { return [self httpRequest:url :nil]; }
-(RACSignal*)httpRequest:(NSString *)url :(NSDictionary *)options { return [HttpRequest httpRequest:url options:options]; }

-(RACSignal*)xPath:(NSString *)document :(NSString *)query { return [self xPath:document :query :YES]; }
-(RACSignal*)xPath:(NSString *)document :(NSString *)query :(BOOL)isHTML { return [XPath xPath:document query:query isHTML:isHTML]; }

+(instancetype)shared
{
    static dispatch_once_t pred;
    static KaarePlatform* sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[KaarePlatform alloc] init];
    });
    return sharedInstance;
}

@end
