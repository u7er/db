
drop table company;
drop table os;


create sequence oid_seq start with 1 increment by 1;
create sequence cid_seq start with 1 increment by 1;

create table os (
       oid number(3) not null,
       oname varchar2(50),
       oyear varchar2(4),
       
       constraint oid_uk unique (oid),
       constraint oname_pk primary key (oname)
);

create table company (
       cid number(3),
       cname varchar2(50) not null,
       oid_oid number(3),
       
       constraint cid_pk primary key (cid),
       constraint oid_oid_fk foreign key (oid_oid) references os(oid)
);

create or replace package supp is
       procedure fill_tables;
       procedure clear_tables;
end;

create or replace package body supp is
       procedure fill_tables is
         begin
           insert into os values (oid_seq.nextval, 'Windows 95', '1995');
           insert into company values (cid_seq.nextval, 'Company1', oid_seq.currval);
           insert into company values (cid_seq.nextval, 'Company2', oid_seq.currval);
           insert into company values (cid_seq.nextval, 'Company3', oid_seq.currval);
           
           insert into os values (oid_seq.nextval, 'Windows 98', '1998');
           insert into company values (cid_seq.nextval, 'Company1', oid_seq.currval);
           insert into company values (cid_seq.nextval, 'Company2', oid_seq.currval);
           insert into company values (cid_seq.nextval, 'Company3', oid_seq.currval);
           
           insert into os values (oid_seq.nextval, 'Windows 2000', '2000');
           insert into company values (cid_seq.nextval, 'Company1', oid_seq.currval);
           
           insert into os values (oid_seq.nextval, 'Windows NT', '2001');
           insert into company values (cid_seq.nextval, 'Company1', oid_seq.currval);
           insert into company values (cid_seq.nextval, 'Company2', oid_seq.currval);
           insert into company values (cid_seq.nextval, 'Company3', oid_seq.currval);
           
           insert into os values (oid_seq.nextval, 'Windows XP', '2002');
           insert into company values (cid_seq.nextval, 'Company1', oid_seq.currval);
           
           insert into os values (oid_seq.nextval, 'Windows Vista', '2004');
           insert into company values (cid_seq.nextval, 'Company1', oid_seq.currval);
           
           insert into os values (oid_seq.nextval, 'Windows 7', '2007');
           insert into company values (cid_seq.nextval, 'Company1', oid_seq.currval);

           insert into os values (oid_seq.nextval, 'Windows 8', '2008');
           insert into company values (cid_seq.nextval, 'Company1', oid_seq.currval);
           
           insert into os values (oid_seq.nextval, 'Windows 10', '2010');
           insert into company values (cid_seq.nextval, 'Company1', oid_seq.currval);
           
           commit;
         end;

       procedure clear_tables is
         begin
           delete from company;
           delete from os;
           commit;
         end;
end;


begin
  supp.fill_tables;
end;

begin
  supp.clear_tables;
end;

select * from os;
select * from company;



