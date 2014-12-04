#import "KaarePlatform.h"
#import "HttpRequest.h"
#import "XPath.h"

@implementation KaarePlatform

+(RACSignal*)httpRequest:(NSString *)url { return [KaarePlatform httpRequest:url :nil]; }
+(RACSignal*)httpRequest:(NSString *)url :(NSDictionary *)options { return [HttpRequest httpRequest:url options:options]; }

+(RACSignal*)xPath:(NSString *)document :(NSString *)query { return [KaarePlatform xPath:document :query :YES]; }
+(RACSignal*)xPath:(NSString *)document :(NSString *)query :(BOOL)isHTML { return [XPath xPath:document query:query isHTML:isHTML]; }

@end
