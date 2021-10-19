package com.techelevator.model;

import java.time.LocalDateTime;
import java.util.List;

public interface NoteDAO {

	public void saveNewNote(Long houseId, String username, String text, LocalDateTime timestamp);
	public List<Note>getNotesByHouseId(Long houseId);
}
