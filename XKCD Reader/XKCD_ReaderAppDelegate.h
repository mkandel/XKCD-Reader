//
//  XKCD_ReaderAppDelegate.h
//  XKCD Reader
//
//  Created by marc on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import <stdlib.h>
#import "XKCDScraper.h"

@interface XKCD_ReaderAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
    NSButton *randButton;
    //IKImageView *xkcdImage;
    NSImageView *xkcdImage;
    NSTableView *table;
    NSProgressIndicator *spinner;
    NSButton *saveButton;
    NSMutableDictionary *dict;
    NSMutableArray *content;
    XKCDScraper *scraper;
}
- (IBAction)showRandomImage:(id)sender;
- (IBAction)saveCurrent:(id)sender;

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn;
- (void)tableViewSelectionDidChange:(NSNotification *)aNotification;
- (void)tableSelectionChanged:(id)notification;

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSButton *randButton;
//@property (assign) IBOutlet IKImageView *xkcdImage;
@property (assign) IBOutlet NSImageView *xkcdImage;
@property (assign) IBOutlet NSTableView *table;
@property (assign) IBOutlet NSProgressIndicator *spinner;
@property (assign) IBOutlet NSButton *saveButton;

@end