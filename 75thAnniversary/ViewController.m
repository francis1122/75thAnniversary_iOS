//
//  ViewController.m
//  75thAnniversary
//
//  Created by Hunter Francis on 8/26/14.
//  Copyright (c) 2014 LastLevelLLC. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"

#define IS_IPHONE5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

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
    float squareSize = 134;
    float xOffset = 6;
    int numOfColumns = 4;
    if (!IS_IPHONE5) {
        squareSize = 152;
        numOfColumns = 3;
    }
        for (int i = 0; i<21; ++i) {
            
            UIImage *IMG = [UIImage imageNamed: [NSString stringWithFormat:@"full%i.jpg", (i+1)]];
            UIImage *image = [self imageWithImage:IMG scaledToFillSize:CGSizeMake(squareSize, squareSize)];
            if (!image) continue;
            
            NSLog(@"%f, %f", image.size.width, image.size.height);
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor blackColor];
            [button setImage:image forState:UIControlStateNormal];
            [button addTarget:self action:@selector(thumbnailTouched:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i+1;
            //button.imageView.contentMode = UIViewContentModeScaleAspectFit;
            button.imageView.contentMode = UIViewContentModeRedraw;
            
            
            [button setFrame:CGRectMake(xOffset+((squareSize+6)*(i%numOfColumns)), 6+((squareSize+6)*(floor(i/numOfColumns))), squareSize, squareSize)];
            [self.scrollview addSubview:button];
            [self.scrollview setContentSize:CGSizeMake(320, 6+(squareSize+6)*((floor(i/numOfColumns))+1))];
        }
    
}

-(void)thumbnailTouched:(id)sender{
    [self performSegueWithIdentifier:@"transition" sender:sender];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"transition"]) {
        DetailViewController *DVC = (DetailViewController*)segue.destinationViewController;
        DVC.index = ((UIButton*)sender).tag-1;
    }
}

-(IBAction)donateButtonTouched:(id)sender{
    NSLog(@"donate now button pressed");
}

-(IBAction)shareButtonTouched:(id)sender{
    NSLog(@"share button pressed");
}

-(UIImage *)imageWithImage:(UIImage *)image scaledToFillSize:(CGSize)size
{
    CGFloat scale = MAX(size.width/image.size.width, size.height/image.size.height);
    CGFloat width = image.size.width * scale;
    CGFloat height = image.size.height * scale;
    CGRect imageRect = CGRectMake((size.width - width)/2.0f,
                                  (size.height - height)/2.0f,
                                  width,
                                  height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
