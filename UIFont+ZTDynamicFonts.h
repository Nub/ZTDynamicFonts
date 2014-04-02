//
//  UIFont+ZTDynamicFonts.h
//  SeeTouchLearn
//
//  Created by Zachry Thayer on 1/20/14.
//  Copyright (c) 2014 BrainParade. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const ZTFontTextStyleH1;
extern NSString *const ZTFontTextStyleH2;
extern NSString *const ZTFontTextStyleH3;
extern NSString *const ZTFontTextStyleH4;

/**
	Overides preferredFontForTextStyle to check for custom font descriptions. Returns system
	default fonts if no custom fonts are found. Addition custom keys may be added aswell as
	using the default system font keys.
 **/
@interface UIFont (ZTDynamicFonts)

/**
 @param font Custom font descriptor for style (set base font size/style)
 @param style Key for custom font
 **/
+ (void)setFontDescriptor:(UIFontDescriptor*)font forTextStyle:(NSString*)style;

/**
 @param fontDescriptors settir for key value representation of custom font styles
 **/
+ (void)setFontDescriptorsForTextSyles:(NSDictionary*)fontDescriptors;

/**
 @param deviation percentage change in font size between each tick in [UIApplication sharedApplication].preferredContentSizeCategory. Default value 0.1f
 **/
+ (void)setDynamicTypeSizeDeviation:(CGFloat)deviation;

/**
	Convenience method for obtaining the percentage of deviation from the base font size.
 **/
+ (CGFloat)preferredContentSizePercentage;

/**
	 Convenience method for obtaining the font size for a style
 **/
+ (CGFloat)preferredFontSizeForTextStyle:(NSString *)style;

@end
