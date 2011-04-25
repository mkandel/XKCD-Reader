//
//  XKCDScraper.m
//  XKCD Reader
//
//  Created by marc on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XKCDScraper.h"
#import "HTMLParser.h"
//#import <RegexKit/RegexKit.h>
#import "RegexKitLite.h"

#define MYDEBUG 0

@implementation XKCDScraper
@synthesize webView;
- (id)init
{
    self = [super init];
    url = [[NSURL alloc] initWithString:@"http://xkcd.com/archive/"];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [webView release];
    [url release];
    [super dealloc];
}

- (NSArray *)getImageLinks{
    //NSError **err = nil;
    //NSString *retVal = [[[NSString alloc] initWithURL:url] autorelease];
    //NSString *retVal = [NSString stringWithContentsOfURL:url encoding:NSStringEncodingConversionExternalRepresentation error:err];
    //NSLog(@"%@", retVal);
    NSArray *retVal = [[[NSArray alloc] init] autorelease];
    
    NSDictionary * myerror = nil;
    //NSError * myerror = nil;
    HTMLParser *parser = [[[HTMLParser alloc] initWithContentsOfURL:url error:&myerror] autorelease];
    if (myerror) {
        NSLog(@"Error: %@", myerror);
        return nil;
    }
    HTMLNode * bodyNode = [parser body];
    
    // Lines we want to match:
    // <a href="/1/" title="2006-1-1">Barrel - Part 1</a><br/>
    // and we want to scrape the href part
    NSArray * inputNodes = [bodyNode findChildTags:@"a"];
    NSLog(@"There are '%lu' a nodes", [inputNodes count]);

    // Counters ... duh ...
    int total_count = 0;
    int good_count  = 0;
    
    for (HTMLNode * inputNode in inputNodes) {
        total_count++;
        
        if (MYDEBUG) {
            NSLog( @"total: %d", total_count);
        }
        
        if (MYDEBUG){
            NSString *title = [[[NSString alloc]initWithFormat:@"%@",[inputNode allContents]] autorelease];
            NSString *raw = [[[NSString alloc]initWithFormat:@"%@",[inputNode rawContents]] autorelease];
            NSLog( @"value: '%@'", title );
            NSLog( @"  raw: '%@'", raw );
            NSLog( @"class: %@", [inputNode className]);
            NSLog (@"  tag: %@", [inputNode tagName]);
            NSLog( @" good: %d", good_count );
        }
        
        // Testing, only process first 25 lines:
        if ( total_count > 25 ) break;
    }

    return retVal;
}

@end
