CREATE OR REPLACE PROCEDURE p_solve_sudoku
(
    p_puzzle_id      NUMBER,
    p_show_workings  NUMBER := 0
) AS

/************************************************************************
GNU General Public License for PL/SQL Sudoku

Copyright (C) 2000-2003 Philip Lambert and the PL/SQL Sudoku Project
(phil@db-innovations.com)

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program (see license.txt); if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
************************************************************************
$Log: p_solve_sudoku.sql,v $
Revision 1.2  2006/11/12 14:52:58  phlambert
*** empty log message ***



************************************************************************/

/*=====================================================================
PROCEDURE: 	p_solve_sudoku

AUTHOR:		Philip Lambert,  November 2005

PARAMETERS:
	p_puzzle_id			The unique identifying puzzle id for puzzles 
    					loaded into the database.
    p_show_workings		The level of workings ouput by the procedure:
    					1	Minimal - shows summary of algorithms used
                        	and the number of iterations.
                        2	Shows a summary of the candidates after 
                        	each iteration.
                        3	Very detailed - shows the candidates and 
                        	certainties after each algorithm.
                            
The procedure displays using DBMS_OUTPUT. For the most demanding 
puzzles showing the most detailed workings, the maximum out buffer 
would be required (1 Mb).

To solve a puzzle, first load the initial puzzle into the database using
the supplied spreadsheet (sudoku.xls) to generate a set of insert 
statements from the entered grid. This can be done using sqlplus or
similar. Then run the procedure in sqlplus or other with DBMS_OUTPUT 
enabled with sufficient buffer size.

Pencil mark settings:
    -1  Rubbed out
    0   Certain value
    1   Possible value
    2 	Marked value

=====================================================================*/

    v_step_no           NUMBER;
    v_cnt               NUMBER;
    v_answer_count      NUMBER;
    v_answer_count_last NUMBER;
    v_limit_cnt         NUMBER := 0;
    v_row_count         NUMBER := 0;
    v_singles_count     NUMBER := 0;

    /*=====================================================================
    FUNCTION: answer_count
    
    This function counts the number of solved cells (certainties) 
    =====================================================================*/
    FUNCTION answer_count(p_puzzle_id NUMBER) RETURN NUMBER AS
        v_cnt NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO   v_cnt
        FROM   answers a
        WHERE  a.puzzle_id = p_puzzle_id
        AND    a.pencil_mark_ind = 0;
    
        RETURN v_cnt;
    END;

    /*=====================================================================
    PROCEDURE: setup_initial_answers
    
    This procedure sets up the intial pencil marks (candidates).  
    =====================================================================*/
    PROCEDURE setup_candidates(p_puzzle_id NUMBER) AS
        v_box_id NUMBER;
        v_row_id NUMBER;
        v_col_id NUMBER;
    
        TYPE t_answers IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
        v_pencil_marks t_answers;
    
        CURSOR c_cells IS
            SELECT box_id,
                   row_id,
                   col_id
            FROM   cells
            MINUS
            SELECT box_id,
                   row_id,
                   col_id
            FROM   answers
            WHERE  pencil_mark_ind = 0
            AND    puzzle_id = p_puzzle_id
            ORDER  BY row_id,
                      col_id;
    
        CURSOR c_pencil_marks IS
            SELECT a.answer
            FROM   (SELECT puzzle_number answer
                    FROM   puzzle_numbers
                    MINUS
                    -- Answers in that row
                    SELECT answer
                    FROM   answers
                    WHERE  pencil_mark_ind = 0
                    AND    row_id = v_row_id
                    AND    puzzle_id = p_puzzle_id
                    MINUS
                    -- Answers in that column
                    SELECT answer
                    FROM   answers
                    WHERE  pencil_mark_ind = 0
                    AND    col_id = v_col_id
                    AND    puzzle_id = p_puzzle_id
                    MINUS
                    -- Answers in that box
                    SELECT answer
                    FROM   answers
                    WHERE  pencil_mark_ind = 0
                    AND    box_id = v_box_id
                    AND    puzzle_id = p_puzzle_id) a;
    BEGIN
        -- Set denormalised box_id on answer
        UPDATE answers a
        SET    box_id = (SELECT box_id
                         FROM   cells c
                         WHERE  c.row_id = a.row_id
                         AND    c.col_id = a.col_id);
    
        -- Determine the initial pencil marks
        FOR r_cells IN c_cells LOOP
        
            v_box_id := r_cells.box_id;
            v_row_id := r_cells.row_id;
            v_col_id := r_cells.col_id;
        
            OPEN c_pencil_marks;
            FETCH c_pencil_marks BULK COLLECT
                INTO v_pencil_marks;
            CLOSE c_pencil_marks;
        
            FORALL i IN 1 .. v_pencil_marks.COUNT
                INSERT INTO answers
                    (puzzle_id,
                     step_no,
                     box_id,
                     row_id,
                     col_id,
                     pencil_mark_ind,
                     answer)
                VALUES
                    (p_puzzle_id,
                     10,
                     v_box_id,
                     v_row_id,
                     v_col_id,
                     1,
                     v_pencil_marks(i));
        
            COMMIT;
        END LOOP;
    
        COMMIT;
    END;

    /*=====================================================================
    PROCEDURE: reset_pencil_marks
    
    After each algorithm, need to set the indicator on pencil marks (of 
    candidates) indicator back to 1 (default).  
    =====================================================================*/
    PROCEDURE reset_pencil_marks(p_puzzle_id NUMBER) AS
    BEGIN
        UPDATE answers
        SET    pencil_mark_ind = 1,
               step_no         = v_cnt
        WHERE  pencil_mark_ind > 0
        AND    puzzle_id = p_puzzle_id;
    
    END;

    /*=====================================================================
    PROCEDURE: output_answers
    
    Draw a grid and output all of the certainties in the appropriate cells.  
    =====================================================================*/
    PROCEDURE output_answers(p_puzzle_id NUMBER) AS
        v_row_id NUMBER;
    
        CURSOR c_answers IS
            SELECT c.row_id,
                   c.col_id,
                   a.answer
            FROM   cells   c,
                   answers a
            WHERE  a.puzzle_id(+) = p_puzzle_id
            AND    a.row_id(+) = c.row_id
            AND    a.col_id(+) = c.col_id
            AND    a.pencil_mark_ind(+) = 0
            ORDER  BY c.row_id,
                      c.col_id;
    BEGIN
        v_row_id := 0;
        FOR r_answers IN c_answers LOOP
        
            IF v_row_id != r_answers.row_id THEN
                dbms_output.put_line(' ');
                IF r_answers.row_id IN (1, 4, 7) THEN
                    dbms_output.put_line('|===========|===========|===========|');
                ELSE
                    dbms_output.put_line('|-----------|-----------|-----------|');
                END IF;
                v_row_id := r_answers.row_id;
                dbms_output.put('|');
            END IF;
            dbms_output.put(' ' || nvl(TRIM(to_char(r_answers.answer)),
                                       ' '));
            dbms_output.put(' |');
        END LOOP;
        dbms_output.put_line(' ');
        dbms_output.put_line('|===========|===========|===========|');
    END;

    /*=====================================================================
    PROCEDURE: output_pencil_marks
    
    Draw a grid and output all of the pencil marks (candidates) in the 
    appropriate cells.  
    =====================================================================*/
    PROCEDURE output_pencil_marks
    (
        p_puzzle_id NUMBER,
        p_step_no   NUMBER := 0
    ) AS
        v_row_id NUMBER;
    
        CURSOR c_answers IS
            SELECT c.row_id,
                   c.col_id,
                   c.puzzle_number,
                   a.answer
            FROM   (SELECT c.row_id,
                           c.col_id,
                           n.puzzle_number
                    FROM   cells          c,
                           puzzle_numbers n) c,
                   answers a
            WHERE  a.puzzle_id(+) = p_puzzle_id
            AND    a.row_id(+) = c.row_id
            AND    a.col_id(+) = c.col_id
            AND    a.step_no(+) >= nvl(p_step_no,
                                       0)
            AND    a.pencil_mark_ind(+) >=
                   decode(nvl(p_step_no,
                               0),
                           0,
                           1,
                           -1)
            AND    a.answer(+) = c.puzzle_number
            ORDER  BY c.row_id,
                      c.col_id,
                      c.puzzle_number;
    BEGIN
        dbms_output.put_line(' ');
        dbms_output.put_line('Step No = ' || nvl(p_step_no,
                                                 0));
    
        v_row_id := 0;
        FOR r_answers IN c_answers LOOP
        
            IF v_row_id != r_answers.row_id THEN
                IF r_answers.row_id IN (1, 4, 7) THEN
                    dbms_output.put_line(' |======================================|======================================|======================================|');
                ELSE
                    dbms_output.put_line(' |--------------------------------------|--------------------------------------|--------------------------------------|');
                END IF;
                v_row_id := r_answers.row_id;
            END IF;
        
            IF r_answers.puzzle_number = 1 THEN
                dbms_output.put(' | ');
            END IF;
        
            dbms_output.put(nvl(TRIM(to_char(r_answers.answer)),
                                ' ') || CASE WHEN
                            r_answers.puzzle_number = 9 THEN ' ' ELSE NULL END);
        
            IF r_answers.col_id = 9 AND r_answers.puzzle_number = 9 THEN
                dbms_output.put_line(' |');
            END IF;
        
        END LOOP;
        dbms_output.put_line(' |======================================|======================================|======================================|');
        dbms_output.put_line(' ');
    END;
    
    /*=====================================================================
    PROCEDURE: set_singles_cell
    
    ALGORITHM: 1. SINGLES - cell

	If there is only a single remaining pencil mark in a cell, then it must 
    be a certainty. Any other candidates with the same value in the same box, 
    row or column can be eliminated.    
    =====================================================================*/

    PROCEDURE set_singles_cell
    (
        p_puzzle_id     NUMBER,
        p_show_workings NUMBER,
        p_row_count     OUT NUMBER
    ) AS
        v_step_no NUMBER;
    BEGIN
    
        IF p_show_workings >= 2 THEN
            dbms_output.put_line('**************************************************************************************************************************************');
            dbms_output.put_line('SINGLES CELL');
            dbms_output.put_line('**************************************************************************************************************************************');
        END IF;
    
        SELECT step_no_seq.NEXTVAL
        INTO   v_step_no
        FROM   dual;
    
        p_row_count := 0;
    
        -- A particular cell has only one answer
        UPDATE answers
        SET    pencil_mark_ind = 0,
               step_no         = v_step_no
        WHERE  pencil_mark_ind > 0
        AND    puzzle_id = p_puzzle_id
        AND    (row_id, col_id) IN
               (SELECT a.row_id,
                        a.col_id
                 FROM   answers a
                 WHERE  a.puzzle_id = p_puzzle_id
                 AND    a.pencil_mark_ind > 0
                 GROUP  BY a.row_id,
                           a.col_id
                 HAVING COUNT(*) = 1);
    
        p_row_count := SQL%ROWCOUNT;
    
        IF p_show_workings >= 2 THEN
            dbms_output.put_line('singles: '|| p_row_count);
            output_pencil_marks(p_puzzle_id,v_step_no);
            output_pencil_marks(p_puzzle_id);
            output_answers(p_puzzle_id);
            dbms_output.put_line('--------------------------------------------------------------------------------------------------------------------------------------');
        END IF;
    
    END;

    /*=====================================================================
    PROCEDURE: set_singles_box
    
    ALGORITHM: 2. SINGLES - box
    
	If there is only a single remaining pencil mark in a box for a given 
    number (there may be other pencil mark in its cell), then it must be a 
    certainty, and all other pencil marks in that cell can be rubbed out. 
    All other pencil marks in the same box, row, or column can also be 
    rubbed out.    
    =====================================================================*/

    PROCEDURE set_singles_box
    (
        p_puzzle_id     NUMBER,
        p_show_workings NUMBER,
        p_row_count     OUT NUMBER
    ) AS
        v_step_no NUMBER;
    BEGIN
    
        IF p_show_workings >= 2 THEN
            dbms_output.put_line('**************************************************************************************************************************************');
            dbms_output.put_line('SINGLES BOX');
            dbms_output.put_line('**************************************************************************************************************************************');
        END IF;
    
        SELECT step_no_seq.NEXTVAL
        INTO   v_step_no
        FROM   dual;
    
        p_row_count := 0;
    
        UPDATE answers
        SET    pencil_mark_ind = 0,
               step_no         = v_step_no
        WHERE  pencil_mark_ind > 0
        AND    puzzle_id = p_puzzle_id
        AND    (box_id, answer) IN
               (SELECT a.box_id,
                        a.answer
                 FROM   answers a
                 WHERE  a.puzzle_id = p_puzzle_id
                 AND    a.pencil_mark_ind > 0
                 GROUP  BY a.box_id,
                           a.answer
                 HAVING COUNT(*) = 1);
    
        p_row_count := SQL%ROWCOUNT;
    
        IF p_show_workings >= 2 THEN
            dbms_output.put_line('singles: '|| p_row_count);
            output_pencil_marks(p_puzzle_id,v_step_no);
            output_pencil_marks(p_puzzle_id);
            output_answers(p_puzzle_id);
            dbms_output.put_line('--------------------------------------------------------------------------------------------------------------------------------------');
        END IF;
    
    END;

    /*=====================================================================
    PROCEDURE: set_singles_rubout
    
    Rubs out any candidates due to exitance of a certainty.
    =====================================================================*/
    
    PROCEDURE set_singles_rubout
    (
        p_puzzle_id     NUMBER,
        p_show_workings NUMBER,
        p_row_count     OUT NUMBER
    ) AS
        v_step_no NUMBER;
    BEGIN
    
        IF p_show_workings >= 2 THEN
            dbms_output.put_line('**************************************************************************************************************************************');
            dbms_output.put_line('SINGLES RUBOUT');
            dbms_output.put_line('**************************************************************************************************************************************');
        END IF;
    
        SELECT step_no_seq.NEXTVAL
        INTO   v_step_no
        FROM   dual;
    
        p_row_count := 0;
    
    	-- Rubout candidates in the same cell as the certainty
        UPDATE answers a
        SET    pencil_mark_ind = -1,
               step_no         = v_step_no
        WHERE  a.pencil_mark_ind > 0
        AND    a.puzzle_id = p_puzzle_id
        AND    (a.row_id, a.col_id) IN
               (SELECT a2.row_id,
                        a2.col_id
                 FROM   answers a2
                 WHERE  a2.pencil_mark_ind = 0
                 AND    a2.puzzle_id = p_puzzle_id);
        
        p_row_count := SQL%ROWCOUNT;
    
        -- Rubout candidates in other cells but in the same box, row, or column  
        FOR i IN 1 .. 3 LOOP
            UPDATE answers a
            SET    a.pencil_mark_ind = -1,
                   a.step_no         = v_step_no
            WHERE  a.pencil_mark_ind > 0
            AND    a.puzzle_id = p_puzzle_id
            AND    (a.answer, DECODE(i,
                                     1, a.box_id,
                                     2, a.row_id,
                                     3, a.col_id
                                     )
                    ) IN
                    (SELECT  a2.answer,
                            DECODE(i,
                                   1, a2.box_id,
                                   2, a2.row_id,
                                   3, a2.col_id)
                     FROM   answers a2
                     WHERE  a2.puzzle_id = p_puzzle_id
                     AND    a2.pencil_mark_ind = 0
                     AND    (a2.row_id != a.row_id OR a2.col_id != a.col_id)
                    );
        
            p_row_count := p_row_count + SQL%ROWCOUNT;
        
        END LOOP;
            
        IF p_show_workings >= 2 THEN
            dbms_output.put_line('Rubbed out: '|| p_row_count);
            output_pencil_marks(p_puzzle_id, v_step_no);
            output_pencil_marks(p_puzzle_id);
            output_answers(p_puzzle_id);
            dbms_output.put_line('--------------------------------------------------------------------------------------------------------------------------------------');
        END IF;
    
    END;

    /*=====================================================================
    PROCEDURE: set_cross_hatches
    
    ALGORITHM: 3. CROSS HATCHING

	For each double candidate [n=2] (forming a row or column in a box), or 
    triple candidate [n=3] (forming a row or column in a box), eliminate 
    candidates of the same value in the same row or column but in a 
    different box. 
    =====================================================================*/

    PROCEDURE set_cross_hatches
    (
        p_puzzle_id     NUMBER,
        p_size          NUMBER,  -- n = 1, 2, or 3
        p_show_workings NUMBER,
        p_row_count     OUT NUMBER
    ) AS
        v_step_no NUMBER;
    BEGIN
        IF p_show_workings >= 2 THEN
            dbms_output.put_line('**************************************************************************************************************************************');
            dbms_output.put_line('CROSS HATCHES size: ' || p_size);
            dbms_output.put_line('**************************************************************************************************************************************');
        END IF;
    
        SELECT step_no_seq.NEXTVAL
        INTO   v_step_no
        FROM   dual;
    
        reset_pencil_marks(p_puzzle_id);
    
        p_row_count := 0;
    
        -- SET CANDIDATES
        UPDATE answers
        SET    pencil_mark_ind = 2,
               step_no         = v_step_no
        WHERE  pencil_mark_ind = 1
        AND    puzzle_id = p_puzzle_id
        AND    (box_id, answer) IN
               (SELECT a.box_id,
                        a.answer
                 FROM   answers a
                 WHERE  a.pencil_mark_ind > 0
                 AND    a.puzzle_id = p_puzzle_id
                 GROUP  BY a.box_id,
                           a.answer
                 HAVING COUNT(*) = p_size 
                 AND (	MIN(a.col_id) = MAX(a.col_id) 
                 	OR 	MIN(a.row_id) = MAX(a.row_id)
                    )
                );
    
        p_row_count := SQL%ROWCOUNT;
    
        IF p_show_workings >= 2 THEN
            dbms_output.put_line('CROSS HATCHES size: ' || p_size ||
                                 ' updated: ' || p_row_count);
            output_pencil_marks(p_puzzle_id, v_step_no);
            dbms_output.put_line('--------------------------------------------------------------------------------------------------------------------------------------');
        END IF;
    
        IF p_row_count > 0 THEN
        
            SELECT step_no_seq.NEXTVAL
            INTO   v_step_no
            FROM   dual;
        
            -- RUBOUT CANDIDATES 
            FOR i IN 1 .. 2 LOOP
            
                UPDATE answers a
                SET    pencil_mark_ind = -1,
                       step_no         = v_step_no
                WHERE  a.pencil_mark_ind > 0
                AND    a.puzzle_id = p_puzzle_id
                AND    (DECODE(i,
                               1, a.row_id,
                               2, a.col_id
                               ), 
                        a.answer
                       ) IN
                       (SELECT DECODE(i,
                                       1, a2.row_id,
                                       2, a2.col_id
                                     ),
                                a2.answer
                         FROM   answers a2
                         WHERE  a2.pencil_mark_ind = 2
                         AND    a2.puzzle_id = p_puzzle_id
                         AND    a2.box_id != a.box_id
                         GROUP  BY a2.box_id,
                                   decode(i,
                                          1, a2.row_id,
                                          2, a2.col_id
                                         ),
                                   a2.answer
                         HAVING COUNT(*) = p_size);
            
                p_row_count := p_row_count + SQL%ROWCOUNT;
            
            END LOOP;
                
        END IF;
    
        IF p_show_workings >= 2 THEN
            dbms_output.put_line('rubbed out: '|| p_row_count);
            output_pencil_marks(p_puzzle_id,v_step_no);
            output_pencil_marks(p_puzzle_id);
            output_answers(p_puzzle_id);
            dbms_output.put_line('--------------------------------------------------------------------------------------------------------------------------------------');
        END IF;
    
    END;

    /*=====================================================================
    PROCEDURE: set_cross_hatches
    
    ALGORITHM: 4. PARTIAL MEMBER SETS
    
    For a combination of n numbers, e.g. n = 3, with combination set of 3,4, 
    and 5, identify n cells in a box, row or column with all candidates 
    being part of the set. The candidates do not have to be the complete
    set, e.g. a box could have three cells with candidates: 3,4 ; 3,4,5 ; 
    and 4,5. Candidates in other cells with the same value in the same 
    box, row, or column (depending on whether the sets have been identified 
    in a box, row or column) can be eliminated. 
    =====================================================================*/

    PROCEDURE set_incomplete_sets
    (
        p_puzzle_id     NUMBER,
        p_type          NUMBER, -- 1 = box, 2 = row, 3 = column
        p_size          NUMBER,	-- n = 2,3,4, or 5
        p_show_workings NUMBER,
        p_row_count     OUT NUMBER
    ) AS
        v_step_no NUMBER;
    BEGIN
        IF p_show_workings >= 2 THEN
            dbms_output.put_line('**************************************************************************************************************************************');
            dbms_output.put_line('INCOMPLETE SETS size:' || p_size || ' box,row,col: ' || p_type);
            dbms_output.put_line('**************************************************************************************************************************************');
        END IF;
    
        SELECT step_no_seq.NEXTVAL
        INTO   v_step_no
        FROM   dual;
    
        reset_pencil_marks(p_puzzle_id);
    
        p_row_count := 0;
    
        -- SET CANDIDATES 
        UPDATE answers
        SET    pencil_mark_ind = 2,
           step_no         = v_step_no
        WHERE  pencil_mark_ind > 0
        AND    puzzle_id = p_puzzle_id
        AND    (row_id, col_id) IN
           (SELECT  /* -------------------------
                    STEP E:
                    This sub-query identifies 
                    the cells which are entirely
                    made up of candidates 
                    belonging to the same set 
                    spread across n cells in a 
                    box/row/column.
                    ------------------------- */
            		a.row_id,
                    a.col_id
             FROM   (SELECT /* -------------------------
             				STEP C:
                            This in-line view identifies 
                            all the possible sets 
                            (combinations) of size n 
                            within a cell and that set 
                            appearing up to and
                            including the most number 
                            of candidates identified
                            in step A. 
                            ------------------------- */ 
                            a.box_id,
                            a.row_id,
                            a.col_id,
                            pn.set_id,
                            COUNT(*) cnt
                     FROM   combinations pn,
                            (SELECT /* ------------------------
                                    STEP B:
                                    This in-line view retrieves 
                                    all the candidates from the 
                                    cells having exactly n or 
                                    less candidates 
                                    ------------------------- */ 
                            		b.box_id,
                                    b.row_id,
                                    b.col_id,
                                    a.cnt,
                                    b.answer
                             FROM   (SELECT /* ------------------------
                             				STEP A:
                                            This in-line view identifies 
                                            those cells which have 
                                            exactly n (set size) or 
                                            less candiates in the cell. 
                                            ------------------------- */ 
                             				a.box_id,
                                            a.row_id,
                                            a.col_id,
                                            COUNT(*) cnt
                                     FROM   answers a
                                     WHERE  a.puzzle_id = p_puzzle_id
                                     AND    a.pencil_mark_ind > 0
                                     GROUP  BY a.box_id,
                                               a.row_id,
                                               a.col_id
                                     HAVING COUNT(*) <= p_size
                                    ) a,
                                    answers b
                             WHERE  a.box_id = b.box_id
                             AND    a.row_id = b.row_id
                             AND    a.col_id = b.col_id
                             AND    b.puzzle_id = p_puzzle_id
                             AND    b.pencil_mark_ind > 0
                             ) a
                     WHERE  pn.set_size = p_size
                     AND    a.answer = pn.puzzle_number
                     GROUP  BY a.box_id,
                               a.row_id,
                               a.col_id,
                               pn.set_id
                     HAVING COUNT(*) = MAX(a.cnt)
                     ) a,
                    (SELECT /* ------------------------
             				STEP D:
                            This in-line repeats steps
                            A, B and C to identify the 
                            cells again, and then
                            selects the box/row/column 
                            which has the sets 
                            appearing in n cells in 
                            that box/row/column
                            ------------------------- */
                    		DECODE(p_type,
                                   1, a.box_id,
                                   2, a.row_id,
                                   3, a.col_id) id,
                            a.set_id
                     FROM   (SELECT a.box_id,
                                    a.row_id,
                                    a.col_id,
                                    pn.set_id,
                                    COUNT(*) cnt
                             FROM   combinations pn,
                                    (SELECT b.box_id,
                                            b.row_id,
                                            b.col_id,
                                            a.cnt,
                                            b.answer
                                     FROM  (SELECT a.box_id,
                                                   a.row_id,
                                                    a.col_id,
                                                    COUNT(*) cnt
                                             FROM   answers a
                                             WHERE  a.puzzle_id =
                                                    p_puzzle_id
                                             AND    a.pencil_mark_ind > 0
                                             GROUP  BY a.box_id,
                                                       a.row_id,
                                                       a.col_id
                                             HAVING COUNT(*) <= p_size
                                            ) a,
                                            answers b
                                     WHERE  a.box_id = b.box_id
                                     AND    a.row_id = b.row_id
                                     AND    a.col_id = b.col_id
                                     AND    b.puzzle_id = p_puzzle_id
                                     AND    b.pencil_mark_ind > 0) a
                             WHERE  pn.set_size = p_size
                             AND    a.answer = pn.puzzle_number
                             GROUP  BY a.box_id,
                                       a.row_id,
                                       a.col_id,
                                       pn.set_id
                             HAVING COUNT(*) = MAX(a.cnt)
                             ) a
                     GROUP  BY DECODE(p_type,
                                      1, a.box_id,
                                      2, a.row_id,
                                      3, a.col_id),
                               a.set_id
                     HAVING COUNT(*) = p_size
                     ) s
             WHERE  s.id = DECODE(p_type,
                                  1, a.box_id,
                                  2, a.row_id,
                                  3, a.col_id)
             AND    s.set_id = a.set_id
             );
    
        p_row_count := SQL%ROWCOUNT;
    
        IF p_show_workings >= 2 THEN
            dbms_output.put_line('CROSS HATCHES size: ' || p_size ||
                                 ' updated: ' || p_row_count);
            output_pencil_marks(p_puzzle_id,v_step_no);
            dbms_output.put_line('--------------------------------------------------------------------------------------------------------------------------------------');
        END IF;
    
        -- RUBOUT CANDIDATES 
        IF p_row_count > 0 THEN
        
            SELECT step_no_seq.NEXTVAL
            INTO   v_step_no
            FROM   dual;
        
            UPDATE answers a
            SET    pencil_mark_ind = -1,
                   step_no         = v_step_no
            WHERE  a.pencil_mark_ind > 0
            AND    a.pencil_mark_ind != 2
            AND    a.puzzle_id = p_puzzle_id
            AND    (DECODE(p_type,
                           1, a.box_id,
                           2, a.row_id,
                           3, a.col_id
                          ), 
                    a.answer
                   ) IN
                   (SELECT  DECODE(p_type,
                                   1, a2.box_id,
                                   2, a2.row_id,
                                   3, a2.col_id),
                            a2.answer
                     FROM   answers a2
                     WHERE  a2.pencil_mark_ind = 2
                     AND    a2.puzzle_id = p_puzzle_id);
                     
        	p_row_count := SQL%ROWCOUNT;

        END IF;
    
        IF p_show_workings >= 2 THEN
            dbms_output.put_line('rubbed out: '|| p_row_count);
            output_pencil_marks(p_puzzle_id,v_step_no);
            output_pencil_marks(p_puzzle_id);
            output_answers(p_puzzle_id);
            dbms_output.put_line('--------------------------------------------------------------------------------------------------------------------------------------');
        END IF;
    
    END;

    /*=====================================================================
    PROCEDURE: set_singles
    
    Executes all of the singles algorithms and subsequent rubbing out. 
    It is executed immediately after any algorithm has successfully 
    eliminated candidates. 
    =====================================================================*/
    PROCEDURE set_singles
    (
        p_puzzle_id     NUMBER,
        p_show_workings NUMBER,
        p_row_count     OUT NUMBER
    ) AS
        v_answer_count      NUMBER;
        v_answer_count_last NUMBER;
        v_row_count         NUMBER;
        v_limit_cnt         NUMBER := 0;
    BEGIN
        p_row_count := 0;
        v_answer_count_last := answer_count(p_puzzle_id);
        LOOP
            v_limit_cnt := v_limit_cnt + 1;
        
            set_singles_cell
            (
            	p_puzzle_id,
                p_show_workings,
                v_row_count
            );
            
            p_row_count := p_row_count + v_row_count;
            IF v_row_count > 0 THEN
                set_singles_rubout
                (
                	p_puzzle_id,
                    p_show_workings,
                    v_row_count
                );
            END IF;
        
            set_singles_box
            (
            	p_puzzle_id,
                p_show_workings,
                v_row_count
            );
            
            p_row_count := p_row_count + v_row_count;
            IF v_row_count > 0 THEN
            
                set_singles_rubout
                (
                	p_puzzle_id,
                    p_show_workings,
                    v_row_count
                );
                
            END IF;
        
            v_answer_count := answer_count(p_puzzle_id);
        
            EXIT WHEN v_answer_count = v_answer_count_last OR v_answer_count = 81 OR v_limit_cnt > 60;
        
            v_answer_count_last := v_answer_count;
        
        END LOOP;
    END;
    
    PROCEDURE reset_puzzle
    (
    	p_puzzle_id     NUMBER	
    )
    AS
    BEGIN
        -- Clear out the answer table with answers to previous runs for the 
        -- particular puzzle id.
        
        DELETE FROM answers
        WHERE  puzzle_id = p_puzzle_id;
     
     	-- Load up the answers table with the saved puzzles in the puzzle_load
        -- table.
        
        INSERT INTO answers
            (puzzle_id,
             step_no,
             row_id,
             col_id,
             pencil_mark_ind,
             answer,
             box_id)
            SELECT puzzle_id,
                   -1,
                   row_id,
                   1,
                   0,
                   col_id1,
                   NULL
            FROM   puzzle_load
            WHERE  puzzle_id = p_puzzle_id
            AND    col_id1 IS NOT NULL
            UNION ALL
            SELECT puzzle_id,
                   -1,
                   row_id,
                   2,
                   0,
                   col_id2,
                   NULL
            FROM   puzzle_load
            WHERE  puzzle_id = p_puzzle_id
            AND    col_id2 IS NOT NULL
            UNION ALL
            SELECT puzzle_id,
                   -1,
                   row_id,
                   3,
                   0,
                   col_id3,
                   NULL
            FROM   puzzle_load
            WHERE  puzzle_id = p_puzzle_id
            AND    col_id3 IS NOT NULL
            UNION ALL
            SELECT puzzle_id,
                   -1,
                   row_id,
                   4,
                   0,
                   col_id4,
                   NULL
            FROM   puzzle_load
            WHERE  puzzle_id = p_puzzle_id
            AND    col_id4 IS NOT NULL
            UNION ALL
            SELECT puzzle_id,
                   -1,
                   row_id,
                   5,
                   0,
                   col_id5,
                   NULL
            FROM   puzzle_load
            WHERE  puzzle_id = p_puzzle_id
            AND    col_id5 IS NOT NULL
            UNION ALL
            SELECT puzzle_id,
                   -1,
                   row_id,
                   6,
                   0,
                   col_id6,
                   NULL
            FROM   puzzle_load
            WHERE  puzzle_id = p_puzzle_id
            AND    col_id6 IS NOT NULL
            UNION ALL
            SELECT puzzle_id,
                   -1,
                   row_id,
                   7,
                   0,
                   col_id7,
                   NULL
            FROM   puzzle_load
            WHERE  puzzle_id = p_puzzle_id
            AND    col_id7 IS NOT NULL
            UNION ALL
            SELECT puzzle_id,
                   -1,
                   row_id,
                   8,
                   0,
                   col_id8,
                   NULL
            FROM   puzzle_load
            WHERE  puzzle_id = p_puzzle_id
            AND    col_id8 IS NOT NULL
            UNION ALL
            SELECT puzzle_id,
                   -1,
                   row_id,
                   9,
                   0,
                   col_id9,
                   NULL
            FROM   puzzle_load
            WHERE  puzzle_id = p_puzzle_id
            AND    col_id9 IS NOT NULL;
    
        COMMIT;
        
        EXECUTE IMMEDIATE 'ANALYZE TABLE answers COMPUTE STATISTICS';
    END;

BEGIN

    /*=====================================================================
    MAIN BODY OF PROCEDURE
    
    The saved puzzles are stored in the puzzle_load table (loaded via the
    insert statements generated by the sudoku.xls spreadsheet).
    
    =====================================================================*/

   	-- Reset the puzzle answers from last run
    reset_puzzle(p_puzzle_id);
    
    -- Display the puzzle grid 
    output_answers(p_puzzle_id);

    -- Create the candidates
    setup_candidates(p_puzzle_id);

    IF p_show_workings >= 1 THEN
    	-- Display the candidates in a grid
        output_pencil_marks(p_puzzle_id);
    END IF;

    
    -- ======================================================
    -- SINGLES algorithms
    -- ======================================================
    v_answer_count_last := answer_count(p_puzzle_id);
    dbms_output.put_line('SINGLES  answers: ' || v_answer_count_last);
                         
    set_singles
    (
    	p_puzzle_id,
    	p_show_workings,
    	v_row_count
    );

    v_answer_count_last := answer_count(p_puzzle_id);


    -- ======================================================
    -- CROSS HATCH algorithm
    -- ======================================================

    v_limit_cnt := 0;
    WHILE v_answer_count_last < 81 LOOP
    
        v_limit_cnt := v_limit_cnt + 1;
        IF p_show_workings >= 1 THEN
            dbms_output.put_line('CROSS HATCH #' || v_limit_cnt ||
                                 '  answers: ' || v_answer_count);
        END IF;
    
        FOR i IN 2 .. 3 LOOP
            set_cross_hatches
            (
            	p_puzzle_id,
                i,
                p_show_workings,
                v_row_count
            );
            
            IF v_row_count > 0 THEN
                set_singles
                (
                	p_puzzle_id,
                    p_show_workings,
                    v_singles_count
                );
            END IF;
        
            IF p_show_workings >= 1 THEN
            
                v_answer_count := answer_count(p_puzzle_id);
                IF p_show_workings >= 1 THEN
                    dbms_output.put_line('     Size: ' || i ||
                                         ' answers: ' ||
                                         v_answer_count ||
                                         ' updated: ' || v_row_count ||
                                         ' singles: ' ||
                                         v_singles_count);
                END IF;
                EXIT WHEN v_answer_count = 81;
            
            END IF;
        END LOOP;
    
        v_answer_count := answer_count(p_puzzle_id);
    
        EXIT WHEN v_answer_count = v_answer_count_last OR v_answer_count = 81 OR v_limit_cnt > 60;
    
        v_answer_count_last := v_answer_count;
    
    END LOOP;

    -- ======================================================
    -- PARTIAL MEMBER SET algorithms
    -- ======================================================
    v_answer_count_last := answer_count(p_puzzle_id);
    v_limit_cnt := 0;
    WHILE v_answer_count_last < 81 LOOP
        v_limit_cnt := v_limit_cnt + 1;
        IF p_show_workings >= 1 THEN
            dbms_output.put_line('PARTIAL MEMBER SET #' || v_limit_cnt ||
                                 ' answers: ' || v_answer_count_last);
        END IF;
    
        FOR i IN 2 .. 5 LOOP
            FOR j IN 1 .. 3 LOOP
                set_incomplete_sets(p_puzzle_id,
                                  j,
                                  i,
                                  p_show_workings,
                                  v_row_count);
                IF v_row_count > 0 THEN
                    set_singles(p_puzzle_id,
                                p_show_workings,
                                v_singles_count);
                END IF;
            
                v_answer_count := answer_count(p_puzzle_id);
                IF p_show_workings >= 1 THEN
                    dbms_output.put_line('     Size: ' || i ||
                                         ' Box,Row,Col: ' || j ||
                                         ' answers: ' ||
                                         v_answer_count ||
                                         ' updated: ' || v_row_count ||
                                         ' singles: ' ||
                                         v_singles_count);
                END IF;
                EXIT WHEN v_answer_count = 81;
            
            END LOOP;
        END LOOP;
    
        v_answer_count := answer_count(p_puzzle_id);
    
        EXIT WHEN v_answer_count = v_answer_count_last OR v_answer_count = 81 OR v_limit_cnt > 60;
    
        v_answer_count_last := v_answer_count;
    
    END LOOP;

    IF p_show_workings >= 2 THEN
        output_pencil_marks(p_puzzle_id);
        output_answers(p_puzzle_id);
    END IF;

    COMMIT;

    v_answer_count := answer_count(p_puzzle_id);

    IF p_show_workings >= 2 THEN
        dbms_output.put_line('Answer Count: ' || v_answer_count);
    END IF;
    
    COMMIT;

    dbms_output.put_line(' ');
    dbms_output.put_line(' ');
    IF v_answer_count = 81 THEN
        dbms_output.put_line('The puzzle has been successfully solved');
    ELSE
        dbms_output.put_line('Failed to solve puzzle completely');
        output_pencil_marks(p_puzzle_id);
    END IF;

    output_answers(p_puzzle_id);
    
    dbms_output.put_line(' ');
    dbms_output.put_line(' ');

    dbms_output.put_line('PL/SQL Sudoku Solver - (c) 2005 Philip Lambert, Database Innovation Limited');

END;
/
