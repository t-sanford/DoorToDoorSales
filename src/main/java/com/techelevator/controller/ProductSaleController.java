package com.techelevator.controller;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.techelevator.model.HouseDAO;
import com.techelevator.model.NoteDAO;
import com.techelevator.model.Product;
import com.techelevator.model.ProductDAO;
import com.techelevator.model.SaleDAO;
import com.techelevator.model.TeamDAO;
import com.techelevator.model.User;
import com.techelevator.model.UserDAO;

@Controller
public class ProductSaleController {
	
	private ProductDAO productDAO;
	private SaleDAO saleDAO;
	private UserDAO userDAO;
	private TeamDAO teamDAO;
	private HouseDAO houseDao;
	private NoteDAO noteDAO;
	
	@Autowired
	public ProductSaleController(NoteDAO noteDAO, ProductDAO productDAO, SaleDAO saleDAO, UserDAO userDAO, TeamDAO teamDAO, HouseDAO houseDao) {
		this.productDAO = productDAO;
		this.saleDAO = saleDAO;
		this.userDAO = userDAO;
		this.houseDao = houseDao;
		this.teamDAO = teamDAO;
		this.noteDAO = noteDAO;
	}
	
	@RequestMapping(path="/addProduct", method=RequestMethod.GET)
	public String showAddProductForm(HttpSession session) {
		
		return "/addProduct";
	}
	
	@RequestMapping(path="/addProduct", method=RequestMethod.POST)
	public String submitNewProduct(@RequestParam String name, @RequestParam double price, RedirectAttributes flash) {
		int success = productDAO.saveNewProduct(name, productDAO.convertDollarsToCents(price));
		
		if(success == 0) {
			flash.addFlashAttribute("message", "Successfully added " + name + " to your product list with a price of: $" +price);
			return "redirect:/admin";
		} else {
			flash.addFlashAttribute("errorMessage", "There was an error while adding your new product. Please try again");
			return "redirect:/admin";
		}
		
	}
	
	@RequestMapping(path="/newSale", method=RequestMethod.POST)
	public String makeNewSale(HttpServletRequest request, HttpSession session, @RequestParam String productId, @RequestParam String quantity, @RequestParam Long houseId) {
		
		String[] products = request.getParameterValues("productId");
		String[] quantities = request.getParameterValues("quantity");
		String userId = userDAO.getUserIdByUserName(((User) session.getAttribute("currentUser")).getUserName()).toString();

		for (int i = 0; i < products.length; i++) {
			
			saleDAO.saveNewSale(houseId, Long.parseLong(products[i]), Long.parseLong(userId), Integer.parseInt(quantities[i]));
		}
		
		houseDao.updateHouseStatus(houseId, "O");
		String username = ((User) session.getAttribute("currentUser")).getUserName();
		noteDAO.saveNewNote(houseId, username, "Order placed ", LocalDateTime.now());
		
		return "redirect:/houseDetail?houseId=" + houseId;
	}
	
	@RequestMapping(path = "/salesData" , method = RequestMethod.GET)
	public String showSalesData(ModelMap modelHolder, HttpSession session, @RequestParam(required = false) String sort) {
		if(sort == null) {
			long id  = teamDAO.getTeamId(((User)session.getAttribute("currentUser")).getUserName());
	     	modelHolder.put("teamMembers",teamDAO.getAllTeamMembers(id));
	     	modelHolder.put("houses", houseDao.viewHouses(((User)session.getAttribute("currentUser")).getUserName()));
		}else if(sort.equals("userId")) {
			long id  = teamDAO.getTeamId(((User)session.getAttribute("currentUser")).getUserName());
	     	modelHolder.put("teamMembers",teamDAO.getAllTeamMembers(id));
			modelHolder.put("houses", houseDao.viewHousesSortedBySalesman(((User)session.getAttribute("currentUser")).getUserName()));
		}else if (sort.equals("resident")) {
			long id  = teamDAO.getTeamId(((User)session.getAttribute("currentUser")).getUserName());
	     	modelHolder.put("teamMembers",teamDAO.getAllTeamMembers(id));
	     	modelHolder.put("houses", houseDao.viewHousesSortedByResident(((User)session.getAttribute("currentUser")).getUserName()));
		}else if(sort.equals("status")) {
			long id  = teamDAO.getTeamId(((User)session.getAttribute("currentUser")).getUserName());
	     	modelHolder.put("teamMembers",teamDAO.getAllTeamMembers(id));
	     	modelHolder.put("houses", houseDao.viewHousesSortedByStatus(((User)session.getAttribute("currentUser")).getUserName()));
		}else {
			long id  = teamDAO.getTeamId(((User)session.getAttribute("currentUser")).getUserName());
	     	modelHolder.put("teamMembers",teamDAO.getAllTeamMembers(id));
	     	modelHolder.put("houses", houseDao.viewHouses(((User)session.getAttribute("currentUser")).getUserName()));
		}
		
		modelHolder.put("products", productDAO.displayAllProducts());
		
		List<BigDecimal> totals = new ArrayList<>();
		for(int i = 1; i < productDAO.displayAllProducts().size() + 1; i++) {
			BigDecimal total = saleDAO.getSalesTotal(saleDAO.getSalesByProductId((long) i));
			totals.add(total);
		}
		modelHolder.put("totals", totals);
		
		List<Integer> quantities = new ArrayList<>();
		for(int i = 1; i < productDAO.displayAllProducts().size() + 1; i++) {
			int quantity = saleDAO.getUnitsSold(saleDAO.getSalesByProductId((long) i));
			quantities.add(quantity);
		}
		modelHolder.put("quantities", quantities);
		
		return "/salesData";
	}
		

}
