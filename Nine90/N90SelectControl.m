//
//  N90SelectControl.m
//  Nine90
//
//  Created by David Schaefgen on 10/29/11.
//  Copyright (c) 2011 David Schaefgen. All rights reserved.
//

#import "N90SelectControl.h"

@interface N90SelectControl () <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, readonly) CGGradientRef mainGradient;
@property (nonatomic, readonly) CGGradientRef rightGradient;
@property (nonatomic, readonly) CGGradientRef highlightedRightGradient;

@property (nonatomic,strong) UIView *selectionView;
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) UILabel *titleLabel;

- (void)setup;

- (BOOL)drawsHighlight;

- (CGGradientRef)mainGradient;
- (CGGradientRef)rightGradient;
- (CGGradientRef)highlightedRightGradient;

- (UIColor *)strokeColor;
- (UIColor *)highlightedStrokeColor;

- (void)showSelectionView;
- (void)hideSelectionView;

@end

@implementation N90SelectControl

@synthesize title = title_;
@synthesize delegate = delegate_;
@synthesize dataSource = dataSource_;

@synthesize selectionView = selectionView_;
@synthesize pickerView = pickerView_;
@synthesize titleLabel = titleLabel_;

@synthesize mainGradient = mainGradient_;
@synthesize rightGradient = rightGradient_;
@synthesize highlightedRightGradient = highlightedRightGradient_;

#pragma mark -
- (void)setup
{
    [self addTarget:self 
             action:@selector(touchUpInside:forEvent:) 
   forControlEvents:UIControlEventTouchUpInside];
    [self setOpaque:NO];
    self.backgroundColor = [UIColor clearColor];
    self.title = @"Twilight";
    
    CGRect labelFrame = CGRectMake(10.0f, 0.0f, self.frame.size.width - 60.0f, self.frame.size.height);
    self.titleLabel = [[UILabel alloc] initWithFrame:labelFrame];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor blackColor];
    
    self.titleLabel.text = self.title;
    
    [self addSubview:self.titleLabel];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    title_ = title;
    self.titleLabel.text = title_;
}

- (void)dealloc
{
    if (mainGradient_ != NULL)
        CGGradientRelease(mainGradient_);
    if (rightGradient_ != NULL)
        CGGradientRelease(rightGradient_);
    if (highlightedRightGradient_ != NULL)
        CGGradientRelease(highlightedRightGradient_);
}

- (CGGradientRef)mainGradient
{
    if (mainGradient_ == NULL) {
        NSArray *gradientColors = [NSArray arrayWithObjects:
                                   (__bridge id)[[UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.00f] CGColor],
                                   (__bridge id)[[UIColor colorWithRed:0.81f green:0.81f blue:0.81f alpha:1.00f] CGColor],
                                   nil];
        CGFloat locations[2] = { 0.0f, 1.0f };
        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
        
        mainGradient_ = CGGradientCreateWithColors(space, (__bridge CFArrayRef)gradientColors, locations);
        
        CGColorSpaceRelease(space);
    }
    
    return mainGradient_;
}

- (CGGradientRef)rightGradient
{
    if (rightGradient_ == NULL) {
        NSArray *gradientColors = [NSArray arrayWithObjects:
                                   (__bridge id)[[UIColor colorWithRed:0.59f green:0.59f blue:0.59f alpha:1.00f] CGColor],
                                   (__bridge id)[[UIColor colorWithRed:0.34f green:0.34f blue:0.34f alpha:1.00f] CGColor],
                                   nil];
        CGFloat locations[2] = { 0.0f, 1.0f };
        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
        
        rightGradient_ = CGGradientCreateWithColors(space, (__bridge CFArrayRef)gradientColors, locations);
        
        CGColorSpaceRelease(space);
    }
    
    return rightGradient_;
}

- (CGGradientRef)highlightedRightGradient
{
    if (highlightedRightGradient_ == NULL) {
        NSArray *gradientColors = [NSArray arrayWithObjects:
                                   (__bridge id)[[UIColor colorWithRed:0.08f green:0.19f blue:0.53f alpha:1.00f] CGColor],
                                   (__bridge id)[[UIColor colorWithRed:0.48f green:0.54f blue:0.74f alpha:1.00f] CGColor],
                                   nil];
        CGFloat locations[2] = { 0.0f, 1.0f };
        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
        
        highlightedRightGradient_ = CGGradientCreateWithColors(space, (__bridge CFArrayRef)gradientColors, locations);
        
        CGColorSpaceRelease(space);
    }
    
    return highlightedRightGradient_;
}

- (UIColor *)strokeColor
{
    return [UIColor colorWithRed:0.30f green:0.30f blue:0.30f alpha:1.0f];
}

- (UIColor *)highlightedStrokeColor
{
    return [UIColor colorWithRed:0.07f green:0.18f blue:0.53f alpha:1.0f];
}

#pragma mark -
- (BOOL)drawsHighlight
{
    return (self.state == UIControlStateHighlighted ||
            self.state == UIControlStateSelected ||
            self.state == (UIControlStateHighlighted | UIControlStateSelected));
}

- (void)fillPath:(UIBezierPath *)path inRect:(CGRect)rect withGradient:(CGGradientRef)gradient
{
    CGPoint start, end;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextAddPath(context, [path CGPath]);
    CGContextClip(context);
    start = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
    end = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGContextDrawLinearGradient(context, gradient, start, end, 0);
    
    CGContextRestoreGState(context);
}

- (void)strokeRightPath:(UIBezierPath *)path clippingToRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextAddPath(context, [path CGPath]);
    CGContextClip(context);
    CGContextClipToRect(context, rect);
    [path stroke];
    
    CGContextRestoreGState(context);
}

- (void)drawTriangleCenteredInRect:(CGRect)rect
{
    CGPoint one, two, three;
    UIBezierPath *triangle = [UIBezierPath bezierPath];
    
    one = CGPointMake(CGRectGetMidX(rect) - 7.0f,
                      CGRectGetMidY(rect) - 7.0f);
    two = CGPointMake(CGRectGetMidX(rect) + 7.0f,
                      CGRectGetMidY(rect) - 7.0f);
    three = CGPointMake(CGRectGetMidX(rect),
                        CGRectGetMidY(rect) + 7.0f);
    
    [triangle moveToPoint:one];
    [triangle addLineToPoint:two];
    [triangle addLineToPoint:three];
    [triangle closePath];
    
    [[UIColor whiteColor] set];
    CGColorRef shadowColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f] CGColor];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetShadowWithColor(context, CGSizeMake(0, 1), 1.0, shadowColor);
    [triangle fill];  
    
    CGContextRestoreGState(context);
}

- (void)drawRect:(CGRect)rect
{
    CGGradientRef rightGradient;
    self.backgroundColor = [UIColor clearColor];
    
    CGRect pathRect = UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(0.5, 0.5, 0.5, 0.5));
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathRect cornerRadius:9.0f];
    
    CGRect rightRect = CGRectMake(CGRectGetMaxX(rect) - 40.0f, CGRectGetMinY(rect), 40.0f, CGRectGetHeight(rect));
    rightRect = UIEdgeInsetsInsetRect(rightRect, UIEdgeInsetsMake(0.5, 0.0, 0.5, 0.5));
    UIBezierPath *rightPath = [UIBezierPath bezierPathWithRoundedRect:rightRect 
                                                    byRoundingCorners:(UIRectCornerBottomRight | UIRectCornerTopRight) 
                                                          cornerRadii:CGSizeMake(9.0f, 9.0f)];
    
    //fill main gradient
    [self fillPath:path inRect:pathRect withGradient:self.mainGradient];
    
    if ([self drawsHighlight])
        rightGradient = self.highlightedRightGradient;
    else
        rightGradient = self.rightGradient;
    
    //fill right-hand gradient
    [self fillPath:rightPath inRect:rightRect withGradient:rightGradient];
    
    if ([self drawsHighlight])
        [[self highlightedStrokeColor] setStroke];
    else
        [[self strokeColor] setStroke];
    
    rightPath.lineWidth = 1.0f;
    path.lineWidth = 1.0f;
    
    [self strokeRightPath:rightPath clippingToRect:rightRect];
    [path stroke];
    
    [self drawTriangleCenteredInRect:rightRect];
}

#pragma mark -
#pragma mark touch handling
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark state handling
- (void)touchUpInside:(id)sender forEvent:(UIEvent *)event
{
    self.selected = !self.selected;
    if (self.isSelected) {
        [self showSelectionView];
        self.userInteractionEnabled = NO;
    }    
}

- (void)setupSelectionView
{
    //setup base view
    self.selectionView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 740.0f)];
    self.selectionView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
    
    //setup picker
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, 524.0f, 320.0f, 260.0f)];
    picker.showsSelectionIndicator = YES;
    picker.delegate = self;
    picker.dataSource = self;
    self.pickerView = picker;
    [self.selectionView addSubview:picker];
    
    //setup toolbar
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 480.0f, 320.0f, 44.0f)];
    toolbar.barStyle = UIBarStyleBlack;
    toolbar.translucent = YES;
    
    //setup items
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                                                          target:nil 
                                                                          action:nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                          target:self 
                                                                          action:@selector(hideSelectionView)];
    NSArray *items = [NSArray arrayWithObjects:flex, done, nil];
    
    [toolbar setItems:items animated:NO];
    [self.selectionView addSubview:toolbar];
}

- (void)setCurrentSelections
{
    NSInteger components = [self numberOfComponentsInPickerView:self.pickerView];
    NSInteger row;
    for (NSInteger i = 0; i < components; i++) {
        if ([delegate_ respondsToSelector:@selector(selectControl:rowForTitle:forComponent:)]) {
            row = [delegate_ selectControl:self rowForTitle:self.title forComponent:i];
            [self.pickerView selectRow:row inComponent:i animated:NO];
        }
    }
}

#pragma mark -
#pragma mark selection view
- (void)showSelectionView
{
    if (self.selectionView == nil) {
        [self setupSelectionView];
    }
    
    self.selectionView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 740.0f);
    [self setCurrentSelections];
    
    CGRect selectionFrame = selectionView_.frame;
    [[[UIApplication sharedApplication] keyWindow] addSubview:selectionView_];
    
    [UIView animateWithDuration:0.3 
                          delay:0.0 
                        options:UIViewAnimationCurveEaseInOut 
                     animations:^{
                         selectionView_.frame = CGRectOffset(selectionFrame, 0.0f, -260.0f);
                     } 
                     completion:nil];
}

- (void)hideSelectionView
{
    CGRect selectionFrame = selectionView_.frame;
    
    __block typeof(self) bself = self;
    [UIView animateWithDuration:0.3 
                          delay:0.0 
                        options:UIViewAnimationCurveEaseInOut 
                     animations:^{
                         selectionView_.frame = CGRectOffset(selectionFrame, 0.0f, 260.0f);
                         bself.userInteractionEnabled = YES;
                         bself.selected = !bself.selected;
                     } 
                     completion:^(BOOL finished) {
                         [selectionView_ removeFromSuperview];
                     }];
}

#pragma mark -
#pragma mark UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [delegate_ selectControl:self titleForRow:row forComponent:component];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.title = [delegate_ selectControl:self titleForRow:row forComponent:component];
}

#pragma mark -
#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [dataSource_ numberOfComponentsForSelectControl:self];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [dataSource_ selectControl:self numberOfRowsInComponent:component];
}

@end
