//
//  ViewController.m
//  CircularTextMac
//
//  Created by Jean-Luc on 14/09/2015.
//  Copyright (c) 2015 Lua Live Inc.. All rights reserved.
//

#import "ViewController.h"

#import "CIMLua/CIMLua.h"

@implementation ViewController

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLuaModuleLoadedNotification:) name:kCIMLuaModuleLoadedNotification object:nil];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void) handleLuaModuleLoadedNotification:(NSNotification*)notification
{
    if ([self isKindOfClass:NSClassFromString(notification.object)])
    {
        // The loaded Lua module was a class extension for this object (named according to the extended class by convention)
        [(id<CIMLuaObject>)self promoteAsLuaObject];
    }
}

@end
