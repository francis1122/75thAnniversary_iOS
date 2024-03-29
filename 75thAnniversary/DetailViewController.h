//
//  DetailViewController.h
//  75thAnniversary
//
//  Created by Joshua Scorca on 8/26/14.
//  Copyright (c) 2014 LastLevelLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface DetailViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate, AVAudioPlayerDelegate >

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageImages;
@property (assign, nonatomic) int index;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *facebookButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *twitterButton;

-(IBAction)backButtonTouched:(id)sender;
-(IBAction)playPauseButtonTouched:(id)sender;
-(IBAction)shareButtonTouched:(id)sender;
-(id)initWithImage:(UIImage*)image;

@end
