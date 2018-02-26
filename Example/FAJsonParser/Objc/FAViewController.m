//
//  FAViewController.m
//  FAJsonParser
//
//  Created by fadizant on 02/25/2018.
//  Copyright (c) 2018 fadizant. All rights reserved.
//

#import "FAViewController.h"
#import "FAJsonParser.h"
#import "FAObject.h"

@interface FAViewController ()

@end

@implementation FAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // get JSON from file
    NSDictionary *dict = [self JSONFromFile];
    
    // parse JSON to object
    FAObject *object = [FAObject new];
    NSError *error;
    [dict FillThisObject:object Error:&error];
    
    if (!error) {
        // generate dictionary from object
        NSDictionary *dictFromObject = [object Dictionary:&error];
        if (!error)
        {
            _previewTextView.text = dictFromObject.description;
        }
    }
}

- (NSDictionary *)JSONFromFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"geojson"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

@end