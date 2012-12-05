//
//  KFBAppDelegate.h
//  TouchTalk
//
//  Created by kfb on 03/12/2012.
//
//

#import <Cocoa/Cocoa.h>
#import "Novocaine.h"
#import "RingBuffer.h"
#import "DDHotKeyCenter.h"

@interface KFBAppDelegate : NSObject <NSApplicationDelegate> {
    float volume;
    BOOL muted;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSMenu *statusMenu;
@property (retain) IBOutlet NSStatusItem *statusItem;
@property (assign) IBOutlet NSMenuItem *muteMenu;
@property (assign) IBOutlet NSButton *button;

- (IBAction)toggleMute:(id)sender;
- (IBAction)quit:(id)sender;

- (void)mute;
- (void)unmute;

@end
