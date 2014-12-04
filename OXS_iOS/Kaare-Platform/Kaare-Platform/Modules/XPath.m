#import "XPath.h"
#import "GDataXmlNode.h"

@implementation XPath

+(RACSignal*)xPath:(NSString*)document query:(NSString*)query isHTML:(BOOL)isHTML
{
    GDataXMLDocument* doc;
    
    if (isHTML)
        doc = [[GDataXMLDocument alloc] initWithHTMLString:document encoding:NSUTF8StringEncoding error:nil];
    else
        doc = [[GDataXMLDocument alloc] initWithXMLString:document encoding:NSUTF8StringEncoding error:nil];
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSArray* nodes = [doc nodesForXPath:query error:nil];
        for (int i=0; i<nodes.count; i++) {
            [subscriber sendNext:[XPath wrapXPathResult:nodes[i]]];
        }
        
        [subscriber sendCompleted];
        return nil;
    }];
}

+(id)wrapXPathResult:(GDataXMLNode*)node
{
    return [node stringValue];
}

@end
