//
//  EverPasteAppDelegate.h
//  EverPaste
//
//  Copyright 2010 Ryan Detzel. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface EverPasteAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	
	NSPasteboard *generalPB;
    int changeCount;
	NSTimer	*timer, *tmp_timer;
	
	IBOutlet NSMenu *statusMenu;
	IBOutlet NSTextField *urlTextField;
	
	NSStatusItem *statusItem;
    NSImage *statusImage;
	NSImage *statusImageSave;
}

@property (assign) IBOutlet NSWindow *window;

-(IBAction)quit:(id)sender;
-(IBAction)showSettings:(id)sender;
-(IBAction)saveSettings:(id)sender;
-(IBAction)closeSettings:(id)sender;

-(void)sendData:(NSData	*)data;
- (NSString *)currentHour;

@end
