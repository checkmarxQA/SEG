--    Copyright (c) 2001, University of Minnesota
--    All rights reserved.
--    
--    Redistribution and use in source and binary forms, with or without
--    modification, are permitted provided that the following conditions are
--    met:
--    
--         * Redistributions of source code must retain the above copyright
--           notice, this list of conditions and the following disclaimer.
--    
--         * Redistributions in binary form must reproduce the above
--           copyright notice, this list of conditions and the following
--           disclaimer in the documentation and/or other materials provided
--           with the distribution.
--    
--         * Neither the name of the University of Minnesota nor the of its
--           contributors may be used to endorse or promote products derived
--           from this software without specific prior written permission.
--    
--    
--           THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
--           CONTRIBUTORS ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
--           INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
--           MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
--           DISCLAIMED. IN NO EVENT SHALL THE UNIVERSITY OF MINNESOTA OR
--           CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
--           SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
--           NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
--           LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
--           HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
--           CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
--           OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
--           EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

-- $Id: core.sql,v 1.22 2001/03/20 01:54:13 herlock Exp $

CREATE OR REPLACE PACKAGE BODY core AS	
   amplify_case_exponent float;
   devalue_constant int;

   procedure set_devalue(n in integer) is 
   begin
      devalue_constant := n;
   end;

   procedure set_amplify_case_exponent(n in integer) is 
   begin
      amplify_case_exponent := n;
   end;

   -- 
   -- This is the function used to devalue correlations
   -- when then number of shared ratings is small
   -- NOTE! To call this function from a SQL query in 
   -- Oracle 7.X, you must fully specify the path to the 
   -- function (ie 'core.corr_strength')
   --
   function corr_strength(n in integer) return float is 
         c float;
      begin
         c := nvl(devalue_constant, 50);
         if (n >= c) then
            return 1;
         else
            return (n / c);
         end if;
     end corr_strength;

     --
     -- Case Amplication causes weights closer to 1 to be strengthened
     -- and cases closer to 0 to be de-empathized.
     --    
     function amplify_case(w in float) return float is 
        exponent float;
     begin
        exponent := nvl(amplify_case_exponent, 1);
        if (exponent = 1) then
		return w;
	end if;
	if (w >= 0) then 
           return power(w, exponent);
        else 
           return -power(-w, exponent);
	end if;
     end amplify_case;
     --
     -- This is the basic corr. algorithm. 
     -- correlations are devalued if they share less
     -- than 50 neighbors.
     -- current_item will be ignored if  
     -- form_item_neighborhood is not set.
     --
     PROCEDURE compute_weighted_correlation(curr_valid IN INTEGER, 
                                            grp        IN INTEGER, 
                                            usr        IN INTEGER,
                                            current_item     in integer) IS
        ind INTEGER;
        curr_corr FLOAT;
        already_there INTEGER;
        valid_value INTEGER;
        max_nbor_count integer;
        min_nbor_count integer;
	mincorr float;
	candidate integer;
	form_item_nbrhd integer;
	max_abs_similarity_wt float;
	raw_correlation float;
	cursor c1 is select msgid 
	                from ratings
	                where groupid = grp
                          AND   userid = candidate
                          AND    msgid = current_item;
     BEGIN 
        max_nbor_count := param.get_param('max_neighborhood_size');
        min_nbor_count := param.get_param('min_neighborhood_size');
        form_item_nbrhd := param.get_param('form_item_neighborhood');
	mincorr := param.get_param('min_abs_similarity_weight');
	max_abs_similarity_wt := param.get_param('max_abs_similarity_weight');

	if (form_item_nbrhd <> 0) then
	   param.debug('computing best item nborhood for ', usr);
	else
           param.debug('computing best overall nborhood for ', usr);
	end if;

	ind := curr_valid;
        -- read the terms needed for the correlation computation
        -- formula, ordered by the resulting correlation value
        -- (best first)
        FOR crec IN (SELECT SUM(x.rating * y.rating) 
	                    - (SUM(x.rating) * SUM(y.rating)) / count(*) ssxy,
	               SUM(x.rating * x.rating) 
		       - (SUM(x.rating) * SUM(x.rating)) / count(*)  ssxx,
	               SUM(y.rating * y.rating) 
		       - (SUM(y.rating) * SUM(y.rating)) / count(*)  ssyy,
                       AVG(x.rating) xmean,
                       AVG(y.rating) ymean,
                       COUNT(*) nn,
                       ABS((SUM(x.rating * y.rating) -
                           (SUM(x.rating) * SUM(y.rating))/
                           COUNT(*)) /
                       ((COUNT(*) - 1) * STDDEV(x.rating) * STDDEV(y.rating)))
                           * core.corr_strength(count(*))
                       sortcol,
                       y.userid usr2
                       FROM ratings x, ratings y
                       WHERE x.groupid = grp AND
                             y.groupid = grp AND
                             x.userid = usr AND
                             y.userid <> usr AND
                             x.msgid = y.msgid
                       GROUP BY y.userid
                       HAVING COUNT(*) > 1
                          AND STDDEV(x.rating) > 0.0
                          AND STDDEV(y.rating) > 0.0
                       ORDER BY sortcol DESC) 
        LOOP
           if (crec.sortcol > max_abs_similarity_wt) then
	         goto next;
           end if;

           -- exit the loop when we have enough correlations
           exit when crec.sortcol < mincorr;
           EXIT WHEN ind >= max_nbor_count;
           exit when crec.sortcol  = 0;

           IF crec.ssxy  >= 0 THEN
              curr_corr := crec.sortcol;
           ELSE
              curr_corr := -crec.sortcol;
           END IF;

           if (form_item_nbrhd <> 0) then 
                 -- We use an explicit cursor, because an implicit
                 -- cursor (select into) will do 2 fetches every time
                 -- ref: ORA Perf. Tuning p.222
                 candidate := crec.usr2;
                 open c1;
                 fetch c1 into valid_value;
                 if c1%notfound then
	            valid_value := 0;
                 end if;
                 close c1;
           else 
               valid_value := 1;
           end if;

           -- insert the correlation if it was not in the db yet
           IF valid_value <> 0 THEN
	     raw_correlation := curr_corr / corr_strength(crec.nn);
             INSERT INTO correlations(groupid, user1, user2,
                                       valid, correlation, timestamp, n, 
					raw_corr, ssxy, ssxx, ssyy, xmean, ymean)
             VALUES(grp, usr, crec.usr2, 5, curr_corr, SYSDATE, crec.nn,
                     raw_correlation, crec.ssxy, crec.ssxx, crec.ssyy, 
  		     crec.xmean, crec.ymean);
              ind := ind + 1;
           end if;
	   -- Do we gain anthing from not commiting every time?
           IF (MOD(ind, 10) = 0) THEN
              COMMIT WORK;
           END IF;
           <<next>>
	   null;
        END LOOP;
	update users 
           set num_nbors = ind 
           where groupid = grp 
             and userid = usr;

        COMMIT WORK;

        param.debug('num neighbors found', ind);
        param.debug('correlation computation done for', usr);
	exception when others then
		param.debug('exception in compute_weighted_correlation','');
		raise;
     END compute_weighted_correlation;

--
-- What does this function do?
--
     PROCEDURE compute_neighbors(curr_valid IN INTEGER, 
                                            grp        IN INTEGER, 
                                            usr        IN INTEGER,
                                            current_item     in integer) IS
        ind INTEGER;
        curr_corr FLOAT;
        already_there INTEGER;
        valid_value INTEGER;
        max_nbor_count integer;
        min_nbor_count integer;
	mincorr float;
	candidate integer;
	form_item_nbrhd integer;
	max_abs_similarity_wt float;
	raw_correlation float;
     BEGIN 
        max_nbor_count := param.get_param('max_neighborhood_size');
        min_nbor_count := param.get_param('min_neighborhood_size');
	mincorr := param.get_param('min_abs_similarity_weight');
	max_abs_similarity_wt := param.get_param('max_abs_similarity_weight');

	ind := curr_valid;
        -- read the terms needed for the correlation computation
        -- formula, ordered by the resulting correlation value
        -- (best first)
        FOR crec IN (SELECT SUM(x.rating * y.rating) 
	                    - (SUM(x.rating) * SUM(y.rating)) / count(*) ssxy,
	               SUM(x.rating * x.rating) 
		       - (SUM(x.rating) * SUM(x.rating)) / count(*)  ssxx,
	               SUM(y.rating * y.rating) 
		       - (SUM(y.rating) * SUM(y.rating)) / count(*)  ssyy,
                       AVG(x.rating) xmean,
                       AVG(y.rating) ymean,
                       COUNT(*) nn,
                       ABS((SUM(x.rating * y.rating) -
                           (SUM(x.rating) * SUM(y.rating))/
                           COUNT(*)) /
                       ((COUNT(*) - 1) * STDDEV(x.rating) * STDDEV(y.rating)))
                           * core.corr_strength(count(*))
                       sortcol,
                       y.userid usr2
                       FROM ratings x, ratings y, users u
                       WHERE x.groupid = grp AND
                             y.groupid = grp AND
                             u.groupid = grp AND
			     u.userid <= 200 AND
                             u.userid = y.userid AND
                             x.userid = usr AND
                             x.msgid = y.msgid
                       GROUP BY y.groupid, y.userid
                       HAVING COUNT(*) > 1
                          AND STDDEV(x.rating) > 0.0
                          AND STDDEV(y.rating) > 0.0
                       ORDER BY sortcol DESC) 
        LOOP
           if (crec.sortcol > max_abs_similarity_wt) then
	         goto next;
           end if;

           -- exit the loop when we have enough correlations
           exit when crec.sortcol < mincorr;
           EXIT WHEN ind >= max_nbor_count;
           exit when crec.sortcol  = 0;

           IF crec.ssxy  >= 0 THEN
              curr_corr := crec.sortcol;
           ELSE
              curr_corr := -crec.sortcol;
           END IF;

	   valid_value := 1;
         
           -- insert the correlation if it was not in the db yet
           IF valid_value <> 0 THEN
	     raw_correlation := curr_corr / corr_strength(crec.nn);
             INSERT INTO correlations(groupid, user1, user2,
                                       valid, correlation, timestamp, n, 
					raw_corr, ssxy, ssxx, ssyy, xmean, ymean)
             VALUES(grp, usr, crec.usr2, 5, curr_corr, SYSDATE, crec.nn,
                     raw_correlation, crec.ssxy, crec.ssxx, crec.ssyy, 
  		     crec.xmean, crec.ymean);
              ind := ind + 1;
           end if;
	   -- Do we gain anthing from not commiting every time?
           IF (MOD(ind, 10) = 0) THEN
              COMMIT WORK;
           END IF;
           <<next>>
	   null;
        END LOOP;
	 
	update users 
           set num_nbors = ind 
           where groupid = grp 
             and userid = usr;

        COMMIT WORK;

        param.debug('num neighbors found', ind);
        param.debug('correlation computation done for', usr);
	exception when others then
		param.debug('exception in compute_neighbors','');
		raise;
     END compute_neighbors;
     --
     -- store_input stores input for getpred()
     --
     PROCEDURE store_input(grpname IN CHAR,
                           usrname IN CHAR,
                           itmname IN CHAR,
                           r       IN FLOAT,
                           tstamp  IN CHAR) IS
     BEGIN
        INSERT INTO input_ratings(groupname, username, itemname, 
                                  rating, timestamp)
        VALUES(grpname, usrname, itmname, r, 
        TO_DATE(tstamp, 'MM/DD/YYYY HH24:MI:SS'));
        COMMIT WORK;
     END store_input;
     --
     -- store_input_by_id stores input for getpred(), but it takes item id
     -- rather than item name
     -- 
     PROCEDURE store_input_by_id(grpname IN CHAR,
                                 usrname IN CHAR,
                                 itmid   IN INTEGER,
                                 r       IN FLOAT,
                                 tstamp  IN CHAR) IS
        itmname VARCHAR2(64);
     BEGIN
        -- find the itemname corresponding the item id
        BEGIN
           SELECT itemname INTO itmname FROM items 
           WHERE msgid = itmid;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
              itmname := 'itemid = ' || itmid;
        END;
        INSERT INTO input_ratings(groupname, username, itemname, 
                                  rating, timestamp)
        VALUES(grpname, usrname, itmname, r, 
        TO_DATE(tstamp, 'MM/DD/YYYY HH24:MI:SS'));
        COMMIT WORK;
     END store_input_by_id;
     -- 
     -- store_rating() stores a single rating
     --
     procedure store_rating(group_name in varchar2, 
                            user_name  in varchar2, 
                            item_name  in varchar2,
                            rating     in integer) is
        m m_type;
        r rr_type;
     begin
        m(1) := item_name;
        r(1) := rating;
        store_ratings(1, group_name, user_name, m, r);
        param.debug('groupname', group_name);
        param.debug('username', user_name);
        param.debug('itemname', item_name);
        param.debug('rating', rating);
     end store_rating;
    
     --
     -- store_ratings() stores the ratings in r for items in m.
     -- 
     PROCEDURE store_ratings(n            IN INTEGER,
                             grpname      IN CHAR,
                             usrname      IN CHAR,
                             m            IN m_type,
                             r            IN rr_type) IS
     BEGIN
        store_ratings(n, grpname, usrname, m, r, SYSDATE);
     END store_ratings;
     --
     -- store_ratings() stores the ratings in r for items in m.
     -- 
     PROCEDURE store_ratings(n            IN INTEGER,
                             grpname      IN CHAR,
                             usrname      IN CHAR,
                             m            IN m_type,
                             r            IN rr_type,
                             tstmp        IN DATE) IS
        curr_avg FLOAT;
        curr_num INTEGER;
        grp      INTEGER;
        usr      INTEGER;
        old_rat  FLOAT;
        m_idx    ind_type;
        usetime  DATE;
        sum_v      integer;
        sumsq_v    integer;
        u_avg    float;
        CURSOR c1 IS SELECT groupid, userid, avgrating, numratings, 
                            sum_ratings, sumsq_ratings
                     FROM users 
                     WHERE groupname = grpname AND username = usrname 
                     FOR UPDATE OF avgrating, numratings, 
                                   sum_ratings, sumsq_ratings, num_nbors;
     BEGIN 
        param.debug('n is ', n);
        if (n <= 0) then
           return;
        end if;
        IF tstmp IS NULL THEN
           usetime := SYSDATE;
        ELSE
           usetime := tstmp;
        END IF;
        param.debug('before loop', '');
        FOR i IN 1..n LOOP
           -- find the item id for the item name
           param.debug('itemname is ', m(i));
           BEGIN
              SELECT msgid INTO m_idx(i) FROM items 
              WHERE itemname = m(i);
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 param.debug('in the exception','');
                 -- if this is a new item give it the next available id
                 select itemid_seq.nextval into m_idx(i) FROM dual;
	         -- save the mapping
                 save_item(m_idx(i), m(i));
           END;
        END LOOP;
        param.debug('after loop', '');
        OPEN c1; 
        FETCH c1 INTO grp, usr, curr_avg, curr_num, sum_v, sumsq_v; 
        IF c1%FOUND THEN 
          FOR i IN 1..n LOOP
             BEGIN 
                SELECT rating INTO old_rat FROM ratings
                   WHERE groupid = grp AND userid = usr AND msgid = m_idx(i);
                sum_v := sum_v - old_rat;
	        sumsq_v := sumsq_v - old_rat * old_rat;
                if (r(i) = -1) then
                   -- We want to delete the rating
                   delete from ratings 
                      where groupid = grp
                        and userid  = usr
                        and msgid   = m_idx(i);
                   curr_num := curr_num - 1;
                else 
                   -- Change the rating
                   UPDATE ratings SET rating = r(i), timestamp = usetime
                      WHERE groupid = grp 
                        AND userid  = usr 
                        AND msgid   = m_idx(i);
                   sum_v := sum_v + r(i);
                   sumsq_v := sumsq_v + r(i) * r(i);
                end if;
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   INSERT INTO ratings(groupid, userid, msgid, rating,
                                       timestamp) 
                   VALUES(grp, usr, m_idx(i), r(i), usetime);
                   curr_num := curr_num + 1;
                   sum_v := sum_v + r(i);
             END; 
          END LOOP;
        param.debug('after second loop', '');
          -- every rating will decrement the correlation validity
          -- count. When the validity count is 0, the correlation is
          -- no longer valid 
          UPDATE correlations SET valid = valid - 1  
             WHERE groupid = grp AND (user1 = usr OR user2 = usr); 
          if (curr_num = 0) then
             u_avg := 0;
          else 
             u_avg := sum_v / curr_num;
          end if;
          UPDATE users SET 
                avgrating = u_avg,
                numratings = curr_num,
                sum_ratings = sum_v,
                sumsq_ratings = sumsq_v,
                num_nbors = -1   -- We invalidate any existing nbors
             WHERE CURRENT OF c1; 
        ELSE 
          -- This is a new user
          -- find the next available user id.
          select userid_seq.nextval into usr from dual;
          BEGIN
             SELECT DISTINCT groupid INTO grp FROM users 
             WHERE groupname = grpname;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                -- find the next available groupid.
                select groupid_seq.nextval into grp from dual;
          END;
          sum_v := 0;
          sumsq_v := 0;
          FOR i IN 1..n LOOP 
             INSERT INTO ratings(groupid, userid, msgid, rating,
                                 timestamp) 
                VALUES(grp, usr, m_idx(i), r(i), usetime);
             
             sum_v := sum_v + r(i);
	     sumsq_v := sumsq_v + old_rat * old_rat;
          END LOOP; 
          INSERT INTO users(groupid, userid, avgrating, numratings,
                            groupname, username, sum_ratings, sumsq_ratings, num_nbors) 
             VALUES(grp, usr, sum_v / n, n, grpname, usrname, sum_v, sumsq_v, -1); 
        END IF; 
        COMMIT WORK; 
        CLOSE c1; 
     END store_ratings;
     --
     -- store_category() stores or removes a category rating
     -- 
     PROCEDURE store_category(itemname in char,
		              cat      in integer,
                              value        IN integer) IS
        grp      INTEGER;
        item_id      INTEGER;
        old_value integer;
     BEGIN 
       -- find the item id for the item name
       item_id := get_item_id(itemname);
       select weight into old_value from item_categories
              where itemid = item_id and category = cat;
       if (value = -1) then
          -- We want to delete the rating
          delete from item_categories
             where itemid = item_id  
               and category = cat;
       else 
          -- Change the weight
          UPDATE item_categories SET weight = value
                      WHERE itemid = item_id
                        and category = cat;
       end if;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             INSERT INTO item_categories(itemid, category, weight) 
               VALUES(item_id, cat, value);
     END store_category;
     --
     -- save_item() stores the item id <--> item name mapping
     -- 
     PROCEDURE save_item(id       IN INTEGER,
                         name     IN CHAR) IS
     BEGIN
        INSERT INTO items(msgid, itemname) VALUES(id, name);
        COMMIT WORK;
     END save_item;
--
-- cached_top_n (this is search_type = 1)
--
-- This procedure will compute the top n recommended items for a user
-- over a set of specified item categories. Up to two categories can
-- currently be specified. The item categories are retrieved from the
-- table 'item_categories'. The top n items are then stored in the
-- table 'topn_cache'. The items are identified in the 'topn_cache' table
-- by a unique identifier, which is returned in 'the_cache_slot' parameter
-- 
     procedure cached_top_n(grpname in char, 
                            usrname in char, 
                            n       in out integer,
                            num_categories in integer,
                            category1 in integer,
                            category2 in integer,
                            the_cache_slot out integer) is
        useraverage FLOAT;
        ind         INTEGER;
        grp         INTEGER;
        usr         INTEGER;
        item_name   varchar2(8);
        pred       float;
        user_rating integer;
        -- Declare the necessary types to use cursor variables for the
        -- topn.
        type topn_item_type is RECORD (
           itemid           integer,
           bias             float,
           num_ratings      number,
           max_similarity   float
        );
        type topn_cursor_type is REF CURSOR RETURN topn_item_type;
	topn_cursor           topn_cursor_type;
        toprec                topn_item_type;
     BEGIN 
        -- find the group (partition) and user ids corresponding to 
        -- the given group and user name
        BEGIN
           SELECT avgrating, groupid, userid INTO useraverage, grp,
           usr FROM users 
	   WHERE groupname = grpname AND username = usrname;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 n := 0;
                 return;
        END;
        ind := 1;
        -- this query uses the same algorithm (presented in the 
        -- original GroupLens paper) as get_predictions, except that
        -- in the top_n case we group by item id in the decreasing 
        -- prediction order (best predictions first)
        --
        select cache_seq.nextval into the_cache_slot from dual;
	delete from topn_cache where cache_slot = the_cache_slot;

        if (num_categories < 0) or (num_categories > 2) then
           n := -1;
           return;
        elsif (num_categories = 0) then
           param.debug('num cats = ', num_categories);
           open topn_cursor for 
                    SELECT       rat.msgid itemid,
                                 SUM((rat.rating-u.avgrating)*c.correlation)/
                                    SUM(ABS(c.correlation)) bias, 
                                 count(*) num_ratings,
                                 max(correlation) max_similarity
                          FROM correlations c, ratings rat, users u
                          WHERE
                             c.groupid = grp AND 
                           rat.groupid = grp AND
                             u.groupid = grp AND   
                               c.user1 = usr AND 
                               c.user2 = u.userid AND
                            rat.userid = u.userid
                          GROUP BY rat.msgid
                          HAVING SUM(ABS(c.correlation)) > 0.0
                          ORDER BY bias DESC, num_ratings DESC;

        elsif (num_categories = 1) then
           open topn_cursor for 
                    SELECT       rat.msgid itemid,
                                 SUM((rat.rating-u.avgrating)*c.correlation)/
                                    SUM(ABS(c.correlation)) bias, 
                                 count(*) num_ratings,
                                 max(correlation) max_similarity
                          FROM correlations c, ratings rat, users u,
                               item_categories ic
                          WHERE
                             c.groupid = grp AND 
                           rat.groupid = grp AND
                             u.groupid = grp AND   
                               c.user1 = usr AND 
                               c.user2 = u.userid AND
                            rat.userid = u.userid and
                            ic.itemid = rat.msgid and
                            ic.category = category1
                          GROUP BY rat.msgid
                          HAVING SUM(ABS(c.correlation)) > 0.0
                          ORDER BY bias DESC, num_ratings DESC;
        elsif (num_categories = 2) then
           open topn_cursor for 
                    SELECT       rat.msgid itemid,
                                 SUM((rat.rating-u.avgrating)*c.correlation)/
                                    SUM(ABS(c.correlation)) bias, 
                                 count(*) num_ratings,
                                 max(correlation) max_similarity
                          FROM correlations c, ratings rat, users u,
                               item_categories i1,
                               item_categories i2
                          WHERE
                             c.groupid = grp AND 
                           rat.groupid = grp AND
                             u.groupid = grp AND   
                               c.user1 = usr AND 
                               c.user2 = u.userid AND
                            rat.userid = u.userid and
                            i1.itemid = rat.msgid and
                            i1.category = category1 and
                            i2.itemid = i1.itemid and
                            i2.category = category2
                          GROUP BY rat.msgid
                          HAVING SUM(ABS(c.correlation)) > 0.0
                          ORDER BY bias DESC, num_ratings DESC;
         end if;

         LOOP
             param.debug('in loop', '');
	     param.debug('n is ', n);
	     param.debug('ind is ', ind);
              -- exit the loop when we have found the top n predictions
              EXIT WHEN ind > n;
              FETCH topn_cursor into toprec;
              EXIT WHEN topn_cursor%NOTFOUND;
             param.debug('made it past the NOTFOUND', '');
              -- Check to see if user has rated the item.
              -- We do this outside of the loop, because that way we
              -- only have to do it 'n' times, instead of for every
              -- single item that the neighbors have rated.
              user_rating := -1;
              begin
                 SELECT rating into user_rating FROM ratings WHERE 
                    groupid = grp AND userid = usr AND msgid = toprec.itemid;
                 exception 
                      when no_data_found then
                       user_rating := -1;
              end;
                                      
	      IF (toprec.bias IS NOT NULL) 
                 and (user_rating = -1) 
                 and ((toprec.num_ratings > 5) 
                      or (toprec.max_similarity > 0.5)) THEN
                 -- find the item name corresponding to the item id
                 BEGIN
                    SELECT itemname INTO item_name FROM items 
                    WHERE msgid = toprec.itemid;
                 END;
                 pred := useraverage + toprec.bias;
                 IF pred < 1 THEN
                    pred := 1.0;
                 ELSIF pred > 5 THEN
                    pred := 5.0;
                 END IF;
                 ind := ind + 1;
                 insert into topn_cache 
                         (cache_slot, search_type, username, itemname, 
                                           prediction, num_ratings, timestamp)
                 values 
                         (the_cache_slot, 1, usrname, item_name, 
                                           pred, toprec.num_ratings, SYSDATE);
              END IF;
           END LOOP;
           close topn_cursor;
      DBMS_SESSION.SET_SQL_TRACE (FALSE);
        n := ind - 1;
     end cached_top_n;
     --
     -- bulkload() loads a set of ratings into the 'server' without
     -- asking for any predictions.
     --
     PROCEDURE bulkload IS
        itemnames m_type;
        itemratings rr_type;
        group_name VARCHAR2(64);
        user_name VARCHAR2(64);
     BEGIN
        -- 
        -- read the entire input table and process every line
        -- separately as described above
        --
        FOR inputrec IN (SELECT groupname, username, itemname, 
                                rating, timestamp 
                         FROM input_ratings) LOOP
           itemnames(1) := inputrec.itemname;
           itemratings(1) := inputrec.rating;
           IF inputrec.groupname IS NULL THEN
              group_name := 'N/A';
           ELSE
              group_name := inputrec.groupname;
           END IF;
           IF inputrec.username IS NULL THEN
              user_name := 'N/A'; 
           ELSE
              user_name := inputrec.username;
           END IF;
	    -- store this rating into the "server"
           store_ratings(1, group_name, user_name,
                         itemnames, itemratings,
                         inputrec.timestamp);
        END LOOP;
        COMMIT WORK;   
     END bulkload;
     --
     -- getpred() function can be used to model the server without
     -- actually running the C++ -based server program. This 
     -- stored procedure will read input ratings from input_ratings
     -- table, get a prediction for every input line, store every
     -- input rating, and write both the rating and the prediction
     -- into dblens_output table. That table can then be used to
     -- analyze the correctness of the algorithm
     --
     PROCEDURE getpred IS
        itemnames m_type;
        itemratings rr_type;
        dblens_pred FLOAT;
        ind INTEGER;
        n INTEGER;
        cursor_id   INTEGER;
        dummy       INTEGER;
        prediction_stmt VARCHAR2(256);
        group_name VARCHAR2(64);
        user_name VARCHAR2(64);
        batchmode INTEGER;
	prediction_func varchar2(64);
     BEGIN
        -- 
        -- read the entire input table and process every line
        -- separately as described above
        --
	param.debug('getpred starting','');
        prediction_func := param.get_param('prediction_function');

        batchmode := 0;
        ind := 0;
        prediction_stmt := 'BEGIN ' || prediction_func || '(' ||
                           ':grpname, :usrname, :m, :r, ' ||
                           ':batchmode); END;';
        cursor_id := DBMS_SQL.OPEN_CURSOR;
        param.debug('prediction_stmt', prediction_stmt);
        DBMS_SQL.PARSE(cursor_id, prediction_stmt, DBMS_SQL.V7);
        FOR inputrec IN (SELECT groupname, username, itemname, 
                                rating, timestamp 
                         FROM input_ratings) LOOP
           param.debug(10, 'in the loop', '');
           itemnames(1) := inputrec.itemname;
           itemratings(1) := inputrec.rating;
           IF inputrec.groupname IS NULL THEN
              group_name := 'N/A';
           ELSE
              group_name := inputrec.groupname;
           END IF;
           IF inputrec.username IS NULL THEN
              user_name := 'N/A'; 
           ELSE
              user_name := inputrec.username;
           END IF;
           -- get the prediction for this item from the "server" based
           -- on the current knowledge in the server
           DBMS_SQL.BIND_VARIABLE_CHAR(cursor_id, ':grpname', group_name);
           DBMS_SQL.BIND_VARIABLE_CHAR(cursor_id, ':usrname', user_name);
           DBMS_SQL.BIND_VARIABLE_CHAR(cursor_id, ':m', inputrec.itemname);
           DBMS_SQL.BIND_VARIABLE(cursor_id, ':r', dblens_pred);
           DBMS_SQL.BIND_VARIABLE(cursor_id, ':batchmode', batchmode);
           dummy := DBMS_SQL.EXECUTE(cursor_id);
           DBMS_SQL.VARIABLE_VALUE(cursor_id, ':r', dblens_pred);
           -- store this rating into the "server"
           --store_ratings(1, group_name, user_name,
           --              itemnames, itemratings,
           --              inputrec.timestamp);
	      INSERT INTO dblens_output(groupname, username, itemname,
                                        rating, prediction, timestamp)
              VALUES(group_name, user_name, inputrec.itemname,
                     inputrec.rating, dblens_pred, inputrec.timestamp);
              ind := ind + 1;
              -- do not commit all the time (to improve performance)
              IF MOD(ind, 10) = 0 THEN
                 COMMIT WORK;
              END IF;
        END LOOP;
        DBMS_SQL.CLOSE_CURSOR(cursor_id);
        COMMIT WORK;   
        param.debug('getpred finished', '');
     END getpred;
     PROCEDURE get_prediction(grpname          IN CHAR,
                                usrname          IN CHAR,
                                m                IN CHAR,
                                r                IN OUT FLOAT,
                                batchmode        IN INTEGER) IS
        itemnames m_type;
        itemratings rr_type;
     BEGIN
        itemnames(1) := m;
        itemratings(1) := r;
	get_predictions(1, grpname, usrname,
                        itemnames, itemratings, batchmode);
        r := itemratings(1);
        param.debug('r is ', r);
        param.debug('done -returning', '');
     END get_prediction;
     PROCEDURE constant_prediction(grpname          IN CHAR,
                              usrname          IN CHAR,
                              m                IN CHAR,
                              r                IN OUT FLOAT,
                              batchmode        IN INTEGER) IS
        constant float;
     BEGIN
	constant := param.get_param('constant');
        r := constant;
     END constant_prediction;
     PROCEDURE predict_user_mean(grpname          IN CHAR,
                              usrname          IN CHAR,
                              m                IN CHAR,
                              r                IN OUT FLOAT,
                              batchmode        IN INTEGER) IS
     BEGIN
        BEGIN
           --
           -- find the group id
           -- 
           select sum_ratings / numratings
              into r
              from users 
	      WHERE groupname = grpname AND username = usrname;
              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                    r := -1;
        END;
     END predict_user_mean;
     --
     -- Computes an average rating for each requested.
     --
     PROCEDURE get_average_prediction(grpname          IN CHAR,
                              usrname          IN CHAR,
                              m                IN CHAR,
                              r                IN OUT FLOAT,
                              batchmode        IN INTEGER) IS
       avg_rating float;
       grp        integer;
       itemid     integer;
     BEGIN
        BEGIN
           --
           -- find the group id
           -- 
           select distinct groupid 
              into grp
              from users 
	      WHERE groupname = grpname;
              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                    grp := -1;
        END;
	   --
	   -- find the item id
	   --
        BEGIN
	   SELECT msgid INTO itemid FROM items 
	      WHERE itemname = m;
              EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 itemid  := -1;
        END;
	--
	-- Get the average rating for this item
	--
	select avg(rating)
	   into r
           from ratings 
           where msgid = itemid and groupid = grp;
	if (r is null) then
		r := -1;
	end if;
	--	
     END get_average_prediction;
     --
     -- Computes an average rating for each requested.
     --
     PROCEDURE get_z_score_average_prediction(grpname          IN CHAR,
                              usrname          IN CHAR,
                              m                IN CHAR,
                              r                IN OUT FLOAT,
                              batchmode        IN INTEGER) IS
       avg_rating float;
       grp        integer;
       itemid     integer;
       u_sum	  integer;
       u_sumsq    integer;
       n          integer;
     BEGIN
        BEGIN
           --
           -- find the group id
           -- 
           select groupid, sum_ratings, sumsq_ratings, numratings
              into grp, u_sum, u_sumsq, n
              from users 
	      WHERE groupname = grpname AND username = usrname;
              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                    grp := -1;
        END;
	   --
	   -- find the item id
	   --
        BEGIN
	   SELECT msgid INTO itemid FROM items 
	      WHERE itemname = m;
              EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 itemid  := -1;
        END;
	--
	-- Get the average z-score rating for this item
	--
	select avg((rating - (sum_ratings / numratings)) / 
		   sqrt((sumsq_ratings - 
                             sum_ratings * sum_ratings / numratings)
                        / (numratings - 1)))
	   into r
           from ratings r, users u
           where msgid = itemid 
              and u.groupid = grp
              and r.groupid = grp
              and u.userid = r.userid;

	if (r is null) then
		r := -1;
	else 
	   r := (u_sum / n) + r * sqrt((u_sumsq - u_sum * u_sum / n) / 
		(n - 1));
           if (r > 5) then
		r := 5;
	   end if;
	   if (r < 1) then 
		r := 1;
	   end if;
	end if;
	--	
     END get_z_score_average_prediction;

     --
     -- Computes an average rating for each requested.
     --
     PROCEDURE bias_mean_average_prediction
                             (grpname          IN CHAR,
                              usrname          IN CHAR,
                              m                IN CHAR,
                              r                IN OUT FLOAT,
                              batchmode        IN INTEGER) IS
       avg_rating float;
       grp        integer;
       itemid     integer;
       u_sum	  integer;
       u_sumsq    integer;
       n          integer;
     BEGIN
        BEGIN
           --
           -- find the group id
           -- 
           select groupid, sum_ratings, sumsq_ratings, numratings
              into grp, u_sum, u_sumsq, n
              from users 
	      WHERE groupname = grpname AND username = usrname;
              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                    grp := -1;
        END;
	   --
	   -- find the item id
	   --
        BEGIN
	   SELECT msgid INTO itemid FROM items 
	      WHERE itemname = m;
              EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 itemid  := -1;
        END;
	--
	-- Get the average bias from mean rating for this item
	--
	select avg(rating - (sum_ratings / numratings))
	   into r
           from ratings r, users u
           where msgid = itemid 
              and r.groupid = grp
              and u.groupid = grp
              and u.userid = r.userid;

	--
	-- r now contains the average bias from a user's mean
	--
	if (r is null) then
		r := -1;
	else 
	   r := (u_sum / n) + r;

           if (r > 5) then
		r := 5;
	   end if;
	   if (r < 1) then 
		r := 1;
	   end if;
	end if;
	--	
     END bias_mean_average_prediction;
     --
     -- This get_predictions function calls a correlate algorithm
     -- for every items and passes the current item into it, allowing
     -- a neighborhood to be computed for each specific item.
     -- 
     PROCEDURE get_predictions(n            in integer,
                                 grpname      IN CHAR,
                                 usrname      IN CHAR,
                                 m            IN m_type,
                                 r            IN OUT rr_type,
                                 batchmode    IN INTEGER) IS
        pred_numerator FLOAT;
        pred_denominator FLOAT;
        grp INTEGER;
        usr INTEGER;
	itemid INTEGER;
        curr_valid INTEGER;
        cursor_id INTEGER;
        dummy INTEGER;
        correlation_stmt VARCHAR2(100);
	form_item_nbrhd integer;
	n_nbors integer;
        only_compute_neighbors integer;
	combination_mode varchar2(64);
	den_contribution float;
	correlation_func varchar2(64);
	mean_rating float;
     BEGIN 
        form_item_nbrhd := param.get_param('form_item_neighborhood');
        only_compute_neighbors := param.get_param('only_compute_neighbors');

        -- find out the group (partition) id and user id corresponding
        -- to the given group (partition) name and user name
        BEGIN
           --
           -- find the average rating, group id, and user id for this
           -- (groupname, username) pair
           -- 
           SELECT  groupid, userid
              INTO grp, usr
              FROM users 
	      WHERE groupname = grpname AND username = usrname;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 grp := -1;
                 usr := -1;
                 return;
        END;
        -- if we are not in batchmode, we need to see if we need to
        -- do more correlation computations before computing the
        -- prediction
        param.debug('in get_predictions for user', usr); 

           --
           -- nvl() returns the first argument if non-null, otherwise
	   -- it returns the second argument.
	   --
           select nvl(num_nbors, -1)
             into n_nbors 
              from users 
              where groupid = grp
                 AND userid = usr;

  	-- 0 means no neighbors could be found. Null or -1 means
	-- that you should recompute the neighbors.

	if (n_nbors = 0) then
           -- No neighbors to compute predictions with.
            FOR i IN 1..n LOOP
               r(i) := -1;
            end loop;
            return;
        end if;

          if (n_nbors = -1) then
              -- Correlations have expired or were never computed.
	      correlation_func := param.get_param('correlation_function');
              curr_valid := 0;
              correlation_stmt := 'BEGIN ' || correlation_func || '(' ||
                               ':curr_valid, :grp, :usr';
--	      if (form_item_nbrhd <> 0) then
	         correlation_stmt := correlation_stmt || ', :item';
--	      end if;
              correlation_stmt := correlation_stmt || '); END;';
	      BEGIN
                cursor_id := DBMS_SQL.OPEN_CURSOR;
                DBMS_SQL.PARSE(cursor_id, correlation_stmt, DBMS_SQL.V7);
                DBMS_SQL.BIND_VARIABLE(cursor_id, ':curr_valid', curr_valid);
                DBMS_SQL.BIND_VARIABLE(cursor_id, ':grp', grp);
                DBMS_SQL.BIND_VARIABLE(cursor_id, ':usr', usr);
                DBMS_SQL.BIND_VARIABLE(cursor_id, ':item', itemid);
                dummy := DBMS_SQL.EXECUTE(cursor_id);
                DBMS_SQL.CLOSE_CURSOR(cursor_id);
              exception when others then
	         param.debug('error dynamically executing SQL in get_predictions', correlation_stmt);
                 raise;
              END; 
           end if;

           if (only_compute_neighbors != 0) then
              return;
           end if;

        FOR i IN 1..n LOOP
           -- find the item id corresponding the item name
           BEGIN
              SELECT msgid INTO itemid FROM items 
	      WHERE itemname = m(i);
              EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 itemid  := -1;
           END;
           param.debug('in get_predictions for item', itemid); 


           r(i) := my_get_prediction(grp, usr, itemid,
	                             mean_rating,
                                     pred_numerator,
                                     pred_denominator);


           param.debug('end get_predictions for item', itemid); 
        END LOOP;

        if (form_item_nbrhd <> 0) then 
           delete from correlations where groupid = grp and user1 = usr;
	end if;
	exception when others then
		param.debug('exception in get_predictions', '');
		raise;
     END get_predictions;
     --
     -- 
     --
     procedure store(in_table varchar2, out_table varchar2) is 
        sql_statement varchar2(500);
        cursor_id integer;
	dummy integer;
        error float;
     begin
--        param.debug('start of mean','');

        sql_statement := 'insert into ' 
                             || out_table || ' (data_table)'
                             || ' values (''' || in_table || ''')';
			     
        -- param.debug('', sql_statement);
        cursor_id := dbms_sql.open_cursor;
        dbms_sql.parse(cursor_id, sql_statement, DBMS_SQL.V7);
        begin
           dummy := dbms_sql.execute(cursor_id);
           exception when dup_val_on_index then
             null;
        end;
        dbms_sql.close_cursor(cursor_id);

        sql_statement := 'update ' || out_table 
                             || ' set mean_abs_err = '
			     || ' (select  avg(abs(prediction - rating))'
                                    || ' from ' || in_table || 
                                    ' where prediction > 0)'
                             || ' where data_table = ''' || in_table || '''';
--        param.debug('', sql_statement);
        cursor_id := dbms_sql.open_cursor;
        dbms_sql.parse(cursor_id, sql_statement, DBMS_SQL.V7);
        dummy := dbms_sql.execute(cursor_id);
        dbms_sql.close_cursor(cursor_id);
        exception when others then
           param.debug('exception in mean_abs_error', '');
	   raise;
     end store;
     --
     --
     function mean_abs_err(in_table varchar2) return float is
        dummy integer;
        error float;
	sql_statement varchar2(500);
	cursor_id integer;
	ignore integer;
     begin
        sql_statement :=  'select avg(abs(prediction - rating))'
                                    || ' from ' || in_table ||
                                    ' where prediction > 0';
	cursor_id := dbms_sql.open_cursor;
        dbms_sql.parse(cursor_id, sql_statement, dbms_sql.v7);
	dbms_sql.define_column(cursor_id, 1, error);
        ignore := dbms_sql.execute(cursor_id);
	if (dbms_sql.fetch_rows(cursor_id) > 0) then
           dbms_sql.column_value(cursor_id, 1, error);
	else 
           raise_application_error(-20000, 'couldnt compute mean err');
        end if;
        dbms_sql.close_cursor(cursor_id);
        return error;
        exception when others then
           param.debug('exception in mean_abs_error', '');
	   raise;
     end mean_abs_err;
     
     function get_item_id (item_name varchar2) return integer is
        item_id integer;
     begin
        SELECT msgid INTO item_id FROM items 
	   WHERE itemname = item_name;
        return item_id;
     end get_item_id;

     procedure lookup_user(grpname varchar2, usrname varchar2,
                            grp in out integer, usr in out integer,
                            numrate in out integer, sum_v in out integer,
                            sumsq_v in out integer) is
     begin
           --
           -- find the group id
           -- 
           select groupid, userid, numratings, sum_ratings, sumsq_ratings
              into grp, usr, numrate, sum_v, sumsq_v
              from users 
	      WHERE groupname = grpname AND username = usrname;
              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                    grp := -1;
		    usr := -1;
     end lookup_user;



--
-- New get_prediction that can be called internally with ids
-- instead of names. It also returns the numerator and denominator
-- of the prediction, which is useful in many incremental computations.
-- 
function my_get_prediction(gid in integer,
                           uid in integer,
	                   itemid in integer,
                           mean_rating out float,
                           pred_numerator out float,
                           pred_denominator out float) return float is
        numerator FLOAT;
        denominator FLOAT;
        useraverage FLOAT;
        curr_valid INTEGER;
        cursor_id INTEGER;
        dummy INTEGER;
        correlation_stmt VARCHAR2(100);
	nbors_count integer;
        max_nbor_count integer;
        min_nbor_count integer;
        contribution float;
	abs_similarity float;
        min_abs_similarity_seen float;
	max_abs_similarity_seen float;
	form_item_nbrhd integer;
	n_nbors integer;
	min_abs_similarity_wt float;
	max_abs_similarity_wt float;
        neighbors_considered integer;
        only_compute_neighbors integer;
        use_negative_similarity integer;
        max_sum_abs_similarity float;
        sum_abs_similarity float;
	sd float;
	combination_mode varchar2(64);
	den_contribution float;
        return_average integer;
	correlation_func varchar2(64);
	prediction float;
        record_neighbors_used boolean;
     BEGIN 
        max_nbor_count := param.get_param('max_contributing_neighbors');
        min_nbor_count := param.get_param('min_contributing_neighbors');
        max_abs_similarity_wt := param.get_param('max_abs_similarity_weight');
        min_abs_similarity_wt := param.get_param('min_abs_similarity_weight');
        use_negative_similarity := param.get_param('use_negative_similarity');
        max_sum_abs_similarity := param.get_param('max_sum_abs_similarity');
	combination_mode := lower(param.get_param('combination_mode'));
	return_average := param.get_param('return_average');
        record_neighbors_used := false;

	sum_abs_similarity := 0;
	prediction := -1;
        pred_numerator := -1;
        pred_denominator := -1;

	if (uid < 0) then
           return -1;
        end if;

        BEGIN
           --
           -- find the average rating, group id, and user id for this
           -- (gid, uid) pair
           -- 
	   -- TODO! make an index on the ids (as opposed to the names)
	   --
           SELECT avgrating, sd
              INTO useraverage, sd
              FROM users 
	      WHERE groupid = gid AND userid = uid;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
		return -1;
        END;
        -- We need to see if we need to
        -- do more correlation computations before computing the
        -- prediction
        param.debug('in my_get_predictions for user', uid); 
	param.debug('in my_get_predictions for item', itemid); 

           -- Get the terms for the prediction formula
           -- that is defined in the original GroupLens
           -- paper.
           nbors_count := 0;
	   numerator := 0;
	   denominator := 0;
	   min_abs_similarity_seen := 2;
	   max_abs_similarity_seen := -2;
 	   neighbors_considered := 0;
           begin
              for nbor_rec in (SELECT /*+ FIRST_ROWS */ 
                                      c.user2 nborid,
                                      r.rating,
                                      u.avgrating,
				      u.sd, 
                                      c.correlation,
                                      ABS(c.correlation) abs_similarity
                               FROM correlations c, ratings r, users u
                               WHERE c.groupid = gid 
                                 AND r.groupid = gid 
                                 AND u.groupid = gid 
                                 AND c.user1 = uid 
                                 AND r.msgid = itemid
                                 AND c.user2 = r.userid
                                 AND r.userid = u.userid
                               order by ABS(c.correlation) desc)
              loop
                 if (neighbors_considered = 0) then
 		   param.debug('after sort, begining iterating...','');
		 end if;
	param.debug('abs_similarity', nbor_rec.abs_similarity);
                 nbor_rec.abs_similarity := 
                    amplify_case(nbor_rec.abs_similarity);

	         neighbors_considered := neighbors_considered + 1;

                 exit when 
			(nbor_rec.abs_similarity < min_abs_similarity_wt);

                 if (nbor_rec.abs_similarity > max_abs_similarity_wt) then
                    goto next;
                 end if;
		 if (use_negative_similarity = 0) then
                    if (nbor_rec.correlation < 0) then
	               goto next;
                    end if;
		 end if;

                 if (record_neighbors_used) then 
                    -- Record this neighbor as used.
                    insert into neighbors_used (userid, itemid, nborid) 
                       values (uid, itemid, nbor_rec.nborid);
                    commit;
                 end if;

	         if (combination_mode = 'weighted_average_rating') then
                    -- For negative correlations to work correctly
                    -- bad ratings must be negative. We assume the rating
  		    -- scale is 1-5 here.
	            contribution := (nbor_rec.rating - 3)
   				 * amplify_case(nbor_rec.correlation);
		    den_contribution := nbor_rec.abs_similarity;

                 elsif (combination_mode = 'weighted_average_deviation_from_mean') then

	              contribution := (nbor_rec.rating - nbor_rec.avgrating) 
			  	 * amplify_case(nbor_rec.correlation);
    		    den_contribution := nbor_rec.abs_similarity;

                 elsif (combination_mode = 'average_deviation_from_mean') then

	              contribution := (nbor_rec.rating - nbor_rec.avgrating);
		      den_contribution := 1;

        	 elsif (combination_mode = 'average_zscore') then

	                contribution := (nbor_rec.rating - nbor_rec.avgrating) 
			  	 * amplify_case(nbor_rec.correlation) 
				   / nbor_rec.sd;
                        den_contribution := 1;
        	 elsif (combination_mode = 'weighted_average_zscore') then

	                contribution := (nbor_rec.rating - nbor_rec.avgrating) 
			  	 * amplify_case(nbor_rec.correlation) 
				   / nbor_rec.sd;
                        den_contribution := nbor_rec.abs_similarity;
                 elsif (combination_mode = 'average_rating') then
                         contribution := nbor_rec.rating;
                         den_contribution := 1;
		 else
                    raise_application_error(-20000, 
                                            'unrecognized combination mode' 
					 	|| combination_mode);
	         end if;
		 

		 numerator := numerator + contribution;
		 denominator := denominator + den_contribution;
	         nbors_count := nbors_count + 1;
	         if (nbor_rec.abs_similarity > max_abs_similarity_seen) then
	            max_abs_similarity_seen := nbor_rec.abs_similarity;
	         end if;
	         if (nbor_rec.abs_similarity < min_abs_similarity_seen) then
	            min_abs_similarity_seen := nbor_rec.abs_similarity;
	         end if;
		sum_abs_similarity := sum_abs_similarity
                                         + nbor_rec.abs_similarity;
	         exit when ((nbors_count = max_nbor_count)
		     or (sum_abs_similarity > max_sum_abs_similarity));
                 <<next>>
                 null;
              end loop;
              exception 
	         when no_data_found then
	            param.debug('no neighbors to use!','');
	   end;
	param.debug('denominator is ', denominator);
           -- if no usable correlations can be found, use -1 as the prediction
           IF denominator > 0 THEN
                 if (combination_mode = 'weighted_average_deviation_from_mean') then
		    prediction := useraverage + (numerator / denominator);
		 elsif (combination_mode = 'average_deviation_from_mean') then
                    prediction := useraverage + (numerator / denominator);
	         elsif (combination_mode = 'average_zscore') then
                     prediction := useraverage + (numerator / denominator) * sd ;
	         elsif (combination_mode = 'weighted_average_zscore') then
                     prediction := useraverage + (numerator / denominator) * sd ;
                 else
                     prediction := numerator / denominator;
                 end if;

	         IF prediction < 1 THEN
                    prediction := 1.0;
                 ELSIF prediction > 5 THEN
                    prediction := 5.0;
                 END IF;
           END IF;
	   if (nbors_count < min_nbor_count) then 
	      param.debug('not enough neighbors!', nbors_count);
	      prediction := -1.0;
           end if;
           IF (return_average = 1) AND (prediction = -1.0) THEN
              BEGIN
                 SELECT AVG(rating) INTO prediction FROM ratings
                 WHERE groupid = gid AND msgid = itemid;
              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                    -- if nothing was found make the value -1
                    prediction := -1.0;
              END;
              -- if the value is now null then make it -1
              IF prediction IS NULL THEN
                 prediction := -1.0;
              END IF; 
           END IF;
	   if (prediction <> -1 ) then
  	      param.debug('number of neighbors used:', nbors_count);
	      param.debug('min_abs_similarity_seen', min_abs_similarity_seen);
	      param.debug('max_abs_similarity_seen', max_abs_similarity_seen);
	      param.debug('mean_similarity', denominator / nbors_count);
	      param.debug('sum_abs_similarity', sum_abs_similarity);
	      param.debug('numerator', numerator);
	      param.debug('denominator', denominator);
	      pred_numerator := numerator;
              pred_denominator := denominator;
	      mean_rating := useraverage;
	   end if;
           param.debug('end get_predictions for item', itemid); 

	return prediction;
	exception when others then
		param.debug('exception in get_predictions', '');
		raise;
     END my_get_prediction;
     --
     -- bulkload_fast() does the same as bulkload, but tries to do
     -- it really fast. This only works if there aren't any 
     --
     PROCEDURE bulkload_fast IS
        itemnames m_type;
        itemratings rr_type;
        group_name VARCHAR2(64);
        user_name VARCHAR2(64);
     BEGIN
        -- 
        -- read the entire input table and process every line
        -- separately as described above
        --
        FOR inputrec IN (SELECT groupname, username, itemname, 
                                rating, timestamp 
                         FROM input_ratings) LOOP
           itemnames(1) := inputrec.itemname;
           itemratings(1) := inputrec.rating;
           IF inputrec.groupname IS NULL THEN
              group_name := 'N/A';
           ELSE
              group_name := inputrec.groupname;
           END IF;
           IF inputrec.username IS NULL THEN
              user_name := 'N/A'; 
           ELSE
              user_name := inputrec.username;
           END IF;
	    -- store this rating into the "server"
           store_ratings(1, group_name, user_name,
                         itemnames, itemratings, 
                         inputrec.timestamp);
        END LOOP;
        COMMIT WORK;   
     END bulkload_fast;

     procedure update_corr_stats_user(grp integer, usr integer) is
     begin
        update users u set u.num_nbors = 
           (select count(*) from correlations c
              where u.groupid = c.groupid AND
                     u.userid = c.user1)
           where u.groupid = grp AND
                 u.userid = usr;
     end update_corr_stats_user;

--
-- get_recommendations
--
-- This procedure is used to get the top n recommendations for
-- each user in a test set. No matter how many ratings a user has
-- in the test set, this procedure will only generate n 
-- recommendations for eaceh user.
--
-- The test set is assumed to be loaded into the table accessed 
-- by the 'input_ratings' view.
--
     procedure get_recommendations(n integer) is 
        the_cache_slot integer;
        local_n integer;
     begin
        for user_rec in (select unique groupname, username  
                            from input_ratings)
        loop
           local_n := n;
           param.debug('username is ', user_rec.username);
           cached_top_n(user_rec.groupname, user_rec.username, local_n, 
                        0,0, 0,                   -- Categories not used
                        the_cache_slot);
           insert into dblens_output 
                           (username, itemname, prediction, rating) 
              select t.username, t.itemname, t.prediction, i.rating 
                 from topn_cache t, input i
                 where cache_slot = the_cache_slot
                   and t.username = i.username (+)
                   and t.itemname = i.itemname (+);	
        end loop;
        commit;
     end get_recommendations;
END core;
/
ALTER PACKAGE core COMPILE
/
create or replace procedure exec(command varchar2) is

     cursor_id integer;
     dummy integer;
     error float;
begin
     cursor_id := dbms_sql.open_cursor;
     begin
        dbms_sql.parse(cursor_id, command, DBMS_SQL.V7);
        dummy := dbms_sql.execute(cursor_id);
        exception when others then
	   param.debug('error executing -> ', command);
           dbms_sql.close_cursor(cursor_id);
	   raise;
     end;
        dbms_sql.close_cursor(cursor_id);
end exec;
/

create or replace procedure copy_pred_table(in_tab varchar2, out_tab varchar2) as
begin
   begin
      exec('drop table ' || out_tab);
   exception when others then
	null;
   end;
   exec('create table ' || out_tab || ' (    
          groupname   VARCHAR2(64),
          username    VARCHAR2(64),
          itemname    VARCHAR2(64),
          rating      FLOAT,
          prediction  FLOAT,
          timestamp   DATE)');

   exec('insert into ' || out_tab || 
            '(groupname, username, itemname, rating, prediction, timestamp)'
            || ' select * from ' || in_tab);
end copy_pred_table;

/
