//
//  MessageVC.m
//  Sendy
//
//  Created by Ishan Shikha on 25/07/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import "MessageVC.h"
#import "ChatService.h"
#import "NSDate+DateTools.h"
#import "ConversationVC.h"

@implementation MessageVC
{
    IBOutlet UITableView *dialogsTableView;
}
#pragma mark
#pragma mark ViewController lyfe cycle
-(void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"%@",[QBSession currentSession].currentUser);
    if([QBSession currentSession].currentUser == nil){
        return;
    }
    
    if([ChatService shared].dialogs == nil)
    {
        // get dialogs
        //[SVProgressHUD showWithStatus:@"Loading"];
        
        
        
//        [[ChatService shared]requestDialogUpdateWithId:[NSString stringWithFormat:@"%lu",(unsigned long)[QBSession currentSession].currentUser.ID] completionBlock:^{
//            [dialogsTableView reloadData];
//
//        }];
        
        [[ChatService shared] requestDialogsWithCompletionBlock:^{
        [dialogsTableView reloadData];
            //[SVProgressHUD dismiss];
    }];
    }else{
        [[ChatService shared] sortDialogs];
        [dialogsTableView reloadData];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dialogsUpdatedNotification) name:kNotificationDialogsUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatDidAccidentallyDisconnectNotification) name:kNotificationChatDidAccidentallyDisconnect object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupDialogJoinedNotification) name:kNotificationGroupDialogJoined object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        // Show splash
//        [self.navigationController performSegueWithIdentifier:kShowSplashViewControllerSegue sender:nil];
//    });
//    
//    if(self.createdDialog != nil){
//        [self performSegueWithIdentifier:kShowNewChatViewControllerSegue sender:nil];
//    }
}


#pragma mark
#pragma mark Notifications

- (void)dialogsUpdatedNotification
{
    [dialogsTableView reloadData];
}

- (void)chatDidAccidentallyDisconnectNotification
{
    [dialogsTableView reloadData];
}

- (void)groupDialogJoinedNotification
{
    [dialogsTableView reloadData];
}

- (void)willEnterForegroundNotification
{
    [dialogsTableView reloadData];
}

#pragma mark
#pragma mark UITableViewDelegate & UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%@",[ChatService shared].dialogs);
    return [[ChatService shared].dialogs count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 100.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"conversationCell"];
    NSLog(@"%@",[ChatService shared].dialogs[indexPath.row]);
    QBChatDialog *chatDialog = [ChatService shared].dialogs[indexPath.row];
    
    UILabel *chatusername = (UILabel*)[cell.contentView viewWithTag:101];
    UILabel *wheretogo = (UILabel*)[cell.contentView viewWithTag:102];
    UILabel *lastmsg = (UILabel*)[cell.contentView viewWithTag:103];
    UILabel *lastchattime = (UILabel*)[cell.contentView viewWithTag:104];
    //UIImageView *userimg = (UIImageView*)[cell.copy viewWithTag:106];
    
    switch (chatDialog.type)
    {
        case QBChatDialogTypePrivate:{
            QBUUser *recipient = [ChatService shared].usersAsDictionary[@(chatDialog.recipientID)];
            chatusername.text = recipient.login == nil ? (recipient.fullName == nil ? [NSString stringWithFormat:@"%lu", (unsigned long)recipient.ID] : recipient.fullName) : recipient.login;
            wheretogo.text = @"Noida";
            lastchattime.text = [chatDialog.lastMessageDate timeAgoSinceNow];
            lastmsg.text = chatDialog.lastMessageText;
           // lastmsg.text = re.
            
            
            
        }
//            break;
//        case QBChatDialogTypeGroup:{
//            cell.textLabel.text = chatDialog.name;
//            cell.imageView.image = [UIImage imageNamed:@"GroupChatIcon"];
//        }
//            break;
//        case QBChatDialogTypePublicGroup:{
//            cell.textLabel.text = chatDialog.name;
//            cell.imageView.image = [UIImage imageNamed:@"GroupChatIcon"];
//        }
//            break;

        default:
            break;
    }
    cell.tag  = indexPath.row;
    return cell;
    
    
//    {
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatRoomCellIdentifier"];
//        QBChatDialog *chatDialog = [ChatService shared].dialogs[indexPath.row];
//        cell.tag  = indexPath.row;
//        
//        switch (chatDialog.type) {
//            case QBChatDialogTypePrivate:{
//                QBUUser *recipient = [ChatService shared].usersAsDictionary[@(chatDialog.recipientID)];
//                cell.textLabel.text = recipient.login == nil ? (recipient.fullName == nil ? [NSString stringWithFormat:@"%lu", (unsigned long)recipient.ID] : recipient.fullName) : recipient.login;
//                cell.imageView.image = [UIImage imageNamed:@"privateChatIcon"];
//            }
//                break;
//            case QBChatDialogTypeGroup:{
//                cell.textLabel.text = chatDialog.name;
//                cell.imageView.image = [UIImage imageNamed:@"GroupChatIcon"];
//            }
//                break;
//            case QBChatDialogTypePublicGroup:{
//                cell.textLabel.text = chatDialog.name;
//                cell.imageView.image = [UIImage imageNamed:@"GroupChatIcon"];
//            }
//                break;
//                
//            default:
//                break;
//        }
//        
//        if ([STKStickersManager isStickerMessage:chatDialog.lastMessageText]) {
//            cell.detailTextLabel.text = @"Sticker";
//        } else {
//            cell.detailTextLabel.text = chatDialog.lastMessageText;
//        }
//        
//        
//        // set unread badge
//        UILabel *badgeLabel = (UILabel *)[cell.contentView viewWithTag:201];
//        if(chatDialog.unreadMessagesCount > 0){
//            badgeLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)chatDialog.unreadMessagesCount];
//            badgeLabel.hidden = NO;
//            
//            badgeLabel.layer.cornerRadius = 10;
//            badgeLabel.layer.borderColor = [[UIColor blueColor] CGColor];
//            badgeLabel.layer.borderWidth = 1;
//        }else{
//            badgeLabel.hidden = YES;
//        }
//        
//        // set group chat joined status
//        UIView *groupChatJoinedStatus =  (UIView *)[cell.contentView viewWithTag:202];
//        if(chatDialog.isJoined){
//            groupChatJoinedStatus.layer.cornerRadius = 5;
//            
//            groupChatJoinedStatus.hidden = NO;
//        }else{
//            groupChatJoinedStatus.hidden = YES;
//        }
//        
//        return cell;
//    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self createdialog_chat : [ChatService shared].dialogs[indexPath.row]];
    
    
    
    
}

-(void)createdialog_chat :(QBChatDialog *)user_chat
{
    QBChatDialog *chatDialog = [QBChatDialog new];
    NSMutableArray *selectedUsersIDs = [NSMutableArray array];
    //[selectedUsersIDs addObject:(    )];
    //chatDialog.occupantIDs = selectedUsersIDs;
    chatDialog.type = QBChatDialogTypePrivate;
    chatDialog.ID = @"56802283a28f9aa206005362";
   
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ConversationVC  *ConversationVC_obj=[storyBoard instantiateViewControllerWithIdentifier: @"ConversationVC"];
    if(user_chat != nil)
    {
        ConversationVC_obj.dialog = user_chat;
        //self.createdDialog = nil;
    }
    else
    {
        QBChatDialog *dialog = [ChatService shared].dialogs[0];
        ConversationVC_obj.dialog = dialog;
    }
    [self.navigationController pushViewController:ConversationVC_obj animated:YES];
    
//    [QBRequest createDialog:chatDialog successBlock:^(QBResponse *response, QBChatDialog *createdDialog)
//     {
//         NSLog(@"%@",response);
//         NSLog(@"%@",createdDialog.ID.description);
//         if(createdDialog.type != QBChatDialogTypePrivate || [ChatService shared].dialogsAsDictionary[createdDialog.ID] == nil)
//         {
//             [[ChatService shared].dialogs insertObject:createdDialog atIndex:0];
//             [[ChatService shared].dialogsAsDictionary setObject:createdDialog forKey:createdDialog.ID];
//             self.createdDialog = createdDialog;
//             UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//             ConversationVC  *ConversationVC_obj=[storyBoard instantiateViewControllerWithIdentifier: @"ConversationVC"];
//             if(self.createdDialog != nil)
//             {
//                 ConversationVC_obj.dialog = self.createdDialog;
//                 self.createdDialog = nil;
//             }
//             else
//             {
//                 QBChatDialog *dialog = [ChatService shared].dialogs[0];
//                 ConversationVC_obj.dialog = dialog;
//             }
//             [self.navigationController pushViewController:ConversationVC_obj animated:YES];
//         }
//         else
//         {
//             createdDialog = [ChatService shared].dialogsAsDictionary[createdDialog.ID];
//             self.createdDialog = createdDialog;
//             UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//             ConversationVC  *ConversationVC_obj=[storyBoard instantiateViewControllerWithIdentifier: @"ConversationVC"];
//             ConversationVC_obj.dialog = createdDialog;
//             [self.navigationController pushViewController:ConversationVC_obj animated:YES];
//
//         }
//         // and join it
//         if(createdDialog.type != QBChatDialogTypePrivate)
//         {
//             [createdDialog setOnJoin:^()
//              {
//                  NSLog(@"Dialog joined");
//                  [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGroupDialogJoined object:nil];
//              }];
//             [createdDialog setOnJoinFailed:^(NSError *error) {
//                 NSLog(@"Join Fail, error: %@", error);
//             }];
//             [createdDialog join];
//         }
//     } errorBlock:^(QBResponse *response) {
//         
//         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errors"
//                                                         message:response.error.error.localizedDescription
//                                                        delegate:nil
//                                               cancelButtonTitle:@"Ok"
//                                               otherButtonTitles: nil];
//         [alert show];
//         
//     }];
}

@end
