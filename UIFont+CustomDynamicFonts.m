//
//  UIFont+CustomDynamicFonts.m
//  SeeTouchLearn
//
//  Created by Zachry Thayer on 1/20/14.
//  Copyright (c) 2014 BrainParade. All rights reserved.
//

#import "UIFont+CustomDynamicFonts.h"
#import <objc/runtime.h>


static NSMutableDictionary* _UIFont_CustomDynamicFonts;
static CGFloat _UIFont_CustomDynamicFonts_ContentSizeDeviation;
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

@implementation UIFont (CustomDynamicFonts)

+ (void)load {
    SwizzleClassMethod(self , @selector(preferredFontForTextStyle:), @selector(swizzled_preferredFontForTextStyle:));
}

+ (UIFont*)swizzled_preferredFontForTextStyle:(NSString *)style {
	UIFont* font;
	
	if (_UIFont_CustomDynamicFonts) {
		UIFontDescriptor* fontDescriptor = _UIFont_CustomDynamicFonts[style];
		NSNumber* fontBaseSize = fontDescriptor.fontAttributes[UIFontDescriptorSizeAttribute];
		CGFloat contentSizePercentage = [UIFont preferredContentSizePercentage];
		CGFloat fontSize = ceil(contentSizePercentage * fontBaseSize.floatValue);
		font = [UIFont fontWithDescriptor:fontDescriptor size:fontSize];
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
	
	static dispatch_once_t once;
	dispatch_once(&once, ^{
		_UIFont_CustomDynamicFonts = [NSMutableDictionary new];
	});
	
	_UIFont_CustomDynamicFonts[style] = font;
}

+ (void)setFontDescriptorsForTextSyles:(NSDictionary*)fontDescriptors {
	for (NSString* style in fontDescriptors) {
		UIFontDescriptor* fontDescriptor = fontDescriptors[style];
		[UIFont setFontDescriptor:fontDescriptor forTextStyle:style];
	}
}

+ (void)setDynamicTypeSizeDeviation:(CGFloat)deviation {
	_UIFont_CustomDynamicFonts_ContentSizeDeviation = deviation;
}

+ (CGFloat)preferredContentSizePercentage {
	NSString *contentSize = [UIApplication sharedApplication].preferredContentSizeCategory;
	CGFloat contentSizePercentage = 1.0;
	
	if (_UIFont_CustomDynamicFonts_ContentSizeDeviation == 0) {
		_UIFont_CustomDynamicFonts_ContentSizeDeviation = DEFAULT_FONT_DEVIATION;
	}
	
	if ([contentSize isEqualToString:UIContentSizeCategoryExtraSmall]) {
		contentSizePercentage -= 3 * _UIFont_CustomDynamicFonts_ContentSizeDeviation;
	} else if ([contentSize isEqualToString:UIContentSizeCategorySmall]) {
		contentSizePercentage -= 2 * _UIFont_CustomDynamicFonts_ContentSizeDeviation;
	} else if ([contentSize isEqualToString:UIContentSizeCategoryMedium]) {
		contentSizePercentage -= 1 * _UIFont_CustomDynamicFonts_ContentSizeDeviation;
	} else if ([contentSize isEqualToString:UIContentSizeCategoryLarge]) {
		contentSizePercentage = 1.0;
	} else if ([contentSize isEqualToString:UIContentSizeCategoryExtraLarge]) {
		contentSizePercentage += 1 * _UIFont_CustomDynamicFonts_ContentSizeDeviation;
	} else if ([contentSize isEqualToString:UIContentSizeCategoryExtraExtraLarge]) {
		contentSizePercentage += 2 * _UIFont_CustomDynamicFonts_ContentSizeDeviation;
	} else if ([contentSize isEqualToString:UIContentSizeCategoryExtraExtraExtraLarge]) {
		contentSizePercentage += 3 * _UIFont_CustomDynamicFonts_ContentSizeDeviation;
	}
	
	return contentSizePercentage;
}

@end
