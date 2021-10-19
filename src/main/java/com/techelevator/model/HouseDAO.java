package com.techelevator.model;

import java.util.List;


public interface HouseDAO {

	public Long createHouse(String address, String resident, String phone_number, String status, String city, String state, String creatorId);

	List<House> viewHouses(String userName);
	
	public int createHouseMultiple(String textArea, String userName);
	
	public List<House> getHouseByTeam(long teamId);
	
	public House getHouseById(long houseId);

	List<House> viewAssignedHouses(String userName);

	int updateAssignment(long houseId, String assignmentId);

	List<House> viewHousesSortedBySalesman(String userName);

	List<House> viewHousesSortedByStatus(String userName);

	List<House> viewHousesSortedByResident(String userName);
	
	public void updateHouseStatus(long houseId, String status);
}
