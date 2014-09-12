//
//  PageContentViewController.m
//  PageViewDemo
//
//  Created by Simon on 24/11/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController (){
    int pageCount;
    NSTimer *timer;
    BOOL stop;
}

@end

@implementation PageContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        self.imageFiles = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    pageCount = 0;
    self.backgroundImageView.image = [self getImageForIndex:pageCount];
    
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"audio%d", (int)self.pageIndex] ofType:@"mp3"];
    NSError *error;
    _backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:audioPath] error:&error];

}

-(void)viewWillAppear:(BOOL)animated{
    pageCount = 0;
    self.backgroundImageView.image = [self getImageForIndex:pageCount];
    

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    stop = NO;
    timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(startAnimation) userInfo:nil repeats:YES];
    [self performSelector:@selector(playAudio) withObject:nil afterDelay:.5];
    

}

-(void)playAudio{
    if(!stop){
        [_backgroundMusicPlayer play];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AudioNotification"
                                                        object:self];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_backgroundMusicPlayer stop];
    stop = YES;
    [timer invalidate];
    timer = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startAnimation{
    if (self.imageFiles.count == 1) return;

    CABasicAnimation *crossFade = [CABasicAnimation animationWithKeyPath:@"contents"];
    crossFade.duration = 2.0;
    if (pageCount == self.imageFiles.count-1) {
        crossFade.fromValue = [self getImageForIndex:pageCount];
        crossFade.toValue = [self getImageForIndex:0];
        pageCount = 0;
    }else{
        crossFade.fromValue = [self getImageForIndex:pageCount++];
        crossFade.toValue = [self getImageForIndex:pageCount];
    }
    [self.backgroundImageView.layer addAnimation:crossFade forKey:@"animateContents"];
    self.backgroundImageView.image = [self getImageForIndex:pageCount];
}

-(NSString*)getAppropriatePathForString:(NSString*)imageString{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)){
        // Retina display
        imageString = [imageString stringByAppendingString:@"@2x"];
    }
    imageString = [ [ NSBundle mainBundle] pathForResource:imageString ofType:@"jpg"];
    return imageString;
}

-(UIImage*)getImageForIndex:(int)i{
    NSString *imageString = [self.imageFiles objectAtIndex:i];
    NSString* imagePath = [self getAppropriatePathForString:imageString];
    UIImage *image = [ UIImage imageWithContentsOfFile: imagePath];
    return image;
}

@end
