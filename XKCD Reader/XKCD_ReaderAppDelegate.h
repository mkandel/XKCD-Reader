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
    NSBrowser *xkcdBrowser;
    IKImageView *xkcdImage;
}
- (IBAction)showRandomImage:(id)sender;

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSButton *randButton;
@property (assign) IBOutlet NSBrowser *xkcdBrowser;
@property (assign) IBOutlet IKImageView *xkcdImage;

@end
