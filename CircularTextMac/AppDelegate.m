//
//  AppDelegate.m
//  CircularTextMac
//
//  Created by Jean-Luc on 14/09/2015.
//  Copyright (c) 2015 Lua Live Inc.. All rights reserved.
//

#import "AppDelegate.h"

#import "CIMLua/CIMLua.h"
#import "CIMLua/CIMLuaContextMonitor.h"

@interface AppDelegate ()
{
    CIMLuaContext* _luaContext;
    CIMLuaContextMonitor* _luaContextMonitor;
}

@end

@implementation AppDelegate

- (void) awakeFromNib
{
    // Create the Lua Context
    _luaContext = [[CIMLuaContext alloc] initWithName:@"CircularTextViewController"];
    _luaContextMonitor = [[CIMLuaContextMonitor alloc] initWithLuaContext:_luaContext connectionTimeout:5.0];
    
    // Load the "ViewController" Lua module
    [_luaContext loadLuaModuleNamed:@"ViewController"];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
