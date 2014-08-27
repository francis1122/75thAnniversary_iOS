//
//  DetailViewController.h
//  75thAnniversary
//
//  Created by Joshua Scorca on 8/26/14.
//  Copyright (c) 2014 LastLevelLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface DetailViewController : UIViewController <UIPageViewControllerDataSource, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageImages;
@property (assign, nonatomic) int *index;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *playPauseButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *facebookButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *twitterButton;

-(IBAction)backButtonTouched:(id)sender;
-(IBAction)playPauseButtonTouched:(id)sender;
-(IBAction)facebookButtonTouched:(id)sender;
-(IBAction)twitterButtonTouched:(id)sender;

-(id)initWithImage:(UIImage*)image;

@end
