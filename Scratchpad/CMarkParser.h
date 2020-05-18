//
//  CMarkParser.h
//  Scratchpad
//
//  Created by 姜柏任 on 2020/5/17.
//  Copyright © 2020 Poren Chiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMarkParser : NSObject

- (NSString *)parse:(NSString *)markdownString;

@end

NS_ASSUME_NONNULL_END
