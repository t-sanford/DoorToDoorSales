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
public class JDBCSaleDAO implements SaleDAO {
	
	JdbcTemplate jdbcTemplate;
	
	@Autowired
	public JDBCSaleDAO(DataSource datasource) {
		this.jdbcTemplate = new JdbcTemplate(datasource);
	}

	@Override
	public List<Sale> getSalesByHouseId(Long houseId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Sale> getSalesByProductId(Long productId) {
		List<Sale> sales = new ArrayList<>();
		String getProductSalesSql = "SELECT * "
										+ "FROM sales "
										+ "WHERE product_id = ?";
		SqlRowSet results = jdbcTemplate.queryForRowSet(getProductSalesSql, productId);
		while(results.next()) {
			Sale sale = new Sale();
			sale.setHouseId(results.getLong("house_id"));
			sale.setProductId(results.getLong("product_id"));
			sale.setUserId(results.getLong("user_id"));
			sale.setQuantity(results.getInt("quantity"));
			sale.setTotal(new BigDecimal(results.getDouble("cost_in_cents")));
			sales.add(sale);
		}
		return sales;
	}

	@Override
	public List<Sale> getSalesByUserId(Long userId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public BigDecimal getSalesTotal(List<Sale> sales) {
		BigDecimal runningTotal = new BigDecimal("0.00");
		runningTotal.setScale(2);
		for(Sale sale : sales) {
			BigDecimal productTotal = sale.getTotal().divide(new BigDecimal("100.00"));
			runningTotal = runningTotal.add(productTotal);
		}
		return runningTotal;
	}
	
	@Override
	public int getUnitsSold(List<Sale> sales) {
		int runningTotal = 0;
		for(Sale sale : sales) {
			int productQuantity = sale.getQuantity();
			runningTotal += productQuantity;
		}
		return runningTotal;
	}

	@Override
	public void saveNewSale(Long houseId, Long productId, Long userId, int quantity) {
		String newSaleSql = "INSERT INTO sales(house_id, product_id, user_id, quantity) "
							   + "VALUES (?, ?, ?, ?); ";
		jdbcTemplate.update(newSaleSql, houseId, productId, userId, quantity);
		String setSaleTotalSql =	"UPDATE sales "
							   		  + "SET cost_in_cents = (SELECT (price_in_cents * ?) "
							   								  + "FROM product "
							   								  + "WHERE product_id = ?) "
							   		  + "WHERE house_id = ? AND product_id = ?";
		jdbcTemplate.update(setSaleTotalSql, quantity, productId, houseId, productId);
		
		
	}

}
