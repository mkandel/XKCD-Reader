//
//  XKCD_ReaderAppDelegate.m
//  XKCD Reader
//
//  Created by marc on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XKCD_ReaderAppDelegate.h"
#import <stdlib.h>
#include <time.h>

#define MYDEBUG 0

@implementation XKCD_ReaderAppDelegate

@synthesize window;
@synthesize randButton;
@synthesize xkcdImage;
@synthesize table;
@synthesize spinner;
@synthesize saveButton;

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
//    [spinner startAnimation:nil];
    
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

- (IBAction)saveCurrent:(id)sender{
    NSLog(@"Save button pressed ...");
    [[NSAlert alertWithMessageText:@"Save Button Pressed" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Save not implemented, sorry!!"] runModal];
    
}

- (IBAction)showRandomImage:(id)sender {
    NSLog(@"Random button pressed ...");

    // Do something fun
    [spinner startAnimation:nil];
    srand((unsigned)time(NULL));
    int random_elem = rand() % ( (int)[content count] - 1 );
    NSLog(@"Random element: '%d'",random_elem);
    
    NSString *comic_str = [content objectAtIndex:random_elem];
    
    NSURL *comic_url = [dict objectForKey:comic_str];
    NSLog(@"Comic URL: '%@'",comic_url);


    NSURL *image_url = [scraper get_image:comic_url];
    NSLog(@"Image URL: '%@'",image_url);
    
    NSImage *xkcd_image = [[[NSImage alloc] initWithContentsOfURL:image_url] autorelease];
    [xkcdImage setImage:xkcd_image];
    [spinner stopAnimation:nil];
    
    // Select and focus on the randomly selected item
//    NSCell *cell = [table preparedCellAtColumn:0 row:random_elem];
//    [table shouldFocusCell:cell atColumn:0 row:random_elem];
    
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
        [spinner startAnimation:nil];
        NSString *comic_str = [content objectAtIndex:rowIndex];
        
        NSURL *comic_url = [dict objectForKey:comic_str];
        NSLog(@"Comic URL: '%@'",comic_url);
        
        image = [scraper get_image:comic_url];
        NSLog(@"Image URL: '%@'",image);

        NSImage *xkcd_image = [[[NSImage alloc] initWithContentsOfURL:image] autorelease];
        [xkcdImage setImage:xkcd_image];
        
        [spinner stopAnimation:nil];
        //[xkcdImage setImageWithURL:image];
    }
    NSLog(@"** Exiting : tableViewSelectionDidChange **");
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {    
    //NSLog(@"willDisplayCell: Row: '%lu'",row);
}

@end
