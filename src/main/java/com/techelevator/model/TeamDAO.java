package com.techelevator.model;

import java.util.List;

public interface TeamDAO {

	void createNewTeam(String name, String username);
	void addSalesmanToTeam(Long team_id, String username);
	User getTeamAdmin(long team_id);
	List<User> getAllTeamMembers(long team_id);
	long getTeamId(String userName);
}
