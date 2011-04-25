//
//  XKCD_ReaderAppDelegate.m
//  XKCD Reader
//
//  Created by marc on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XKCD_ReaderAppDelegate.h"

@implementation XKCD_ReaderAppDelegate

@synthesize window;
@synthesize randButton;
@synthesize xkcdBrowser;
@synthesize xkcdImage;

NSString *baseUrl = @"http://imgs.xkcd.com/comics/";
NSString *file    = @"turtles.png";
bool doAlert = true;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{    
    // Load the header logo as the default image
    NSURL *url = [[[NSURL alloc] initWithString:@"http://imgs.xkcd.com/s/9be30a7.png"] autorelease];

    [xkcdImage setAutoresizes:TRUE];
    [xkcdImage setImageWithURL:url];
}

- (void)applicationDidUpdate:(NSNotification *)aNotification{
//    NSLog(@"applicationDidUpdate!!");
}

-(BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    return YES;
}

- (IBAction)showRandomImage:(id)sender {
    NSLog(@"Random button pressed ...");
    
    XKCDScraper *scraper = [[[XKCDScraper alloc] init] autorelease];
    NSArray *content = [scraper getImageLinks];
    
    NSLog(@"Got '%lu' image links ...\n\n", [content count]);
    
    
    
    // | Replace informativeTextWithFormat:@"Help!"
    // v With    informativeTextWithFormat:content
//    [[NSAlert alertWithMessageText:@"Random Button Pressed" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Help!"] runModal];
}
@end
