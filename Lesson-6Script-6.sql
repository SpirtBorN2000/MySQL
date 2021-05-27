USE VK;
-- 1.Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
-- Ищем друзей
SELECT * FROM friend_requests 
WHERE (initiator_user_id = 1 or target_user_id = 1)
	and status = 'approved';

-- Ищем сообщение от наших друзей
SELECT * FROM messages 
WHERE from_user_id IN (3,4,10) AND to_user_id =1;

-- итоговый
SELECT from_user_id ,COUNT(from_user_id) AS messagecount FROM messages 
WHERE from_user_id IN (
SELECT initiator_user_id FROM friend_requests WHERE (target_user_id = 1) and status = 'approved'
UNION
SELECT target_user_id FROM friend_requests WHERE (initiator_user_id = 1) and status = 'approved') 
AND to_user_id=1
GROUP BY from_user_id 
ORDER BY from_user_id DESC ;


-- 2. Подсчитать общее количество лайков, которые получили пользователи младше 10 лет.
-- Ищем айдишники людей возрастом меньше 10
SELECT user_id FROM profiles WHERE(YEAR(NOW())-YEAR(birthday))<10;

-- Ищем айдишники медии людей возрастом меньше 10 лет
SELECT id FROM media WHERE user_id IN (SELECT user_id FROM profiles WHERE(YEAR(NOW())-YEAR(birthday))<10);

-- Ищем кол-во записей лайков на медиа людей возрастом меньше 10 лет
SELECT COUNT(*) FROM likes WHERE media_id IN(SELECT id FROM media WHERE user_id IN (SELECT user_id FROM profiles WHERE(YEAR(NOW())-YEAR(birthday))<10));

-- Насколько я понял, т.к. у нашей выборки <10 лет в лайках нету нужных нам медиа id значит никто их медиа не лайкал
-- Ниже привел селект для тех самых медиа айдишников
SELECT * FROM likes WHERE media_id IN(7,37,45,57,63,78,84,93,94);

-- 3.Определить кто больше поставил лайков (всего): мужчины или женщины.

SELECT gender,COUNT(*) FROM profiles GROUP BY gender;
SELECT * FROM profiles;
SELECT user_id as gf_id FROM profiles WHERE gender='f';
SELECT user_id as m_id FROM profiles WHERE gender='m';
-- 16 на 4 но непонятно как разделить на 2 столбца!!!
SELECT COUNT(*) AS GF FROM LIKES WHERE user_id IN (SELECT user_id as gf_id FROM profiles WHERE gender='f')
UNION
SELECT COUNT(*) AS MAN FROM LIKES WHERE user_id IN (SELECT user_id as m_id FROM profiles WHERE gender='m');

SELECT COUNT(*) FROM LIKES WHERE user_id IN (SELECT user_id FROM profiles );


