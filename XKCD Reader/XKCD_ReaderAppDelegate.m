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
@synthesize spinner;

NSString *baseUrl = @"http://imgs.xkcd.com/comics/";
NSString *file    = @"turtles.png";
bool doAlert = true;

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification{
    XKCDScraper *scraper = [[[XKCDScraper alloc] init] autorelease];
    dict = [scraper getImageDict];
    content = [NSMutableArray new];
//    [content setArray:[dict keysSortedByValueUsingSelector:@selector(caseInsensitiveCompare:)]];
    
    // Careful with this crap ...
    int i = 0;
    for ( NSString *key in [dict allKeys] ){
            [content insertObject:key atIndex:i];
        i++;
    } 
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{    
    // Load the header logo as the default image
    //NSURL *url = [[[NSURL alloc] initWithString:@"http://imgs.xkcd.com/s/9be30a7.png"] autorelease];
    
    [spinner setStyle:NSProgressIndicatorSpinningStyle];
    [spinner setHidden:FALSE];
    [spinner display];
    
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

    [[NSAlert alertWithMessageText:@"Random Button Pressed" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Hey, don't push that!!"] runModal];
}

#pragma mark -
#pragma mark NSTableView delegate/datasource methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [content count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    //NSLog(@"Row: '%ul'",row);
   
    NSParameterAssert(row >= 0 && row < [content count]);
    
    NSString *row_obj = [content objectAtIndex:row];
    id ret = (id)[[[NSString alloc]initWithFormat:@"%@",row_obj] autorelease];
    
    return ret;
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification{
    NSLog(@"tableViewSelectionDidChange: '%@'",aNotification);
    // This does NOT trigger when I select an item in the table ...
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSLog(@"willDisplayCell: Row: '%lu'",row);
//    NSString *cell_text = [[[NSString alloc] initWithFormat:@"Cell #'%lu'",row] autorelease];
//    
//    [cell setText:cell_text];
}

@end
