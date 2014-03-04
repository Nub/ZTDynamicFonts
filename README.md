ZTDynamicFonts
================

Lightweight tool to define custom fonts and styles for dynamic text sizing via Settings.app

Example:
```obj-c

//Define styles

NSDictionary* fontDescriptors = @{
	UIFontTextStyleHeadline:	[UIFontDescriptor fontDescriptorWithName:@"Helvetica-Neue" size:20],
	UIFontTextStyleBody:		[UIFontDescriptor fontDescriptorWithName:@"Helvetica-Neue" size:14],
	UIFontTextStyleSubheadline:	[UIFontDescriptor fontDescriptorWithName:@"Helvetica-Neue" size:14],
	UIFontTextStyleCaption1:	[UIFontDescriptor fontDescriptorWithName:@"Helvetica-Neue" size:14],
	UIFontTextStyleCaption2:	[UIFontDescriptor fontDescriptorWithName:@"Helvetica-Neue" size:12],
	UIFontTextStyleFootnote:	[UIFontDescriptor fontDescriptorWithName:@"Helvetica-Neue" size:10],
};

[UIFont setFontDescriptorsForTextSyles:fontDescriptors];

//Usage

self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];


```