//
//  UIFont+ZTDynamicFonts.m
//  SeeTouchLearn
//
//  Created by Zachry Thayer on 1/20/14.
//  Copyright (c) 2014 BrainParade. All rights reserved.
//

#import "UIFont+ZTDynamicFonts.h"
#import <objc/runtime.h>

NSString *const ZTFontTextStyleH1 = @"UIFontTextStyleHeadline";
NSString *const ZTFontTextStyleH2 = @"UIFontTextStyleHeadlineTwo";
NSString *const ZTFontTextStyleH3 = @"UIFontTextStyleHeadlineThree";
NSString *const ZTFontTextStyleH4 = @"UIFontTextStyleHeadlineFour";

static NSMutableDictionary* _UIFont_ZTDynamicFonts;
static NSCache* _UIFont_ZTDynamicFontsCache;

static CGFloat _UIFont_ZTDynamicFonts_ContentSizeDeviation;
#define DEFAULT_FONT_DEVIATION 0.1f

void SwizzleClassMethod(Class c, SEL orig, SEL new) {
	
    Method origMethod = class_getClassMethod(c, orig);
    Method newMethod = class_getClassMethod(c, new);
	
    c = object_getClass((id)c);
	
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}

@implementation UIFont (ZTDynamicFonts)

+ (void)load {
    SwizzleClassMethod(self , @selector(preferredFontForTextStyle:), @selector(swizzled_preferredFontForTextStyle:));
	static dispatch_once_t once;
	dispatch_once(&once, ^{
		_UIFont_ZTDynamicFonts = [NSMutableDictionary new];
		_UIFont_ZTDynamicFontsCache = [NSCache new];
		[UIFont addBaseStyles];
	});
}

+ (UIFont*)swizzled_preferredFontForTextStyle:(NSString *)style {
	UIFont* font;
	
	if (_UIFont_ZTDynamicFonts) {
		font = [_UIFont_ZTDynamicFontsCache objectForKey:style];
		
		if (!font) {
			UIFontDescriptor* fontDescriptor = _UIFont_ZTDynamicFonts[style];
			CGFloat fontSize = [self preferredFontSizeForTextStyle:style];
			font = [UIFont fontWithDescriptor:fontDescriptor size:fontSize];
			[_UIFont_ZTDynamicFontsCache setObject:font forKey:style];
		}
	}
	
	if (!font) {
		font = [self swizzled_preferredFontForTextStyle:style];
	}
	
	return font;
}

+ (void)setFontDescriptor:(UIFontDescriptor*)font forTextStyle:(NSString*)style {
	if (!font || !style) {
		return;
	}
	
	_UIFont_ZTDynamicFonts[style] = font;
}

+ (void)setFontDescriptorsForTextSyles:(NSDictionary*)fontDescriptors {
	for (NSString* style in fontDescriptors) {
		UIFontDescriptor* fontDescriptor = fontDescriptors[style];
		[UIFont setFontDescriptor:fontDescriptor forTextStyle:style];
	}
}

+ (void)setDynamicTypeSizeDeviation:(CGFloat)deviation {
	_UIFont_ZTDynamicFonts_ContentSizeDeviation = deviation;
}

+ (CGFloat)preferredContentSizePercentage {
	NSString *contentSize = [UIApplication sharedApplication].preferredContentSizeCategory;
	CGFloat contentSizePercentage = 1.0;
	
	if (_UIFont_ZTDynamicFonts_ContentSizeDeviation == 0) {
		_UIFont_ZTDynamicFonts_ContentSizeDeviation = DEFAULT_FONT_DEVIATION;
	}
	
	if ([contentSize isEqualToString:UIContentSizeCategoryExtraSmall]) {
		contentSizePercentage -= 3 * _UIFont_ZTDynamicFonts_ContentSizeDeviation;
	} else if ([contentSize isEqualToString:UIContentSizeCategorySmall]) {
		contentSizePercentage -= 2 * _UIFont_ZTDynamicFonts_ContentSizeDeviation;
	} else if ([contentSize isEqualToString:UIContentSizeCategoryMedium]) {
		contentSizePercentage -= 1 * _UIFont_ZTDynamicFonts_ContentSizeDeviation;
	} else if ([contentSize isEqualToString:UIContentSizeCategoryLarge]) {
		contentSizePercentage = 1.0;
	} else if ([contentSize isEqualToString:UIContentSizeCategoryExtraLarge]) {
		contentSizePercentage += 1 * _UIFont_ZTDynamicFonts_ContentSizeDeviation;
	} else if ([contentSize isEqualToString:UIContentSizeCategoryExtraExtraLarge]) {
		contentSizePercentage += 2 * _UIFont_ZTDynamicFonts_ContentSizeDeviation;
	} else if ([contentSize isEqualToString:UIContentSizeCategoryExtraExtraExtraLarge]) {
		contentSizePercentage += 3 * _UIFont_ZTDynamicFonts_ContentSizeDeviation;
	}
	
	return contentSizePercentage;
}

+ (CGFloat)preferredFontSizeForTextStyle:(NSString *)style {
	UIFontDescriptor* fontDescriptor = _UIFont_ZTDynamicFonts[style];
	
	NSNumber* fontBaseSize = fontDescriptor.fontAttributes[UIFontDescriptorSizeAttribute];
	CGFloat contentSizePercentage = [UIFont preferredContentSizePercentage];
	CGFloat fontSize = ceil(contentSizePercentage * fontBaseSize.floatValue);
	
	return fontSize;
}

#pragma mark - Helpers

+ (void)addBaseStyles {
	NSDictionary* styles =
	@{
	  ZTFontTextStyleH1 : [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline],
	  ZTFontTextStyleH2 : [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleSubheadline],
	  ZTFontTextStyleH3 : [[[UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleSubheadline] fontDescriptorWithSize:12] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold],
	  ZTFontTextStyleH4 : [[[UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleSubheadline] fontDescriptorWithSize:10] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold],
	  };
	
	[UIFont setFontDescriptorsForTextSyles:styles];
}

@end
