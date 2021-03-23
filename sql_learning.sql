-- 1回
-- 全てのデータを取り出す
SELECT * FROM `players` WHERE 1

-- 一部のカラムだけ取得する
SELECT name, level FROM players;

-- 一部の行だけ取得する
SELECT * FROM players WHERE level >= 7;

-- 複数の条件を組み合わせる
SELECT * FROM players WHERE level >= 7 AND job_id <> 6;


-- 2回
-- データ件数を表示する
SELECT COUNT(*) FROM players;


--条件に合ったデータの件数を表示する
SELECT COUNT(*) FROM players WHERE job_id = 6;


-- データを並び替えて取得する
SELECT * FROM players ORDER BY level;


-- データを並び替えて取得する 降順(DESC) 昇順(ASC)
SELECT * FROM players ORDER BY level DESC;


--上位3件だけ表示す
SELECT * FROM players ORDER BY level DESC LIMIT 3;


-- 職業ごとに人数を集計する。 SELECTの後ろにjob_idなしだとカウントだけ表示される。
SELECT job_id, COUNT(*) FROM players GROUP BY job_id;


-- 3回
-- データ(行)を追加する
INSERT INTO players(id,name,level,job_id) VALUES(11, "霧島1号", 1, 1);


-- データを追加して表示する
INSERT INTO players(id,name,level,job_id) VALUES(12, "霧島2号", 1, 1);
SELECT * FROM players;


-- 一度に複数のデータを追加する
INSERT INTO players(id,name,level,job_id)
VALUES
(13, "霧島3号", 1, 1),
(14, "霧島4号", 1, 1)
;
SELECT * FROM players;


-- データを更新する
UPDATE players SET level = 10 WHERE id = 11;
SELECT * FROM players;


-- データを更新する。1増加
UPDATE players SET level = level + 1 WHERE id = 12;
SELECT * FROM players;


-- データを削除する
DELETE FROM players WHERE id = 13;
SELECT * FROM players;


-- データを削除する
DELETE FROM players WHERE id >= 11;
SELECT * FROM players;

-- 4
-- テーブルを結合して表示する（内部結合）
SELECT * FROM players INNER JOIN jobs ON jobs.id = players.job_id;


-- テーブルを結合して表示する(左結合)
SELECT * FROM players LEFT JOIN jobs ON jobs.id = players.job_id;


-- テーブルを結合して表示する(右結合)NULLは順に並べられないので、NULLじゃない方のテーブルで昇・降順にする。
SELECT * FROM players RIGHT JOIN jobs ON jobs.id = players.job_id ORDER BY players.id ASC;

-- 5
-- 結合したテーブルを操作する
SELECT * FROM players INNER JOIN jobs ON jobs.id = players.job_id;


-- 結合したテーブルで、指定カラムだけ表示
SELECT name, level, vitality FROM players INNER JOIN jobs ON jobs.id = players.job_id;


-- 結合したテーブルで、条件に合った行だけ表示
SELECT name, level, strength FROM players INNER JOIN jobs ON jobs.id = players.job_id WHERE strength >= 5;


-- 職業ごとに人数を集計する
SELECT job_id, job_name, COUNT(*) FROM players INNER JOIN jobs ON jobs.id = players.job_id GROUP BY job_id;