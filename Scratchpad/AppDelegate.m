#import "AppDelegate.h"
#import "CMarkParser.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextView *textView;
@property (weak) IBOutlet WKWebView *webView;
@end

@implementation AppDelegate

CMarkParser *parser = nil;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    parser = [[CMarkParser alloc] init];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)windowWillClose:(NSNotification *)notification {
    [NSApp terminate:self];
}

- (void)textDidChange:(NSNotification *)notification {
    NSDate *startTime = [[NSDate alloc] init];

    [parser parse:[self.textView string]];
    NSString *html = [parser render];
    [self.webView loadHTMLString:html baseURL:nil];

    NSLog(@"Time: %.02fms", [startTime timeIntervalSinceNow] * -1000.0);
}

@end
