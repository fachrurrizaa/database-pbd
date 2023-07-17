-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 15, 2023 at 03:53 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `final_project`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_success_status` (OUT `out_count` INT)   BEGIN
    DECLARE finished INT DEFAULT FALSE;
    DECLARE count_success INT DEFAULT 0;
    DECLARE cur CURSOR FOR SELECT COUNT(*) FROM
    transactions WHERE transaction_status = 'success';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = TRUE;
    OPEN cur;
    read_loop: LOOP
    FETCH cur INTO count_success;
    IF finished THEN
    LEAVE read_loop;
    END IF;
    END LOOP;
    CLOSE cur;
    SET out_count = count_success;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `f_total_payment` (`u_id` VARCHAR(15), `t_status` VARCHAR(15)) RETURNS INT(15)  BEGIN
	DECLARE total INT(15);
    SET total = (SELECT SUM(price) FROM transaction_details AS TD
	INNER JOIN transactions AS T ON TD.transaction_id = T.transaction_id
	WHERE user_id = u_id && transaction_status = t_status);
    RETURN total;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `category_id` varchar(10) NOT NULL,
  `category_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_id`, `category_name`) VALUES
('CAT001', 'Front End Developer'),
('CAT002', 'Back End Developer'),
('CAT003', 'Full Stack Developer'),
('CAT004', 'Flutter Developer'),
('CAT005', 'Data Analyst');

-- --------------------------------------------------------

--
-- Table structure for table `course`
--

CREATE TABLE `course` (
  `course_id` int(10) NOT NULL,
  `category_id` varchar(10) NOT NULL,
  `mentor_id` varchar(10) NOT NULL,
  `publish_date` datetime NOT NULL,
  `description` text NOT NULL,
  `title_course` varchar(50) NOT NULL,
  `price` decimal(12,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `course`
--

INSERT INTO `course` (`course_id`, `category_id`, `mentor_id`, `publish_date`, `description`, `title_course`, `price`) VALUES
(1, 'CAT003', 'M001', '2023-07-13 00:00:00', 'This is Description', 'Membuat Company Profile Menggunakan MERN Stack', '150000'),
(2, 'CAT001', 'M001', '2023-07-13 00:00:00', 'This is Description', 'Fundamental React JS', '50000'),
(3, 'CAT004', 'M002', '2023-07-13 00:00:00', 'This is Description', 'Flutter & Dart Crash Course: Modern UI Design', '150000'),
(4, 'CAT004', 'M002', '2023-07-13 00:00:00', 'This is Description', 'Complete Flutter, PHP, MySQL: Build Money Record A', '55000'),
(5, 'CAT004', 'M002', '2023-07-13 00:00:00', 'This is Description', 'Flutter App Developer: Bikin Aplikasi Tinder Cari ', '200000'),
(6, 'CAT002', 'M003', '2023-07-13 00:00:00', 'This is Description', 'Fundamental NodeJs', '100000'),
(7, 'CAT005', 'M004', '2023-07-13 11:34:26', 'This is Description', 'Fundamental Matplotlib untuk Data Analyst', '150000'),
(8, 'CAT001', 'M005', '2023-07-13 00:00:00', 'This is Description', 'Master Class: React JS dan Tailwind CSS Website De', '300000'),
(9, 'CAT002', 'M005', '2023-07-13 00:00:00', 'This is Description', 'Build API with GraphQL', '50000'),
(10, 'CAT003', 'M005', '2023-07-13 00:00:00', 'This is Description', 'Full-Stack Golang Vue NuxtJS: Website Crowdfunding', '400000');

-- --------------------------------------------------------

--
-- Table structure for table `log_transaction_status`
--

CREATE TABLE `log_transaction_status` (
  `log_id` int(11) NOT NULL,
  `transaction_id` varchar(25) DEFAULT NULL,
  `user_id` varchar(25) DEFAULT NULL,
  `payment_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `log_transaction_status`
--

INSERT INTO `log_transaction_status` (`log_id`, `transaction_id`, `user_id`, `payment_date`) VALUES
(1, 'T002', 'U001', '2023-07-15 20:42:04'),
(2, 'T008', 'U004', '2023-07-15 20:42:04'),
(3, 'T009', 'U005', '2023-07-15 20:42:04');

-- --------------------------------------------------------

--
-- Table structure for table `mentor`
--

CREATE TABLE `mentor` (
  `mentor_id` varchar(10) NOT NULL,
  `mentor_email` varchar(25) NOT NULL,
  `mentor_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mentor`
--

INSERT INTO `mentor` (`mentor_id`, `mentor_email`, `mentor_name`) VALUES
('M001', 'mentor01@gmail.com', 'mentor_01'),
('M002', 'mentor02@gmail.com', 'mentor_02'),
('M003', 'mentor03@gmail.com', 'mentor_03'),
('M004', 'mentor04@gmail.com', 'mentor_04'),
('M005', 'mentor05@gmail.com', 'mentor_05');

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `transaction_id` varchar(25) NOT NULL,
  `user_id` varchar(6) DEFAULT NULL,
  `date_checkout` datetime NOT NULL,
  `payment_method` varchar(10) NOT NULL,
  `transaction_status` varchar(10) DEFAULT NULL CHECK (`transaction_status` in ('pending','success','cancel'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`transaction_id`, `user_id`, `date_checkout`, `payment_method`, `transaction_status`) VALUES
('T001', 'U001', '2023-07-13 00:00:00', 'm-banking', 'success'),
('T002', 'U001', '2023-07-13 00:00:00', 'm-banking', 'success'),
('T003', 'U002', '2023-07-13 00:00:00', 'm-banking', 'success'),
('T004', 'U002', '2023-07-13 00:00:00', 'm-banking', 'cancel'),
('T005', 'U001', '2023-07-13 00:00:00', 'Gopay', 'success'),
('T006', 'U003', '2023-07-13 00:00:00', 'OVO', 'success'),
('T007', 'U003', '2023-07-13 00:00:00', 'm-banking', 'cancel'),
('T008', 'U004', '2023-07-13 00:00:00', 'Gopay', 'success'),
('T009', 'U005', '2023-07-13 00:00:00', 'Gopay', 'success'),
('T010', 'U005', '2023-07-13 00:00:00', 'Gopay', 'success'),
('T011', 'U005', '2023-07-13 00:00:00', 'OVO', 'success'),
('T012', 'U003', '2023-07-13 00:00:00', 'm-banking', 'success'),
('T013', 'U002', '2023-07-13 00:00:00', 'Gopay', 'success'),
('T014', 'U004', '2023-07-13 00:00:00', 'OVO', 'success'),
('T015', 'U001', '2023-07-13 00:00:00', 'm-banking', 'success');

--
-- Triggers `transactions`
--
DELIMITER $$
CREATE TRIGGER `after_update_transaction` AFTER UPDATE ON `transactions` FOR EACH ROW BEGIN
    INSERT INTO log_transaction_status (transaction_id, user_id, payment_date)
    VALUES(OLD.transaction_id, OLD.user_id, NOW());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `transaction_details`
--

CREATE TABLE `transaction_details` (
  `detail_id` varchar(15) NOT NULL,
  `transaction_id` varchar(15) DEFAULT NULL,
  `course_id` int(15) DEFAULT NULL,
  `price` decimal(12,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaction_details`
--

INSERT INTO `transaction_details` (`detail_id`, `transaction_id`, `course_id`, `price`) VALUES
('DT001', 'T001', 1, '150000'),
('DT002', 'T002', 10, '400000'),
('DT003', 'T003', 8, '300000'),
('DT004', 'T004', 9, '50000'),
('DT005', 'T005', 5, '200000'),
('DT006', 'T006', 6, '100000'),
('DT007', 'T007', 4, '55000'),
('DT008', 'T008', 9, '50000'),
('DT009', 'T009', 2, '50000'),
('DT010', 'T010', 8, '300000'),
('DT011', 'T011', 10, '400000'),
('DT012', 'T012', 6, '100000'),
('DT013', 'T013', 10, '400000'),
('DT014', 'T014', 8, '300000'),
('DT015', 'T015', 7, '150000');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_id` varchar(10) NOT NULL,
  `user_email` varchar(20) NOT NULL,
  `user_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `user_email`, `user_name`) VALUES
('U001', 'user01@gmail.com', 'Muhammad Fachrur Riza'),
('U002', 'user02@gmail.com', 'Muhammad Taqiyuddin'),
('U003', 'user03@gmail.com', 'Fauzan Lutfi Muzaki'),
('U004', 'user04@gmail.com', 'Gusti Ayu Putu Febriyanti'),
('U005', 'user05@gmail.com', 'Laili Aulia Fitri');

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_user`
-- (See below for the actual view)
--
CREATE TABLE `v_user` (
`user_name` varchar(50)
,`title_course` varchar(50)
,`date_checkout` datetime
,`payment_method` varchar(10)
,`price` decimal(12,0)
,`transaction_status` varchar(10)
);

-- --------------------------------------------------------

--
-- Structure for view `v_user`
--
DROP TABLE IF EXISTS `v_user`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_user`  AS SELECT `u`.`user_name` AS `user_name`, `c`.`title_course` AS `title_course`, `t`.`date_checkout` AS `date_checkout`, `t`.`payment_method` AS `payment_method`, `td`.`price` AS `price`, `t`.`transaction_status` AS `transaction_status` FROM (((`user` `u` join `transactions` `t` on(`u`.`user_id` = `t`.`user_id`)) join `transaction_details` `td` on(`t`.`transaction_id` = `td`.`transaction_id`)) join `course` `c` on(`td`.`course_id` = `c`.`course_id`)) WHERE exists(select `t`.`transaction_status` from `transaction_details` where `t`.`transaction_status` = 'success' limit 1)  ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `course`
--
ALTER TABLE `course`
  ADD PRIMARY KEY (`course_id`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `mentor_id` (`mentor_id`);

--
-- Indexes for table `log_transaction_status`
--
ALTER TABLE `log_transaction_status`
  ADD PRIMARY KEY (`log_id`);

--
-- Indexes for table `mentor`
--
ALTER TABLE `mentor`
  ADD PRIMARY KEY (`mentor_id`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`transaction_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `transaction_details`
--
ALTER TABLE `transaction_details`
  ADD PRIMARY KEY (`detail_id`),
  ADD KEY `transaction_id` (`transaction_id`),
  ADD KEY `course_id` (`course_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`),
  ADD KEY `idx_user_id` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `course`
--
ALTER TABLE `course`
  MODIFY `course_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `log_transaction_status`
--
ALTER TABLE `log_transaction_status`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `course`
--
ALTER TABLE `course`
  ADD CONSTRAINT `course_ibfk_1` FOREIGN KEY (`mentor_id`) REFERENCES `mentor` (`mentor_id`);

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

--
-- Constraints for table `transaction_details`
--
ALTER TABLE `transaction_details`
  ADD CONSTRAINT `transaction_details_ibfk_1` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`transaction_id`),
  ADD CONSTRAINT `transaction_details_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
