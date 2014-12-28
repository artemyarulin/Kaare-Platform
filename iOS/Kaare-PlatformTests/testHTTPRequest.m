#import "JSCoreTestCase.h"

@interface testHTTPRequest : JSCoreTestCase
@end

@implementation testHTTPRequest

-(void)testHTTPRequestSimpleGetShouldWork
{
    NSString* expectedBody = @"HelloWorld";
    int expectedStatusCode = 200;
    NSDictionary* expectedHeaders = @{@"Content-Type": @"text/plain",
                                      @"Set-Cookie": @"A=B",
                                      @"Content-Length": [NSString stringWithFormat:@"%d",expectedBody.length]};
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithData:[expectedBody dataUsingEncoding:NSUTF8StringEncoding]
                                          statusCode:expectedStatusCode
                                             headers:expectedHeaders];
    }];
    
    Kaare* kaare = [[Kaare alloc] initWithTransport:[[KaareJSCoreTransport alloc] initWithContextFinder:^JSContext *{
        return [self getContextForTestAndEvaluate:@[@"var kaare = new Kaare()",
                                                    @"var platform = new Kaare.Platform(kaare)"]];
    }]];
    KaarePlatform* platform = [[KaarePlatform alloc] initWithKaare:kaare];
    
    __block NSDictionary* output;
    context[@"onResponse"] = ^(NSDictionary* response) {
        output = response;
    };
    
    [context evaluateScript:[NSString stringWithFormat:@"platform.httpRequest('http://example.com').subscribe(function(resp){ onResponse(resp)},null,function(){ done()})"]];
    if (!isDone) WAIT_WHILE(!isDone,2);
    

    XCTAssertEqual([output[@"statusCode"] intValue], expectedStatusCode, @"Status code shoud be right");
    XCTAssertEqualObjects(output[@"body"], expectedBody,@"Response body should be right");
    NSDictionary* headers = output[@"headers"];
    
    [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        XCTAssert([obj isEqualToString:expectedHeaders[key]] , @"Each header item should be presented");
    }];
}

@end
