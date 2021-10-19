package com.techelevator.model;

import java.io.IOException;
import java.net.URL;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.ObjectMapper;

@Component
public class JDBCHouseDAO<JSONArray> implements HouseDAO
{

	private JdbcTemplate jdbcTemplate;

	@Autowired
	public JDBCHouseDAO(DataSource dataSource)
	{
		this.jdbcTemplate = new JdbcTemplate(dataSource);

	}

	@Override
	public Long createHouse(String address, String city, String state, String resident, String phone_number,
			String status, String creatorId)
	{

		String creatHouseSql = "INSERT INTO house(address, city, state, resident,  phone_number, status,creator_id) VALUES (?, ?, ?, ?, ?, ?, ?) RETURNING house_id";

		SqlRowSet result = jdbcTemplate.queryForRowSet(creatHouseSql, address, city, state, resident, phone_number,
				status, creatorId);

		result.next();
		long id = result.getLong("house_id");
/*		String geolocation = getGeoFromAddress(address+","+city+","+state);
*/
		return id;
	}

	@Override
	public int createHouseMultiple(String textArea, String userName)
	{

		textArea = textArea.replace("\r", "");
		String[] line = textArea.split("\n");

		try
		{
			for (String field : line)
			{
				if (!field.equals(""))
				{
					String[] values = field.split("\\|");
					long houseId = createHouse(values[0], values[1], values[2], values[3], values[4], values[5],
							userName);
					saveNewNote(houseId);
				}
			}
		} catch (Exception e)
		{
			e.printStackTrace();
			System.out.println("This did not work");
			return 1;
		}
		return 0;
	}

	@Override
	public List<House> viewHouses(String userName)
	{
		List<House> houseList = new ArrayList<House>();
		String sql = "SELECT * FROM house WHERE creator_id = ?";
		SqlRowSet results = jdbcTemplate.queryForRowSet(sql, userName);

		while (results.next())
		{
			houseList.add(mapToRow(results));
		}

		return houseList;
	}

	@Override
	public List<House> viewAssignedHouses(String userName)
	{
		List<House> houseList = new ArrayList<House>();
		String sql = "SELECT * FROM house WHERE assignment_id = ?";
		SqlRowSet results = jdbcTemplate.queryForRowSet(sql, userName);

		while (results.next())
		{
			houseList.add(mapToRow(results));
		}

		return houseList;
	}

	@Override
	public House getHouseById(long houseId)
	{
		House house = new House();
		String sql = "SELECT * FROM house WHERE house_id = ?";
		SqlRowSet results = jdbcTemplate.queryForRowSet(sql, houseId);
		results.next();
		house = mapToRow(results);
		return house;
	}

	@Override
	public List<House> viewHousesSortedBySalesman(String userName)
	{
		List<House> houseList = new ArrayList<House>();
		String sql = "SELECT * FROM house WHERE creator_id = ? ORDER BY assignment_id ASC";
		SqlRowSet results = jdbcTemplate.queryForRowSet(sql, userName);

		while (results.next())
		{
			houseList.add(mapToRow(results));
		}

		return houseList;
	}

	@Override
	public List<House> viewHousesSortedByStatus(String userName)
	{
		List<House> houseList = new ArrayList<House>();
		String sql = "SELECT * FROM house WHERE creator_id = ? " + "ORDER BY " + "        CASE status "
				+ "        WHEN 'NV' THEN 1 " + "        WHEN 'NI' THEN 2 " + "        WHEN 'O'  THEN 3 "
				+ "        WHEN 'CL' THEN 4 " + "        WHEN 'FU' THEN 5 " + "     " + "   END;";
		SqlRowSet results = jdbcTemplate.queryForRowSet(sql, userName);

		while (results.next())
		{
			houseList.add(mapToRow(results));
		}

		return houseList;
	}

	@Override
	public List<House> viewHousesSortedByResident(String userName)
	{
		List<House> houseList = new ArrayList<House>();
		String sql = "SELECT * FROM house WHERE creator_id = ? ORDER BY resident ASC";
		SqlRowSet results = jdbcTemplate.queryForRowSet(sql, userName);

		while (results.next())
		{
			houseList.add(mapToRow(results));
		}

		return houseList;
	}

	@Override
	public int updateAssignment(long houseId, String assignmentId)
	{

		String updateSql = "UPDATE house SET assignment_id = ? WHERE house_id =?";

		try
		{
			jdbcTemplate.update(updateSql, assignmentId, houseId);

		} catch (Exception e)
		{
			return 1;
		}

		return 0;
	}

	private House mapToRow(SqlRowSet results)
	{
		House house = new House();
		house.setHouseId(results.getLong("house_id"));
		house.setAddress(results.getString("address"));
		house.setAssignmentId(results.getString("assignment_id"));
		house.setCreatorId(results.getString("creator_id"));
		house.setPhoneNumber(results.getString("phone_number"));
		house.setResident(results.getString("resident"));
		house.setStatus(results.getString("status"));
		house.setCity(results.getString("city"));
		house.setState(results.getString("state"));
		return house;
	}

	@Override
	public void updateHouseStatus(long houseId, String status)
	{
		String changeHouseStatusSql = "UPDATE house " + "SET status = ? " + "WHERE house_id = ?;";
		jdbcTemplate.update(changeHouseStatusSql, status, houseId);
	}

	@Override
	public List<House> getHouseByTeam(long teamId)
	{

		return null;
	}

	private void saveNewNote(long houseId)
	{
		String newNoteSql = "INSERT INTO note (text, time) " + "VALUES (?, ?) RETURNING note_id";
		String finalNote = "House Added.";
		long noteId;
		SqlRowSet newNoteResult = jdbcTemplate.queryForRowSet(newNoteSql, finalNote, LocalDateTime.now());
		newNoteResult.next();
		noteId = newNoteResult.getLong("note_id");

		String matchNoteToHouseSql = "INSERT INTO house_notes (house_id, note_id) " + "VALUES (?, ?)";
		jdbcTemplate.update(matchNoteToHouseSql, houseId, noteId);
	}
	
	/*private String getGeoFromAddress(String address) {
		ObjectMapper mapper = new ObjectMapper();
		Map data = null;
        try {
             data = mapper.readValue(new URL("http://www.mapquestapi.com/geocoding/v1/address?key=KEY&location="+address), Map.class);
            System.out.println(data);
          
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        String url = "http://www.mapquestapi.com/geocoding/v1/address?key=Mtbu18nHxlnliiqzIQuzjPlbm3zUrdQk&location="+ address; 

        		$.getJSON(url, function(data)
        		 {
        		         alert(data.results[0].formatted_address)

        		 });
        
		return geolocation;
	}*/

}
