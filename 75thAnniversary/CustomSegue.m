//
//  CustomSegue.m
//  75thAnniversary
//
//  Created by Joshua Scorca on 8/26/14.
//  Copyright (c) 2014 LastLevelLLC. All rights reserved.
//

#import "CustomSegue.h"

@implementation CustomSegue
-(void)perform{
    UIViewController *sourceViewController = (UIViewController *) self.sourceViewController;
    UIViewController *destinationViewController = (UIViewController *) self.destinationViewController;

    [sourceViewController.view addSubview:destinationViewController.view];
    [destinationViewController.view setFrame:sourceViewController.view.window.frame];
    [destinationViewController.view setTransform:CGAffineTransformMakeScale(0.5,0.5)];
    [destinationViewController.view setAlpha:1.0];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         [destinationViewController.view setTransform:CGAffineTransformMakeScale(1.0,1.0)];
                         [destinationViewController.view setAlpha:1.0];
                     }
                     completion:^(BOOL finished){
                         [destinationViewController.view removeFromSuperview];
                         [sourceViewController presentViewController:destinationViewController animated:NO completion:nil];
                     }];
}
@end
