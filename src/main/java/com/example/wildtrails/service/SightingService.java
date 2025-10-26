package com.example.wildtrails.service;

import com.example.wildtrails.module.Sighting;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class SightingService {

    private final JdbcTemplate jdbcTemplate;

    public SightingService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<Sighting> sightingRowMapper = (rs, rowNum) -> {
        Sighting sighting = new Sighting();
        sighting.setId(rs.getLong("id"));
        sighting.setSightId(rs.getString("sight_id"));
        sighting.setGuideId(rs.getString("guide_id"));
        sighting.setAnimalType(rs.getString("animal_type"));
        sighting.setSpecies(rs.getString("species"));
        sighting.setCoordinates(rs.getString("coordinates"));
        sighting.setLocation(rs.getString("location"));
        sighting.setSpecialDetails(rs.getString("special_details"));

        Timestamp sightingDate = rs.getTimestamp("sighting_date");
        if (sightingDate != null) sighting.setSightingDate(sightingDate.toLocalDateTime());

        sighting.setPhotoName(rs.getString("photo_name"));
        sighting.setPhotoData(rs.getBytes("photo_data"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) sighting.setCreatedAt(createdAt.toLocalDateTime());

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) sighting.setUpdatedAt(updatedAt.toLocalDateTime());

        return sighting;
    };

    // NEW: Get all sightings
    public List<Sighting> getAllSightings() {
        String sql = "SELECT * FROM sightings ORDER BY sighting_date DESC";
        return jdbcTemplate.query(sql, sightingRowMapper);
    }

    // NEW: Get all sightings with pagination
    public List<Sighting> getAllSightings(int limit, int offset) {
        String sql = "SELECT * FROM sightings ORDER BY sighting_date DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        return jdbcTemplate.query(sql, sightingRowMapper, offset, limit);
    }

    // NEW: Get total sightings count
    public int getTotalSightingsCount() {
        String sql = "SELECT COUNT(*) FROM sightings";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class);
        return count != null ? count : 0;
    }

    // NEW: Get today's sightings count (all guides)
    public int getTodaySightingsCount() {
        String sql = "SELECT COUNT(*) FROM sightings WHERE CAST(sighting_date AS DATE) = CAST(GETDATE() AS DATE)";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class);
        return count != null ? count : 0;
    }

    // NEW: Get unique animal types count
    public int getAnimalTypesCount() {
        String sql = "SELECT COUNT(DISTINCT animal_type) FROM sightings";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class);
        return count != null ? count : 0;
    }

    // NEW: Get distinct animal types
    public List<String> getDistinctAnimalTypes() {
        String sql = "SELECT DISTINCT animal_type FROM sightings WHERE animal_type IS NOT NULL ORDER BY animal_type";
        return jdbcTemplate.queryForList(sql, String.class);
    }

    public Sighting addSighting(Sighting sighting, MultipartFile photoFile) {
        // Generate sight ID
        if (sighting.getSightId() == null) {
            sighting.setSightId(generateSightId());
        }

        // Set current timestamps if not provided
        if (sighting.getSightingDate() == null) {
            sighting.setSightingDate(LocalDateTime.now());
        }
        if (sighting.getCreatedAt() == null) {
            sighting.setCreatedAt(LocalDateTime.now());
        }
        if (sighting.getUpdatedAt() == null) {
            sighting.setUpdatedAt(LocalDateTime.now());
        }

        String sql = "INSERT INTO sightings (sight_id, guide_id, animal_type, species, coordinates, " +
                "location, special_details, sighting_date, photo_name, photo_data, created_at, updated_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        KeyHolder keyHolder = new GeneratedKeyHolder();

        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, sighting.getSightId());
            ps.setString(2, sighting.getGuideId());
            ps.setString(3, sighting.getAnimalType());
            ps.setString(4, sighting.getSpecies());
            ps.setString(5, sighting.getCoordinates());
            ps.setString(6, sighting.getLocation());
            ps.setString(7, sighting.getSpecialDetails());
            ps.setTimestamp(8, Timestamp.valueOf(sighting.getSightingDate()));

            if (photoFile != null && !photoFile.isEmpty()) {
                ps.setString(9, photoFile.getOriginalFilename());
                try {
                    ps.setBytes(10, photoFile.getBytes());
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
            } else {
                ps.setNull(9, java.sql.Types.VARCHAR);
                ps.setNull(10, java.sql.Types.VARBINARY);
            }

            ps.setTimestamp(11, Timestamp.valueOf(sighting.getCreatedAt()));
            ps.setTimestamp(12, Timestamp.valueOf(sighting.getUpdatedAt()));
            return ps;
        }, keyHolder);

        sighting.setId(keyHolder.getKey().longValue());
        return sighting;
    }

    public List<Sighting> getRecentSightingsByGuide(String guideId, int limit) {
        String sql = "SELECT TOP (?) * FROM sightings WHERE guide_id = ? ORDER BY sighting_date DESC";
        return jdbcTemplate.query(sql, sightingRowMapper, limit, guideId);
    }

    public int getSightingsCountByGuide(String guideId) {
        String sql = "SELECT COUNT(*) FROM sightings WHERE guide_id = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, guideId);
        return count != null ? count : 0;
    }

    public int getTodaySightingsCountByGuide(String guideId) {
        String sql = "SELECT COUNT(*) FROM sightings WHERE guide_id = ? AND CAST(sighting_date AS DATE) = CAST(GETDATE() AS DATE)";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, guideId);
        return count != null ? count : 0;
    }

    public byte[] getSightingPhoto(String sightId) {
        String sql = "SELECT photo_data FROM sightings WHERE sight_id = ?";
        try {
            return jdbcTemplate.queryForObject(sql, byte[].class, sightId);
        } catch (Exception e) {
            return null;
        }
    }

    // NEW: Get sighting by ID
    public Optional<Sighting> getSightingById(Long sightId) {
        String sql = "SELECT * FROM sightings WHERE id = ?";
        try {
            Sighting sighting = jdbcTemplate.queryForObject(sql, sightingRowMapper, sightId);
            return Optional.ofNullable(sighting);
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    // NEW: Get sighting by sightId (String)
    public Optional<Sighting> getSightingBySightId(String sightId) {
        String sql = "SELECT * FROM sightings WHERE sight_id = ?";
        try {
            Sighting sighting = jdbcTemplate.queryForObject(sql, sightingRowMapper, sightId);
            return Optional.ofNullable(sighting);
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    // NEW: Update sighting
    public Sighting updateSighting(Sighting sighting, MultipartFile photoFile) throws IOException {
        String sql = "UPDATE sightings SET animal_type = ?, species = ?, coordinates = ?, " +
                "location = ?, special_details = ?, sighting_date = ?, photo_name = ?, photo_data = ?, " +
                "updated_at = ? WHERE id = ?";

        // Set update timestamp
        sighting.setUpdatedAt(LocalDateTime.now());

        jdbcTemplate.update(sql,
                sighting.getAnimalType(),
                sighting.getSpecies(),
                sighting.getCoordinates(),
                sighting.getLocation(),
                sighting.getSpecialDetails(),
                Timestamp.valueOf(sighting.getSightingDate()),
                photoFile != null && !photoFile.isEmpty() ? photoFile.getOriginalFilename() : sighting.getPhotoName(),
                photoFile != null && !photoFile.isEmpty() ? photoFile.getBytes() : sighting.getPhotoData(),
                Timestamp.valueOf(sighting.getUpdatedAt()),
                sighting.getId());

        return sighting;
    }

    // NEW: Delete sighting
    public void deleteSighting(Long sightId) {
        String sql = "DELETE FROM sightings WHERE id = ?";
        jdbcTemplate.update(sql, sightId);
    }

    private String generateSightId() {
        String sql = "SELECT MAX(sight_id) FROM sightings WHERE sight_id LIKE 'sight-%'";
        try {
            String maxSightId = jdbcTemplate.queryForObject(sql, String.class);
            if (maxSightId == null) {
                return "sight-001";
            }
            int number = Integer.parseInt(maxSightId.substring(6)) + 1;
            return String.format("sight-%03d", number);
        } catch (Exception e) {
            return "sight-001";
        }
    }
    // Add this method to SightingService class
    public List<Sighting> getSightingsByGuideId(String guideId) {
        String sql = "SELECT * FROM sightings WHERE guide_id = ? ORDER BY sighting_date DESC";
        return jdbcTemplate.query(sql, sightingRowMapper, guideId);
    }
}