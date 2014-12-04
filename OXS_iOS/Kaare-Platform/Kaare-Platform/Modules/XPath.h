@interface XPath : NSObject

+(RACSignal*)xPath:(NSString*)document query:(NSString*)query isHTML:(BOOL)isHTML;

@end
