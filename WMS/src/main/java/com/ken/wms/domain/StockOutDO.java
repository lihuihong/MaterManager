package com.ken.wms.domain;


import java.util.Date;

/**
 * 出租记录
 *
 * @author Ken
 */
public class StockOutDO {

    /**
     * 出租记录ID
     */
    private Integer id;

    /**
     * 客户ID
     */
    private Integer customerID;

    /**
     * 客户名称
     */
    private String customerName;

    /**
     * 商品ID
     */
    private Integer goodID;

    /**
     * 商品名称
     */
    private String goodName;

    /**
     * 出租价格
     */
    private double price;

    /**
     * 商品出租数量
     */
    private long number;

    /**
     * 出租日期
     */
    private Date time;

    /**
     * 出租经手人
     */
    private String personInCharge;// 经手人


    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getCustomerID() {
        return customerID;
    }

    public void setCustomerID(Integer customerID) {
        this.customerID = customerID;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public Integer getGoodID() {
        return goodID;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public void setGoodID(Integer goodID) {
        this.goodID = goodID;
    }

    public String getGoodName() {
        return goodName;
    }

    public void setGoodName(String goodName) {
        this.goodName = goodName;
    }

    public long getNumber() {
        return number;
    }

    public void setNumber(long number) {
        this.number = number;
    }

    public Date getTime() {
        return time;
    }

    public void setTime(Date time) {
        this.time = time;
    }

    public String getPersonInCharge() {
        return personInCharge;
    }

    public void setPersonInCharge(String personInCharge) {
        this.personInCharge = personInCharge;
    }

    @Override
    public String toString() {
        return "StockOutDO [id=" + id + ", customerID=" + customerID + ", customerName=" + customerName + ", goodID="
                + goodID + ", goodName=" + goodName + ", number=" + number
                + ", time=" + time + ", personInCharge=" + personInCharge + "]";
    }

}
