package com.techelevator.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;

@Component
public class JDBCNoteDAO implements NoteDAO{

	private JdbcTemplate jdbcTemplate;
	

	@Autowired
	 public JDBCNoteDAO(DataSource dataSource){
	 this.jdbcTemplate = new JdbcTemplate(dataSource);

	}
	
	@Override
	public List<Note> getNotesByHouseId(Long houseId) {
		List<Note> notes = new ArrayList<>();
		String getNotesSql = "SELECT * "
								+ "FROM note n "
								+ "JOIN house_notes hn "
								+ "ON n.note_id = hn.note_id "
								+ "WHERE hn.house_id = ? "
								+ "ORDER BY time DESC;";
		SqlRowSet results = jdbcTemplate.queryForRowSet(getNotesSql, houseId);
		while(results.next()) {
			Note thisNote = new Note();
			thisNote.setId(results.getLong("note_id"));
			thisNote.setText(results.getString("text"));
			thisNote.setTimestamp(results.getTimestamp("time").toLocalDateTime());
			
			notes.add(thisNote);
		}
		return notes;
	}

	@Override
	public void saveNewNote(Long houseId, String username, String text, LocalDateTime timestamp) {
		String finalNote = text + "   | Submitted by: " + username;
		Long noteId = null;
		String newNoteSql = "INSERT INTO note (text, time) "
							   + "VALUES (?, ?) RETURNING note_id";
		SqlRowSet newNoteResult = jdbcTemplate.queryForRowSet(newNoteSql, finalNote, timestamp);
		newNoteResult.next();
		noteId = newNoteResult.getLong("note_id");
		
		String matchNoteToHouseSql = "INSERT INTO house_notes (house_id, note_id) "
										  + "VALUES (?, ?)";
		jdbcTemplate.update(matchNoteToHouseSql, houseId, noteId);
		
	}

}
