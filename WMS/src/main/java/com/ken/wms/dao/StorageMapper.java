package com.ken.wms.dao;

import com.ken.wms.domain.Storage;
import org.apache.ibatis.annotations.Param;


import java.util.List;

/**
 * 库存信息映射器
 * @author Ken
 *
 */
public interface StorageMapper {

	/**
	 * 选择所有的库存信息
	 * @return 返回所有的库存信息
	 */
	List<Storage> selectAll();
	
	/**
	 * 选择指定材料ID和供应商ID的库存信息
	 * @param goodsID 材料ID
	 * @param supplierID 库存ID
	 * @return 返回所有指定材料ID和供应商ID的库存信息
	 */
	List<Storage> selectByGoodsIDAndSupplierID(@Param("goodsID") Integer goodsID,
												 @Param("supplierID") Integer supplierID);
	
	/**
	 * 选择指定材料名的库存信息
	 * @param goodsName 材料名称
	 * @return 返回所有指定材料名称的库存信息
	 */
	List<Storage> selectByGoodsName(@Param("goodsName") String goodsName);
	
	/**
	 * 选择指定材料类型的库存信息
	 * @param goodsType 材料类型
	 * @return 返回所有指定材料类型的库存信息
	 */
	List<Storage> selectByGoodsType(@Param("goodsType") String goodsType);
	
	/**
	 * 更新库存信息
	 * 该库存信息必需已经存在于数据库当中，否则更新无效
	 * @param storage 库存信息
	 */
	void update(Storage storage);
	
	/**
	 * 插入新的库存信息
	 * @param storage 库存信息
	 */
	void insert(Storage storage);
	
	/**
	 * 批量导入库存信息
	 * @param storages 若干条库存信息
	 */
	void insertBatch(List<Storage> storages);
	
	/**
	 * 删除指定材料ID的库存信息
	 * @param goodsID 材料ID
	 */
	void deleteByGoodsID(Integer goodsID);
	
	/**
	 * 删除指定供应商的库存信息
	 * @param repositoryID 供应商ID
	 */
	void deleteByRepositoryID(Integer repositoryID);
	
	/**
	 * 删除指定供应商中的指定材料的库存信息
	 * @param goodsID 材料ID
	 * @param repositoryID 供应商ID
	 */
	void deleteByRepositoryIDAndGoodsID(@Param("goodsID") Integer goodsID, @Param("repositoryID") Integer repositoryID);
}
