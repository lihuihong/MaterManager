package com.ken.wms.common.service.Impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ken.wms.common.service.Interface.StockRecordManageService;
import com.ken.wms.common.service.Interface.StorageManageService;
import com.ken.wms.dao.*;
import com.ken.wms.domain.*;
import com.ken.wms.exception.CustomerManageServiceException;
import com.ken.wms.exception.StockRecordManageServiceException;
import com.ken.wms.exception.StorageManageServiceException;
import com.ken.wms.util.aop.UserOperation;
import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.exceptions.PersistenceException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
public class StockRecordManageServiceImpl implements StockRecordManageService {

    @Autowired
    private SupplierMapper supplierMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private GoodsMapper goodsMapper;
    @Autowired
    private StorageManageService storageManageService;
    @Autowired
    private StockInMapper stockinMapper;
    @Autowired
    private StockOutMapper stockOutMapper;


    /**材料租入租出操作
     *
     *
     */
    @UserOperation(value = "材料出租")
    public boolean stockInOutOperation(Integer supplierID, Integer customerID,Integer goodsID, long number, String personInCharge,Double price) throws StockRecordManageServiceException {

        boolean isSuccess;

        try {
            // 更新库存记录
            isSuccess = storageManageService.storageDecrease(goodsID,supplierID, number);

            // 保存租出记录
            if (isSuccess) {
                StockInDO stockInDO = new StockInDO();
                stockInDO.setGoodID(goodsID);
                stockInDO.setSupplierID(supplierID);
                stockInDO.setNumber(number);
                stockInDO.setPersonInCharge(personInCharge);
                stockInDO.setTime(new Date());
                stockInDO.setPrice(price);
                stockinMapper.insert(stockInDO);

                StockOutDO stockOutDO = new StockOutDO();
                stockOutDO.setGoodID(goodsID);
                stockOutDO.setCustomerID(customerID);
                stockOutDO.setNumber(number);
                stockOutDO.setPersonInCharge(personInCharge);
                stockOutDO.setTime(new Date());
                stockOutDO.setPrice(price);
                stockOutMapper.insert(stockOutDO);
            }

            return isSuccess;
        } catch (PersistenceException | StorageManageServiceException e) {
            throw new StockRecordManageServiceException(e);
        }
    }

    @Override
    public Map<String, Object> selectInRecord(String supplierName, int offset, int limit) throws StockRecordManageServiceException {

        // 初始化结果集
        Map<String, Object> resultSet = new HashMap<>();
        long total = 0;
        boolean isPagination = true;
        if (offset < 0 || limit < 0)
            isPagination = false;

        List<StockInDO> stockInDTOS;

        if (isPagination) {
            PageHelper.offsetPage(offset, limit);
            if("".equals(supplierName)){
                stockInDTOS = stockinMapper.selectAll();
            }else{
                stockInDTOS = stockinMapper.selectBySupplierName(supplierName);
            }
            if (stockInDTOS != null) {
                PageInfo<StockInDO> pageInfo = new PageInfo<>(stockInDTOS);
                total = pageInfo.getTotal();
            } else
                stockInDTOS = new ArrayList<>();
        } else {
            if("".equals(supplierName)){
                stockInDTOS = stockinMapper.selectAll();
            }else{
                stockInDTOS = stockinMapper.selectBySupplierName(supplierName);
            }
            if (stockInDTOS != null)
                total = stockInDTOS.size();
            else
                stockInDTOS = new ArrayList<>();
        }

        resultSet.put("data", stockInDTOS);
        resultSet.put("total",total);

        return resultSet;

    }

    @Override
    public Map<String, Object> selectOutRecord(String customerName, int offset, int limit) throws StockRecordManageServiceException {
        // 初始化结果集
        Map<String, Object> resultSet = new HashMap<>();
        long total = 0;
        boolean isPagination = true;
        if (offset < 0 || limit < 0)
            isPagination = false;

        List<StockOutDO> stockOutDTOS;

        if (isPagination) {
            PageHelper.offsetPage(offset, limit);
            if("".equals(customerName)){
                stockOutDTOS = stockOutMapper.selectAll();
            }else{
                stockOutDTOS = stockOutMapper.selectByCustomerName(customerName);
            }
            if (stockOutDTOS != null) {
                PageInfo<StockOutDO> pageInfo = new PageInfo<>(stockOutDTOS);
                total = pageInfo.getTotal();
            } else
                stockOutDTOS = new ArrayList<>();
        } else {
            if("".equals(customerName)){
                stockOutDTOS = stockOutMapper.selectAll();
            }else{
                stockOutDTOS = stockOutMapper.selectByCustomerName(customerName);
            }
            if (stockOutDTOS != null)
                total = stockOutDTOS.size();
            else
                stockOutDTOS = new ArrayList<>();
        }

        resultSet.put("data", stockOutDTOS);
        resultSet.put("total",total);

        return resultSet;
    }


    /**
     * 材料租入操作
     *
     * @param supplierID   供应商ID
     * @param goodsID      材料ID
     * @param number       租入数量
     * @return 返回一个boolean 值，若值为true表示租入成功，否则表示租入失败
     */
    @UserOperation(value = "材料租入")
    @Override
    public boolean stockInOperation(Integer supplierID, Integer goodsID, long number, String personInCharge,Double price) throws StockRecordManageServiceException {

        // ID对应的记录是否存在
        if (!(supplierValidate(supplierID) && goodsValidate(goodsID)))
            return false;

        if (personInCharge == null)
            return false;

        // 检查租入数量有效性
        if (number < 0)
            return false;

        try {
            // 更新库存记录
            boolean isSuccess;
            isSuccess = storageManageService.storageIncrease(goodsID,supplierID, number);

            // 保存租入记录
            if (isSuccess) {
                StockInDO stockInDO = new StockInDO();
                stockInDO.setGoodID(goodsID);
                stockInDO.setSupplierID(supplierID);
                stockInDO.setNumber(number);
                stockInDO.setPersonInCharge(personInCharge);
                stockInDO.setTime(new Date());
                stockInDO.setPrice(price);
                stockinMapper.insert(stockInDO);
            }

            return isSuccess;
        } catch (PersistenceException | StorageManageServiceException e) {
            throw new StockRecordManageServiceException(e);
        }
    }

    /**
     * 材料出租操作
     *
     * @param customerID   客户ID
     * @param goodsID      材料ID
     * @param number       出租数量
     * @return 返回一个boolean值，若值为true表示出租成功，否则表示出租失败
     */
    @UserOperation(value = "材料出租")
    @Override
    public boolean stockOutOperation(Integer customerID, Integer goodsID, long number, String personInCharge,Double price) throws StockRecordManageServiceException {

        // 检查ID对应的记录是否存在
        if (!(customerValidate(customerID) && goodsValidate(goodsID)))
            return false;

        // 检查出租数量范围是否有效
        if (number < 0)
            return false;

        try {
            // 更新库存信息
            boolean isSuccess;
            isSuccess = storageManageService.storageDecrease(goodsID, customerID, number);

            // 保存出租记录
            if (isSuccess) {
                StockOutDO stockOutDO = new StockOutDO();
                stockOutDO.setCustomerID(customerID);
                stockOutDO.setGoodID(goodsID);
                stockOutDO.setNumber(number);
                stockOutDO.setPersonInCharge(personInCharge);
                stockOutDO.setPrice(price);
                stockOutDO.setTime(new Date());
                stockOutMapper.insert(stockOutDO);
            }

            return isSuccess;
        } catch (PersistenceException | StorageManageServiceException e) {
            throw new StockRecordManageServiceException(e);
        }
    }

    /**
     * 查询出租入记录
     *
     * @param supplierID 仓库ID
     * @param endDateStr   查询记录起始日期
     * @param startDateStr 查询记录结束日期
     * @param searchType   记录查询方式
     * @return 结果的一个Map，其中： key为 data 的代表记录数据；key 为 total 代表结果记录的数量
     */
    @Override
    public Map<String, Object> selectStockRecord(Integer supplierID, String startDateStr, String endDateStr, String searchType) throws StockRecordManageServiceException {
        return selectStockRecord(supplierID, startDateStr, endDateStr, searchType, -1, -1);
    }

    /**
     * 分页查询出租入记录
     *
     * @param supplierID 仓库ID
     * @param endDateStr   查询记录起始日期
     * @param startDateStr 查询记录结束日期
     * @param searchType   记录查询方式
     * @param offset       分页偏移值
     * @param limit        分页大小
     * @return 结果的一个Map，其中： key为 data 的代表记录数据；key 为 total 代表结果记录的数量
     */
    @SuppressWarnings("unchecked")
    @Override
    public Map<String, Object> selectStockRecord(Integer supplierID, String startDateStr, String endDateStr, String searchType, int offset, int limit) throws StockRecordManageServiceException {
        // 初始化结果集
        Map<String, Object> resultSet = new HashMap<>();
        long total = 0;

        // 检查传入参数
        if (supplierID == null || searchType == null)
            throw new StockRecordManageServiceException("exception");

        // 转换 Date 对象
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date startDate = null;
        Date endDate = null;
        try {
            if (StringUtils.isNotEmpty(startDateStr))
                startDate = dateFormat.parse(startDateStr);
            if (StringUtils.isNotEmpty(endDateStr))
                endDate = dateFormat.parse(endDateStr);
        } catch (ParseException e) {
            throw new StockRecordManageServiceException(e);
        }

        // 根据查询模式执行查询
        List<StockRecordDTO> stockRecordDTOS = new ArrayList<>();
        Map<String, Object> stockInTemp;
        Map<String, Object> stockOutTemp;
        List<StockInDO> stockInRecordDOS = null;
        List<StockOutDO> stockOutRecordDOS = null;
        switch (searchType) {
            case "all": {
                if (offset < 0 || limit < 0) {
                    stockInTemp = selectStockInRecord(supplierID, startDate, endDate, offset, limit);
                    stockOutTemp = selectStockOutRecord(supplierID, startDate, endDate, offset, limit);
                    stockInRecordDOS = (List<StockInDO>) stockInTemp.get("data");
                    stockOutRecordDOS = (List<StockOutDO>) stockOutTemp.get("data");
                } else {
                    int stockInRecordOffset = offset / 2;
                    int stockOutRecordOffset = stockInRecordOffset * 2 < offset ? stockInRecordOffset + 1 : stockInRecordOffset;
                    int stockInRecordLimit = limit / 2;
                    int stockOutRecordLimit = stockInRecordLimit * 2 < limit ? stockInRecordLimit + 1 : stockInRecordLimit;

                    stockInTemp = selectStockInRecord(supplierID, startDate, endDate, stockInRecordOffset, limit);
                    stockOutTemp = selectStockOutRecord(supplierID, startDate, endDate, stockOutRecordOffset, limit);

                    stockInRecordDOS = (List<StockInDO>) stockInTemp.get("data");
                    stockOutRecordDOS = (List<StockOutDO>) stockOutTemp.get("data");

                    int stockInRecordDosSize = stockInRecordDOS.size();
                    int stockOutRecordDoSize = stockOutRecordDOS.size();
                    if (stockInRecordDosSize >= stockInRecordLimit && stockOutRecordDoSize >= stockOutRecordLimit) {
                        stockInRecordDOS = stockInRecordDOS.subList(0, stockInRecordLimit);
                        stockOutRecordDOS = stockOutRecordDOS.subList(0, stockOutRecordLimit);
                    } else if (stockInRecordDosSize < stockInRecordLimit && stockOutRecordDoSize > stockOutRecordLimit) {
                        int appendSize = (stockOutRecordDoSize - stockOutRecordLimit) > (stockInRecordLimit - stockInRecordDosSize) ?
                                (stockInRecordLimit - stockInRecordDosSize) : (stockOutRecordDoSize - stockOutRecordLimit);
                        stockOutRecordDOS = stockOutRecordDOS.subList(0, stockInRecordLimit + appendSize - 1);
                    } else if (stockOutRecordDoSize < stockOutRecordLimit && stockInRecordDosSize > stockInRecordLimit) {
                        int appendSize = (stockInRecordDosSize - stockInRecordLimit) > (stockOutRecordLimit - stockOutRecordDoSize) ?
                                (stockOutRecordLimit - stockOutRecordDoSize) : (stockInRecordDosSize - stockInRecordLimit);
                        stockInRecordDOS = stockInRecordDOS.subList(0, stockInRecordLimit + appendSize);
                    }
                }
                long stockInRecordDOSTotal = (long) stockInTemp.get("total");
                long stockOutRecordDOSTotal = (long) stockOutTemp.get("total");
                total = stockInRecordDOSTotal + stockOutRecordDOSTotal;
                break;
            }
            case "stockInOnly": {
                stockInTemp = selectStockInRecord(supplierID, startDate, endDate, offset, limit);
                total = (long) stockInTemp.get("total");
                stockInRecordDOS = (List<StockInDO>) stockInTemp.get("data");
                break;
            }
            case "stockOutOnly": {
                stockOutTemp = selectStockOutRecord(supplierID, startDate, endDate, offset, limit);
                total = (long) stockOutTemp.get("total");
                stockOutRecordDOS = (List<StockOutDO>) stockOutTemp.get("data");
                break;
            }
            case "none": {
                break;
            }
        }

        if (stockInRecordDOS != null)
            stockInRecordDOS.forEach(stockInDO -> stockRecordDTOS.add(stockInRecordConvertToStockRecordDTO(stockInDO)));
        if (stockOutRecordDOS != null)
            stockOutRecordDOS.forEach(stockOutDO -> stockRecordDTOS.add(stockOutDoConvertToStockRecordDTO(stockOutDO)));

        resultSet.put("data", stockRecordDTOS);
        resultSet.put("total", total);
        return resultSet;
    }

    /**
     * 查询租入记录
     *
     * @param supplierID   租入公司ID
     * @param startDate    租入记录起始日期
     * @param endDate      租入记录结束日期
     * @param offset       分页偏移值
     * @param limit        分页大小
     * @return 返回所有符合要求的租入记录
     */
    private Map<String, Object> selectStockInRecord(Integer supplierID, Date startDate, Date endDate, int offset, int limit) throws StockRecordManageServiceException {
        Map<String, Object> result = new HashMap<>();
        List<StockInDO> stockInRecords;
        long stockInTotal = 0;
        boolean isPagination = true;

        // 检查是否需要分页查询
        if (offset < 0 || limit < 0)
            isPagination = false;

        // 查询记录
        try {
            if (isPagination) {
                PageHelper.offsetPage(offset, limit);
                stockInRecords = stockinMapper.selectBySupplierIDAndDate(supplierID, startDate, endDate);
                if (stockInRecords != null)
                    stockInTotal = new PageInfo<>(stockInRecords).getTotal();
                else
                    stockInRecords = new ArrayList<>(10);
            } else {
                stockInRecords = stockinMapper.selectBySupplierIDAndDate(supplierID, startDate, endDate);
                if (stockInRecords != null)
                    stockInTotal = stockInRecords.size();
                else
                    stockInRecords = new ArrayList<>(10);
            }
        } catch (PersistenceException e) {
            throw new StockRecordManageServiceException(e);
        }

        result.put("data", stockInRecords);
        result.put("total", stockInTotal);
        return result;
    }

    /**
     * 查询出租记录
     *
     * @param customerID   客户ID
     * @param startDate    出租记录起始日期
     * @param endDate      出租记录结束日期
     * @param offset       分页偏移值
     * @param limit        分页大小
     * @return 返回所有符合要求的出租记录
     */
    private Map<String, Object> selectStockOutRecord(Integer customerID, Date startDate, Date endDate, int offset, int limit) throws StockRecordManageServiceException {
        Map<String, Object> result = new HashMap<>();
        List<StockOutDO> stockOutRecords;
        long stockOutRecordTotal = 0;
        boolean isPagination = true;

        // 检查是否需要分页
        if (offset < 0 || limit < 0)
            isPagination = false;

        // 查询记录
        try {
            if (isPagination) {
                PageHelper.offsetPage(offset, limit);
                stockOutRecords = stockOutMapper.selectBycustomerIDAndDate(customerID, startDate, endDate);
                if (stockOutRecords != null)
                    stockOutRecordTotal = new PageInfo<>(stockOutRecords).getTotal();
                else
                    stockOutRecords = new ArrayList<>(10);
            } else {
                stockOutRecords = stockOutMapper.selectBycustomerIDAndDate(customerID, startDate, endDate);
                if (stockOutRecords != null)
                    stockOutRecordTotal = stockOutRecords.size();
                else
                    stockOutRecords = new ArrayList<>(10);
            }
        } catch (PersistenceException e) {
            System.out.println("______________________________________"+e.getMessage());
            throw new StockRecordManageServiceException(e);
        }

        result.put("data", stockOutRecords);
        result.put("total", stockOutRecordTotal);
        return result;
    }

    private DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd-hh-mm");

    /**
     * 将 StockInDO 转换为 StockRecordDTO
     *
     * @param stockInDO StockInDO 对象
     * @return 返回 StockRecordDTO 对象
     */
    private StockRecordDTO stockInRecordConvertToStockRecordDTO(StockInDO stockInDO) {
        StockRecordDTO stockRecordDTO = new StockRecordDTO();
        stockRecordDTO.setRecordID(stockInDO.getId());
        stockRecordDTO.setSupplierOrCustomerName(stockInDO.getSupplierName());
        stockRecordDTO.setGoodsName(stockInDO.getGoodName());
        stockRecordDTO.setNumber(stockInDO.getNumber());
        stockRecordDTO.setTime(dateFormat.format(stockInDO.getTime()));
        stockRecordDTO.setPrice(stockInDO.getPrice());
        stockRecordDTO.setPersonInCharge(stockInDO.getPersonInCharge());
        stockRecordDTO.setType("租入");
        return stockRecordDTO;
    }

    /**
     * 将 StockOutDO 转换为 StockRecordDTO 对象
     *
     * @param stockOutDO StockOutDO 对象
     * @return 返回 StockRecordDTO 对象
     */
    private StockRecordDTO stockOutDoConvertToStockRecordDTO(StockOutDO stockOutDO) {
        StockRecordDTO stockRecordDTO = new StockRecordDTO();
        stockRecordDTO.setRecordID(stockOutDO.getId());
        stockRecordDTO.setSupplierOrCustomerName(stockOutDO.getCustomerName());
        stockRecordDTO.setGoodsName(stockOutDO.getCustomerName());
        stockRecordDTO.setNumber(stockOutDO.getNumber());
        stockRecordDTO.setTime(dateFormat.format(stockOutDO.getTime()));
        stockRecordDTO.setPrice(stockOutDO.getPrice());
        stockRecordDTO.setPersonInCharge(stockOutDO.getPersonInCharge());
        stockRecordDTO.setType("出租");
        return stockRecordDTO;
    }


    /**
     * 检查材料ID对应的记录是否存在
     *
     * @param goodsID 材料ID
     * @return 若存在则返回true，否则返回false
     */
    private boolean goodsValidate(Integer goodsID) throws StockRecordManageServiceException {
        try {
            Goods goods = goodsMapper.selectById(goodsID);
            return goods != null;
        } catch (PersistenceException e) {
            throw new StockRecordManageServiceException(e);
        }
    }

    /**
     * 检查仓库ID对应的记录是否存在
     *
     * @param repositoryID 仓库ID
     * @return 若存在则返回true，否则返回false
     */
    private boolean repositoryValidate(Integer repositoryID) throws StockRecordManageServiceException {
        try {
            Supplier supplier = supplierMapper.selectById(repositoryID);
            return supplier != null;
        } catch (PersistenceException e) {
            throw new StockRecordManageServiceException(e);
        }
    }

    /**
     * 检查供应商ID对应的记录是否存在
     *
     * @param supplierID 供应商ID
     * @return 若存在则返回true，否则返回false
     */
    private boolean supplierValidate(Integer supplierID) throws StockRecordManageServiceException {
        try {
            Supplier supplier = supplierMapper.selectById(supplierID);
            return supplier != null;
        } catch (PersistenceException e) {
            throw new StockRecordManageServiceException(e);
        }
    }

    /**
     * 检查客户ID对应的记录是否存在
     *
     * @param cumtomerID 客户ID
     * @return 若存在则返回true，否则返回false
     */
    private boolean customerValidate(Integer cumtomerID) throws StockRecordManageServiceException {
        try {
            Customer customer = customerMapper.selectById(cumtomerID);
            return customer != null;
        } catch (PersistenceException e) {
            throw new StockRecordManageServiceException(e);
        }
    }

}
