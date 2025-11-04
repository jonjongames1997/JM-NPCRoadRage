CREATE TABLE IF NOT EXISTS `npc_road_rage_incidents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `coords` longtext DEFAULT NULL,
  `weapon_used` varchar(50) DEFAULT 'none',
  `police_notified` tinyint(1) DEFAULT 0,
  `timestamp` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_road_rage_citizen_time ON npc_road_rage_incidents (citizenid, timestamp);
CREATE INDEX idx_road_rage_coords ON npc_road_rage_incidents (coords(100));