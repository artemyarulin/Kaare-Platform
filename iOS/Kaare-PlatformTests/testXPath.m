#import "JSCoreTestCase.h"

@interface testXPath : JSCoreTestCase

@end

@implementation testXPath

-(void)testXPathShouldReturnAttibuteValue
{
    Kaare* kaare = [[Kaare alloc] initWithTransport:[[KaareJSCoreTransport alloc] initWithContextFinder:^JSContext *{
        return [self getContextForTestAndEvaluate:@[@"var kaare = new Kaare()",
                                                    @"var platform = new Kaare.Platform(kaare)"]];
    }]];

    KaarePlatform* platform = [[KaarePlatform alloc] initWithKaare:kaare];
    
    __block NSString* output;
    context[@"onOutput"] = ^(NSString* response) {
        output = response;
    };
    
    [context evaluateScript:[NSString stringWithFormat:@"platform.xPath('<doc hello=\\'world\\'/>','//doc/@hello').subscribe(function(output){ onOutput(output)},null,function(){ done()})"]];
    if (!isDone) WAIT_WHILE(!isDone,1);

    XCTAssertEqualObjects(@"world", output);
}

-(void)testXPathShouldReturnNode
{
    Kaare* kaare = [[Kaare alloc] initWithTransport:[[KaareJSCoreTransport alloc] initWithContextFinder:^JSContext *{
        return [self getContextForTestAndEvaluate:@[@"var kaare = new Kaare()",
                                                    @"var platform = new Kaare.Platform(kaare)"]];
    }]];
    
    KaarePlatform* platform = [[KaarePlatform alloc] initWithKaare:kaare];
    
    __block NSDictionary* output;
    context[@"onOutput"] = ^(NSDictionary* response) {
        output = response;
    };
    
    [context evaluateScript:[NSString stringWithFormat:@"platform.xPath('<doc><hello world=\\'true\\'></hello></doc>','//doc/hello').subscribe(function(output){ onOutput(output)},null,function(){ done()})"]];
    if (!isDone) WAIT_WHILE(!isDone,1);
    
    XCTAssertEqualObjects(@"hello", output[@"name"],@"There should be right name");
    XCTAssertEqualObjects(@"", output[@"value"],@"There should be no value");
    XCTAssertEqual(((NSDictionary*)output[@"attributes"]).count, (NSUInteger)1,@"There should be right number of attributes");
    XCTAssertEqualObjects(output[@"attributes"][@"world"], @"true",@"There should be right attribute");
    XCTAssertEqual(((NSArray*)output[@"children"]).count,(NSUInteger)0,@"There should no childs");
}

-(void)testXPathShouldReturnRightValueForChildNode
{
    Kaare* kaare = [[Kaare alloc] initWithTransport:[[KaareJSCoreTransport alloc] initWithContextFinder:^JSContext *{
        return [self getContextForTestAndEvaluate:@[@"var kaare = new Kaare()",
                                                    @"var platform = new Kaare.Platform(kaare)"]];
    }]];
    
    KaarePlatform* platform = [[KaarePlatform alloc] initWithKaare:kaare];
    
    __block NSDictionary* output;
    context[@"onOutput"] = ^(NSDictionary* response) {
        output = response;
    };
    
    [context evaluateScript:[NSString stringWithFormat:@"platform.xPath('<doc><hello>World</hello></doc>','//doc').subscribe(function(output){ onOutput(output)},null,function(){ done()})"]];
    if (!isDone) WAIT_WHILE(!isDone,1);
    
    XCTAssertEqual(((NSArray*)output[@"children"]).count,(NSUInteger)1,@"There should no childs");
    XCTAssertEqualObjects(output[@"children"][0][@"name"], @"hello","There should be right child name");
    XCTAssertEqualObjects(output[@"children"][0][@"value"], @"World","There should be right child value");
}

@end
