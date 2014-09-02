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
-(void) replacePlayButton:(UIBarButtonItem*) newPlayButton;
-(void) FBShare;
-(void) TwitterShare;

-(void)newPageContentDidAppear:(NSNotification*) notification;

@end

@implementation DetailViewController


-(id)initWithImage:(UIImage*)image{
    if(self = [super init]){
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.toolbar setAlpha:0.0];
    _pageImages = @[@[@"full1a"], @[@"full2a"], @[@"full3a", @"full3b"], @[@"full4a"], @[@"full5a"], @[@"full6a"], @[@"full7a", @"full7b", @"full7c", @"full7d", @"full7e"], @[@"full8a"], @[@"full9a", @"full9b", @"full9d", @"full9e", @"full9f"], @[@"full10a"], @[@"full11a"], @[@"full12a"], @[@"full13a"], @[@"full14a"],@[@"full15a"],@[@"full16a"],@[@"full17a"],@[@"full18a"],@[@"full19a"],@[@"full20a"],@[@"full21a"]];
    
    // Create page view controller
    //self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:self.index];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
    }];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+37);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    // Do any additional setup after loading the view from its nib.

    contentViewController = startingViewController;
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    recognizer.delegate = contentViewController;
    [contentViewController.view addGestureRecognizer:recognizer];
    
    contentViewController.backgroundMusicPlayer.delegate = self;
    // check to see if audio is playing successfully
    if([contentViewController.backgroundMusicPlayer isPlaying]){
        
        UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pausePlaying)];
        [self replacePlayButton:button];
        
    }else{
        
        UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(resumePlaying)];
        [self replacePlayButton:button];
        
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newPageContentDidAppear:)
                                                 name:@"AudioNotification"
                                               object:nil];
    
    
//    self.navigationItem.rightBarButtonItem = self.playPauseButton;
}

-(void) replacePlayButton:(UIBarButtonItem*) newPlayButton{
    NSMutableArray *toolbarArray = [[NSMutableArray alloc] initWithArray: self.toolbar.items];
    [toolbarArray removeObjectAtIndex:2];
    [toolbarArray insertObject:newPlayButton atIndex:2];
    [self.toolbar setItems:toolbarArray];
    
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

-(void)handleTap:(id)sender{
    if(self.toolbar.alpha <= 0.0){
        [self startFadeIn];
    }else{
        [self startFadeOut];
    }
}

-(void)startFadeOut{
    
    [self.toolbar setAlpha:1.0f];
    
    //fade in
    [UIView animateWithDuration:0.8f animations:^{
        
        [self.toolbar setAlpha:0.0f];
        
    } completion:^(BOOL finished) {

        
    }];
}

-(void)startFadeIn{
    
    [self.toolbar setAlpha:0.0f];
    
    //fade in
    [UIView animateWithDuration:0.8f animations:^{
        
        [self.toolbar setAlpha:1.0f];
        
    } completion:^(BOOL finished) {
        
        
    }];
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageImages count] == 0) || (index >= [self.pageImages count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    [pageContentViewController.imageFiles addObjectsFromArray:self.pageImages[index]];
    pageContentViewController.pageIndex = index;
    
    
    //contentViewController = pageContentViewController;
    
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

    return [self viewControllerAtIndex:index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers{
    if (pendingViewControllers.count >0) {
        PageContentViewController *PCVC = [pendingViewControllers objectAtIndex:0];
        contentViewController = PCVC;
        UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        recognizer.delegate = contentViewController;
        [contentViewController.view addGestureRecognizer:recognizer];
        
        //audio toolbar stuff
        contentViewController.backgroundMusicPlayer.delegate = self;

    }
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
        //self.playPauseButton setS
    }else{
        [contentViewController.backgroundMusicPlayer play];
    }
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

-(IBAction)FBShare{
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
        
        NSInteger currentIndex = contentViewController.pageIndex;
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",((NSArray*)self.pageImages[currentIndex])[0]]];
        [fbController addImage:image];
        [fbController setInitialText:@"Enjoying the 75th Anniversary Celebration Photo Exhibition. #allhands75"];
        [fbController addURL:[NSURL URLWithString:@"https://www.facebook.com/EpiscopalRelief"]];
        [fbController setCompletionHandler:completionHandler];
        [self presentViewController:fbController animated:YES completion:nil];
    }
}

-(IBAction)TwitterShare{
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
        NSInteger currentIndex = contentViewController.pageIndex;
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",((NSArray*)self.pageImages[currentIndex])[0]]];
        [twitterController addImage:image];
        [twitterController setInitialText:@"Enjoying the @EpiscopalRelief 75th Anniversary Photo Exhibition. #allhands75"];

        [twitterController setCompletionHandler:completionHandler];
        [self presentViewController:twitterController animated:YES completion:nil];
    }
}


#pragma mark - pause play button

-(IBAction)pausePlaying
{
    
    NSLog(@"push tap");
    if([contentViewController.backgroundMusicPlayer isPlaying])
    {
        UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(resumePlaying)];
        [self replacePlayButton:button];
        [contentViewController.backgroundMusicPlayer pause];
    }
}

-(IBAction)resumePlaying
{
    if(![contentViewController.backgroundMusicPlayer isPlaying])
    {
        UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pausePlaying)];
        [self replacePlayButton:button];
        [contentViewController.backgroundMusicPlayer play];
    }
    
    NSLog(@"resume tap");
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)newPageContentDidAppear:(NSNotification*) notification{
    contentViewController.backgroundMusicPlayer.delegate = self;
    // check to see if audio is playing successfully
    if([contentViewController.backgroundMusicPlayer isPlaying]){
        
        UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pausePlaying)];
        [self replacePlayButton:button];
        
    }else{
        
        UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(resumePlaying)];
        [self replacePlayButton:button];
        
    }
}

#pragma mark - avDelegates

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if(contentViewController.backgroundMusicPlayer == player){
        UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(resumePlaying)];
        [self replacePlayButton:button];
    }

    NSLog(@"did finish playing");
    
    
    
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    
}


/* audioPlayerBeginInterruption: is called when the audio session has been interrupted while the player was playing. The player will have been paused. */
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    
}

/* audioPlayerEndInterruption:withOptions: is called when the audio session interruption has ended and this player had been interrupted while playing. */
/* Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume. */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags NS_AVAILABLE_IOS(6_0){
    
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags NS_DEPRECATED_IOS(4_0, 6_0){
    
}

/* audioPlayerEndInterruption: is called when the preferred method, audioPlayerEndInterruption:withFlags:, is not implemented. */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player NS_DEPRECATED_IOS(2_2, 6_0){
    
}


@end
