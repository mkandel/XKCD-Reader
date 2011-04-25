//
//  XKCDScraper.h
//  XKCD Reader
//
//  Created by marc on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface XKCDScraper : NSObject {
@private
    WebView *webView;
    NSURL *url;
}
@property (retain) WebView *webView;
- (NSArray *)getImageLinks;
- (NSMutableDictionary *)getImageDict;
- (NSURL *)get_image:(NSURL *)comic_url;
@end
