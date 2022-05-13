//
//  HDVideoVerticalAlignmentLabel.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/5/12.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDVideoVerticalAlignmentLabel.h"

@implementation HDVideoVerticalAlignmentLabel

- (void)setVerticalAlignment:(VerticalAlignment)verticalAlignment {

     verticalAlignment_ = verticalAlignment;

     [self setNeedsDisplay];

 }

 - (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {

     CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];

     switch (self.verticalAlignment) {

         case VerticalAlignmentTop:

             textRect.origin.y = bounds.origin.y;

             break;

         case VerticalAlignmentBottom:

             textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;

             break;

         case VerticalAlignmentMiddle:


         default:

             textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;

     }

     return textRect;

 }



 -(void)drawTextInRect:(CGRect)requestedRect {

     CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];

     [super drawTextInRect:actualRect];
 }
@end
