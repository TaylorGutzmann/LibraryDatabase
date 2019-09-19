--Homework 4 (Duo October 31st, 11:59PM)

set echo on;

--Query #1: List the names of authors who have authored more than 3 books.
select b.AUTHORNAME
from book_authors b
group by b.AUTHORNAME having count(b.bookid) > 3;

--Query #2: Print the names of borrowers whose phone number starts with area code “414”.
select name
from borrower
where phone LIKE '414%';

--Query #3: Retrieve the names of borrowers who have never checked out any books.
select distinct b.NAME
from borrower b, book_loans l
where b.cardno <> l.cardno
MINUS
select distinct b.NAME
from borrower b, book_loans l
where b.cardno = l.cardno;

--Qeury #4: List the titles of books written by “Ringer” author?
select distinct b.title
from book_authors a, book b
where b.bookid IN (select bookid from book_authors where authorname = 'Ringer');

--Query #5: List the name(s) of borrowers, who have loaned books ONLY published by “New Moon Books” publisher?
select distinct b.name
from borrower b, book_loans l, book k
where b.cardno IN (select cardno from book_loans where bookid IN (select bookid from book where publisher = 'New Moon Books'));

--Qeury #6: How many copies of the book titled “But Is It User Friendly?” are owned by each library branch?
select distinct l.branchname, c.no_of_copies
from book_copies c, book b, library_branch l
where c.bookid IN (select bookid from book where title = 'But Is It User Friendly?') and c.branchid = l.branchid;

--Query #7: List the book titles co-authored by more than 2 people.
select title
from book
where bookid IN (select bookid from book_authors group by bookid having count(bookid) > 1);

--Query #8: Print the names of borrowers who have borrowed the highest number of books.
select name
from borrower
where cardno IN (select cardno from book_loans group by cardno having count(cardno) = (select MAX(count(cardno)) from book_loans group by cardno));

--Query #9: Print the names of borrowers who have not yet returned the books.
select name 
from borrower 
where cardno IN (select cardno from book_loans where datein is null);

--Query #10: Print the BookId, book title and average rating received for each book. Shows the results sorted in decreasing order of average rating received. Do not show books below an average rating of 3.0.
select k.bookid, avg(rating)
from book k left join book_loans l
on k.bookid = l.bookid
group by k.bookid having avg(rating) > 3
order by avg(rating) desc;

--Query #11: For each book that is loaned out from the "Sharpstown" branch and which are not yet returned to the library, retrieve the book title, the borrower's name, and the borrower's address.
select distinct k.title, b.name, b.address
from book k, borrower b, book_loans l
where l.bookid
IN(
select distinct bookid
from book_loans
where cardno IN (select cardno from book_loans where datein is null and branchid = (select branchid from library_branch where branchname = 'Sharpstown')) 
and branchid = (select branchid from library_branch where branchname = 'Sharpstown')) 
and l.bookid = k.bookid and b.cardno = l.cardno and branchid = (select branchid from library_branch where branchname = 'Sharpstown');

--Query #12: Print the total number of borrowers in the database.
select count(cardno)
from borrower;

--Query #13: Print the names of tough reviewers. Tough reviewers are the borrowers who have given the lowest overall rating value that a book has for each of the books they have rated.
select distinct b.name
from borrower b, book_loans l
where b.cardno = l.cardno and l.cardno = (select cardno
                                         from book_loans
                                         where rating <= all (select rating from book_loans
                                                              where bookid = l.bookid) and bookid = l.bookid);

--Query #14: Print the names of borrowers and the count of number of books that they have reviewed.  Shows the results sorted in decreasing order of number of books reviewed. Display the count as zero for the borrowers who have not reviewed any book.
select name, count(rating)
from borrower b left join  book_loans l
on b.cardno = l.cardno
group by b.name
order by count(l.rating) desc;



--Qeury #15: Print the names and addresses of all publishers in the database.
select p.NAME, p.ADDRESS
from PUBLISHER p;

set echo off;
