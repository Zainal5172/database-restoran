-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 25, 2024 at 08:53 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `restorant`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `listAllTransaksi` ()   BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM transaksi;
    
    IF total > 0 THEN
        SELECT * FROM transaksi;
    ELSE
        SELECT 'Tidak ada transaksi yang tersedia' AS message;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listTransaksiByPesan` (`pesanID` CHAR(5), `startDate` DATE)   BEGIN
	CASE 
    	WHEN EXISTS (SELECT * FROM transaksi WHERE pesan_id = pesanID AND tgl_pesan >= startDate)THEN 
        SELECT * FROM transaksi WHERE pesan_id = pesanID AND tgl_pesan >= startDate;
	ELSE 
    	SELECT 'Tidak ada transaksi untuk pesanan ini setelah tanggal tersebut' AS message;
    END CASE;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `getTotalTransaksi` () RETURNS DECIMAL(10,2)  BEGIN 
	DECLARE total DECIMAL(10, 2);
    SELECT SUM(total_bayar)INTO total FROM transaksi;
    return total;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getTransaksiByKasir` (`pesanID` CHAR(5), `tgl_pesan` DATE) RETURNS DECIMAL(10,2)  BEGIN DECLARE total DECIMAL(10, 2); SELECT SUM(total_bayar)INTO total FROM transaksi WHERE pesan_id = pesanID AND tgl_pesan >= tgl_pesan; RETURN total; END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `bahan_makanan`
--

CREATE TABLE `bahan_makanan` (
  `bahan_id` char(5) NOT NULL,
  `supplier_id` char(5) DEFAULT NULL,
  `stock` int(3) DEFAULT NULL,
  `nama_bahan` varchar(40) DEFAULT NULL,
  `Tgl_penerimaan` date DEFAULT NULL,
  `No_faktur` int(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bahan_makanan`
--

INSERT INTO `bahan_makanan` (`bahan_id`, `supplier_id`, `stock`, `nama_bahan`, `Tgl_penerimaan`, `No_faktur`) VALUES
('BM001', 'S001', 100, 'Beras', '2024-07-24', 1),
('BM002', 'S002', 200, 'Ayam', '2024-07-24', 2),
('BM003', 'S003', 300, 'Daging', '2024-07-24', 3),
('BM004', 'S004', 500, 'Bahan Dapur', '2024-07-24', 4),
('BM005', 'S005', 500, 'Buah-Buahan', '2024-07-24', 5);

-- --------------------------------------------------------

--
-- Table structure for table `chef`
--

CREATE TABLE `chef` (
  `chef_id` char(5) NOT NULL,
  `nama` varchar(40) DEFAULT NULL,
  `Alamat` varchar(40) DEFAULT NULL,
  `Jenis_kelamin` char(1) DEFAULT NULL,
  `bahan_id` char(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `chef`
--

INSERT INTO `chef` (`chef_id`, `nama`, `Alamat`, `Jenis_kelamin`, `bahan_id`) VALUES
('KO001', 'Ahmad', 'Tanggerang', '1', 'BM001'),
('KO002', 'Ibnu', 'Jakarta', 'L', 'BM002'),
('KO003', 'Vina', 'Jakarta', 'P', 'BM003'),
('KO004', 'Mawaddah', 'Depok', 'P', 'BM004'),
('KO005', 'Aditya', 'Depok', 'L', 'BM005');

-- --------------------------------------------------------

--
-- Stand-in structure for view `horizontal_view`
-- (See below for the actual view)
--
CREATE TABLE `horizontal_view` (
`pesan_id` char(5)
,`tgl_pesan` date
,`total_bayar` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `inside_view`
-- (See below for the actual view)
--
CREATE TABLE `inside_view` (
`pesan_id` char(5)
,`tgl_pesan` date
,`nama_kasir` varchar(50)
,`nama_pelanggan` varchar(50)
,`total_bayar` decimal(10,2)
,`Nama_makanan` varchar(50)
);

-- --------------------------------------------------------

--
-- Table structure for table `kasir`
--

CREATE TABLE `kasir` (
  `kasir_id` char(5) NOT NULL,
  `nama` varchar(50) DEFAULT NULL,
  `alamat` varchar(50) DEFAULT NULL,
  `jenis_kelamin` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kasir`
--

INSERT INTO `kasir` (`kasir_id`, `nama`, `alamat`, `jenis_kelamin`) VALUES
('KS001', 'Zainal', 'Banjarbaru', 'L'),
('KS002', 'Jessica', 'Boyolali', 'P'),
('KS003', 'Fiqih', 'Yogyakarta', 'L'),
('KS004', 'Tunggal', 'Yogyakarta', 'L'),
('KS005', 'Dimas', 'Klaten', 'L');

-- --------------------------------------------------------

--
-- Table structure for table `menu`
--

CREATE TABLE `menu` (
  `menu_id` char(5) NOT NULL,
  `chef_id` char(5) DEFAULT NULL,
  `Nama_makanan` varchar(40) DEFAULT NULL,
  `Harga` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `menu`
--

INSERT INTO `menu` (`menu_id`, `chef_id`, `Nama_makanan`, `Harga`) VALUES
('MK001', 'KO001', 'Nasi Goreng', 25000.00),
('MK002', 'KO002', 'Ayam Geprek', 12000.00),
('MK003', 'KO003', 'Beef Steak', 100000.00),
('MK004', 'KO004', 'Juice Mangga', 14000.00),
('MK005', 'KO005', 'Salad', 10000.00),
('MK006', 'KO001', 'Bakmi', 15000.00),
('MK008', 'KO001', 'Seblak', 20000.00);

--
-- Triggers `menu`
--
DELIMITER $$
CREATE TRIGGER `AfterDeleteMenu` AFTER DELETE ON `menu` FOR EACH ROW BEGIN
    INSERT INTO menulog (Nama_Makanan, activity, OldPrice)
    VALUES (OLD.Nama_makanan, 'AFTER DELETE', OLD.Harga);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `AfterInsertMenu` AFTER INSERT ON `menu` FOR EACH ROW BEGIN
    INSERT INTO MenuLog (Nama_Makanan, activity, NewPrice)
    VALUES (NEW.Nama_makanan, 'AFTER INSERT', NEW.Harga);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `AfterUpdateMenu` AFTER UPDATE ON `menu` FOR EACH ROW BEGIN
    INSERT INTO MenuLog (Nama_Makanan, activity, OldPrice, NewPrice)
    VALUES (OLD.Nama_makanan, 'AFTER UPDATE', OLD.Harga, NEW.Harga);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `BeforeDeleteMenu` BEFORE DELETE ON `menu` FOR EACH ROW BEGIN
    INSERT INTO menulog (Nama_Makanan, activity, OldPrice)
    VALUES (OLD.Nama_makanan, 'BEFORE DELETE', OLD.Harga);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `BeforeInsertMenu` BEFORE INSERT ON `menu` FOR EACH ROW BEGIN
    INSERT INTO menulog (Nama_Makanan, activity, NewPrice)
    VALUES (NEW.Nama_Makanan, 'BEFORE INSERT', NEW.Harga);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `BeforeUpdateMenu` BEFORE UPDATE ON `menu` FOR EACH ROW BEGIN
    INSERT INTO menulog (Nama_Makanan, activity, OldPrice, NewPrice)
    VALUES (OLD.Nama_makanan, 'BEFORE UPDATE', OLD.Harga, NEW.Harga);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `menubaru`
--

CREATE TABLE `menubaru` (
  `menu_id` int(11) NOT NULL,
  `Nama_makanan` varchar(255) NOT NULL,
  `Harga` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `menulog`
--

CREATE TABLE `menulog` (
  `log_id` int(11) NOT NULL,
  `Nama_Makanan` varchar(50) DEFAULT NULL,
  `activity` varchar(50) DEFAULT NULL,
  `OldPrice` int(50) DEFAULT NULL,
  `NewPrice` int(50) DEFAULT NULL,
  `Waktu` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `menulog`
--

INSERT INTO `menulog` (`log_id`, `Nama_Makanan`, `activity`, `OldPrice`, `NewPrice`, `Waktu`) VALUES
(2, 'Nasi Goreng Cumi', 'BEFORE INSERT', NULL, 15000, '2024-07-24 10:34:20'),
(4, 'Seblak', 'BEFORE INSERT', NULL, 20000, '2024-07-24 11:20:41'),
(5, 'Seblak', 'AFTER INSERT', NULL, 20000, '2024-07-24 11:20:41'),
(6, 'Nasi Goreng Cumi', 'BEFORE DELETE', 15000, NULL, '2024-07-24 11:23:58'),
(7, 'Nasi Goreng Cumi', 'AFTER DELETE', 15000, NULL, '2024-07-24 11:23:58');

-- --------------------------------------------------------

--
-- Table structure for table `pelanggan`
--

CREATE TABLE `pelanggan` (
  `pesan_id` char(5) NOT NULL,
  `kasir_id` char(5) DEFAULT NULL,
  `nama_pelanggan` varchar(50) DEFAULT NULL,
  `Tgl_pesan` date DEFAULT NULL,
  `menu_id` char(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pelanggan`
--

INSERT INTO `pelanggan` (`pesan_id`, `kasir_id`, `nama_pelanggan`, `Tgl_pesan`, `menu_id`) VALUES
('', NULL, 'Joni', NULL, NULL),
('PS001', 'KS001', 'Singgel', '2024-07-24', 'MK001'),
('PS002', 'KS002', 'Ahmad', '2024-07-24', 'MK002'),
('PS003', 'KS003', 'Julian', '2024-07-24', 'MK003'),
('PS004', 'KS004', 'Rahman', '2024-07-24', 'MK004'),
('PS005', 'KS005', 'Thoriq', '2024-07-24', 'MK005');

-- --------------------------------------------------------

--
-- Table structure for table `supplier`
--

CREATE TABLE `supplier` (
  `supplier_id` char(5) NOT NULL,
  `nama` varchar(40) DEFAULT NULL,
  `alamat` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `supplier`
--

INSERT INTO `supplier` (`supplier_id`, `nama`, `alamat`) VALUES
('S001', 'PT. Iniko Karya Persada', 'JL. Mutiara Taman Palem Blok. C6 No. 51, Cengkareng'),
('S002', 'PT. Sumber Roso Agromakmur', 'Jl. Bekasi Timur Raya No. 136,RT. 08, RW.09'),
('S003', 'PT. Chason Indonesia Venture', 'Jl. Boulevard Raya Blok QA 3 No, 15'),
('S004', 'PT. Foxa Asa Energy', 'Ruko Permata Regency D/37 Jl. Haji Kelik'),
('S005', 'PT. Foxa Asa Energy', 'Ruko Permata Regency D/37 Jl. Haji Kelik');

-- --------------------------------------------------------

--
-- Table structure for table `transaksi`
--

CREATE TABLE `transaksi` (
  `pesan_id` char(5) DEFAULT NULL,
  `tgl_pesan` date DEFAULT NULL,
  `nama_kasir` varchar(50) DEFAULT NULL,
  `nama_pelanggan` varchar(50) DEFAULT NULL,
  `Nama_makanan` varchar(50) DEFAULT NULL,
  `jml_pesan` int(5) DEFAULT NULL,
  `Harga` decimal(10,2) DEFAULT NULL,
  `total_bayar` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaksi`
--

INSERT INTO `transaksi` (`pesan_id`, `tgl_pesan`, `nama_kasir`, `nama_pelanggan`, `Nama_makanan`, `jml_pesan`, `Harga`, `total_bayar`) VALUES
('PS001', '2024-07-24', 'Zainal', 'Berry', 'Nasi Goreng', 2, 25000.00, 50000.00),
('PS002', '2024-07-24', 'Jessica', 'Thoriq', 'Beef Steak', 1, 100000.00, 100000.00),
('PS003', '2024-07-24', 'Fiqih', 'Rahman', 'Salad', 3, 10000.00, 30000.00),
('PS004', '2024-07-31', 'Tunggal', 'Ahmad', 'Ayam Geprek', 2, 12000.00, 24000.00),
('PS001', '2024-07-24', 'Zainal', 'Berry', 'Juice Mangga', 1, 14000.00, 14000.00);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vertical_view`
-- (See below for the actual view)
--
CREATE TABLE `vertical_view` (
`nama_pelanggan` varchar(50)
);

-- --------------------------------------------------------

--
-- Structure for view `horizontal_view`
--
DROP TABLE IF EXISTS `horizontal_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `horizontal_view`  AS SELECT `transaksi`.`pesan_id` AS `pesan_id`, `transaksi`.`tgl_pesan` AS `tgl_pesan`, `transaksi`.`total_bayar` AS `total_bayar` FROM `transaksi` ;

-- --------------------------------------------------------

--
-- Structure for view `inside_view`
--
DROP TABLE IF EXISTS `inside_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `inside_view`  AS SELECT `hv`.`pesan_id` AS `pesan_id`, `hv`.`tgl_pesan` AS `tgl_pesan`, `t`.`nama_kasir` AS `nama_kasir`, `t`.`nama_pelanggan` AS `nama_pelanggan`, `hv`.`total_bayar` AS `total_bayar`, `t`.`Nama_makanan` AS `Nama_makanan` FROM (`horizontal_view` `hv` join `transaksi` `t` on(`hv`.`pesan_id` = `t`.`pesan_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `vertical_view`
--
DROP TABLE IF EXISTS `vertical_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vertical_view`  AS SELECT `pelanggan`.`nama_pelanggan` AS `nama_pelanggan` FROM `pelanggan` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bahan_makanan`
--
ALTER TABLE `bahan_makanan`
  ADD PRIMARY KEY (`bahan_id`),
  ADD KEY `supplier_id` (`supplier_id`);

--
-- Indexes for table `chef`
--
ALTER TABLE `chef`
  ADD PRIMARY KEY (`chef_id`),
  ADD KEY `bahan_id` (`bahan_id`);

--
-- Indexes for table `kasir`
--
ALTER TABLE `kasir`
  ADD PRIMARY KEY (`kasir_id`);

--
-- Indexes for table `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`menu_id`),
  ADD KEY `chef_id` (`chef_id`),
  ADD KEY `idx_harga_nama` (`Harga`,`Nama_makanan`),
  ADD KEY `idx_menuid_harga` (`menu_id`,`Harga`);

--
-- Indexes for table `menubaru`
--
ALTER TABLE `menubaru`
  ADD PRIMARY KEY (`menu_id`,`Nama_makanan`);

--
-- Indexes for table `menulog`
--
ALTER TABLE `menulog`
  ADD PRIMARY KEY (`log_id`);

--
-- Indexes for table `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD PRIMARY KEY (`pesan_id`),
  ADD KEY `kasir_id` (`kasir_id`),
  ADD KEY `pelanggan_ibfk_2` (`menu_id`);

--
-- Indexes for table `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`supplier_id`);

--
-- Indexes for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD KEY `fk_pesan_id` (`pesan_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `menulog`
--
ALTER TABLE `menulog`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bahan_makanan`
--
ALTER TABLE `bahan_makanan`
  ADD CONSTRAINT `bahan_makanan_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `supplier` (`supplier_id`);

--
-- Constraints for table `chef`
--
ALTER TABLE `chef`
  ADD CONSTRAINT `chef_ibfk_1` FOREIGN KEY (`bahan_id`) REFERENCES `bahan_makanan` (`bahan_id`);

--
-- Constraints for table `menu`
--
ALTER TABLE `menu`
  ADD CONSTRAINT `menu_ibfk_1` FOREIGN KEY (`chef_id`) REFERENCES `chef` (`chef_id`);

--
-- Constraints for table `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD CONSTRAINT `pelanggan_ibfk_1` FOREIGN KEY (`kasir_id`) REFERENCES `kasir` (`kasir_id`),
  ADD CONSTRAINT `pelanggan_ibfk_2` FOREIGN KEY (`menu_id`) REFERENCES `menu` (`menu_id`);

--
-- Constraints for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD CONSTRAINT `fk_pesan_id` FOREIGN KEY (`pesan_id`) REFERENCES `pelanggan` (`pesan_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
