//
//  TodoListViewController.m
//  TodoList
//
//  Created by Nick Lockwood on 08/04/2010.
//  Copyright Charcoal Design 2010. All rights reserved.
//

#import "TodoListViewController.h"
#import "NewItemViewController.h"
#import "TodoItem.h"
#import "TodoList.h"


@implementation TodoListViewController

@synthesize tableView = _tableView;

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	[self.tableView reloadData];
}

- (IBAction)toggleEditing:(id)sender
{	
	[self.tableView setEditing:!self.tableView.editing animated:YES];
	[sender setTitle:(self.tableView.editing)? @"Done" : @"Edit"];
}

- (IBAction)createNewItem
{	
	UIViewController *viewController = [[NewItemViewController alloc] init];
	[self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	TodoItem *item = [[TodoList sharedList].items objectAtIndex:indexPath.row];
	item.checked = !item.checked;
	[[TodoList sharedList] save];
	[tableView reloadData];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)_tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{	
	[[TodoList sharedList].items removeObjectAtIndex:indexPath.row];
	[[TodoList sharedList] save];
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{	
	return [[TodoList sharedList].items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	static NSString *cellType = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellType];
	if (cell == nil)
    {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewStylePlain reuseIdentifier:cellType] autorelease];
	}
	
	TodoItem *item = [[TodoList sharedList].items objectAtIndex:indexPath.row];
	cell.textLabel.text = item.label;
	if (item.checked)
    {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
    else
    {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	return cell;
}

#pragma mark -
#pragma mark Cleanup

- (void)viewDidUnload
{
	self.tableView = nil;
    [super viewDidUnload];
}

- (void)dealloc
{	
	[_tableView release];
    [super dealloc];
}

@end
