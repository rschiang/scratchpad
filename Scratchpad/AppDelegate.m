#import "AppDelegate.h"
#import <cmark-gfm.h>
#import <cmark-gfm-core-extensions.h>

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextView *textView;
@property (weak) IBOutlet WKWebView *webView;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    cmark_gfm_core_extensions_ensure_registered();
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

    int options = CMARK_OPT_LIBERAL_HTML_TAG | CMARK_OPT_UNSAFE | CMARK_OPT_FOOTNOTES;
    cmark_parser *parser = cmark_parser_new(options);
    cmark_llist *extensions = nil;
    char *extension_names[] = {"table", "strikethrough", "autolink", "tasklist"};
    for (int i = 0; i < 4; i++) {
        cmark_syntax_extension *extension = cmark_find_syntax_extension(extension_names[i]);
        if (!extension) {
            NSLog(@"Extension %s unavailable", extension_names[i]);
        } else {
            cmark_parser_attach_syntax_extension(parser, extension);
            cmark_llist_append(cmark_get_default_mem_allocator(), extensions, extension);
        }
    }

    cmark_parser_feed(parser, markdownText, strlen(markdownText));
    cmark_node *document = cmark_parser_finish(parser);
    cmark_parser_finish(parser);

    const char *htmlText = cmark_render_html(document, options, extensions);
    NSString *html = [[NSString alloc] initWithUTF8String: htmlText];
    [self.webView loadHTMLString:html baseURL:nil];

    free((void *)htmlText);
    cmark_llist_free_full(cmark_get_default_mem_allocator(), extensions, (cmark_free_func) cmark_syntax_extension_free);

    NSLog(@"Time: %.02fms", [startTime timeIntervalSinceNow] * -1000.0);
}

@end
