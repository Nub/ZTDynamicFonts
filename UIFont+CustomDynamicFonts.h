//
//  UIFont+CustomDynamicFonts.h
//  SeeTouchLearn
//
//  Created by Zachry Thayer on 1/20/14.
//  Copyright (c) 2014 BrainParade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (CustomDynamicFonts)

+ (void)setFontDescriptor:(UIFontDescriptor*)font forTextStyle:(NSString*)style;
+ (void)setFontDescriptorsForTextSyles:(NSDictionary*)fontDescriptors;

+ (void)setDynamicTypeSizeDeviation:(CGFloat)deviation;
+ (CGFloat)preferredContentSizePercentage;

@end
