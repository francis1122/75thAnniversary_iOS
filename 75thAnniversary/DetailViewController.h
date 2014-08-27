//
//  DetailViewController.h
//  75thAnniversary
//
//  Created by Joshua Scorca on 8/26/14.
//  Copyright (c) 2014 LastLevelLLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UIPageViewControllerDataSource>
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageImages;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

-(id)initWithImage:(UIImage*)image;

@end
