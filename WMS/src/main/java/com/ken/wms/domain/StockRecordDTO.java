package com.ken.wms.domain;

/**
 * 出租/租入记录DO
 *
 * @author Ken
 * @since 2018/12/30.
 */
public class StockRecordDTO {

    /**
     * 记录ID
     */
    private Integer recordID;

    /**
     * 记录的类型（出租/租入）
     */
    private String type;

    /**
     * 供应商（租入）或客户（出租）名称
     */
    private String supplierOrCustomerName;

    /**
     * 商品名称
     */
    private String goodsName;

    /**
     * 出租或租入仓库ID
     */
    private double price;

    /**
     * 出租或租入数量
     */
    private long number;

    /**
     * 出租或租入时间
     */
    private String time;

    /**
     * 出租或租入经手人
     */
    private String personInCharge;


    public Integer getRecordID() {
        return recordID;
    }

    public String getType() {
        return type;
    }

    public String getSupplierOrCustomerName() {
        return supplierOrCustomerName;
    }

    public String getGoodsName() {
        return goodsName;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public long getNumber() {
        return number;
    }

    public String getTime() {
        return time;
    }

    public String getPersonInCharge() {
        return personInCharge;
    }

    public void setRecordID(Integer recordID) {
        this.recordID = recordID;
    }

    public void setType(String type) {
        this.type = type;
    }

    public void setSupplierOrCustomerName(String supplierOrCustomerName) {
        this.supplierOrCustomerName = supplierOrCustomerName;
    }

    public void setGoodsName(String goodsName) {
        this.goodsName = goodsName;
    }


    public void setNumber(long number) {
        this.number = number;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public void setPersonInCharge(String personInCharge) {
        this.personInCharge = personInCharge;
    }

    @Override
    public String toString() {
        return "StockRecordDTO{" +
                "recordID=" + recordID +
                ", type='" + type + '\'' +
                ", supplierOrCustomerName='" + supplierOrCustomerName + '\'' +
                ", goodsName='" + goodsName + '\'' +
                ", number=" + number +
                ", time=" + time +
                ", personInCharge='" + personInCharge + '\'' +
                '}';
    }
}
