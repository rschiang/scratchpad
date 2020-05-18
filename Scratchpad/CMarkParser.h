//
//  CMarkParser.h
//  Scratchpad
//
//  Created by 姜柏任 on 2020/5/17.
//  Copyright © 2020 Poren Chiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <cmark-gfm.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMarkParser : NSObject

@property (readonly) cmark_node *document;

- (void)parse:(NSString *)markdownString;
- (NSString *)render;

@end

NS_ASSUME_NONNULL_END
