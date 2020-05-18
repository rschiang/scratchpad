#import "CMarkParser.h"
#import <cmark-gfm.h>
#import <cmark-gfm-extension_api.h>
#import <cmark-gfm-core-extensions.h>

@implementation CMarkParser

static cmark_mem *allocator = nil;
cmark_llist *extensions = nil;

void find_extension(const char *name) {
    cmark_syntax_extension *extension = cmark_find_syntax_extension(name);
    if (!extension) {
        NSLog(@"Extension %s unavailable", name);
    } else {
        cmark_llist_append(allocator, extensions, extension);
    }
}

- (instancetype)init
{
    self = [super init];
    if (!allocator) {
        allocator = cmark_get_default_mem_allocator();
        cmark_gfm_core_extensions_ensure_registered();
    }
    if (self) {
        find_extension("table");
        find_extension("strikethrough");
        find_extension("autolink");
        find_extension("tasklist");
    }
    return self;
}

- (NSString *)parse:(NSString *)markdownString
{
    const char *markdownBuffer = [markdownString UTF8String];
    int options = CMARK_OPT_LIBERAL_HTML_TAG | CMARK_OPT_UNSAFE | CMARK_OPT_FOOTNOTES;

    cmark_parser *parser = cmark_parser_new(options);
    cmark_llist *it = extensions;
    while (it != nil) {
        cmark_parser_attach_syntax_extension(parser, (cmark_syntax_extension *)it->data);
    }

    cmark_parser_feed(parser, markdownBuffer, strlen(markdownBuffer));
    cmark_node *document = cmark_parser_finish(parser);
    cmark_parser_free(parser);

    const char *htmlBuffer = cmark_render_html(document, options, extensions);
    NSString *htmlString = [[NSString alloc] initWithUTF8String: htmlBuffer];
    free((void *)htmlBuffer);

    return htmlString;
}

- (void)dealloc
{
    cmark_llist_free_full(allocator, extensions,
                          (cmark_free_func) cmark_syntax_extension_free);
}

@end
