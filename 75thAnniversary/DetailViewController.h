//
//  DetailViewController.h
//  75thAnniversary
//
//  Created by Joshua Scorca on 8/26/14.
//  Copyright (c) 2014 LastLevelLLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
-(id)initWithImage:(UIImage*)image;

@end
