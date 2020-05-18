#import "CMarkParser.h"
#import <cmark-gfm.h>
#import <cmark-gfm-extension_api.h>
#import <cmark-gfm-core-extensions.h>

@implementation CMarkParser

cmark_mem *allocator;

- (instancetype)init
{
    self = [super init];
    if (self) {
        allocator = cmark_get_default_mem_allocator();
        cmark_gfm_core_extensions_ensure_registered();
    }
    return self;
}

void find_extension(cmark_parser *parser, cmark_llist *list, const char *name) {
    cmark_syntax_extension *extension = cmark_find_syntax_extension(name);
    if (!extension) {
        NSLog(@"Extension %s unavailable", name);
    } else {
        cmark_parser_attach_syntax_extension(parser, extension);
        cmark_llist_append(allocator, list, extension);
    }
}

- (NSString *)parse:(NSString *)markdownString
{
    const char *markdownBuffer = [markdownString UTF8String];
    int options = CMARK_OPT_LIBERAL_HTML_TAG | CMARK_OPT_UNSAFE | CMARK_OPT_FOOTNOTES;

    cmark_parser *parser = cmark_parser_new(options);
    cmark_llist *extensions = nil;
    find_extension(parser, extensions, "table");
    find_extension(parser, extensions, "strikethrough");
    find_extension(parser, extensions, "autolink");
    find_extension(parser, extensions, "tasklist");

    cmark_parser_feed(parser, markdownBuffer, strlen(markdownBuffer));
    cmark_node *document = cmark_parser_finish(parser);
    cmark_parser_free(parser);
    cmark_llist_free_full(cmark_get_default_mem_allocator(), extensions,
                          (cmark_free_func) cmark_syntax_extension_free);


    const char *htmlBuffer = cmark_render_html(document, options, extensions);
    NSString *htmlString = [[NSString alloc] initWithUTF8String: htmlBuffer];
    free((void *)htmlBuffer);

    return htmlString;
}

@end
