
### 201115 part4_일별인덱스생성_감성_갯수 - 050 정리해서 6개 종목다 별도 테이블로 만들기 
# 일별 글 건수 인덱스 만들기 - DB작업 : CNT
# 일별 감정 지수 인덱스 만들기 : EMO_I
# 일별 글 건수 인덱스 만들기 - DB작업   R_CNT  
# 일별 감정 지수 인덱스 만들기 - DB작업 R_EMO_I

# 일별 글 건수 인덱스  : CNT 
# 일별 감정 지수 인덱스  : EMO_I
# EMO_RT : 감정지수 비율 인덱스

# 일별 글 건수 인덱스   R_CNT  (추천 수 1 이상이고 추천이 더 많은 것 중)
# 일별 감정 지수 인덱스 R_EMO_I (추천 수 1 이상이고 추천이 더 많은 것 중)
# R_EMO_RT : 감정지수 비율 인덱스  (추천 수 1 이상이고 추천이 더 많은 것 중)


CREATE TABLE T006280_index AS 
WITH V1 AS 
( SELECT 
SUBSTR(DATE,1,10) AS BAS_DT
, DATE_FORMAT(DATE_FORMAT(DATE,'%Y.%m.%d %H:%i')- INTERVAL 30 MINUTE - INTERVAL 8 HOUR,'%Y%m%d') AS NEW_BAS_DT
, CASE WHEN A.`LIKE` >= 1 AND `LIKE` > `DISLIKE` THEN 1 ELSE 0 END AS LIKE_I
, A.* 
FROM T006280_label A
) 
SELECT NEW_BAS_DT
, COUNT(*) AS CNT
, SUM(label) AS  EMO_I
, CASE WHEN COUNT(*) = 0 THEN 0 ELSE NVL(SUM(label) / COUNT(*),0) END AS EMO_RT
, SUM(LIKE_I) AS  R_CNT
, SUM(LIKE_I*label) AS  R_EMO_I
, CASE WHEN SUM(LIKE_I) = 0 THEN 0 ELSE NVL(SUM(LIKE_I*label) / SUM(LIKE_I) ,0) END AS R_EMO_RT
FROM V1
GROUP BY NEW_BAS_DT
HAVING NEW_BAS_DT BETWEEN '20200101' AND '20201009'
ORDER BY NEW_BAS_DT 