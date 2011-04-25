//
//  XKCD_ReaderAppDelegate.m
//  XKCD Reader
//
//  Created by marc on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XKCD_ReaderAppDelegate.h"
#import <stdlib.h>

#define MYDEBUG 0

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
    scraper = [[XKCDScraper alloc] init];
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
    NSURL *logo_url = [[[NSURL alloc] initWithString:@"http://imgs.xkcd.com/s/9be30a7.png"] autorelease];
    
    NSImage *logo_image = [[[NSImage alloc] initWithContentsOfURL:logo_url] autorelease];
    [xkcdImage setImage:logo_image];
    
//    [xkcdImage setAutoresizes:TRUE];
//    [xkcdImage setImageWithURL:logo_url];

    [spinner setStyle:NSProgressIndicatorSpinningStyle];
    [spinner setHidden:FALSE];
    [spinner display];
    
    NSLog(@"Got '%lu' image links ...", [content count]);

    [table reloadData];
    NSLog(@"Table has '%lu' entries",[table numberOfRows]);
}

- (void)dealloc
{
    [scraper release];
}

-(BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    return YES;
}

- (IBAction)showRandomImage:(id)sender {
    NSLog(@"Random button pressed ...");

    // Do something fun
    int random_elem = rand() % ( (int)[content count] - 1 );
    NSLog(@"Random element: '%d'",random_elem);
    
    NSString *comic_str = [content objectAtIndex:random_elem];
    
    NSURL *comic_url = [dict objectForKey:comic_str];
    NSLog(@"Comic URL: '%@'",comic_url);


    NSURL *image_url = [scraper get_image:comic_url];
    NSLog(@"Image URL: '%@'",image_url);
    
    NSImage *xkcd_image = [[[NSImage alloc] initWithContentsOfURL:image_url] autorelease];
    [xkcdImage setImage:xkcd_image];
    
//    NSString *random_comic = [content objectAtIndex:random_elem];
//    NSLog(@"Random comic  : '%@'",random_comic);
//    NSString *image_url = [scraper get_image:[dict objectForKey:random_comic]];
//    NSLog(@"Image URL     : '%@'",image_url);
//    NSURL *random_url = [[[NSURL alloc] initWithString:image_url] autorelease];
//    NSImage *random_image = [[[NSImage alloc] initWithContentsOfURL:random_url] autorelease];
//    [xkcdImage setImage:random_image];

//    [[NSAlert alertWithMessageText:@"Random Button Pressed" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Hey, don't push that!!"] runModal];
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

- (void)tableSelectionChanged:(id)notification
{
    NSLog(@"tableSelectionChanged: '%@'",notification);
//
//    NSLog(@"tableSelectionChanged");
//	[ self resetSentence ];
}


- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn{
    NSLog(@"didClickTableColumn: '%@'",tableColumn);
    
}
- (void)tableViewSelectionDidChange:(NSNotification *)notification{
    //NSLog(@"tableViewSelectionDidChange: '%@'",notification);
    NSLog(@"** Entering: tableViewSelectionDidChange **");
    NSInteger rowIndex;
    NSURL *image = NULL;
    
    // What was selected. Skip out if the row has not changed.
    rowIndex = [(NSTableView *)[notification object] selectedRow];
    if (rowIndex >= 0)
    {
        if ( MYDEBUG ){
            NSLog(@"Selected row '%ld'", rowIndex);
        }
        
        // Do something fun
        NSString *comic_str = [content objectAtIndex:rowIndex];
        
        NSURL *comic_url = [dict objectForKey:comic_str];
        NSLog(@"Comic URL: '%@'",comic_url);
        
        image = [scraper get_image:comic_url];
        NSLog(@"Image URL: '%@'",image);

        NSImage *xkcd_image = [[[NSImage alloc] initWithContentsOfURL:image] autorelease];
        [xkcdImage setImage:xkcd_image];
        
        //[xkcdImage setImageWithURL:image];
    }
    NSLog(@"** Exiting : tableViewSelectionDidChange **");
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {    
    //NSLog(@"willDisplayCell: Row: '%lu'",row);
}

@end
