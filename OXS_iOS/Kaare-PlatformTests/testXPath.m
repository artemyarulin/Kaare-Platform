#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "OHHTTPStubs.h"
#import "AGWaitForAsyncTestHelper.h"
#import "KaarePlatform.h"

@interface testXPath : XCTestCase

@end

@implementation testXPath

-(void)testXPathShouldReturnAttibuteValue
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

-(void)testXPathShouldReturnNode
{
    __block BOOL isDone = NO;
    __block BOOL isNextTriggered = NO;
    
    [[Kaare.platform xPath:@"<doc><hello world='true'></hello></doc>" :@"//doc/hello"] subscribeNext:^(NSDictionary* foundNode) {
        XCTAssertEqualObjects(@"hello", foundNode[@"name"],@"There should be right name");
        XCTAssertEqualObjects(@"", foundNode[@"value"],@"There should be no value");
        XCTAssertEqual(((NSDictionary*)foundNode[@"attributes"]).count, (NSUInteger)1,@"There should be right number of attributes");
        XCTAssertEqualObjects(foundNode[@"attributes"][@"world"], @"true",@"There should be right attribute");
        XCTAssertEqual(((NSArray*)foundNode[@"children"]).count,(NSUInteger)0,@"There should no childs");
        isNextTriggered = YES;
    } completed:^{
        isDone = isNextTriggered;
    }];
    
    if (!isDone) WAIT_WHILE(!isDone, 1);
}

-(void)testXPathShouldReturnRightValueForChildNode
{
    __block BOOL isDone = NO;
    __block BOOL isNextTriggered = NO;
    
    [[Kaare.platform xPath:@"<doc><hello>World</hello></doc>" :@"//doc"] subscribeNext:^(NSDictionary* foundNode) {
        XCTAssertEqual(((NSArray*)foundNode[@"children"]).count,(NSUInteger)1,@"There should no childs");
        XCTAssertEqualObjects(foundNode[@"children"][0][@"name"], @"hello","There should be right child name");
        XCTAssertEqualObjects(foundNode[@"children"][0][@"value"], @"World","There should be right child value");
        isNextTriggered = YES;
    } completed:^{
        isDone = isNextTriggered;
    }];
    
    if (!isDone) WAIT_WHILE(!isDone, 1);
}

@end
