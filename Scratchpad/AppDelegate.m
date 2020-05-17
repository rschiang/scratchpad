#import "AppDelegate.h"
#import <cmark-gfm.h>

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextView *textView;
@property (weak) IBOutlet WKWebView *webView;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)windowWillClose:(NSNotification *)notification {
    [NSApp terminate:self];
}

- (void)textDidChange:(NSNotification *)notification {
    NSDate *startTime = [[NSDate alloc] init];

    const char *markdownText = [[self.textView string] UTF8String];
    int options = CMARK_OPT_HARDBREAKS | CMARK_OPT_UNSAFE | CMARK_OPT_FOOTNOTES;
    const char *htmlText = cmark_markdown_to_html(markdownText, strlen(markdownText), options);
    NSString *html = [[NSString alloc] initWithUTF8String: htmlText];
    [self.webView loadHTMLString:html baseURL:nil];
    free((void *)htmlText);

    NSLog(@"Time: %.02fms", [startTime timeIntervalSinceNow] * -1000.0);
}

@end
