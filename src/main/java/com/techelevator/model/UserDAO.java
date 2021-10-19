package com.techelevator.model;

import org.omg.CosNaming.NamingContextExtPackage.StringNameHelper;

public interface UserDAO {

	public int saveUser(String firstName, String lastName, String userName, String password, String email, String role);

	public boolean searchForUsernameAndPassword(String userName, String password);

	public int updatePassword(String userName, String password);

	public User getUserByUserName(String userName);

	public Long getUserIdByUserName(String userName);

	//public void setLocation(String location);

	

}
