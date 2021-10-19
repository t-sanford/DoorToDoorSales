package com.techelevator.model;

import java.math.BigDecimal;
import java.util.List;

public interface ProductDAO {
	
	public BigDecimal convertCentsToDollars(int priceInCents);
	public int convertDollarsToCents(double priceInDollars);
	public int saveNewProduct(String name, int price);
	public List<Product> displayAllProducts();
	public int updateProductInfo(String name, int price);

}
