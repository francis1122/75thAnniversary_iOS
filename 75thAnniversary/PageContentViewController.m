//
//  PageContentViewController.m
//  PageViewDemo
//
//  Created by Simon on 24/11/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController (){
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)){
        // Retina display
        self.imageFile = [self.imageFile stringByAppendingString:@"@2x"];
    } else {}
    
    NSString* imagePath = [ [ NSBundle mainBundle] pathForResource:self.imageFile ofType:@"jpg"];
    
    UIImage *image = [ UIImage imageWithContentsOfFile: imagePath];

    self.backgroundImageView.image = image;
    self.titleLabel.text = self.titleText;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    audioSession.delegate = self;
    [audioSession setActive:YES error:nil];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"audio1" ofType:@"mp3"];
    NSError *error;
    _backgroundMusicPlayer = [[AVAudioPlayer alloc]
                              initWithContentsOfURL:[NSURL URLWithString:audioPath] error:&error];
    [_backgroundMusicPlayer prepareToPlay];
    [_backgroundMusicPlayer play];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
