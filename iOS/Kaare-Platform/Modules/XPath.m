#import "XPath.h"
#import <GDataXMLNode.h>

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
    switch (node.kind) {
        case GDataXMLInvalidKind:
        {
            return nil;
        }
        case GDataXMLDocumentKind:
        {
            return nil;
        }
        case GDataXMLElementKind:
        {
            return [XPath wrapNodeToDicionary:node];
        }
        case GDataXMLAttributeKind:
        {
            return [node stringValue];
        }
        case GDataXMLNamespaceKind:
        {
            return nil;
        }
        case GDataXMLProcessingInstructionKind:
        {
            return nil;
        }
        case GDataXMLCommentKind:
        {
            return nil;
        }
        case GDataXMLTextKind:
        {
            return nil;
        }
        case GDataXMLDTDKind:
        {
            return nil;
        }
        case GDataXMLEntityDeclarationKind:
        {
            return nil;
        }
        case GDataXMLAttributeDeclarationKind:
        {
            return nil;
        }
        case GDataXMLElementDeclarationKind:
        {
            return nil;
        }
        case GDataXMLNotationDeclarationKind:
        {
            return nil;
        }
    }
    
    [NSException raise:@"NotSupportNodeType" format:@"Current XML node type is unsupported"];
    return nil;
}

+(NSDictionary*)wrapNodeToDicionary:(GDataXMLNode*)node
{
    NSMutableDictionary* attributes = [@{} mutableCopy];
    if ([node isKindOfClass:GDataXMLElement.class])
    {
        [((GDataXMLElement*)node).attributes enumerateObjectsUsingBlock:^(GDataXMLElement* attr, NSUInteger idx, BOOL *stop) {
            attributes[attr.name] = [attr stringValue];
        }];
    }

    NSMutableArray* childrens = [@[] mutableCopy];
    [node.children enumerateObjectsUsingBlock:^(GDataXMLNode* child, NSUInteger idx, BOOL *stop) {
        if (child.kind != GDataXMLTextKind) // We cover node content separatly as a value
            [childrens addObject:[XPath wrapNodeToDicionary:child]];
    }];
    
    return @{
             @"name": [node name],
             @"value": [node stringValue],
             @"attributes": attributes,
             @"children": childrens
           };
}

@end
