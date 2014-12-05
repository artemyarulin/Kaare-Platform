#import "HttpRequest.h"

@implementation HttpRequest

+(RACSignal*)httpRequest:(NSString*)url options:(NSDictionary*)options
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSession* session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.ephemeralSessionConfiguration];
        NSMutableURLRequest* request = [HttpRequest requestFromOptions:options url:url];
        
        NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error)
                [subscriber sendError:error];
            else
            {
                [subscriber sendNext:[HttpRequest wrapResponse:data response:response options:options]];
                [subscriber sendCompleted];
            }
        }];
        
        [task resume];
        return nil;
    }];
}

+(NSMutableURLRequest*)requestFromOptions:(NSDictionary*)options url:(NSString*)url
{
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];

    request.HTTPMethod = (options[@"method"] ?: @"GET");
    request.URL = [NSURL URLWithString:url];

    if (options[@"headers"])
        for (NSString* headerName in options[@"headers"]) {
            [request setValue:headerName forHTTPHeaderField:options[@"headers"][headerName]];
        }

    if (options[@"body"])
        request.HTTPBody = [((NSString*)options[@"body"]) dataUsingEncoding:NSUTF8StringEncoding];
    
    return request;
}

+(NSDictionary*)wrapResponse:(NSData*)data response:(NSURLResponse*)response options:(NSDictionary*)options
{
    return @{@"body": [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],
             @"headers" : ((NSHTTPURLResponse*)response).allHeaderFields,
             @"statusCode" : @(((NSHTTPURLResponse*)response).statusCode) };
}

@end
