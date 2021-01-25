//
//  USCellStates.h
//  RSSReader
//
//  Created by Uladzislau Stankevich on 19.01.21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface USCellStates : NSObject

typedef NS_ENUM(NSInteger, CellStates) {
    USCellStateHidden = 0,
    USCellStateShown = 1
};

@end

NS_ASSUME_NONNULL_END
