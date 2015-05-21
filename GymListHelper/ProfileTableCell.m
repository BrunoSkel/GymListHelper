//
//  ProfileTableCell.m
//  Mirin
//
//  Created by Bruno Henrique da Rocha e Silva on 5/7/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import "ProfileTableCell.h"

@interface ProfileTableCell ()
@property NSString* GuestString;
@property NSString* language;
@end

@implementation ProfileTableCell

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _GuestString=@"Guest";
        _language = [[NSLocale preferredLanguages] objectAtIndex:0];
        if([self.language isEqualToString:@"pt"]||[self.language isEqualToString:@"pt_br"]){
            _GuestString=@"Usuário";
        }
    }
    return self;
}

-(void) viewDidLoad{
    [super viewDidLoad];
    self.fbButton.delegate=self;
    
    //Comes here because the profileimg and fbbutton links should happen during viewwillappear
    
    if ([FBSDKAccessToken currentAccessToken]) {
        NSURL * imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=200&height=200",[[NSUserDefaults standardUserDefaults] valueForKey:@"loggedUserFacebookId"]]];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage * image = [UIImage imageWithData:imageData];
        self.profileImg.image = image;
        
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"loggedUserFacebookId"]);
        
        self.profileName.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"loggedUserName"];
    }else{
        self.profileImg.image = [UIImage imageNamed:@"guest"];
        self.profileName.text = _GuestString;
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"loggedUserId"];
    }
    
}

- (IBAction)LogInOutAction:(id)sender {
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"loggedUserId"] == 0){
        //Go To Login Screen
        [self performSegueWithIdentifier:@"GoToLogin" sender:self];
    }else{
        //Logout
        self.profileImg.image = [UIImage imageNamed:@"guest"];
        self.profileName.text = _GuestString;
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"loggedUserId"];
        //[FBSDKLoginManager finalize];
        //[FBSDKAccessToken ];
    }
    
}

- (void) loginButtonDidLogOut:(FBSDKLoginButton *)FBLoginBtn{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"loggedUserId"];
    
    self.profileImg.image = [UIImage imageNamed:@"guest"];
    self.profileName.text = _GuestString;
    
}

- (void)
loginButton:	(FBSDKLoginButton *)FBLoginBtn
didCompleteWithResult:	(FBSDKLoginManagerLoginResult *)result
error:	(NSError *)error
{
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 
                 //NSLog(@"fetched user:%@", result);
                 
                 [[NSUserDefaults standardUserDefaults] setValue: result[@"id"] forKey:@"loggedUserFacebookId"];
                 
                 [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@ %@", result[@"first_name"],result[@"last_name"]] forKey:@"loggedUserName"];
                 
                 NSString *sendData = @"facebookid=";
                 sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", result[@"id"]]];
                 
                 sendData = [sendData stringByAppendingString:@"&name="];
                 sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@ %@", result[@"first_name"],result[@"last_name"]]]];
                 
                 sendData = [sendData stringByAppendingString:@"&email="];
                 sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", @""]];
                 
                 sendData = [sendData stringByAppendingString:@"&password="];
                 sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", @""]];
                 
                 sendData = [sendData stringByAppendingString:@"&pic="];
                 sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", @""]];
                 
                 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.gamescamp.com.br/gymhelper/webservices/insertUser.php"]];
                 
                 [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
                 
                 //Here you send your data
                 [request setHTTPBody:[sendData dataUsingEncoding:NSUTF8StringEncoding]];
                 
                 [request setHTTPMethod:@"POST"];
                 NSURLResponse *response = nil;
                 NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                 
                 NSString *results = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 
                 
                 if (error)
                 {
                     NSLog(@"Error");
                 }
                 else
                 {
                     //The response is in data
                     //NSLog(@"%@", results);
                     
                     if([results isEqualToString:@"ERROR2"]){
                         NSLog(@"InsertUser Error2");
                     }else{
                         NSLog(@"InsertUser ok = %@",results);
                         
                         [[NSUserDefaults standardUserDefaults] setInteger:[results intValue] forKey:@"loggedUserId"];
                         
                         NSURL * imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=200&height=200",[[NSUserDefaults standardUserDefaults] valueForKey:@"loggedUserFacebookId"]]];
                         NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
                         UIImage * image = [UIImage imageWithData:imageData];
                         
                         self.profileImg.image = image;
                         
                         self.profileName.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"loggedUserName"];
                     }
                 }
                 
             }
         }];
    }else{
        NSLog(@"Not Logged");
    }
}

@end
