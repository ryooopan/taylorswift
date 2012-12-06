//
//  DetailViewController.m
//  Taylorswift
//
//  Created by Ryo Suzuki on 11/30/12.
//  Copyright (c) 2012 Ryo Suzuki. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    NSString *apiURL = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@&country=US", self.trackId];
    NSURL *url = [NSURL URLWithString: apiURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

}

/// サーバからレスポンスが送られてきたときのデリゲート
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    data = [[NSMutableData alloc] initWithData:0];
}

/// サーバからデータが送られてきたときのデリゲート
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)_data;
{
	[data appendData:_data];
}

/// データのロードか完了した時のデリゲート
- (void)connectionDidFinishLoading:(NSURLConnection *)_connection;
{
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *result = [[NSDictionary alloc] initWithDictionary:[jsonString JSONValue]];
    NSArray *array = [result valueForKey:@"results"];
    NSDictionary *resultDict = [array objectAtIndex:0];
    NSString *artistName = [resultDict valueForKey:@"artistName"];
    NSString *trackID = [resultDict valueForKey:@"trackId"];
    NSString *trackName = [resultDict valueForKey:@"trackName"];
    NSString *collectionName = [resultDict valueForKey:@"collectionName"];
    NSString *releaseDate = [resultDict valueForKey:@"releaseDate"];
    NSString *musicURL = [resultDict valueForKey:@"previewUrl"];
    musicURL = [musicURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    
    NSURL *artworkUrl = [NSURL URLWithString:[resultDict valueForKey:@"artworkUrl100"]];
    NSData *artworkData = [NSData dataWithContentsOfURL:artworkUrl];
    UIImage *albumArtImage = [UIImage imageWithData:artworkData];

    self.detailDescriptionLabel.text = trackName;
    self.image.image = albumArtImage;
    
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:musicURL] error:nil];
    [audioPlayer prepareToPlay];
    [audioPlayer play];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}
							
@end
