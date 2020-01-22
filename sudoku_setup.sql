SPOOL sudoku_setup.log


prompt PL/SQL Developer import file
prompt Created on 23 October 2005 by philip1
set feedback off
set define off

prompt Creating STEP_NO_SEQ...
create sequence step_no_seq;


prompt Creating ANSWERS...
create table ANSWERS
(
  PUZZLE_ID       NUMBER,
  STEP_NO         NUMBER,
  ROW_ID          NUMBER,
  COL_ID          NUMBER,
  PENCIL_MARK_IND NUMBER default 0,
  ANSWER          NUMBER,
  BOX_ID          NUMBER
)
;
create index IDX_ANSWERS_01 on ANSWERS (PUZZLE_ID);
create index IDX_ANSWERS_02 on ANSWERS (BOX_ID, PUZZLE_ID);
create index IDX_ANSWERS_03 on ANSWERS (ROW_ID, PUZZLE_ID);
create index IDX_ANSWERS_04 on ANSWERS (COL_ID, PUZZLE_ID);

prompt Creating CELLS...
create table CELLS
(
  ROW_ID NUMBER,
  COL_ID NUMBER,
  BOX_ID NUMBER
)
;
create index IDX_CELLS_01 on CELLS (ROW_ID, COL_ID, BOX_ID);

prompt Creating COMBINATIONS...
create table COMBINATIONS
(
  SET_ID        NUMBER,
  SET_SIZE      NUMBER,
  PUZZLE_NUMBER NUMBER
)
;
create unique index IDX_COMBINATIONS_01 on COMBINATIONS (SET_ID, PUZZLE_NUMBER);
create index IDX_COMBINATIONS_02 on COMBINATIONS (SET_SIZE, PUZZLE_NUMBER, SET_ID);
create index IDX_COMBINATIONS_03 on COMBINATIONS (PUZZLE_NUMBER, SET_ID, SET_SIZE);

prompt Creating PUZZLES...
create table PUZZLES
(
  PUZZLE_ID   NUMBER,
  PUZZLE_DSCR VARCHAR2(255),
  PUZZLE_DATE DATE
)
;

alter table PUZZLES
  add constraint PK_PUZZLES primary key (PUZZLE_ID)
  using index;


prompt Creating PUZZLE_LOAD...
create table PUZZLE_LOAD
(
  PUZZLE_ID NUMBER,
  ROW_ID    NUMBER,
  COL_ID1   NUMBER,
  COL_ID2   NUMBER,
  COL_ID3   NUMBER,
  COL_ID4   NUMBER,
  COL_ID5   NUMBER,
  COL_ID6   NUMBER,
  COL_ID7   NUMBER,
  COL_ID8   NUMBER,
  COL_ID9   NUMBER
)
;

alter table PUZZLE_LOAD
  add constraint PK_PUZZLE_LOAD primary key (PUZZLE_ID, ROW_ID)
  using index;


prompt Creating PUZZLE_NUMBERS...
create table PUZZLE_NUMBERS
(
  PUZZLE_NUMBER NUMBER
)
;

alter table PUZZLE_NUMBERS
  add constraint PK_PUZZLE_NUMBERS primary key (PUZZLE_NUMBER)
  using index;


prompt Loading CELLS...
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (1, 1, 1);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (1, 2, 1);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (1, 3, 1);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (1, 4, 2);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (1, 5, 2);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (1, 6, 2);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (1, 7, 3);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (1, 8, 3);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (1, 9, 3);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (2, 1, 1);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (2, 2, 1);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (2, 3, 1);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (2, 4, 2);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (2, 5, 2);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (2, 6, 2);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (2, 7, 3);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (2, 8, 3);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (2, 9, 3);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (3, 1, 1);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (3, 2, 1);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (3, 3, 1);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (3, 4, 2);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (3, 5, 2);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (3, 6, 2);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (3, 7, 3);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (3, 8, 3);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (3, 9, 3);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (4, 1, 4);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (4, 2, 4);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (4, 3, 4);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (4, 4, 5);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (4, 5, 5);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (4, 6, 5);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (4, 7, 6);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (4, 8, 6);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (4, 9, 6);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (5, 1, 4);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (5, 2, 4);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (5, 3, 4);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (5, 4, 5);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (5, 5, 5);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (5, 6, 5);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (5, 7, 6);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (5, 8, 6);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (5, 9, 6);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (6, 1, 4);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (6, 2, 4);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (6, 3, 4);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (6, 4, 5);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (6, 5, 5);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (6, 6, 5);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (6, 7, 6);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (6, 8, 6);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (6, 9, 6);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (7, 1, 7);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (7, 2, 7);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (7, 3, 7);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (7, 4, 8);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (7, 5, 8);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (7, 6, 8);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (7, 7, 9);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (7, 8, 9);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (7, 9, 9);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (8, 1, 7);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (8, 2, 7);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (8, 3, 7);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (8, 4, 8);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (8, 5, 8);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (8, 6, 8);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (8, 7, 9);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (8, 8, 9);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (8, 9, 9);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (9, 1, 7);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (9, 2, 7);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (9, 3, 7);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (9, 4, 8);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (9, 5, 8);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (9, 6, 8);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (9, 7, 9);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (9, 8, 9);
insert into CELLS (ROW_ID, COL_ID, BOX_ID)
values (9, 9, 9);
commit;
prompt 81 records loaded


analyze table cells compute statistics;

prompt Loading COMBINATIONS...
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1234, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1234, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1234, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1234, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1235, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1235, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1235, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1235, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1236, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1236, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1236, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1236, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1237, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1237, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1237, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1237, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1238, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1238, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1238, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1238, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1239, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1239, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1239, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1239, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1245, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1245, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1245, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1245, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1246, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1246, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1246, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1246, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1247, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1247, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1247, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1247, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1248, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1248, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1248, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1248, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1249, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1249, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1249, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1249, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1256, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1256, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1256, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1256, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1257, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1257, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1257, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1257, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1258, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1258, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1258, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1258, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1259, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1259, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1259, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1259, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1267, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1267, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1267, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1267, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1268, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1268, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1268, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1268, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1269, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1269, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1269, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1269, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1278, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1278, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1278, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1278, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1279, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1279, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1279, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1279, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1289, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1289, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1289, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1289, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2345, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2345, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2345, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2345, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2346, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2346, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2346, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2346, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2347, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2347, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2347, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2347, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2348, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2348, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2348, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2348, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2349, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2349, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2349, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2349, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2356, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2356, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2356, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2356, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2357, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2357, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2357, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2357, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2358, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2358, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2358, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2358, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2359, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2359, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2359, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2359, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2367, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2367, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2367, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2367, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2368, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2368, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2368, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2368, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2369, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2369, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2369, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2369, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2378, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2378, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2378, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2378, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2379, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2379, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2379, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2379, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2389, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2389, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2389, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2389, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1345, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1345, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1345, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1345, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1346, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1346, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1346, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1346, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1347, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1347, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1347, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1347, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1348, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1348, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1348, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1348, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1349, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1349, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1349, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1349, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1356, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1356, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1356, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1356, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1357, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1357, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1357, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1357, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1358, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1358, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1358, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1358, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1359, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1359, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1359, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1359, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1367, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1367, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1367, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1367, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1368, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1368, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1368, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1368, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1369, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1369, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1369, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1369, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1378, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1378, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1378, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1378, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1379, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1379, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1379, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1379, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1389, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1389, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1389, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1389, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3456, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3456, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3456, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3456, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3457, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3457, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3457, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3457, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3458, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3458, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3458, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3458, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3459, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3459, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3459, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3459, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3467, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3467, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3467, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3467, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3468, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3468, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3468, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3468, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3469, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3469, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3469, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3469, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3478, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3478, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3478, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3478, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3479, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3479, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3479, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3479, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3489, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3489, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3489, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3489, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2456, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2456, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2456, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2456, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2457, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2457, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2457, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2457, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2458, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2458, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2458, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2458, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2459, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2459, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2459, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2459, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2467, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2467, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2467, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2467, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2468, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2468, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2468, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2468, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2469, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2469, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2469, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2469, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2478, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2478, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2478, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2478, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2479, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2479, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2479, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2479, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2489, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2489, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2489, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2489, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1456, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1456, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1456, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1456, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1457, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1457, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1457, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1457, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1458, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1458, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1458, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1458, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1459, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1459, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1459, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1459, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1467, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1467, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1467, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1467, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1468, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1468, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1468, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1468, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1469, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1469, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1469, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1469, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1478, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1478, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1478, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1478, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1479, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1479, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1479, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1479, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1489, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1489, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1489, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1489, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4567, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4567, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4567, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4567, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4568, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4568, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4568, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4568, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4569, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4569, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4569, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4569, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4578, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4578, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4578, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4578, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4579, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4579, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4579, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4579, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4589, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4589, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4589, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4589, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3567, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3567, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3567, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3567, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3568, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3568, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3568, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3568, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3569, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3569, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3569, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3569, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3578, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3578, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3578, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3578, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3579, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3579, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3579, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3579, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3589, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3589, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3589, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3589, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1567, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1567, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1567, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1567, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1568, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1568, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1568, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1568, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1569, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1569, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1569, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1569, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1578, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1578, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1578, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1578, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1579, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1579, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1579, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1579, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1589, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1589, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1589, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1589, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2567, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2567, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2567, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2567, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2568, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2568, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2568, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2568, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2569, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2569, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2569, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2569, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2578, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2578, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2578, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2578, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2579, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2579, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2579, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2579, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2589, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2589, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2589, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2589, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (5678, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (5678, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (5678, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (5678, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (5679, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (5679, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (5679, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (5679, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (5689, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (5689, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (5689, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (5689, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4678, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4678, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4678, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4678, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4679, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4679, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4679, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4679, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4689, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4689, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4689, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4689, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3678, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3678, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3678, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3678, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3679, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3679, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3679, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3679, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3689, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3689, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3689, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3689, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1678, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1678, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1678, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1678, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1679, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1679, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1679, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1679, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1689, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1689, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1689, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1689, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2678, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2678, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2678, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2678, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2679, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2679, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2679, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2679, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2689, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2689, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2689, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2689, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (6789, 4, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (6789, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (6789, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (6789, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (5789, 4, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (5789, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (5789, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (5789, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4789, 4, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4789, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4789, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4789, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2789, 4, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2789, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2789, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2789, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1789, 4, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1789, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1789, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1789, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3789, 4, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3789, 4, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3789, 4, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3789, 4, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (123, 3, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (124, 3, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (125, 3, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (126, 3, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (127, 3, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (128, 3, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (129, 3, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (123, 3, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (124, 3, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (125, 3, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (126, 3, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (127, 3, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (128, 3, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (129, 3, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (123, 3, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (124, 3, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (125, 3, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (126, 3, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (127, 3, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (128, 3, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (129, 3, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (234, 3, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (235, 3, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (236, 3, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (237, 3, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (238, 3, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (239, 3, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (134, 3, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (135, 3, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (136, 3, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (137, 3, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (138, 3, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (139, 3, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (134, 3, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (135, 3, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (136, 3, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (137, 3, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (138, 3, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (139, 3, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (234, 3, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (235, 3, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (236, 3, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (237, 3, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (238, 3, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (239, 3, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (134, 3, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (135, 3, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (136, 3, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (137, 3, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (138, 3, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (139, 3, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (234, 3, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (235, 3, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (236, 3, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (237, 3, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (238, 3, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (239, 3, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (345, 3, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (346, 3, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (347, 3, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (348, 3, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (349, 3, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (245, 3, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (246, 3, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (247, 3, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (248, 3, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (249, 3, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (145, 3, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (146, 3, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (147, 3, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (148, 3, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (149, 3, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (345, 3, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (346, 3, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (347, 3, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (348, 3, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (349, 3, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (245, 3, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (246, 3, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (247, 3, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (248, 3, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (249, 3, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (145, 3, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (146, 3, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (147, 3, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (148, 3, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (149, 3, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (345, 3, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (346, 3, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (347, 3, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (348, 3, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (349, 3, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (145, 3, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (146, 3, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (147, 3, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (148, 3, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (149, 3, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (245, 3, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (246, 3, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (247, 3, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (248, 3, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (249, 3, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (456, 3, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (457, 3, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (458, 3, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (459, 3, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (356, 3, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (357, 3, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (358, 3, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (359, 3, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (256, 3, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (257, 3, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (258, 3, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (259, 3, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (456, 3, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (457, 3, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (458, 3, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (459, 3, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (156, 3, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (157, 3, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (158, 3, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (159, 3, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (256, 3, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (257, 3, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (258, 3, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (259, 3, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (356, 3, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (357, 3, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (358, 3, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (359, 3, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (156, 3, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (157, 3, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (158, 3, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (159, 3, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (456, 3, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (457, 3, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (458, 3, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (459, 3, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (156, 3, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (157, 3, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (158, 3, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (159, 3, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (256, 3, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (257, 3, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (258, 3, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (259, 3, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (356, 3, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (357, 3, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (358, 3, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (359, 3, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (567, 3, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (568, 3, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (569, 3, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (467, 3, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (468, 3, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (469, 3, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (367, 3, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (368, 3, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (369, 3, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (267, 3, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (268, 3, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (269, 3, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (367, 3, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (368, 3, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (369, 3, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (167, 3, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (168, 3, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (169, 3, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (467, 3, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (468, 3, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (469, 3, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (267, 3, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (268, 3, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (269, 3, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (167, 3, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (168, 3, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (169, 3, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (367, 3, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (368, 3, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (369, 3, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (567, 3, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (568, 3, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (569, 3, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (267, 3, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (268, 3, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (269, 3, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (467, 3, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (468, 3, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (469, 3, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (567, 3, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (568, 3, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (569, 3, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (167, 3, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (168, 3, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (169, 3, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (678, 3, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (679, 3, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (578, 3, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (579, 3, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (478, 3, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (479, 3, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (378, 3, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (379, 3, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (578, 3, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (579, 3, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (378, 3, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (379, 3, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (178, 3, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (179, 3, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (578, 3, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (579, 3, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (378, 3, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (379, 3, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (178, 3, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (179, 3, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (278, 3, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (279, 3, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (478, 3, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (479, 3, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (678, 3, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (679, 3, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (278, 3, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (279, 3, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (478, 3, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (479, 3, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (678, 3, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (679, 3, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (178, 3, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (179, 3, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (278, 3, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (279, 3, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (789, 3, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (689, 3, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (589, 3, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (489, 3, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (789, 3, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (589, 3, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (389, 3, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (189, 3, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (689, 3, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (189, 3, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (289, 3, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (389, 3, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (489, 3, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (589, 3, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (789, 3, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (289, 3, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (489, 3, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (689, 3, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (189, 3, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (289, 3, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (389, 3, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12, 2, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13, 2, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14, 2, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (15, 2, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (16, 2, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (17, 2, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (18, 2, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (19, 2, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12, 2, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13, 2, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14, 2, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (15, 2, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (16, 2, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (17, 2, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (18, 2, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (19, 2, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23, 2, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24, 2, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (25, 2, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (26, 2, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (27, 2, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (28, 2, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (29, 2, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23, 2, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24, 2, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (25, 2, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (26, 2, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (27, 2, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (28, 2, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (29, 2, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34, 2, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (35, 2, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (36, 2, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (37, 2, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (38, 2, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (39, 2, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34, 2, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (35, 2, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (36, 2, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (37, 2, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (38, 2, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (39, 2, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (45, 2, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (46, 2, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (47, 2, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (48, 2, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (49, 2, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (45, 2, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (46, 2, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (47, 2, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (48, 2, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (49, 2, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (56, 2, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (57, 2, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (58, 2, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (59, 2, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (56, 2, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (57, 2, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (58, 2, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (59, 2, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (67, 2, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (68, 2, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (69, 2, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (67, 2, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (68, 2, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (69, 2, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (78, 2, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (79, 2, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (78, 2, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (79, 2, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (89, 2, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (89, 2, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (1, 1, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (2, 1, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (3, 1, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (4, 1, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (5, 1, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (6, 1, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (7, 1, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (8, 1, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (9, 1, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12789, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12789, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12789, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12789, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12789, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13789, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13789, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13789, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13789, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13789, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23789, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23789, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23789, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23789, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23789, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14789, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14789, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14789, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14789, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14789, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24789, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24789, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24789, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24789, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24789, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34789, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34789, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34789, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34789, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34789, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (15789, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (15789, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (15789, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (15789, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (15789, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (25789, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (25789, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (25789, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (25789, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (25789, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (35789, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (35789, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (35789, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (35789, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (35789, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (45789, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (45789, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (45789, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (45789, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (45789, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (16789, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (16789, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (16789, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (16789, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (16789, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (26789, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (26789, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (26789, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (26789, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (26789, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (36789, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (36789, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (36789, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (36789, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (36789, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (46789, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (46789, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (46789, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (46789, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (46789, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (56789, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (56789, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (56789, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (56789, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (56789, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12689, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12689, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12689, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12689, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12689, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13689, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13689, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13689, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13689, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13689, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23689, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23689, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23689, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23689, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23689, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14689, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14689, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14689, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14689, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14689, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24689, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24689, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24689, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24689, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24689, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34689, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34689, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34689, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34689, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34689, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (15689, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (15689, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (15689, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (15689, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (15689, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (25689, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (25689, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (25689, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (25689, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (25689, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (35689, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (35689, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (35689, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (35689, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (35689, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (45689, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (45689, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (45689, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (45689, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (45689, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12589, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12589, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12589, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12589, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12589, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13589, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13589, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13589, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13589, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13589, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23589, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23589, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23589, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23589, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23589, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14589, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14589, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14589, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14589, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14589, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24589, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24589, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24589, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24589, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24589, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34589, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34589, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34589, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34589, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34589, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12489, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12489, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12489, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12489, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12489, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13489, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13489, 5, 3);
commit;
prompt 1000 records committed...
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13489, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13489, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13489, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23489, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23489, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23489, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23489, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23489, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12389, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12389, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12389, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12389, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12389, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12679, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12679, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12679, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12679, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12679, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13679, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13679, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13679, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13679, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13679, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23679, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23679, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23679, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23679, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23679, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14679, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14679, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14679, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14679, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14679, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24679, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24679, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24679, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24679, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24679, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34679, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34679, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34679, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34679, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34679, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (15679, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (15679, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (15679, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (15679, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (15679, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (25679, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (25679, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (25679, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (25679, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (25679, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (35679, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (35679, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (35679, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (35679, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (35679, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (45679, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (45679, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (45679, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (45679, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (45679, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12579, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12579, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12579, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12579, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12579, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13579, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13579, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13579, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13579, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13579, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23579, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23579, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23579, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23579, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23579, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14579, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14579, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14579, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14579, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14579, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24579, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24579, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24579, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24579, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24579, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34579, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34579, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34579, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34579, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34579, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12479, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12479, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12479, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12479, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12479, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13479, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13479, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13479, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13479, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13479, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23479, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23479, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23479, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23479, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23479, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12379, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12379, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12379, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12379, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12379, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12678, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12678, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12678, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12678, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12678, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13678, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13678, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13678, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13678, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13678, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23678, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23678, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23678, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23678, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23678, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14678, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14678, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14678, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14678, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14678, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24678, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24678, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24678, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24678, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24678, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34678, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34678, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34678, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34678, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34678, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (15678, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (15678, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (15678, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (15678, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (15678, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (25678, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (25678, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (25678, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (25678, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (25678, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (35678, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (35678, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (35678, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (35678, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (35678, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (45678, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (45678, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (45678, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (45678, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (45678, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12578, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12578, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12578, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12578, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12578, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13578, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13578, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13578, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13578, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13578, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23578, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23578, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23578, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23578, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23578, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14578, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14578, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14578, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14578, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14578, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24578, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24578, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24578, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24578, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24578, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34578, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34578, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34578, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34578, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34578, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12478, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12478, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12478, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12478, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12478, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13478, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13478, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13478, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13478, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13478, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23478, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23478, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23478, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23478, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23478, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12378, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12378, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12378, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12378, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12378, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12569, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12569, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12569, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12569, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12569, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13569, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13569, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13569, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13569, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13569, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23569, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23569, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23569, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23569, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23569, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14569, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14569, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14569, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14569, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14569, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24569, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24569, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24569, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24569, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24569, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34569, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34569, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34569, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34569, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34569, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12469, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12469, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12469, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12469, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12469, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13469, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13469, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13469, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13469, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13469, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23469, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23469, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23469, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23469, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23469, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12369, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12369, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12369, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12369, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12369, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12567, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12567, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12567, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12567, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12567, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13567, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13567, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13567, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13567, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13567, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23567, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23567, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23567, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23567, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23567, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14567, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14567, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14567, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14567, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14567, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24567, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24567, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24567, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24567, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24567, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34567, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34567, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34567, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34567, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34567, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12467, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12467, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12467, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12467, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12467, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13467, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13467, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13467, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13467, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13467, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23467, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23467, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23467, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23467, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23467, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12367, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12367, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12367, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12367, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12367, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12568, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12568, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12568, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12568, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12568, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13568, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13568, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13568, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13568, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13568, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23568, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23568, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23568, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23568, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23568, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14568, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14568, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14568, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14568, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (14568, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24568, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24568, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24568, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24568, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (24568, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34568, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34568, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34568, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34568, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (34568, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12468, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12468, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12468, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12468, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12468, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13468, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13468, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13468, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13468, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13468, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23468, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23468, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23468, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23468, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23468, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12368, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12368, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12368, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12368, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12368, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12459, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12459, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12459, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12459, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12459, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13459, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13459, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13459, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13459, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13459, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23459, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23459, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23459, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23459, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23459, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12359, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12359, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12359, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12359, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12359, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12457, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12457, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12457, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12457, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12457, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13457, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13457, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13457, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13457, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13457, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23457, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23457, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23457, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23457, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23457, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12357, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12357, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12357, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12357, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12357, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12456, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12456, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12456, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12456, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12456, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13456, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13456, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13456, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13456, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13456, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23456, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23456, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23456, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23456, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23456, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12356, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12356, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12356, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12356, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12356, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12458, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12458, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12458, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12458, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12458, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13458, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13458, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13458, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13458, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (13458, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23458, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23458, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23458, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23458, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (23458, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12358, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12358, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12358, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12358, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12358, 5, 8);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12349, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12349, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12349, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12349, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12349, 5, 9);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12345, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12345, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12345, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12345, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12345, 5, 5);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12346, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12346, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12346, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12346, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12346, 5, 6);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12347, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12347, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12347, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12347, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12347, 5, 7);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12348, 5, 1);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12348, 5, 2);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12348, 5, 3);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12348, 5, 4);
insert into COMBINATIONS (SET_ID, SET_SIZE, PUZZLE_NUMBER)
values (12348, 5, 8);
commit;
prompt 1467 records loaded
prompt Loading PUZZLES...

analyze table combinations compute statistics;

prompt Loading PUZZLE_NUMBERS...
insert into PUZZLE_NUMBERS (PUZZLE_NUMBER)
values (1);
insert into PUZZLE_NUMBERS (PUZZLE_NUMBER)
values (2);
insert into PUZZLE_NUMBERS (PUZZLE_NUMBER)
values (3);
insert into PUZZLE_NUMBERS (PUZZLE_NUMBER)
values (4);
insert into PUZZLE_NUMBERS (PUZZLE_NUMBER)
values (5);
insert into PUZZLE_NUMBERS (PUZZLE_NUMBER)
values (6);
insert into PUZZLE_NUMBERS (PUZZLE_NUMBER)
values (7);
insert into PUZZLE_NUMBERS (PUZZLE_NUMBER)
values (8);
insert into PUZZLE_NUMBERS (PUZZLE_NUMBER)
values (9);
commit;
prompt 9 records loaded
analyze table puzzle_numbers compute statistics;


prompt Loading sample puzzle...
insert into puzzles values (10,'The Times: Fiendish',SYSDATE);
insert into puzzle_load values (10,1,'6','','','','','','1','4','');
insert into puzzle_load values (10,2,'','','1','5','','','','','3');
insert into puzzle_load values (10,3,'','','','','','9','','6','8');
insert into puzzle_load values (10,4,'','','','','','1','','7','');
insert into puzzle_load values (10,5,'','7','2','','','','8','1','');
insert into puzzle_load values (10,6,'','3','','6','','','','','');
insert into puzzle_load values (10,7,'9','1','','3','','','','','');
insert into puzzle_load values (10,8,'3','','','','','2','7','','');
insert into puzzle_load values (10,9,'','8','4','','','','','','5');
commit;

analyze table puzzles compute statistics;
analyze table puzzle_load compute statistics;

set feedback on
set define on



prompt Done.

SPOOL OFF
