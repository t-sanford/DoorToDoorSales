package com.techelevator.controller;

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

import com.techelevator.model.EmailServiceImpl;
//import com.techelevator.model.EmailServiceImpl;
import com.techelevator.model.HouseDAO;
import com.techelevator.model.NoteDAO;
import com.techelevator.model.TeamDAO;
import com.techelevator.model.User;
import com.techelevator.model.UserDAO;

@Controller
public class UserController {

	private UserDAO userDAO;
	private TeamDAO teamDAO;
	private HouseDAO houseDao;
	private NoteDAO noteDao;
	private EmailServiceImpl email;

	@Autowired
	public UserController(UserDAO userDAO, TeamDAO teamDAO, HouseDAO houseDao, NoteDAO noteDao, EmailServiceImpl email) {
		this.userDAO = userDAO;
		this.teamDAO = teamDAO;
		this.houseDao= houseDao;
		this.noteDao= noteDao;
		this.email = email;
	}

	@RequestMapping(path="/users/new", method=RequestMethod.GET)
	public String displayNewAdminForm(ModelMap modelHolder) {
		if( ! modelHolder.containsAttribute("user")) {
			modelHolder.addAttribute("user", new User());
		}
		return "newUser";
	}
	
	@RequestMapping(path="/users", method=RequestMethod.POST)
    public String createAdmin(@Valid @ModelAttribute User user, @RequestParam String teamName, BindingResult result, RedirectAttributes flash) {
        if(result.hasErrors()) {
            flash.addFlashAttribute("user", user);
            flash.addFlashAttribute(BindingResult.MODEL_KEY_PREFIX + "user", result);
            flash.addFlashAttribute("errorMessage", "Error creating new Admin.");
            return "redirect:/users/new";
        }
        
       int success= userDAO.saveUser(user.getFirstName(), user.getLastName(), user.getUserName(), user.getPassword(), user.getEmail(), user.getRole() );
       if(success ==0) {
    	   flash.addFlashAttribute("message", "New Admin " + user.getFirstName() + " Created Successfully!");
    	   teamDAO.createNewTeam(teamName, user.getUserName());
       }else {
    	   flash.addFlashAttribute("errorMessage", "Invalid Registration, Please Try Again");
    	   return "redirect:/users/new";
       }
        
      
        
        return "redirect:/login";
    }
	
	@RequestMapping(path="/newSalesman", method=RequestMethod.GET)
	public String displayNewSalesmanForm(ModelMap modelHolder, RedirectAttributes flash, HttpSession session) {
		
		if (!((User) session.getAttribute("currentUser")).getRole().equals("Admin")) {
			return "/notAuthorized";
		}
		
		if( ! modelHolder.containsAttribute("user")) {
			modelHolder.addAttribute("user", new User());
		}
		if(flash.containsAttribute("message")) {
			
		}
		return "newSalesman";
	}
	
	@RequestMapping(path="/newSalesman", method=RequestMethod.POST)
    public String createNewSalesman(@Valid @ModelAttribute User user, BindingResult result, HttpSession session, RedirectAttributes flash) {
        if(result.hasErrors()) {
            flash.addFlashAttribute("user", user);
            flash.addFlashAttribute(BindingResult.MODEL_KEY_PREFIX + "user", result);
            flash.addFlashAttribute("errorMessage", "Error creating new Salesman.");
            return "redirect:/admin";
        }
        
        email.sendSimpleMessage(user.getEmail(),((User)session.getAttribute("currentUser")).getUserName() ,user.getUserName(), user.getPassword());
        userDAO.saveUser(user.getFirstName(), user.getLastName(), user.getUserName(), user.getPassword(), user.getEmail(), user.getRole() );
        flash.addFlashAttribute("message", "New Salesman " + user.getFirstName() + " Created Successfully!");
        long team_id  = teamDAO.getTeamId(((User)session.getAttribute("currentUser")).getUserName());
        teamDAO.addSalesmanToTeam(team_id, user.getUserName());
        return "redirect:/admin";
    }
	
	
	
	@RequestMapping(path="/salesman", method=RequestMethod.GET)
	public String showSalesmanPage(HttpSession session, ModelMap modelHolder) {
		modelHolder.put("houses", houseDao.viewAssignedHouses(((User)session.getAttribute("currentUser")).getUserName()));
		return "/salesman";
	}
	
	@RequestMapping(path = "/salesmanPage", method = RequestMethod.GET)
	public String showSalesmanPage2(@RequestParam String userName, ModelMap modelHolder) {
		modelHolder.put("houses", houseDao.viewAssignedHouses(userName));
		modelHolder.put("salesman", userName);
		return "/salesman";
		
	}
	
	@RequestMapping(path= {"/admin"}, method=RequestMethod.GET)
	public String showTeam(HttpSession session, ModelMap modelHolder) {
		long id  = teamDAO.getTeamId(((User)session.getAttribute("currentUser")).getUserName());
		modelHolder.put("teamMembers",teamDAO.getAllTeamMembers(id));
		return "/adminHome";
	}
	
	@RequestMapping(path="/changePassword", method=RequestMethod.GET)
	public String showChangePassForm() {
		return "/changePassword"; 
	}
	
	@RequestMapping(path="/changePassword", method=RequestMethod.POST)
	public String submitChangePassForm(ModelMap model, @RequestParam String oldPassword, @RequestParam String newPassword, HttpSession session, RedirectAttributes flash) {
		String userName = ((User) (session.getAttribute("currentUser"))).getUserName();
		if(userDAO.searchForUsernameAndPassword(userName, oldPassword)) {
			int success = userDAO.updatePassword(userName, newPassword);
			
			if(success == 0) {
				flash.addFlashAttribute("message", "Password has been successfully changed. Please log back in.");
				model.remove("currentUser");
				session.invalidate();
				return "redirect:/";
			} else {
				flash.addFlashAttribute("errorMessage", "An error occured when trying to change your password. Please try again.");
				return "redirect:/changePassword"; 
			}
		} else {
			flash.addFlashAttribute("errorMessage", "An error occured when trying to change your password. Please try again.");
			return "redirect:/changePassword"; 
		}
	}
	
	@RequestMapping(path="/loctionForm", method=RequestMethod.POST)
	public String updatelocation(@RequestParam String location, HttpSession session, RedirectAttributes flash) 
	{
		//userDAO.setLocation(location);
		return "/salesman";
	}	
		
			
	
	
}
