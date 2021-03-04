//
//  UIColor+ColorCategory.m
//  RSSReader
//
//  Created by Uladzislau Stankevich on 3.03.21.
//

#import "UIColor+ColorCategory.h"

@implementation UIColor (ColorCategory)

+ (UIColor *)backgroundColor {
    return [UIColor colorNamed:@"AppBackground"];
}

+ (UIColor *)borderColor {
    return [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1];
}

@end
