package com.techelevator.controller;

import java.time.LocalDateTime;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.techelevator.model.House;
import com.techelevator.model.HouseDAO;
import com.techelevator.model.NoteDAO;
import com.techelevator.model.ProductDAO;
import com.techelevator.model.TeamDAO;
import com.techelevator.model.User;

@Controller
public class HouseController {
	
	private HouseDAO houseDAO;
	private TeamDAO teamDao;
	private NoteDAO noteDAO;
	private ProductDAO productDAO;
	
	@Autowired
	public HouseController(HouseDAO houseDAO, TeamDAO teamDao, NoteDAO noteDAO, ProductDAO productDAO) {
		this.houseDAO = houseDAO;
		this.teamDao = teamDao;
		this.noteDAO = noteDAO;
		this.productDAO = productDAO;
	}
	
	
	@RequestMapping(path = "/addHouses",method = RequestMethod.GET)
	public String displayAddHousePage(HttpSession session) {
		if(session.getAttribute("currentUser") == null) {
			return "redirect:/login?destination=/addHouses";
		} else if (!((User) session.getAttribute("currentUser")).getRole().equals("Admin")) {
			return "/notAuthorized";
		}
		return "/addHouses";
	}
	
	@RequestMapping(path = "/addHouses",method = RequestMethod.POST)
	public String addNewHouses(@Valid @ModelAttribute House house,
							          @RequestParam String creatorId,
							          @RequestParam String note,
									  BindingResult result,
									  RedirectAttributes flash) {
		if(result.hasErrors()) {
			flash.addFlashAttribute("house",house);
			flash.addFlashAttribute(BindingResult.MODEL_KEY_PREFIX+ "house", result);
            flash.addFlashAttribute("errorMessage", "Error creating new House.");
			return "redirect:/addHouses";
		} 
		
			Long id = houseDAO.createHouse(house.getAddress(), house.getCity(), house.getState(), house.getResident(), house.getPhoneNumber(), house.getStatus(), creatorId);
			noteDAO.saveNewNote(id, creatorId, note, LocalDateTime.now());
			flash.addFlashAttribute("message", "New House " + house.getAddress() + " Created Successfully!");
			return "redirect:/admin";
		
		
	}
	
	@RequestMapping(path = "/textArea",method = RequestMethod.POST)
	public String addNewHousesByCsv(@Valid @RequestParam String textArea, RedirectAttributes flash, HttpSession session) {
		int success = houseDAO.createHouseMultiple(textArea, ((User)session.getAttribute("currentUser")).getUserName());	
		if(success==0) {
			flash.addFlashAttribute("message", "House(s) Created Successfully!");
		}else {
			flash.addFlashAttribute("errorMessage", "Unable to create new houses");
		}
		
		return "redirect:/admin";
	}
	
	@RequestMapping(path ="/viewHouses", method = RequestMethod.GET)
	public String viewHouse(ModelMap modelHolder, HttpSession session) {
		long teamId  = teamDao.getTeamId(((User)session.getAttribute("currentUser")).getUserName());
		modelHolder.put("teamMembers",teamDao.getAllTeamMembers(teamId));
		modelHolder.put("houses", houseDAO.viewHouses(((User)session.getAttribute("currentUser")).getUserName()));
		return "/viewHouses";
	}
	
	@RequestMapping(path = "/updateAssignment", method = RequestMethod.POST)
	public String updateAssignment(@RequestParam long houseId, @RequestParam String assignmentId, RedirectAttributes flash) {
		if(assignmentId.equals("")) {
			assignmentId = null;
		}
		int success = houseDAO.updateAssignment(houseId, assignmentId);
		if(success==0) {
			flash.addFlashAttribute("message", "House(s) updated Successfully!");
		}else {
			flash.addFlashAttribute("message", "Unable to update house(s)");
		}
		
		return "redirect:/viewHouses";
	}
	
	@RequestMapping(path="/addNote", method=RequestMethod.GET)
	public String displayNewNoteForm(ModelMap modelHolder, @RequestParam long houseId) {
		modelHolder.put("house", houseDAO.getHouseById(houseId));
		return "/newNote";
	}
	
	@RequestMapping(path="/addNote", method=RequestMethod.POST)
	public String addNewHouseNote(@RequestParam String text, @RequestParam long houseId, @RequestParam String creatorId) {
		noteDAO.saveNewNote(houseId, creatorId, text, LocalDateTime.now());
		return "redirect:/houseDetail?houseId=" + houseId;
	}
	
	@RequestMapping(path="/updateStatus", method=RequestMethod.POST)
	public String updateHouseStatus(@RequestParam String status, @RequestParam long houseId, @RequestParam String username) {
		houseDAO.updateHouseStatus(houseId, status);
		
		if(status.equals("NV")) {
			status = "Not Visited";
		} else if(status.equals("NI") ) {
			status = "Not Interested";
		} else if(status.equals("CL") ) {
			status = "Closed";
		} else if(status.equals("O") ) {
			status = "Ordered";
		} else {
			status = "Follow Up";
		}
		String statusChange = "Status changed to " + status + ".";
		noteDAO.saveNewNote(houseId, username, statusChange, LocalDateTime.now());
		return "redirect:/houseDetail?houseId=" + houseId;
	}
	
	@RequestMapping(path = "/houseDetail", method = RequestMethod.GET)
	public String showHouseDetail(ModelMap modelHolder, @RequestParam long houseId, HttpSession session) {
		String username = ((User) session.getAttribute("currentUser")).getUserName();
		String assignedTo = houseDAO.getHouseById(houseId).getAssignmentId();
		String assignedAdmin = houseDAO.getHouseById(houseId).getCreatorId();
		if (!username.equals(assignedTo) && !username.equals(assignedAdmin) ) {
			return "/notAuthorized";
		}
		modelHolder.put("house", houseDAO.getHouseById(houseId));
		modelHolder.put("notes", noteDAO.getNotesByHouseId(houseId));
		modelHolder.put("products", productDAO.displayAllProducts());
		return "/houseDetail";
	}
}
