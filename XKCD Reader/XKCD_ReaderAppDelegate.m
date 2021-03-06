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
@synthesize titleLabel;
@synthesize filterBox;

NSString *baseUrl = @"http://imgs.xkcd.com/comics/";
NSString *file    = @"turtles.png";
bool doAlert = true;

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification{
    scraper = [[XKCDScraper alloc] init];
    dict = [scraper getImageDict];
    content = [NSMutableArray new];
    
    // Careful with this crap ...
    // Trying to sort them:
    //[content setArray:[dict keysSortedByValueUsingSelector:@selector(caseInsensitiveCompare:)]];    
    int i = 0;
    for ( NSString *key in [dict allKeys] ){
            [content insertObject:key atIndex:i];
        i++;
    } 
    // end Careful with this crap ...
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{    
    // Load the header logo as the default image
    NSURL *logo_url = [[[NSURL alloc] initWithString:@"http://imgs.xkcd.com/s/9be30a7.png"] autorelease];
    
    NSImage *logo_image = [[[NSImage alloc] initWithContentsOfURL:logo_url] autorelease];
    [xkcdImage setImage:logo_image];
    [titleLabel setTitleWithMnemonic:@"XKCD"];
    
    [spinner setStyle:NSProgressIndicatorSpinningStyle];
    [spinner setHidden:FALSE];
    [spinner display];
    
    if ( MYDEBUG ){
        NSLog(@"Got '%lu' image links ...", [content count]);
    }
    
    [table reloadData];
    if ( MYDEBUG ){
        NSLog(@"Table has '%lu' entries",[table numberOfRows]);
    }
}

- (void)dealloc{
    [scraper release];
    [dict release];
    [content release];
    [xkcdImage release];
    [super dealloc];
}

-(BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication{
    return YES;
}

- (IBAction)saveCurrent:(id)sender{
    
    if ( MYDEBUG ){
        NSLog(@"Save button pressed ...");
    }
    
    [[NSAlert alertWithMessageText:@"Button Pressed!!" defaultButton:@"Go Away" alternateButton:nil otherButton:nil informativeTextWithFormat:@"I bet you thought pushing that button would do something interesting.  You were wrong ..."] runModal];
    
}

- (IBAction)showRandomImage:(id)sender {
    
    if ( MYDEBUG ){    
        NSLog(@"Random button pressed ...");
    }
    
    // Do something fun
    [spinner startAnimation:nil];
    srand((unsigned)time(NULL));
    int random_elem = rand() % ( (int)[content count] - 1 );
    
    NSString *comic_str = [content objectAtIndex:random_elem];
    
    NSURL *comic_url = [dict objectForKey:comic_str];
    NSURL *image_url = [scraper get_image:comic_url];
        
    if ( MYDEBUG ){
        NSLog(@"Random element: '%d'",random_elem);
        NSLog(@"Comic URL: '%@'",comic_url);
        NSLog(@"Image URL: '%@'",image_url);
    }
    
    NSImage *xkcd_image = [[[NSImage alloc] initWithContentsOfURL:image_url] autorelease];
    [xkcdImage setImage:xkcd_image];
    [titleLabel setTitleWithMnemonic:comic_str];
    [spinner stopAnimation:nil];
    
    // Select and focus on the randomly selected item
    NSIndexSet *row_to_select = [[[NSIndexSet alloc] initWithIndex:random_elem] autorelease];
    [table selectRowIndexes:row_to_select byExtendingSelection:FALSE];
    [table scrollRowToVisible:random_elem];
}

- (IBAction)filterList:(id)sender {
    
}

#pragma mark -
#pragma mark NSTableView delegate/datasource methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {

    return [content count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSParameterAssert(row >= 0 && row < [content count]);
    
    NSString *row_obj = [content objectAtIndex:row];
    id ret = (id)[[[NSString alloc]initWithFormat:@"%@",row_obj] autorelease];
    
    return ret;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification{
    
    if ( MYDEBUG ){
        NSLog(@"** Entering: tableViewSelectionDidChange **");
    }
            
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
        
        image = [scraper get_image:comic_url];
        
        if ( MYDEBUG ){    
            NSLog(@"Comic URL: '%@'",comic_url);
            NSLog(@"Image URL: '%@'",image);
        }
        
        NSImage *xkcd_image = [[[NSImage alloc] initWithContentsOfURL:image] autorelease];
        [xkcdImage setImage:xkcd_image];
        [titleLabel setTitleWithMnemonic:comic_str];
        [spinner stopAnimation:nil];
        //[xkcdImage setImageWithURL:image];
    }
    
    if ( MYDEBUG ){
        NSLog(@"** Exiting : tableViewSelectionDidChange **");
    }
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {    

}

- (void)tableSelectionChanged:(id)notification{
    
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn{
    // This is the action called when someone clicks the table header, typically a "sort" of the table
    
    //NSLog(@"didClickTableColumn: '%@'",tableColumn);
    
}

// I don't have any better place for this snippet:
//[[NSAlert alertWithMessageText:@"Random Button Pressed" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Hey, don't push that!!"] runModal];

@end
