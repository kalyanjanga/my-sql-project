drop database if exists library;
create database library;
use library;

create table tbl_publisher(
publisher_PublisherName varchar(100) primary key,
publisher_Address varchar(100) not null,
publisher_PublisherPhone varchar(50) not null);

create table tbl_borrower(
borrower_CardNo int primary key ,
borrower_borrowerName varchar(50) not null,
borrower_borrowerAddress varchar(100) not null,
borrower_borrowerPhone varchar(50)not null);

create table tbl_Library_branch(
Library_branch_BranchID int auto_increment primary key,
Library_branch_branchName varchar(50)not null,
Library_branch_branchAddress varchar(100)not null);

create table tbl_book(
book_BookID int primary key,
book_Title varchar(100) not null,
book_PublisherName varchar(70) not null ,
foreign key (book_PublisherName)
references tbl_publisher(publisher_PublisherName));

create table tbl_book_copies(
book_copies_CopiesID int auto_increment primary key,
book_copies_BookID int not null,
book_copies_BranchID int not null,
book_copies_No_Of_Copies int not null,
foreign key(book_copies_BookID)
references tbl_book (book_BookID) on delete cascade,
foreign key (book_copies_BranchID)
references tbl_Library_branch(Library_branch_BranchID) on delete cascade);

create table tbl_book_authors(
book_authors_AuthorID int auto_increment primary key,
book_authors_BookID int not null,
book_authors_AuthorName varchar(70) not null,
foreign key(book_authors_BookID)
references tbl_book(book_BookID) on delete cascade);

create table tbl_book_Loans(
book_loans_LoansID int auto_increment primary key,
book_loans_BookID int not null,
book_loans_BranchID int not null,
book_loans_CardNo int not null,
book_loans_DateOut varchar(50) not null,
book_loans_DueDate varchar(50) not null,
foreign key (book_loans_BookID)
references tbl_book(book_BookID) on delete cascade,
foreign key (book_loans_BranchID)
references tbl_Library_branch(Library_branch_BranchID) on delete cascade,
foreign key (book_loans_CardNo)
references tbl_borrower(borrower_CardNo) on delete cascade);

-- 1 How many copies of the book titled "The Lost Tribe" are owned by each library branch?
select b.book_Title,lb.library_branch_BranchName,sum(c.book_copies_No_Of_Copies) as No_Of_Copies
from tbl_book_copies as c
inner join tbl_book as b on c.book_copies_BookID = b.book_BookID
join tbl_library_branch as lb on c.book_copies_BranchID = lb.library_branch_BranchID
where b.book_Title = "The Lost Tribe"
and lb.library_branch_BranchName = "Sharpstown";

-- 2 How many copies of the book titled "The Lost Tribe" are owned by each library branch?
select b.book_Title,lb.library_branch_branchname,count(c.book_copies_No_Of_Copies) as bookcount
from tbl_book_copies as c
 inner join tbl_book as b on c.book_copies_bookid=b.book_bookid
 join tbl_library_branch  as lb on c.book_copies_branchid =lb.library_branch_branchid
 where b.book_title ="The Lost Tribe" 
 group by  lb.library_branch_branchname;
 
-- 3 Retrieve the names of all borrowers who do not have any books checked out.
select borrower_borrowername
 from tbl_borrower as b 
left join tbl_book_loans as bl 
on  b.borrower_cardno = bl.book_loans_cardno
WHERE bl.book_loans_CardNo is null;

-- 4 For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address. 
select b1.book_title,b.borrower_borrowername,b.borrower_borroweraddress from tbl_borrower as b
inner join tbl_book_loans as bl on b.borrower_cardno =bl.book_loans_cardno
join tbl_book as  b1 on b1.book_bookId=bl.book_loans_bookID
join tbl_library_branch as lb on lb.library_branch_BranchID=bl.book_loans_branchID
where bl.book_loans_Duedate='2/3/18' and lb.library_branch_BranchName='Sharpstown';

-- 5 For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
select lb.library_branch_branchname,sum(book_loans_bookid) as bookcount
from tbl_library_branch as lb
inner join tbl_book_loans as bl on lb.library_branch_branchid =bl.book_loans_branchid
group by lb.library_branch_branchname;

-- 6 Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
select b.borrower_borrowername,b.borrower_borroweraddress,count(bl.book_loans_bookid) as bookcount from tbl_borrower as b
inner join tbl_book_loans as bl on b.borrower_cardno = bl.book_loans_cardno
join tbl_book as b1 on b1.book_bookid =bl.book_loans_bookid
group by b.borrower_borrowername,b.borrower_borroweraddress
having bookcount >5;
select * from tbl_book_copies;

-- 7 For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
select b.book_title ,c.book_copies_no_of_copies as no_of_copies from tbl_library_branch as lb
 inner join tbl_book_copies as c on c.book_copies_branchid = lb.library_branch_branchid
join tbl_book as b on b.book_bookid=c.book_copies_bookid
join tbl_book_authors as a on b.book_bookid=a.book_authors_bookid
where a.book_authors_authorname ="stephen king" and lb.library_branch_branchname = "central"
group by b.book_title,c.book_copies_no_of_copies;

