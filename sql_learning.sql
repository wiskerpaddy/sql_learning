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

--6
-- 日次のアクセス数を求める
SELECT DATE(startTime), COUNT(logID)
FROM eventlog
GROUP BY DATE(startTime);

-- 日次のアクセス数を求める
SELECT DATE(startTime), COUNT(logID)
FROM eventlog
WHERE DATE(startTime) BETWEEN "2015-04-01" AND "2015-04-30"
GROUP BY DATE(startTime);

-- 月次のアクセス数を求める
SELECT DATE_FORMAT(startTime, '%Y-%m'), COUNT(logID)
FROM eventlog
GROUP BY DATE_FORMAT(startTime, '%Y-%m');

--7
SELECT userID AS "アクティブユーザー"
FROM users;

SELECT DISTINCT userID AS "アクティブユーザー"
FROM users;

SELECT userID AS "アクティブユーザー"
FROM users
WHERE deleted_at IS NULL;

--8
-- アクティブユーザーを求める
SELECT
    DATE(eventlog.startTime) AS 日付,
    COUNT(DISTINCT eventlog.userID) AS "アクティブユーザー"
FROM eventlog
    INNER JOIN users ON users.userID = eventlog.userID
WHERE deleted_at IS NULL
GROUP BY DATE(eventlog.startTime);

--9
-- いろいろな集計
SELECT
	eventlog.userID AS ユーザーID,
	SUM(events.increase_exp) AS 合計,
	AVG(events.increase_exp) AS 平均
FROM
	eventlog
	INNER JOIN events ON events.eventID = eventlog.eventID
GROUP BY eventlog.userID
HAVING SUM(events.increase_exp) >= 3000;
-- 1. FROM 対象テーブルからデータを取り出す
-- 2. WHERE 条件に一致するレコードを絞り込み
-- 3. GROUP BY グループ化
-- 4. HAVING 集計結果から絞り込み
-- 5. SELECT 指定したカラムだけを表示

SELECT
	eventlog.userID AS ユーザーID,
	MIN(startTime) AS 開始日,
	MAX(endTime) AS 終了日
FROM
	eventlog
GROUP BY eventlog.userID;

-- ユーザーごとの合計獲得金額と平均獲得金額
SELECT
	eventlog.userID AS "ユーザーID",
	SUM(events.increase_gold) AS "合計",
	AVG(events.increase_gold) AS "平均"
FROM
	eventlog
	INNER JOIN events ON events.eventID = eventlog.eventID
GROUP BY eventlog.userID
HAVING SUM(events.increase_gold) >= 50
ORDER BY eventlog.userID;

--10
-- 日付に関する計算
SELECT
	userID AS ユーザーID,
	MIN(startTime) AS 開始日,
	MAX(endTime) AS 終了日,
	DATE(MAX(endTime))-DATE(MIN(startTime)) + 1 AS プレイ期間
FROM
	eventlog
GROUP BY userID;

--11
-- 日付に関する計算
SELECT
	userID AS ユーザーID,
	YEAR(CURRENT_DATE()) AS 現在年,
	birth AS 生年月日,
    YEAR(CURRENT_DATE()) - YEAR(birth) AS 数え年,
    TIMESTAMPDIFF(YEAR,birth,CURRENT_DATE()) AS 満年齢
FROM
	users;

--11
-- テキスト検索
SELECT
	events.event_summary
FROM
	eventlog
	INNER JOIN events ON events.eventID = eventlog.eventID
WHERE  events.event_summary LIKE '%との闘い'

-- テキスト検索
SELECT
	userID,
	startTime,
	events.event_summary
FROM
	eventlog
	INNER JOIN events ON events.eventID = eventlog.eventID
WHERE events.event_stage <> 0
ORDER BY
    userID,startTime;

-- テキスト検索
SELECT
	events.event_summary
FROM
	eventlog
	INNER JOIN events ON events.eventID = eventlog.eventID
WHERE  events.event_summary LIKE '%との闘い'

--12
-- FROM句に書く場合
SELECT *
FROM (サブクエリ) AS (サブクエリ名);

-- サブクエリで、アクティブユーザー数を求める
SELECT DISTINCT
	DATE(startTime) AS day,
	eventlog.userID AS user
FROM eventlog
	INNER JOIN users ON users.userID = eventlog.userID
WHERE deleted_at IS NULL;

-- サブクエリで、アクティブユーザー数を求める
SELECT *
FROM (SELECT DISTINCT
	DATE(startTime) AS day,
	eventlog.userID AS user
FROM eventlog
	INNER JOIN users ON users.userID = eventlog.userID
WHERE deleted_at IS NULL) AS ActiveUsers;

SELECT day , COUNT(user)
FROM (SELECT DISTINCT
	DATE(startTime) AS day,
	eventlog.userID AS user
FROM eventlog
	INNER JOIN users ON users.userID = eventlog.userID
WHERE deleted_at IS NULL) AS ActiveUsers
GROUP BY day;

--13
-- 所持金で、お金持ちか分類する
SELECT userID, gold,
    CASE
        WHEN gold >= 3000 THEN '大金持ち'
        WHEN gold >= 1000 THEN '小金持ち'
        ELSE '発展途上'
        END AS finance
FROM users;

--14
--1. クロス集計の元になるデータを用意する
--2. サブクエリとして読み込む
--3. CASEで、特定の値だったら1にする。このとき別名を、特定の値と同じにする


CASE WHEN クラス = "初級" THEN 1 ELSE NULL END AS "初級",
CASE WHEN クラス = "中級" THEN 1 ELSE NULL END AS "中級",
CASE WHEN クラス = "上級" THEN 1 ELSE NULL END AS "上級"


--4. SUM関数とGROUP BYで集計する

-- クロス集計
SELECT
    日付,
    ユーザー,
    クラス,
    CASE WHEN クラス = '初級' THEN 1 ELSE 0 END AS 初級
FROM (SELECT DISTINCT
    DATE_FORMAT(startTime, '%Y-%m') AS 日付,
    eventlog.userID AS ユーザー,
    CASE
        WHEN users.level >= 4 THEN '上級'
        WHEN users.level >= 2 THEN '中級'
        ELSE '初級'
    END AS クラス
FROM eventlog
	INNER JOIN users ON users.userID = eventlog.userID
) AS クラス分け;

-- クロス集計
SELECT
    日付,
    SUM(CASE WHEN クラス = '初級' THEN 1 ELSE 0 END) AS 初級,
    SUM(CASE WHEN クラス = '中級' THEN 1 ELSE 0 END) AS 中級,
    SUM(CASE WHEN クラス = '上級' THEN 1 ELSE 0 END) AS 上級
FROM (SELECT DISTINCT
    DATE_FORMAT(startTime, '%Y-%m') AS 日付,
    eventlog.userID AS ユーザー,
    CASE
        WHEN users.level >= 4 THEN '上級'
        WHEN users.level >= 2 THEN '中級'
        ELSE '初級'
    END AS クラス
FROM eventlog
	INNER JOIN users ON users.userID = eventlog.userID
) AS クラス分け
GROUP BY 日付;

--15
-- サブクエリで、平均レベル以上の割合を求める
SELECT AVG(level) AS 平均レベル FROM users;

SELECT
    COUNT(userID) AS 平均以上のユーザー数,
    (SELECT COUNT(*) FROM users) AS 全体のユーザー数,
    COUNT(userID) /(SELECT COUNT(*) FROM users) * 100 AS 割合
FROM users
WHERE level >= (SELECT AVG(level) FROM users);

-- ユーザーの平均年齢を求める
SELECT
	SUM(TIMESTAMPDIFF(YEAR, birth, '2017-01-01')) AS '年齢の合計',
	COUNT(*) AS 'ユーザー数',
	SUM(TIMESTAMPDIFF(YEAR, birth, '2017-01-01')) / COUNT(*) AS '平均年齢'
FROM
	users;