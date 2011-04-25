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
    //NSURL *url = [[[NSURL alloc] initWithString:@"http://imgs.xkcd.com/s/9be30a7.png"] autorelease];
    
    XKCDScraper *scraper = [[[XKCDScraper alloc] init] autorelease];
    //NSArray *content = [scraper getImageLinks];
    //content = [scraper getImageLinks];
    dict = [scraper getImageDict];
    content = [NSMutableArray new];
    int i = 0;
    for ( NSString *key in [dict allKeys] ){
        [content insertObject:key atIndex:i];
        i++;
    }
    
    NSLog(@"Got '%lu' image links ...", [content count]);

    [table reloadData];
    NSLog(@"Table has '%lu' entries",[table numberOfRows]);
}

-(BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    return YES;
}

- (IBAction)showRandomImage:(id)sender {
    NSLog(@"Random button pressed ...");

    [table reloadData];
    NSLog(@"Table has '%lu' entries",[table numberOfRows]);
    
    [[NSAlert alertWithMessageText:@"Random Button Pressed" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Hey, don't push that!!"] runModal];
}

#pragma mark -
#pragma mark NSTableView delegate/datasource methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [dict count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSLog(@"Row: '%lu'",row);
    //NSLog(@"Row: '%ul'",row);
   
    NSParameterAssert(row >= 0 && row < [dict count]);
//    id theRecord, theValue;
    
//    theRecord = [content objectAtIndex:row];
//    theValue = [theRecord objectForKey:[tableColumn identifier]];
    
    id ret;
    ret = [content objectAtIndex:row];
    
    return ret;
}


- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    [cell setText:[[content objectAtIndex:row] string]];
//    if ([cell isKindOfClass:[NSURL class]]) {
//        NSURL *cel = (NSURL *)cell;
//        LinkTextFieldCell *linkCell = (LinkTextFieldCell *)cell;
//        // Setup the work to be done when a link is clicked
//        linkCell.linkClickedHandler = ^(NSURL *url, id sender) {
//            [[NSWorkspace sharedWorkspace] openURL:url];
//        };
//    }
}

@end
