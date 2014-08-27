//
//  ViewController.m
//  75thAnniversary
//
//  Created by Hunter Francis on 8/26/14.
//  Copyright (c) 2014 LastLevelLLC. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupGrid];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupGrid{
    for (int i = 0; i<20; ++i) {
        
        UIImage *image = [UIImage imageNamed:@"google"];
        NSLog(@"%f, %f", image.size.width, image.size.height);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor blackColor];
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(thumbnailTouched:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i+1;
        
        
        [button setFrame:CGRectMake(20+((image.size.width+6)*(i%4)), 10+((image.size.height+6)*(i/4)), image.size.width, image.size.height)];
        [self.scrollview addSubview:button];
        [self.scrollview setContentSize:CGSizeMake(320, 10+(image.size.height+6)*((i/4)+1))];
    }
}

-(void)thumbnailTouched:(id)sender{
    [self performSegueWithIdentifier:@"transition" sender:sender];
}

@end
