//
//  EverPasteAppDelegate.m
//  EverPaste
//
//  Copyright 2010 Ryan Detzel. All rights reserved.
//

#import "EverPasteAppDelegate.h"

@implementation EverPasteAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	generalPB = [[NSPasteboard generalPasteboard] retain];
	changeCount = [generalPB changeCount];
	
	timer = [[NSTimer scheduledTimerWithTimeInterval:0.5f
											  target:self
											selector:@selector(checkPasteboardCount:)
											userInfo:nil
											 repeats:YES] retain];
	 
}

- (void) awakeFromNib{
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
    statusImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon" ofType:@"png"]];
	statusImageSave = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon-save" ofType:@"png"]];
	
	[statusImageSave retain];
	[statusItem retain];
	
	[statusItem setImage:statusImage];    
    [statusItem setMenu:statusMenu];
}

-(IBAction)closeSettings:(id)sender{
	[window close];
}

-(IBAction)saveSettings:(id)sender{
	[[NSUserDefaults standardUserDefaults] setValue:[urlTextField stringValue] forKey:@"url"];
	[self closeSettings:sender];
}

-(IBAction)showSettings:(id)sender{
	NSString *url = [[NSUserDefaults standardUserDefaults] stringForKey:@"url"];
	if (url != nil){
		[urlTextField setStringValue:url];
	}
	
	[window center];
	[NSApp arrangeInFront:sender];
	[window makeKeyAndOrderFront:sender];
	[NSApp activateIgnoringOtherApps:YES];
}

-(IBAction)quit:(id)sender{
	[[NSApplication sharedApplication] terminate:sender];
}

- (void)checkPasteboardCount:(NSTimer *)timer {
    if(changeCount != [generalPB changeCount]) {
        changeCount = [generalPB changeCount];
		
		NSData *data;
		NSString *str;
		
		data = [generalPB dataForType:@"NSStringPboardType"];
		if (data){
			str = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
			[self sendData:data];
		}
    }
}

- (NSString *)urlEncodeValue:(NSString *)str{
	NSString *result = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR("?=&+"), kCFStringEncodingUTF8);
	return [result autorelease];
}

- (NSString *)currentHour{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | 
									NSMonthCalendarUnit | 
									NSDayCalendarUnit | 
									NSHourCalendarUnit | 
									NSMinuteCalendarUnit | 
									NSSecondCalendarUnit fromDate:now];
		
	return [NSString stringWithFormat:@"%d-%d-%d %d:%d:%d",
			[components year],
			[components month],
			[components day],
			[components hour],
			[components minute],
			[components second]
			];
}

-(void)resetIcon{
	NSLog(@"Reset");
	[statusItem setImage:statusImage];    
}

-(void)sendData:(NSData	*)data{
	NSString *urlString = [[NSUserDefaults standardUserDefaults] stringForKey:@"url"];
	 
	if (urlString == nil){
		return;
	}
	
	NSString *post = [NSString stringWithFormat:@"data=%@&inserted=%@",
					  [self urlEncodeValue:[[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease]],
					  [self urlEncodeValue:[self currentHour]]];
	
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
	
	NSError *error = nil;
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
	
	if (error){
		NSLog(@"Something wrong %@", error);
	}
	else{
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
		NSLog(@"%@",returnString);
		//[statusItem setImage:statusImageSave];    
		//tmp_timer = [NSTimer scheduledTimerWithTimeInterval: 3.0 target:self selector:@selector(resetIcon) userInfo:nil repeats: NO]; 
	}
}


@end
