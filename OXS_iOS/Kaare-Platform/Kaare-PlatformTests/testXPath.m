#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "OHHTTPStubs.h"
#import "AGWaitForAsyncTestHelper.h"
#import "KaarePlatform.h"

@interface testXPath : XCTestCase

@end

@implementation testXPath

-(void)testXPathShouldReturnStrings
{
    __block BOOL isDone = NO;
    __block BOOL isNextTriggered = NO;

    [[Kaare.platform xPath:@"<doc hello='world'/>" :@"//doc/@hello"] subscribeNext:^(NSString* attrValue) {
        XCTAssertEqualObjects(@"world", attrValue);
        isNextTriggered = YES;
    } completed:^{
        isDone = isNextTriggered;
    }];
    
    if (!isDone) WAIT_WHILE(!isDone, 1);
}


@end
