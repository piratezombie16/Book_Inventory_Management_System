$filename = "Books_Inventory.txt";
@records;
open $fh, '<', $filename;
$header=<$fh>;
chomp $header;
@headers=split(',', $header);
while ($line = <$fh>)
{
    chomp $line;
    @fields=split(',', $line);
    %record;
    for $i(0..$#headers)
    {
        $record{$headers[$i]}=$fields[$i];
    }
    push @records, \%record;
}
close $fh;

$orderfilename = "Books_Orders.txt";
@records;
open $fh, '<', $filename;
$header=<$fh>;
chomp $header;
@headers=split(',', $header);
while ($line = <$fh>)
{
    chomp $line;
    @fields=split(',', $line);
    %record;
    for $i(0..$#headers)
    {
        $record{$headers[$i]}=$fields[$i];
    }
    push @records, \%record;
}
close $fh;

sub Bookshoplogin
{
    open($fh, '<', 'Login_Details.txt');
    chomp($saved_id = <$fh>);
    chomp($saved_password = <$fh>);
    close($fh);
    print ("-----Login----- \n");
    print ("Enter the Login ID: \n");
    chomp($login_id=<STDIN>);
    print ("Enter the Password: \n");
    chomp($login_password=<STDIN>);

    if($login_id eq $saved_id && $login_password eq $saved_password)
    {
        print ("Login Successful \n");
        mainmenu();
        return;

    }
    else
    {
        print ("Incorrect Login ID And Password. Try Again \n");
        Bookshoplogin();
    }
}
sub mainmenu
{
    print "\n === Welcome To Book Shop === \n";
    print "Choose from the Options Below :\n";
    print "1. Add \n";
    print "2. Order \n";
    print "3. Change Authentication \n";
    print "4. View Details \n";
    print "5. Exit \n";
    print "Enter Your Choice: ";

    chomp ($input = <STDIN>);

    if    ($input eq '1') 
    { 
        add(); 
    }
    elsif ($input eq '2')
    {
        Order();
    }
    elsif ($input eq '3')
    {
        authenticate();
    }
    elsif ($input eq '4')
    {
        View();
    }
    elsif ($input eq '5')
    {
        exit();
    }
    else  
    { 
        print ("Invalid choice. Please Select a Valid Option.\n");
        mainmenu(); 
    } 
}
sub add
{
    print ("\n Enter Book Title: ");
    $title = <STDIN>;
    print ("\n Enter Book ID: ");
    $bookid = <STDIN>;
    print ("\n Enter Author Name: ");
    $author = <STDIN>;
    print("\n Enter Publisher Name: ");
    $publisher = <STDIN>;
    print ("\n Enter Price: ");
    $price = <STDIN>;
    print ("\n Enter No of Copies: ");
    $quantity = <STDIN>;

    chomp($title, $bookid, $author, $publisher, $price, $quantity);
    open($fh, '>>', $filename); 
    print $fh join(',', $title, $bookid, $author, $publisher, $price, $quantity) . "\n";
    close($fh);
    print ("\n New Book Data Added successfully to $filename \n");
    mainmenu();
}
sub View
{
    while (1) 
{
    print "Press 1 To View All the Books Records \n";
    print "Press 2 To View Order Records \n";
    print "Press 0 For Main Menu \n";
    print "Enter Your Choice: \n";

    chomp ($input = <STDIN>);

    if    ($input eq '1') 
    { 
        open $fh, '<', $filename;
        printf "%-20s %-6s %-20s %-30s %-7s %-8s\n",
        "Title", "ID", "Author", "Publisher", "Price", "Quantity";
        print "-" x 100 . "\n";
        while($line=<$fh>)
        {
            chomp($line);
            ($title, $bookid, $author, $publisher, $price, $quantity) = split /,/, $line;
            printf "%-20s %-6s %-20s %-30s %-7s %-8s\n",
            $title, $bookid, $author, $publisher, $price, $quantity;
        }
        close $fh;
    }
    elsif ($input eq '2')
    {
        open $fh, '<', $orderfilename;
        printf "%-20s %-6s %-20s %-30s %-7s %-8s\n",
        "Name", "Order Id", "Book Id", "Price", "Quantity", "Warehouse";
        print "-" x 100 . "\n";
        while($line=<$fh>)
        {
            chomp($line);
            ($name, $orderID, $book_id, $amount, $bookquantity, $selected_warehouse) = split /,/, $line;
            printf "%-20s %-6s %-20s %-30s %-7s %-8s\n",
            $name, $orderID, $book_id, $amount, $bookquantity, $selected_warehouse;
        }
        close $fh;
    }
    elsif ($input eq '0')
    {
       mainmenu(); 
    }
    else  
    { 
        print ("Invalid choice. Please Select a Valid Option.\n"); 
        View();
    }
}
}
sub Order
{
    print ("Please Enter Your Name: \n");
    $name = <STDIN>;
    print ("Entered Name is: $name \n");
    print ("Please Enter The Book ID: \n");
    $book_id = <STDIN>;
    chomp $book_id;
    print ("Entered Book ID is: $book_id \n");
    open $fh, '<', $filename;
    $found=0;
    while($line = <$fh>)
    {
        chomp $line;
        @fields = split /,/, $line;
    if ($fields[1] && $fields[1] eq $book_id)
    {
        print ("Book ID Found \n");
        print ("$line \n");
        $found = 1;
        last;
    }
    }
    close $fh;
    if (!$found) 
    {
        print "Book Not Available.\n";
        mainmenu();
    }
    print ("Enter the Quantity: \n");
    $bookquantity = <STDIN>;
    print ("Entered Quantity is: $bookquantity \n");
    print ("----- Warehouse ----- \n");

        while(1)
        {
        print "Press 1 For ABC Warehouse \n";
        print "Press 2 For CNBC Warehouse \n";
        print ("Please Select the Warehouse: \n");

        chomp ($input = <STDIN>);

        if    ($input eq '1') 
        { 
            $selected_warehouse="ABC Warehouse";
            print ("Your Selected Warehouse is: ABC Warehouse  \n");
            last;  
        }
        elsif    ($input eq '2')
        {
            $selected_warehouse="CNBC Warehouse";
            print ("Your Selected Warehouse is: CNBC Warehouse \n");
            last;        
        }
        else
        {
            print ("Please Enter the Correct Choice \n");
        }
        }

        $orderfilename = "Books_Orders.txt";
        open(my $fh, '>>', $orderfilename);
        print $fh "Selected Warehouse: $selected_warehouse\n";
        close $fh;

        print ("Enter Book Amount For 1 Unit \n");
        $bookamount = <STDIN>;
        $amount=$bookquantity*$bookamount;

        print ("Total Amount $amount \n");
        $orderID = int (rand(20));
        print ("Thank You $name Your Order has been Placed Successfully. \n");
        print ("Please Note Down The Order Number: $orderID for Futher Reference. \n");
        orderdata();

    sub orderdata
    {
        $orderfilename = "Books_Orders.txt";
        chomp($name, $orderID, $book_id, $amount, $bookquantity, $selected_warehouse);
        open($fh, '>>', $orderfilename); 
        print $fh join(',', $name, $orderID, $book_id, $amount, $bookquantity, $selected_warehouse) . "\n";
        close($fh);
        mainmenu();
    } 
}
sub authenticate
{
    print("Enter New User ID: \n");
    chomp($loginid=<STDIN>);
    print("Enter New Password: \n");
    chomp($loginpassword=<STDIN>);
    open($fh, '>', 'Login_Details.txt');
    print $fh "$loginid\n$loginpassword\n";
    close $fh;
    print("User ID and Password Changed");
}
Bookshoplogin();

sub exit
{
    exit(0);
}