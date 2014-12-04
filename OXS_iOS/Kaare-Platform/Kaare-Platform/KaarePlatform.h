@interface Kaare : NSObject // Temporary here

+(RACSignal*)executeCommand:(NSString*)cmd params:(NSArray*)params;

@end

@interface KaarePlatform : NSObject

+(RACSignal*)httpRequest:(NSString*)url :(NSDictionary*)options;
+(RACSignal*)httpRequest:(NSString*)url;

+(RACSignal*)xPath:(NSString*)document :(NSString*)query;
+(RACSignal*)xPath:(NSString*)document :(NSString*)query :(BOOL)isHTML;

@end

@interface Kaare (KaarePlatform)

+(KaarePlatform*)platform;

@end

