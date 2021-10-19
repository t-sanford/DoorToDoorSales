--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- Data for Name: app_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO app_user (user_id, email, last_name, first_name, user_name, password, role, salt) VALUES (1, 'nathan.bardwell96@gmail.com', 'Bardwell', 'Nathan', 'Nbardwell1234', 'xLWkvd8t+b3eXrarrs0kJA==', 'Admin', 'iTzkiv82zfmmtAAwzlc+kInGDktvhlzoqxPpAWwcm0L7fcwdvbqzqnUIKw6+TKOVowkQGGRfR+jCueGrwhm5DPz1QD0lG8Wp+x0yY7AAVZC2MWgfzyjydXqMXSJIR8lOdNeP7jYoUM2ylK6c1pohqpN/uR1nJQdJiNjtz62lOfA=');
INSERT INTO app_user (user_id, email, last_name, first_name, user_name, password, role, salt) VALUES (2, 'jason@clark.com', 'Clark', 'Jason', 'Jclark1234', 'sTr86YckUuvFzzNILQNmJQ==', 'Salesman', '8sL/DeEq7XRyv+uJ1lPXsUA57z9/L8R2NTklfLUdAX+4FWPhkLGJ7B7ck6RK1doKTg6CTVH+EP4pGsfKGTuceRhZprAG7I7UIKObxHC8+466g/HRJ2EuRYXXPauw5pbKipai3/sYxWZFM7sRYnhE+lNlQGc3aa21knmk/5W4tkA=');
INSERT INTO app_user (user_id, email, last_name, first_name, user_name, password, role, salt) VALUES (3, 'brian@siebert.com', 'Siebert', 'Brian', 'Bsiebert1234', 'PNSXdE0hSyvnx29kiZRKug==', 'Salesman', 'sxTXJ/U/f6KAD+B17xLnn5CL0ECYTJAbJQnvyirMLXQaXQOfIpdKMD6ZYXltk6GiRc+8rN4Cg45DPHGFbMXQAPEitTDfVdo9baez68AfZgHbIqCQViMaCv623CF0LQpmN80fxtT3nNONbyHSiYGI8yXgWOw98xi36yuQb8dZQok=');
INSERT INTO app_user (user_id, email, last_name, first_name, user_name, password, role, salt) VALUES (4, 'tyler@sanford.com', 'Sanford', 'Tyler', 'Tsanford1234', 'v48/5Nnmr7lUSEI3ogUKGA==', 'Salesman', 'IfEWgS2GMo1sN7GgtwLn+LHBrKoH1Q9xf2AqrSykC0jngRqia7iItEObcP/tk6gtGIE3kNgtZB0v9fhs3kGXpd2OHPVlfalBGZEvQHoUk/tEAg2VoHbRCq4e3YH9ITaUDZUEBfdtCJy5V8aJcEgXa2pYD+bWvV+efKm+0OHFbv8=');
INSERT INTO app_user (user_id, email, last_name, first_name, user_name, password, role, salt) VALUES (5, 'steven@beard.com', 'Beard', 'Steve', 'Sbeard1234', '058xcj9dHro48zcwsH2epA==', 'Salesman', 'K7Dcy9fHlKPKCTINfkIgHvEEkihVoLR1q76p7PHXCWmS/SRmMIaOm/isvTEpOXWPJ/Ns8JqJq3WqOx63g8k9YhWScBuF/MrijhusQygSsugjRmcMeXD9Ec6ILtFbU68Qe2X0kOcF6G87I3BOySNkJYf85Z4gqh+DpVa5uF7+W6Q=');
INSERT INTO app_user (user_id, email, last_name, first_name, user_name, password, role, salt) VALUES (6, 'frank@fella.com', 'Fella', 'Frank', 'Ffella1234', 'Ao7DGu7kaNufCYvimZt0TQ==', 'Salesman', 'Q+HUNYtAKV/0dwPp0l8E5JlDVOcYssVlCyXtydP37xlPhZ0eMMvA5UCa3TbOTbsyBxrjO7f5jLkKQpI7IrqGBDwTsBZBY/9ZCtV8q/ytCsd1PKO67grCb2YsWzyNZjKw44VkP2+iA++gQ+kh65wQaNCZOocISBzapuBVJ/ZZkm8=');


--
-- Name: app_user_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_user_user_id_seq', 6, true);


--
-- PostgreSQL database dump complete
--

