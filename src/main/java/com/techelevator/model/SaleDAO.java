package com.techelevator.model;

import java.math.BigDecimal;
import java.util.List;

public interface SaleDAO {
	
	public void saveNewSale(Long houseId, Long productId, Long userId, int quantity);
	public List<Sale> getSalesByHouseId(Long houseId);
	public List<Sale> getSalesByProductId(Long productId);
	public List<Sale> getSalesByUserId(Long userId);
	public BigDecimal getSalesTotal(List<Sale> sales);
	public int getUnitsSold(List<Sale> sales);

}
