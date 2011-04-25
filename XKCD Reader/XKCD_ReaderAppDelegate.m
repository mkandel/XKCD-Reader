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
@synthesize xkcdImage;
@synthesize table;

NSString *baseUrl = @"http://imgs.xkcd.com/comics/";
NSString *file    = @"turtles.png";
bool doAlert = true;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{    
    // Load the header logo as the default image
    NSURL *url = [[[NSURL alloc] initWithString:@"http://imgs.xkcd.com/s/9be30a7.png"] autorelease];
    
    XKCDScraper *scraper = [[[XKCDScraper alloc] init] autorelease];
    NSArray *content = [scraper getImageLinks];
    
    NSLog(@"Got '%lu' image links ...\n\n", [content count]);

//    [xkcdImage setAutoresizes:TRUE];
//    [xkcdImage setAutoresizesSubviews:TRUE];
//    [xkcdImage setImageWithURL:url];
}

-(BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    return YES;
}

- (IBAction)showRandomImage:(id)sender {
    NSLog(@"Random button pressed ...");
    
    [[NSAlert alertWithMessageText:@"Random Button Pressed" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Hey, don't push that!!"] runModal];
}



@end
