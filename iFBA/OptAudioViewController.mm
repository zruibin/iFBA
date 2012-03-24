//
//  OptAudioViewController.m
//  iFBA
//
//  Created by Yohann Magnien on 28/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OptAudioViewController.h"

#import "fbaconf.h"

extern volatile int emuThread_running;
extern int launchGame;
extern char gameName[64];

@implementation OptAudioViewController
@synthesize tabView,btn_backToEmu;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=NSLocalizedString(@"Audio",@"");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //
    // Change the properties of the imageView and tableView (these could be set
    // in interface builder instead).
    //
    //self.tabView.style=UITableViewStyleGrouped;
    tabView.backgroundView=nil;
    tabView.backgroundView=[[[UIView alloc] init] autorelease];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (emuThread_running) {
        btn_backToEmu.title=[NSString stringWithFormat:@"%s",gameName];
        self.navigationItem.rightBarButtonItem = btn_backToEmu;
    }    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title=nil;
    switch (section) {
        case 0:title=@"";//NSLocalizedString(@"Output",@"");
            break;
        case 1:title=@"";//NSLocalizedString(@"Frequency",@"");
            break;
        case 2:title=@"";//NSLocalizedString(@"Latency",@"");
            break;
    }
    return title;
}

- (void)segActionLatency:(id)sender {
    int refresh=0;
    if (ifba_conf.sound_latency!=[sender selectedSegmentIndex]) refresh=1;
    ifba_conf.sound_latency=[sender selectedSegmentIndex];
    if (refresh) [tabView reloadData];
}
- (void)switchSoundOutput:(id)sender {
    ifba_conf.sound_on =((UISwitch*)sender).on;
    [tabView reloadData];
}
- (void)segActionFrequency:(id)sender {
    int refresh=0;
    if (ifba_conf.sound_freq!=[sender selectedSegmentIndex]) refresh=1;
    ifba_conf.sound_freq=[sender selectedSegmentIndex];
    if (refresh) [tabView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    NSString *footer=nil;
    switch (section) {
        case 0://Output
            if (ifba_conf.sound_on) {
                footer=NSLocalizedString(@"Sound Output on",@"");
            } else {
                footer=NSLocalizedString(@"Sound Output off",@"");
            }
            break;
        case 1://Frequency
            switch (ifba_conf.sound_freq) {
                case 0:
                    footer=NSLocalizedString(@"Sound Freq22",@"");
                    break;
                case 1:
                    footer=NSLocalizedString(@"Sound Freq44",@"");
                    break;
            }
            break;
        case 2://Latency
            switch (ifba_conf.sound_latency) {
                case 0:
                    footer=NSLocalizedString(@"Sound Latency0",@"");
                    break;
                case 1:
                    footer=NSLocalizedString(@"Sound Latency1",@"");
                    break;
                case 2:
                    footer=NSLocalizedString(@"Sound Latency2",@"");
                    break;
            }
            break;
    }
    return footer;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UISwitch *switchview;
    UISegmentedControl *segconview;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];                
    }
    cell.accessoryType=UITableViewCellAccessoryNone;
    switch (indexPath.section) {
        case 0://Sound output
            cell.textLabel.text=NSLocalizedString(@"Sound Output",@"");
            switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
            [switchview addTarget:self action:@selector(switchSoundOutput:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchview;
            [switchview release];
            switchview.on=ifba_conf.sound_on;
            break;
        case 1://Sound Frequency
            cell.textLabel.text=NSLocalizedString(@"Sound Frequency",@"");
            segconview = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"22Khz", @"44Khz",nil]];
            segconview.segmentedControlStyle = UISegmentedControlStylePlain;
            [segconview addTarget:self action:@selector(segActionFrequency:) forControlEvents:UIControlEventValueChanged];            
            cell.accessoryView = segconview;
            [segconview release];
            segconview.selectedSegmentIndex=ifba_conf.sound_freq;
            break;
        case 2://Sound Latency
            cell.textLabel.text=NSLocalizedString(@"Sound Latency",@"");
            segconview = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@" 0 ", @" 1 ",@" 2 ",nil]];
            segconview.segmentedControlStyle = UISegmentedControlStylePlain;
            [segconview addTarget:self action:@selector(segActionLatency:) forControlEvents:UIControlEventValueChanged];            
            cell.accessoryView = segconview;
            [segconview release];
            segconview.selectedSegmentIndex=ifba_conf.sound_latency;
            break;
    }
    
	
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


-(IBAction) backToEmu {
    launchGame=2;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
