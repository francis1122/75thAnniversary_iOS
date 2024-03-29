//
//  ViewController.m
//  75thAnniversary
//
//  Created by Hunter Francis on 8/26/14.
//  Copyright (c) 2014 LastLevelLLC. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "Social/Social.h"

#define IS_IPHONE_5 ( [ [ UIScreen mainScreen ] bounds ].size.width == 568 )

#define NUM_OF_IMGS 23

@interface ViewController ()

-(void) FBShare;

-(void) TwitterShare;

@end

@implementation ViewController

-(CGRect)currentScreenBoundsDependOnOrientation
{
    NSString *reqSysVer = @"8.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
        return [UIScreen mainScreen].bounds;
    
    CGRect screenBounds = [UIScreen mainScreen].bounds ;
    CGFloat width = CGRectGetWidth(screenBounds)  ;
    CGFloat height = CGRectGetHeight(screenBounds) ;
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation)){
        screenBounds.size = CGSizeMake(width, height);
        NSLog(@"Portrait Height: %f", screenBounds.size.height);
    }else if(UIInterfaceOrientationIsLandscape(interfaceOrientation)){
        screenBounds.size = CGSizeMake(height, width);
        NSLog(@"Landscape Height: %f", screenBounds.size.height);
    }
    
    return screenBounds ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupGrid];
    

    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupGrid{
    float squareSize = 124;
    float xMargin = 6;
    float yMargin = 6;
    
    float imgPadding = 6;
    
    //int numOfColumns = 4;
    
    float screenWidth =  [self currentScreenBoundsDependOnOrientation].size.width;
    

    
    int numOfColumns = ((screenWidth-(2.0*xMargin))/(squareSize+imgPadding));
    float extraSpace = (screenWidth - (numOfColumns * (squareSize+imgPadding)))-imgPadding;
    
    float extraImageSpace = extraSpace - xMargin/2;
    float increasedImageSpace = extraImageSpace/numOfColumns;
    squareSize = squareSize + increasedImageSpace;
    
    //recalculate spacing of squares
    extraSpace = (screenWidth - (numOfColumns * (squareSize+imgPadding)))-imgPadding;
    
    xMargin = extraSpace/2.0;
    xMargin += (imgPadding);
    yMargin = xMargin;
    
    
        for (int i = 0; i<NUM_OF_IMGS; ++i) {
            
            UIImage *IMG = [UIImage imageNamed: [NSString stringWithFormat:@"full%ia.jpg", (i)]];
            UIImage *image = [self imageWithImage:IMG scaledToFillSize:CGSizeMake(squareSize, squareSize)];
            if (!image) continue;
            
            NSLog(@"%f, %f", image.size.width, image.size.height);
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor blackColor];
            [button setImage:image forState:UIControlStateNormal];
            [button addTarget:self action:@selector(thumbnailTouched:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            //button.imageView.contentMode = UIViewContentModeScaleAspectFit;
            button.imageView.contentMode = UIViewContentModeRedraw;
            
            
            [button setFrame:CGRectMake(xMargin+((squareSize+imgPadding)*(i%numOfColumns)), yMargin+((squareSize+imgPadding)*(floor(i/numOfColumns))), squareSize, squareSize)];
            [self.scrollview addSubview:button];

        }
    [self setupSpecialThumbnail];
    
}

-(void)setupSpecialThumbnail{
    float squareSize = 124;
    float xMargin = 6;
    float yMargin = 6;
    float imgPadding = 6;
    float screenWidth =  [self currentScreenBoundsDependOnOrientation].size.width;
    int numOfColumns = ((screenWidth-(2.0*xMargin))/(squareSize+imgPadding));
    float extraSpace = (screenWidth - (numOfColumns * (squareSize+imgPadding)))-imgPadding;
    float extraImageSpace = extraSpace - xMargin/2;
    float increasedImageSpace = extraImageSpace/numOfColumns;
    squareSize = squareSize + increasedImageSpace;
    
    //recalculate spacing of squares
    extraSpace = (screenWidth - (numOfColumns * (squareSize+imgPadding)))-imgPadding;

    xMargin = extraSpace/2.0;
    xMargin += (imgPadding);
    yMargin = xMargin;
    
    
    UIImage *IMG = [UIImage imageNamed:@"special_thumb@2x.jpg"];
    //UIImage *image = [self imageWithImage:IMG scaledToFillSize:CGSizeMake(squareSize, squareSize)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    [button setImage:IMG forState:UIControlStateNormal];
    [button addTarget:self action:@selector(thumbnailTouched:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = -1;
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    [button setFrame:CGRectMake(xMargin+((squareSize+imgPadding)*(NUM_OF_IMGS%numOfColumns)), yMargin+((squareSize+imgPadding)*(floor(NUM_OF_IMGS/numOfColumns))), squareSize, squareSize)];
    [self.scrollview addSubview:button];
    [self.scrollview setContentSize:CGSizeMake(xMargin+((squareSize+imgPadding)*(NUM_OF_IMGS%numOfColumns)), (yMargin*4)+(squareSize+imgPadding)*((ceil((((float)NUM_OF_IMGS+1.0)) /numOfColumns))))];
}


-(void)thumbnailTouched:(id)sender{
    if(((UIButton*)sender).tag == -1){
        //take the user to safari
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.episcopalrelief.org"]];
        //
    }else{
        [self performSegueWithIdentifier:@"transition" sender:sender];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"transition"]) {
        DetailViewController *DVC = (DetailViewController*)segue.destinationViewController;
        DVC.index = ((UIButton*)sender).tag;
    }
}

-(IBAction)donateButtonTouched:(id)sender{
    NSLog(@"donate now button pressed");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.episcopalrelief.org/what-you-can-do/donate-now/individual-donation/75th-fundraising-campaigns"]];
}

-(IBAction)shareButtonTouched:(id)sender{
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select Sharing Option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Share on Facebook",
                            @"Share on Twitter",
                            nil];
    popup.tag = 1;
    [popup showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self FBShare];
                    break;
                case 1:
                    [self TwitterShare];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

-(void) FBShare{
    SLComposeViewController *fbController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            
            [fbController dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                default:
                {
                    NSLog(@"Cancelled.....");
                    
                }
                    break;
                case SLComposeViewControllerResultDone:
                {
                    NSLog(@"Posted....");
                }
                    break;
            }};
        
        [fbController addImage:[UIImage imageNamed:@"full20.jpg"]];
        [fbController setInitialText:@"Enjoying the 75th Anniversary Celebration Photo Exhibition. #allhands75"];
        [fbController addURL:[NSURL URLWithString:@"https://www.facebook.com/EpiscopalRelief"]];
        [fbController setCompletionHandler:completionHandler];
        [self presentViewController:fbController animated:YES completion:nil];
    }
}

-(void) TwitterShare{
    SLComposeViewController *twitterController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewControllerCompletionHandler __block completionHandler = ^(SLComposeViewControllerResult result){
            
            [twitterController dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                default:
                {
                    NSLog(@"Cancelled.....");
                    
                }
                    break;
                case SLComposeViewControllerResultDone:
                {
                    NSLog(@"Posted....");
                }
                    break;
            }};
        
        [twitterController setInitialText:@"Enjoying the @EpiscopalRelief 75th Anniversary Photo Exhibition. #allhands75"];
        [twitterController addImage:[UIImage imageNamed:@"full20.jpg"]];
        
        [twitterController setCompletionHandler:completionHandler];
        [self presentViewController:twitterController animated:YES completion:nil];
    }
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
