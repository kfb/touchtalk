//
//  KFBAppDelegate.m
//  TouchTalk
//
//  Created by kfb on 03/12/2012.
//
//

#import "KFBAppDelegate.h"

@implementation KFBAppDelegate

- (void)awakeFromNib
{
    _statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
    
    if (_statusItem == nil)
    {
        NSLog(@"Couldn't create statusItem!");
        
        [NSApp terminate:nil];
    }
    else
    {
        [_statusItem setTitle:@"TT"];
        [_statusItem setHighlightMode:YES];
        [_statusItem setMenu:_statusMenu];
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self unmute];
    
    // the audio manager
    Novocaine *audioManager = [Novocaine audioManager];
    
    // a ring buffer to store incoming mic data
    RingBuffer *buffer = new RingBuffer(512, 2);
    
    // capture the mic input into the ring buffer
    [audioManager setInputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels) {
        vDSP_vsmul(data, 1, &volume, data, 1, numFrames*numChannels);
        buffer->AddNewInterleavedFloatData(data, numFrames, numChannels);
    }];
    
    // throw it out to the output device
    [audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels) {
        buffer->FetchInterleavedData(data, numFrames, numChannels);
    }];
    
    NSLog(@"Installing key handler...");
    
    DDHotKeyCenter *hotKeyCenter = [[[DDHotKeyCenter alloc] init] autorelease];
    
    [hotKeyCenter registerHotKeyWithKeyCode:46 modifierFlags:NSShiftKeyMask|NSCommandKeyMask task:^(NSEvent *) {
        [self toggleMute:self];
    }];
}

- (IBAction)toggleMute:(id)sender
{
    if (muted) {
        [self unmute];
    } else {
        [self mute];
    }
}

- (IBAction)quit:(id)sender
{
    [NSApp terminate:nil];
}

- (void)mute
{
    volume = 0.0f;
    muted = YES;
    
    [[self button] setTitle:@"Unmute"];
    [[self muteMenu] setTitle:@"Unmute"];
}

- (void)unmute
{
    volume = 1.0f;
    muted = NO;
    
    [[self button] setTitle:@"Mute"];
    [[self muteMenu] setTitle:@"Mute"];
}

@end
