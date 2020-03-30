//
//  FTUWebActionManager.m
//  FTUWebView
//
//  Created by ke on 2020/3/30.
//  Copyright © 2020 ke. All rights reserved.
//

#import "FTUWebActionManager.h"

@implementation FTUWebActionManager
{
    NSMutableArray *_urlFilterObjects;
    NSMutableArray *_jsBridgeObjects;
//    FTUWebActionStoreManager *_storeManager;
    NSHashTable *_observers;
}

#pragma mark - URLFilter
- (void)setupWithURLFilterConfigPath:(NSString *)configPath {
    NSArray *objects = [[NSArray alloc] initWithContentsOfFile:configPath];
    [self.urlFilterObjects removeAllObjects];
    for (NSString *className in objects) {
        __kindof FTUWebURLFilterObject *object = [[NSClassFromString(className) alloc] init];
        if (object != nil) {
            [self.urlFilterObjects addObject:object];
        }
    }
}


- (void)addURLFilterObject: (FTUWebURLFilterObject *)object {
    if (object != nil) {
        [self.urlFilterObjects addObject:object];
    }
}

- (void)removeURLFilterObject: (FTUWebURLFilterObject *)object {
    [self.urlFilterObjects removeObject:object];
}

- (void)removeAllURLFilterObject {
    [self.urlFilterObjects removeAllObjects];
}

- (FTUWebURLFilterObject *)URLFilterObjectWithURL: (NSString *)URL {
    for (FTUWebURLFilterObject *object in self.urlFilterObjects) {
        if ([object.url isEqualToString:URL] || [object.url containsString:URL] || [URL containsString:object.url]) {
            return object;
        }
    }
    return nil;
}

- (NSArray<FTUWebURLFilterObject *> *)allURLFilterObjects {
    return [[NSArray alloc] initWithArray:self.urlFilterObjects];
}

#pragma mark - JSBridge

- (void)setupWithJSBridgeConfigPath:(NSString *)configPath {
    NSArray *objects = [[NSArray alloc] initWithContentsOfFile:configPath];
    [self.jsBridgeObjects removeAllObjects];
    for (NSString *className in objects) {
        __kindof FTUWebJSBridgeObject *object = [[NSClassFromString(className) alloc] init];
        if (object != nil) {
            [self.jsBridgeObjects addObject:object];
        }
    }
}

- (void)addJSBridgeObject: (FTUWebJSBridgeObject *)object {
    if (object != nil) {
        [self.jsBridgeObjects addObject:object];
    }
}

- (void)removeJSBridgeObject: (FTUWebJSBridgeObject *)object {
    [self.jsBridgeObjects removeObject:object];
}

- (void)removeAllJSBridgeObject {
    [self.jsBridgeObjects removeAllObjects];
}

- (FTUWebJSBridgeObject *)JSBridgeObjectWithName: (NSString *)name {
    for (FTUWebJSBridgeObject *object in self.jsBridgeObjects) {
        if ([object.name isEqualToString:name]) {
            return object;
        }
    }
    return nil;
}

- (NSArray<FTUWebJSBridgeObject *> *)JSBridgeObjectsWithType:(FTUWebJSBridgeObjectType)type {
    return [self.jsBridgeObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type == %ld", type]];
}

- (NSArray<FTUWebJSBridgeObject *> *)allJSBridgeObjects {
    return [[NSArray alloc] initWithArray:self.jsBridgeObjects];
}

#pragma mark - Lazy Load

- (NSMutableArray *)urlFilterObjects {
    if (_urlFilterObjects == nil) {
        _urlFilterObjects = [[NSMutableArray alloc] init];
    }
    return _urlFilterObjects;
}

- (NSMutableArray *)jsBridgeObjects {
    if (_jsBridgeObjects == nil) {
        _jsBridgeObjects = [[NSMutableArray alloc] init];
    }
    return _jsBridgeObjects;
}

- (void)reset {
    [self.urlFilterObjects removeAllObjects];
    [self.jsBridgeObjects removeAllObjects];
}


@end
