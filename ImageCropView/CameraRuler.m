//
//  CameraRuler.m
//  ImageCropView
//
//  Created by Preethi Baskar Baskaran on 8/1/15.
//
//
#import "CameraRuler.h"
#import "UserInputViewController.h"
@interface CameraRuler ()

@end

@implementation CameraRuler
NSMutableArray *touchPointsArray;
double knownRealDistance, unknownRealDistance,measurement;
int selected = 0;
-(void)viewDidLoad{
    [_resetButton setEnabled:NO];
    [_calculate setEnabled:NO];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]]];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
                [imagePicker setDelegate:self];
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            else
            {
                [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your device doesn't have a camera." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            }

    
    //Temporarily choose image from gallery - to check in simulator. Uncomment the above code before deploying.
       _touchCount = 0;
    touchPointsArray =  [[NSMutableArray alloc]init];
    
//    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//    imagePickerController.delegate = self;
//    [self presentViewController:imagePickerController animated:YES completion:nil];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizerMethod:)];
    [_rulerImageView addGestureRecognizer:tapGestureRecognizer];

}

- (void)gestureRecognizerMethod:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"Here!!");
    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint touchLocation = [recognizer locationInView:self.view];
        NSLog(@"Touch Location %f",touchLocation.x);
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _rulerImage = [info valueForKey:UIImagePickerControllerOriginalImage];

    _rulerImageView.image = _rulerImage;
    _tempImage = _rulerImage;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
//                                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
//                                             target:self
//                                             action:@selector(cancel:)];
    [picker dismissViewControllerAnimated:NO completion:nil];

}
- (IBAction)cancel:(id)sender
{
    
    NSLog(@"Cancel being called.");
    //[self.navigationController popViewControllerAnimated:YES];
    [self.view setNeedsDisplay];
    UIStoryboard* _initalStoryboard;
    _initalStoryboard = self.storyboard;
    for (UIView* view in self.view.subviews)
    {
        
        [view removeFromSuperview];
    }
    
    UIViewController* initialScene = [_initalStoryboard instantiateInitialViewController];
    self.view.window.rootViewController = initialScene;
    
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_knownValue resignFirstResponder];
    _touchCount++;
   [_resetButton setEnabled:YES];
    if(_touchCount <= 4){
        UITouch *touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView: _rulerImageView];
        NSLog(@"Touch Point %f",touchPoint.x);
        [self drawOverImage:touchPoint :touchPoint];
        [touchPointsArray addObject:[NSValue valueWithCGPoint:touchPoint]];
        if(_touchCount %2 == 0){
            
            
            CGPoint startPoint = [[touchPointsArray objectAtIndex:_touchCount - 1] CGPointValue];
            CGPoint endPoint = [[touchPointsArray objectAtIndex : _touchCount - 2 ] CGPointValue];
            
            [self drawOverImage:startPoint :endPoint];
            
        }
    }
    
    if(_touchCount == 4){
        
        [_calculate setEnabled:YES];
    }
}
-(void)drawOverImage: (CGPoint)startPoint: (CGPoint)endPoint{
    UIGraphicsBeginImageContext(_rulerImageView.frame.size);
    [_rulerImageView.image drawInRect:CGRectMake(0, 0, _rulerImageView.frame.size.width, _rulerImageView.frame.size.height)];
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2);
    if(_touchCount == 2){
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [UIColor redColor].CGColor);
    }
    else{
         CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [UIColor greenColor].CGColor);
    }
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(),(int) startPoint.x, (int)startPoint.y);
    
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(),(int) endPoint.x, (int)endPoint.y);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    _rulerImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}

double coordinateDistance(CGPoint p1, CGPoint p2)
{
    double dist = pow(p2.x - p1.x, 2.0) + pow(p2.y - p1.y, 2.0);
    return sqrt(dist);
}

 double calculateDistance(double knownRealDistance)
{
    CGPoint startPoint = [[touchPointsArray objectAtIndex:0] CGPointValue];
    CGPoint endPoint = [[touchPointsArray objectAtIndex :1] CGPointValue];
    double knownCoordinateDistance = coordinateDistance(startPoint , endPoint);
    CGPoint unknownStartPoint = [[touchPointsArray objectAtIndex:2] CGPointValue];
    CGPoint unknownEndPoint = [[touchPointsArray objectAtIndex :3] CGPointValue];
    double unknownCoordinateDistance = coordinateDistance(unknownStartPoint, unknownEndPoint);
    
    double unknownRealDistance = (knownRealDistance * unknownCoordinateDistance) / knownCoordinateDistance;
    
    return unknownRealDistance;
}


- (IBAction)resetButton:(id)sender {
    _rulerImageView.image = _tempImage;
    [touchPointsArray removeAllObjects];
    _touchCount = 0;
    [_resetButton setEnabled:NO];
    [_calculate setEnabled:NO];
}
- (IBAction)calculate:(id)sender {
    NSString *inputValue = _knownValue.text;
    
    measurement = calculateDistance([inputValue doubleValue]);
    NSString* messageString = [NSString stringWithFormat: @"Calculated measurement %f",measurement];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Calculated measurement"
                                                    message:messageString
                                                   delegate:self
                                          cancelButtonTitle:@"Discard"
                                          otherButtonTitles:@"Set as Width", @"Set as Height",nil];
    [alert show];
    
    
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    
        if (buttonIndex == 0)
        {
            // Cancel Tapped
            NSLog(@"Discard!!");
        }
        else if (buttonIndex == 1)
        {
            // DELETE Tapped
            selected = 1;
            [self performSegueWithIdentifier: @"setMeasureScreen" sender: self];
            
        }
        else if (buttonIndex == 2)
        {
            // DELETE Tapped
            selected = 2;
            [self performSegueWithIdentifier: @"setMeasureScreen" sender: self];
            
        }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSLog(@" From view controller The segue identifer %@",segue.identifier);
    
    if([segue.identifier isEqualToString:@"setMeasureScreen"])
    {
        NSLog(@"setMeasureScreen");
        
        UserInputViewController *controller = (UserInputViewController *)segue.destinationViewController;
        controller.image = _originalImage;
        NSNumber *myDoubleNumber = [NSNumber numberWithDouble:measurement];
        NSLog(@"Measurement %@",myDoubleNumber);
        
        NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
        [fmt setPositiveFormat:@"0.##"];
        NSString *newText = [fmt stringFromNumber:[NSNumber numberWithFloat:measurement]];
        measurement = [newText doubleValue];
        
        if(selected == 1){
            
        controller.widthValue = measurement;
        }
        if(selected == 2){
        controller.heightValue = measurement;
        }
        
        
        /*UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Return", returnbuttontitle) style:     UIBarButtonItemStyleBordered target:nil action:nil];
         
         self.navigationItem.backBarButtonItem = backButton;*/
        
        
        
        //self.navigationItem.backBarButtonItem.image = [UIImage imageNamed:@"backward_arrow.png"];
        
        
        //controller.stringForVC2 = @"some string";
        // here you have passed the value //
        
    }
    
}

- (IBAction)retakePhoto:(id)sender {
    
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                {
                    [touchPointsArray removeAllObjects];
                    _touchCount = 0;
                    [_resetButton setEnabled:NO];
                    [_calculate setEnabled:NO];
                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
                    [imagePicker setDelegate:self];
                    [self presentViewController:imagePicker animated:YES completion:nil];
                }
                else
                {
                    [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your device doesn't have a camera." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    
                }
}
@end


