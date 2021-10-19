package com.techelevator.model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;

@Component
public class JDBCProductDAO implements ProductDAO {
	
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	public JDBCProductDAO(DataSource datasource) {
		this.jdbcTemplate = new JdbcTemplate(datasource);
	}

	@Override
	public BigDecimal convertCentsToDollars(int priceInCents) {
		BigDecimal priceInDollars = new BigDecimal(priceInCents / 100 +".00");
		return priceInDollars;
	}

	@Override
	public int convertDollarsToCents(double priceInDollars) {
		int priceInCents = (int) (priceInDollars * 100);
		return priceInCents;
	}

	@Override
	public int saveNewProduct(String name, int price) {
		String newProductSql = "INSERT INTO product(name, price_in_cents) "
								  + "VALUES (?, ?)";
		try {
			jdbcTemplate.update(newProductSql, name, price);
		} catch (Exception e) {
			System.out.println("ERROR OCCURED -- Beginning stack trace:");
			e.printStackTrace();
			return 1;
		}
		return 0;
	}

	@Override
	public List<Product> displayAllProducts() {
		List<Product> products = new ArrayList<>();
		String displayProductsSql = "SELECT * FROM product";
		SqlRowSet results = jdbcTemplate.queryForRowSet(displayProductsSql);
		
		while(results.next()) {
			Product product = new Product();
			product.setId(results.getLong("product_id"));
			product.setName(results.getString("name"));
			product.setPrice(convertCentsToDollars(results.getInt("price_in_cents")));
			
			products.add(product);
		}
		return products;
	}

	@Override
	public int updateProductInfo(String name, int price) {
		String updateProductSql = "UPDATE product "
				  				  + "SET name = ?, price_in_cents = ?";
		try {
			jdbcTemplate.update(updateProductSql, name, price);
		} catch (Exception e) {
			System.out.println("ERROR OCCURED -- Beginning stack trace:");
			e.printStackTrace();
			return 1;
		}
		return 0;
	}

}
