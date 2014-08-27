//
//  DetailViewController.m
//  75thAnniversary
//
//  Created by Joshua Scorca on 8/26/14.
//  Copyright (c) 2014 LastLevelLLC. All rights reserved.
//

#import "DetailViewController.h"
#import "PageContentViewController.h"
#import "Social/Social.h"


@interface DetailViewController (){
    PageContentViewController *contentViewController;
}
@end

@implementation DetailViewController


-(id)initWithImage:(UIImage*)image{
    if(self = [super init]){
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageImages = @[@"image1", @"image1", @"image1", @"image1", @"image1", @"image1", @"image1", @"image1", @"image1", @"image1", @"image1", @"image1", @"image1", @"image1",@"image1",@"image1",@"image1",@"image1",@"image1",@"image1"];
    
    // Create page view controller
    //self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+37);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //UIImage *_image = [UIImage imageNamed: [NSString stringWithFormat:@"image_%d.jpg", (int)_index]];
    //[self.imageView setImage:_image];
    [self.view bringSubviewToFront:self.toolbar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageImages count] == 0) || (index >= [self.pageImages count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.pageIndex = index;
    contentViewController = pageContentViewController;
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    [contentViewController.backgroundMusicPlayer stop];
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageImages count]) {
        return nil;
    }
    [contentViewController.backgroundMusicPlayer stop];
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageImages count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

-(IBAction)backButtonTouched:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)playPauseButtonTouched:(id)sender{
    if ([contentViewController.backgroundMusicPlayer isPlaying]) {
        [contentViewController.backgroundMusicPlayer pause];
    }else{
        [contentViewController.backgroundMusicPlayer play];
    }
    
}

-(IBAction)facebookButtonTouched:(id)sender{
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
        
        [fbController addImage:[UIImage imageNamed:@"image1.jpg"]];
        [fbController setInitialText:@"Check out this article."];
        [fbController addURL:[NSURL URLWithString:@"http://soulwithmobiletechnology.blogspot.com/"]];
        [fbController setCompletionHandler:completionHandler];
        [self presentViewController:fbController animated:YES completion:nil];
    }
}

-(IBAction)twitterButtonTouched:(id)sender{
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
        
        [twitterController setInitialText:@"Check out this article."];
        [twitterController addImage:[UIImage imageNamed:@"image1.jpg"]];
        
        [twitterController setCompletionHandler:completionHandler];
        [self presentViewController:twitterController animated:YES completion:nil];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
