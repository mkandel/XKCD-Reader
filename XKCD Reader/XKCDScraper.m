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

NSMutableDictionary *get_data();
NSURL *get_image_url( NSString * );

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
    
    NSMutableDictionary *image_data = get_data();
    
    NSArray *retVal = [[[NSArray alloc] initWithArray:[image_data allKeys]] autorelease];
    
    return retVal;
}

- (NSMutableDictionary *)getImageDict{
//    NSMutableDictionary *ret;
//    NSMutableDictionary *tmp;
//    
//    tmp = get_data();
//    
//    NSMutableArray *keys = [NSMutableArray arrayWithArray:[tmp allKeys] ];
//    for ( NSString *comic_name in keys ){
//        NSURL *comic_url = 
//    }
//    
//    return ret;

    return get_data();
}

- (NSURL *)get_image:(NSURL *) comic_url{
    NSURL *ret = NULL;

    NSError *myerror = NULL;
    NSString *comic_html = [[[NSString alloc] initWithContentsOfURL:comic_url encoding:NSStringEncodingConversionExternalRepresentation error:&myerror] autorelease];
    
    // process HTML
    HTMLParser *parser = [[[HTMLParser alloc] initWithString:comic_html error:&myerror] autorelease];
    if (myerror) {
        NSLog(@"Error: %@", myerror);
        exit(1);
    }
    HTMLNode * bodyNode = [parser body];
//    NSLog(@"Node: '%@'", [bodyNode rawContents]);
    
    // Grab all of the 'img' nodes
    NSArray * inputNodes = [bodyNode findChildTags:@"img"];
    
    for( HTMLNode *node in inputNodes ){
        NSString *raw = [node rawContents];
        if ( MYDEBUG ){
            NSLog(@"** raw: '%@'", raw);
        }
        // <img src="http://imgs.xkcd.com/comics/automatic_doors.png" title="I hope no automatic doors I know read this.  I would be so embarrassed." alt="Automatic Doors">
//        NSString *regex_str = @"<img src=\"(.*)\" title=\".*\" alt=\".*\">";
        NSString *regex_str = @"<img src=\"(.*)\" title=.*>";
        NSString *image_url_str = [raw stringByMatching:regex_str capture:1L];
        if( image_url_str ){
            if ( MYDEBUG ){
                NSLog(@"url: '%@'", image_url_str);
            }
            ret = [[[NSURL alloc] initWithString:image_url_str] autorelease];
        }
    }
    
    return ret;
}

NSMutableDictionary * get_data(){
    
    if ( MYDEBUG ){
        NSLog( @"Entered get_data()" );
    }
    // My return object
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
    
    // My all-purpose error object:
    NSError *myerror = NULL;
    
    // Get archive page HTML content
    NSURL *url = [[[NSURL alloc] initWithString:@"http://xkcd.com/archive/"] autorelease];
    NSString *archive_html = [[[NSString alloc] initWithContentsOfURL:url encoding:NSStringEncodingConversionExternalRepresentation error:&myerror] autorelease];
    
    // process HTML
    HTMLParser *parser = [[[HTMLParser alloc] initWithString:archive_html error:&myerror] autorelease];
    if (myerror) {
        NSLog(@"Error: %@", myerror);
        exit(1);
    }
    HTMLNode * bodyNode = [parser body];
    
    // Grab all of the 'a' nodes
    NSArray * inputNodes = [bodyNode findChildTags:@"a"];
    
    // Process the a nodes
    int total_count = 0;
    int good_count  = 0;
    for (HTMLNode * inputNode in inputNodes) {
        total_count++;
        //        NSLog( @"total: %d", total_count);
        
        NSString *raw = [[[NSString alloc]initWithFormat:@"%@",[inputNode rawContents]] autorelease];
        
        /*
         
         Example line I'm scraping:
         
         <a href="/1/" title="2006-1-1">Barrel - Part 1</a>
         
         Regex in Perl code:
         
         m/
         <a href="/
         (\d+)                # the directory, we'll append this to the base URL
         /" title="
         .*                   # the alt-text which is the date whic we don't need
         ">
         (.*)                 # the comic title, we'll display this in the UI
         </a>
         /x
         
         Simple Perl RegEx
         
         <a href="/(\d+)/" title=".*">(.*)</a>
         
         In Perl I'd make a hash as the next lines:
         
         my %dir_for_title;
         $dir_for_title{ $2 } = $1;
         
         Maybe I can use an NSDictionary as a hash?
         
         I can!!  Woo hoo!!
         
         */
        
        NSString *regex_str = @"<a href=\"/(\\d+)/\" title=\".*\">(.*)</a>";
        
        int dir = [[raw stringByMatching:regex_str capture:1L] intValue];
        NSString *dir_str = [[[NSString alloc] initWithFormat:@"%d", dir] autorelease];
        NSString *name = [raw stringByMatching:regex_str capture:2L];
        
        if( dir && name ){
            good_count++;
            if ( MYDEBUG ){
                NSLog( @"  raw: '%@'", raw );
                NSLog( @" name: '%@'", name );
                NSLog (@"  dir: '%d'", dir );
                //NSLog( @" good: %d", good_count );
            }
            
            //Create the image URL
            NSURL *img_url = get_image_url( dir_str );
            
            // Add stuff the name and URL into the Dictionary for return:
            [ret setObject:img_url forKey:name];
        }
        
        // Testing, only process first 25 lines:
        //if ( total_count > 25 ) break;
    }
    
    if ( MYDEBUG ){
        NSLog( @"Total:'%d'", total_count );
        NSLog( @" Good:'%d'", good_count );
    }
    
    if ( MYDEBUG ){
        NSLog( @"Exiting get_data()" );
    }
    
    return ret;
}

NSURL * get_image_url( NSString *comic_url_str ){
    if ( MYDEBUG ){
        NSLog( @"Entered get_image_url()" );
    }
    
    // My return object
    NSURL *ret;
    
    // Base URL:
    NSString *comic_url_base = @"http://xkcd.com/";
    NSString *comic_url = [comic_url_base stringByAppendingFormat:@"%@/",comic_url_str];
    //ret = [[[NSURL alloc] initWithString:comic_url_str relativeToURL:comic_url_base] autorelease];
    ret = [[[NSURL alloc] initWithString:comic_url] autorelease];
    
    
    if ( MYDEBUG ){
        NSLog( @"Exiting get_image_url()" );
    }
    
    return ret;
}

@end