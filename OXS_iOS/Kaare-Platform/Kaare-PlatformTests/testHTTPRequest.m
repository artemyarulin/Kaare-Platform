#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "OHHTTPStubs.h"
#import "AGWaitForAsyncTestHelper.h"
#import "KaarePlatform.h"

@interface testHTTPRequest : XCTestCase

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
    
    __block BOOL isDone = NO;
    __block BOOL isNextTriggered = NO;
    [[Kaare.platform httpRequest:@"http://example.com"] subscribeNext:^(NSDictionary* response) {
        XCTAssertEqual([response[@"statusCode"] intValue], expectedStatusCode, @"Status code shoud be right");
        XCTAssertEqualObjects(response[@"body"], expectedBody,@"Response body should be right");
        NSDictionary* headers = response[@"headers"];
        
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            XCTAssert([obj isEqualToString:expectedHeaders[key]] , @"Each header item should be presented");
        }];
        
        isNextTriggered = YES;
    } completed:^{
        isDone = isNextTriggered;
    }];
    
    if (!isDone) WAIT_WHILE(!isDone, 100);
}

@end
