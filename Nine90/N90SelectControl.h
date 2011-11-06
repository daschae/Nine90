//
//  N90SelectControl.h
//  Nine90
//
//  Created by David Schaefgen on 10/29/11.
//  Copyright (c) 2011 David Schaefgen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol N90SelectControlDataSource;
@protocol N90SelectControlDelegate;

@interface N90SelectControl : UIControl

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) id<N90SelectControlDataSource> dataSource;
@property (nonatomic, assign) id<N90SelectControlDelegate> delegate;

@end

@protocol N90SelectControlDataSource <NSObject>
@required 

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsForSelectControl:(N90SelectControl *)selectControl;

// returns the # of rows in each component..
- (NSInteger)selectControl:(N90SelectControl *)selectControl numberOfRowsInComponent:(NSInteger)component;
@end


@protocol N90SelectControlDelegate <NSObject>
@required

// this method returns a plain NSString to display the row for the component.
- (NSString *)selectControl:(N90SelectControl *)selectControl titleForRow:(NSInteger)row forComponent:(NSInteger)component;

@optional
// this method returns the row number to select for the current title
- (NSInteger)selectControl:(N90SelectControl *)selectControl rowForTitle:(NSString *)title forComponent:(NSInteger)component;

@end