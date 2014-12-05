@interface KaarePlatform : NSObject

-(RACSignal*)httpRequest:(NSString*)url;
-(RACSignal*)httpRequest:(NSString*)url :(NSDictionary*)options;

-(RACSignal*)xPath:(NSString*)document :(NSString*)query;
-(RACSignal*)xPath:(NSString*)document :(NSString*)query :(BOOL)isHTML;

+(instancetype)shared;

@end

@interface Kaare (KaarePlatform)

+(KaarePlatform*)platform;

@end

