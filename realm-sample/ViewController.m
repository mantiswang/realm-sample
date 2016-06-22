//
//  ViewController.m
//  realm-sample
//
//  Created by onecat on 16/6/22.
//  Copyright © 2016年 onecat. All rights reserved.
//

#import "ViewController.h"
#import <Realm/Realm.h>
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>

#import "MessageCell.h"
#import "Message.h"


@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *msgTableView;
@property (nonatomic, strong) RLMResults<Message*> *allMessages;
@property (nonatomic, strong) RLMNotificationToken *resultsNotificationToken;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提醒通知";
    
    [self setupUI];
    [self configData];
    
    // Set realm notification block
    
    @weakify(self);
    _allMessages = [[Message allObjects] sortedResultsUsingProperty:@"id" ascending:NO];
    
    self.resultsNotificationToken = [self.allMessages addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable changes, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Failed to open Realm on background worker: %@", error);
            return;
        }
        
        UITableView *tableView = weak_self.msgTableView;
        // 对于变化信息来说，检索的初次运行将会传递 nil
        if (!changes) {
            [tableView reloadData];
            return;
        }
        
        // 检索结果被改变，因此将它们应用到 UITableView 当中
        [tableView beginUpdates];
        [tableView insertRowsAtIndexPaths:[changes insertionsInSection:0]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadRowsAtIndexPaths:[changes modificationsInSection:0]
                         withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }];
    
    [_msgTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allMessages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"MessageCell" configuration:^(MessageCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark - Privates
- (void)setupUI {
    _msgTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_msgTableView registerNib:[UINib nibWithNibName:@"MessageCell" bundle:nil] forCellReuseIdentifier:@"MessageCell"];
    [self.view addSubview:_msgTableView];
    [_msgTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsZero);
    }];
    
    _msgTableView.delegate = self;
    _msgTableView.dataSource = self;

     self.navigationItem.rightBarButtonItem =
     [[UIBarButtonItem alloc] initWithTitle:@"BG Add"
     style:UIBarButtonItemStylePlain
     target:self
     action:@selector(backgroundAdd)];

}

- (void)configureCell:(MessageCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    
    cell.entity = self.allMessages[indexPath.row];
}


- (void)backgroundAdd

{
     dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

     // Import many items in a background thread
     dispatch_async(queue, ^{
         // Get new realm and table since we are in a new thread
         RLMRealm *realm = [RLMRealm defaultRealm];
         [realm beginWriteTransaction];
         for (NSInteger index = 0; index < 3; index++) {
             [Message createInRealm:realm withValue:@{@"id":@([self randomID]),
                                                             @"title": [self randomTitle],
                                                             @"datetime": [[NSDate new] stringWithFormat:@"yyyy.MM.dd"],
                                                             @"creator":@"onecat",
                                                             @"content": [NSString stringWithFormat:@"werdxwe"]}];
         }
         [realm commitWriteTransaction];
     });

}

- (NSString *)randomTitle
{
    return [NSString stringWithFormat:@"Title %d", arc4random()];
}

- (NSInteger)randomID
{
    return arc4random() * 1000000;
}


- (void)configData {

     NSString *dataFilePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
     NSData *data = [NSData dataWithContentsOfFile:dataFilePath];
     NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
     NSArray *feedArray = rootDict[@"feed"];
     
    
     RLMRealm *realm = RLMRealm.defaultRealm;
     
     [realm transactionWithBlock:^{
         for (id obj in feedArray) {
             Message *model = [[Message alloc] initWithValue:obj];
             [realm addOrUpdateObject:model];
         }
     }];
    
}
@end