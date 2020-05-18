#import "AppDelegate.h"
#import "CMarkParser.h"

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

    CMarkParser *parser = [[CMarkParser alloc] init];
    NSString *html = [parser parse:[self.textView string]];
    [self.webView loadHTMLString:html baseURL:nil];

    NSLog(@"Time: %.02fms", [startTime timeIntervalSinceNow] * -1000.0);
}

@end
