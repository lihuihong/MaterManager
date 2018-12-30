<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
	var stockin_supplier = null;// 入库供应商编号
	var stockin_goods = null;// 入库货物编号
	var stockin_number = null;// 入库数量

	var supplierCache = new Array();// 供应商信息缓存
	var customerCache = new Array();//货物信息缓存

	var goodsMap = {};


	var price;

	$(function(){
        supplierSelectorInit();
        GoodsSelectorInit();
        customerSelectorInit();

		dataValidateInit();
		detilInfoToggle();
		stockInOption();
		fetchStorage();

        opthinPrice();
	})


	function opthinPrice() {
		$('#stockin_input').blur(function () {
			$('#price').val(price * $('#stockin_input').val());
        })
    }

	// 数据校验
	function dataValidateInit(){
		$('#stockin_form').bootstrapValidator({
			message : 'This is not valid',
			
			fields : {
				stockin_input : {
					validators : {
						notEmpty : {
							message : '租入数量不能为空'
						},
						greaterThan: {
	                        value: 0,
	                        message: '租入数量不能小于0'
	                    }
					}
				}
			}
		})
	}


    // 供应商下拉列表初始化
    function supplierSelectorInit(){
        $.ajax({
            type : 'GET',
            url : 'supplierManage/getSupplierList',
            dataType : 'json',
            contentType : 'application/json',
            data : {
                searchType : 'searchAll',
                keyWord : '',
                offset : -1,
                limit : -1
            },
            success : function(response){
                $.each(response.rows,function(index,elem){
                    supplierCache.push(elem);
                    $('#supplier_selector').append("<option value='" + elem.id + "'>" + elem.name + "</option>");
                });
                supplierInfoSet(supplierCache[0].id);
            },
            error : function(response){
                $('#supplier_selector').append("<option value='-1'>加载失败</option>");
            }



        });
        //选中后获取价格
        $('#supplier_selector').change(function () {
            supplierInfoSet(this.value);
        });
    }

    // 材料下拉列表初始化
    function GoodsSelectorInit(){
        $.ajax({
            type : 'GET',
            url : 'goodsManage/getGoodsList',
            dataType : 'json',
            contentType : 'application/json',
            data : {
                searchType : 'searchAll',
                keyWord : '',
                offset : -1,
                limit : -1
            },
            success : function(response){
                $.each(response.rows,function(index,elem){
                    if(index==0)
                        price = elem.value;
                    $('#goods_selector').append("<option value='" + elem.id + "'>" + elem.name + "</option>");
                    goodsMap[elem.id] = elem.value;
                });
            },
            error : function(response){
                $('#goods_selector').append("<option value='-1'>加载失败</option>");
            }

        })

		//选中后获取价格
    	$('#goods_selector').change(function () {
            price = goodsMap[this.value];
        });
    }

    // 客户下拉列表初始化
    function customerSelectorInit(){
        $.ajax({
            type : 'GET',
            url : 'customerManage/getCustomerList',
            dataType : 'json',
            contentType : 'application/json',
            data : {
                searchType : 'searchAll',
                keyWord : '',
                offset : -1,
                limit : -1
            },
            success : function(response){
                $.each(response.rows,function(index,elem){
                    customerCache.push(elem);
                    $('#customer_selector').append("<option value='" + elem.id + "'>" + elem.name + "</option>");
                });
                customerInfoSet(customerCache[0].id);
            },
            error : function(response){
                $('#customer_selector').append("<option value='-1'>加载失败</option>");
            }
        })

        //选中后获取价格
        $('#customer_selector').change(function () {
            customerInfoSet(this.value);
        });
    }

    function customerInfoSet(customerID){
        var detailInfo;
        $.each(customerCache,function(index,elem){
            if(elem.id == customerID){
                detailInfo = elem;

                if(detailInfo.id == null)
                    $('#info_customer_ID').text('-');
                else
                    $('#info_customer_ID').text(detailInfo.id);

                if(detailInfo.name == null)
                    $('#info_customer_name').text('-');
                else
                    $('#info_customer_name').text(detailInfo.name);

                if(detailInfo.tel == null)
                    $('#info_customer_tel').text('-');
                else
                    $('#info_customer_tel').text(detailInfo.tel);

                if(detailInfo.address == null)
                    $('#info_customer_address').text('-');
                else
                    $('#info_customer_address').text(detailInfo.address);

                if(detailInfo.email == null)
                    $('#info_customer_email').text('-');
                else
                    $('#info_customer_email').text(detailInfo.email);

                if(detailInfo.personInCharge == null)
                    $('#info_customer_person').text('-');
                else
                    $('#info_customer_person').text(detailInfo.personInCharge);

            }
        })
    }


	// 填充供应商详细信息
	function supplierInfoSet(supplierID){
		var detailInfo;
		$.each(supplierCache,function(index,elem){
			if(elem.id == supplierID){
				detailInfo = elem;

				if(detailInfo.id==null)
					$('#info_supplier_ID').text('-');
				else
					$('#info_supplier_ID').text(detailInfo.id);
				
				if(detailInfo.name==null)
					$('#info_supplier_name').text('-');
				else
					$('#info_supplier_name').text(detailInfo.name);
				
				if(detailInfo.tel==null)
					$('#info_supplier_tel').text('-');
				else
					$('#info_supplier_tel').text(detailInfo.tel);
				
				if(detailInfo.personInCharge==null)
					$('#info_supplier_person').text('-');
				else
					$('#info_supplier_person').text(detailInfo.personInCharge);
				
				if(detailInfo.email==null)
					$('#info_supplier_email').text('-');
				else
					$('#info_supplier_email').text(detailInfo.email);
				
				
				if(detailInfo.adress==null)
					$('#info_supplier_address').text('-');
				else
					$('#info_supplier_address').text(detailInfo.address);
			}
		})

	}

	// 填充货物详细信息
	function goodsInfoSet(goodsID){
		var detailInfo;
		$.each(goodsCache,function(index,elem){
			if(elem.id == goodsID){
				detailInfo = elem;
				if(detailInfo.id==null)
					$('#info_goods_ID').text('-');
				else
					$('#info_goods_ID').text(detailInfo.id);
				
				if(detailInfo.name==null)
					$('#info_goods_name').text('-');
				else
					$('#info_goods_name').text(detailInfo.name);
				
				if(detailInfo.type==null)
					$('#info_goods_type').text('-');
				else
					$('#info_goods_type').text(detailInfo.type);
				
				if(detailInfo.size==null)
					$('#info_goods_size').text('-');
				else
					$('#info_goods_size').text(detailInfo.size);
				
				if(detailInfo.value==null)
					$('#info_goods_value').text('-');
				else
					$('#info_goods_value').text(detailInfo.value);
			}
		})
	}

	// 详细信息显示与隐藏
	function detilInfoToggle(){
		$('#info-show').click(function(){
			$('#detailInfo').removeClass('hide');
			$(this).addClass('hide');
			$('#info-hidden').removeClass('hide');
		});

		$('#info-hidden').click(function(){
			$('#detailInfo').removeClass('hide').addClass('hide');
			$(this).addClass('hide');
			$('#info-show').removeClass('hide');
		});
	}



	// 获取当前库存量
	function fetchStorage(){
		$('#repository_selector').change(function(){
			stockin_repository = $(this).val();
			loadStorageInfo();
		});
	}

	function loadStorageInfo(){
		if(stockin_repository != null && stockin_goods != null){
			$.ajax({
				type : 'GET',
				url : 'storageManage/getStorageListWithRepository',
				dataType : 'json',
				contentType : 'application/json',
				data : {
					offset : -1,
					limit : -1,
					searchType : 'searchByGoodsID',
					repositoryBelong : stockin_repository,
					keyword : stockin_goods
				},
				success : function(response){
					if(response.total > 0){
						data = response.rows[0].number;
						$('#info_storage').text(data);
					}else{
						$('#info_storage').text('0');
					}
				},
				error : function(response){
					// do nothing
				}
			})
		}
	}

	// 执行货物出租操作
	function stockInOption(){
		$('#submit').click(function(){
			// data validate
			$('#stockin_form').data('bootstrapValidator').validate();
			if (!$('#stockin_form').data('bootstrapValidator').isValid()) {
				return;
			}

			data = {
				supplierID :  $('#supplier_selector').val(),
                customerID :  $('#customer_selector').val(),
				goodsID : $('#goods_selector').val(),
				number : $('#stockin_input').val(),
				price : $('#price').val()
			}

			$.ajax({
				type : 'POST',
				url : 'stockRecordManage/stockInOut',
				dataType : 'json',
				content : 'application/json',
				data : data,
				success : function(response){
					var msg;
					var type;
					var append = '';
					if(response.result == "success"){
						type = 'success';
						msg = '货物入库成功';
						inputReset();
					}else{
						type = 'error';
						msg = '货物入库失败'
					}
					showMsg(type, msg, append);
				},
				error : function(xhr, textStatus, errorThrown){
					// handler error
					handleAjaxError(xhr.status);
				}
			})
		});
	}

	// 页面重置
	function inputReset(){
		$('#supplier_input').val('');
		$('#goods_input').val('');
		$('#stockin_input').val('');
		$('#info_supplier_ID').text('-');
		$('#info_supplier_name').text('-');
		$('#info_supplier_tel').text('-');
		$('#info_supplier_address').text('-');
		$('#info_supplier_email').text('-');
		$('#info_supplier_person').text('-');
		$('#info_goods_ID').text('-');
		$('#info_goods_name').text('-');
		$('#info_goods_size').text('-');
		$('#info_goods_type').text('-');
		$('#info_goods_value').text('-');
		$('#info_storage').text('-');
		$('#stockin_form').bootstrapValidator("resetForm",true); 
	}

</script>


<div class="panel panel-default">
	<ol class="breadcrumb">
		<li>材料出租管理</li>
	</ol>
	<div class="panel-body">
		<div class="row">
			<div class="col-md-6 col-sm-6">
				<div class="row">
					<div class="col-md-1 col-sm-1"></div>
					<div class="col-md-10 col-sm-11">
						<form action="" class="form-inline">
							<div class="form-group">
								<label for="" class="form-label">&nbsp;&nbsp;&nbsp;供应商：</label>
								<select name="" id="supplier_selector" class="form-control">
								</select>
							</div>
						</form>
					</div>
				</div>
			</div>
			<div class="col-md-6 col-sm-6">
				<div class="row">
					<div class="col-md-1 col-sm-1"></div>
					<div class="col-md-10 col-sm-11">
						<form action="" class="form-inline">
							<div class="form-group">
								<label for="" class="form-label">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;客户：</label>
								<select name="" id="customer_selector" class="form-control">
								</select>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
		<div class="row visible-md visible-lg">
			<div class="col-md-12 col-sm-12">
				<div class='pull-right' style="cursor:pointer" id="info-show">
					<span>显示详细信息</span>
					<span class="glyphicon glyphicon-chevron-down"></span>
				</div>
				<div class='pull-right hide' style="cursor:pointer" id="info-hidden">
					<span>隐藏详细信息</span>
					<span class="glyphicon glyphicon-chevron-up"></span>
				</div>
			</div>
		</div>
		<div class="row hide" id="detailInfo" style="margin-bottom:30px">
			<div class="col-md-6 col-sm-6  visible-md visible-lg">
				<div class="row">
					<div class="col-md-1 col-sm-1"></div>
					<div class="col-md-10 col-sm-10">
						<label for="" class="text-info">供应商信息</label>
					</div>
				</div>

				<div class="row">
					<div class="col-md-1 col-sm-1"></div>
					<div class="col-md-11 col-sm-11">
						<div class="col-md-12 col-sm-12">
							<div style="margin-top:5px">
								<div class="col-md-6 col-sm-6">
									<span for="" class="pull-right">供应商ID：</span>
								</div>
								<div class="col-md-6 col-sm-6">
									<span id="info_supplier_ID">-</span>
								</div>
							</div>
							<div style="margin-top:5px">
								<div class="col-md-6 col-sm-6">
									<span for="" class="pull-right">负责人：</span>
								</div>
								<div class="col-md-6 col-sm-6">
									<span id="info_supplier_person">-</span>
								</div>
							</div>
							<div style="margin-top:5px">
								<div class="col-md-6 col-sm-6">
									<span for="" class="pull-right">电子邮件：</span>
								</div>
								<div class="col-md-6">
									<span id="info_supplier_email">-</span>
								</div>
							</div>
						</div>
						<div class="col-md-12 col-sm-12  visible-md visible-lg">
							<div style="margin-top:5px">
								<div class="col-md-6 col-sm-6">
									<span for="" class="pull-right">供应商名：</span>
								</div>
								<div class="col-md-6 col-sm-6">
									<span id="info_supplier_name">-</span>
								</div>
							</div>
							<div style="margin-top:5px">
								<div class="col-md-6 col-sm-6">
									<span for="" class="pull-right">联系电话：</span>
								</div>
								<div class="col-md-6 col-sm-6">
									<span id="info_supplier_tel">-</span>
								</div>
							</div>
							<div style="margin-top:5px">
								<div class="col-md-6 col-sm-6">
									<span for="" class="pull-right">联系地址：</span>
								</div>
								<div class="col-md-6 col-sm-6">
									<span id="info_supplier_address">-</span>
								</div>
							</div>

						</div>
					</div>
				</div>
			</div>
			<div class="col-md-6 col-sm-6">
				<div class="row">
					<div class="col-md-1 col-sm-1"></div>
					<div class="col-md-11 col-sm-11">
						<label for="" class="text-info">客户信息</label>
					</div>
				</div>
				<div class="row">
					<div class="col-md-1 col-sm-1"></div>
					<div class="col-md-11">
						<div class="col-md-12">
							<div style="margin-top:5px">
								<div class="col-md-6">
									<span for="" class="pull-right">客户ID：</span>
								</div>
								<div class="col-md-6">
									<span id="info_customer_ID">-</span>
								</div>
							</div>
							<div style="margin-top:5px">
								<div class="col-md-6">
									<span for="" class="pull-right">负责人：</span>
								</div>
								<div class="col-md-6">
									<span id="info_customer_person">-</span>
								</div>
							</div>
							<div style="margin-top:5px">
								<div class="col-md-6">
									<span for="" class="pull-right">电子邮件：</span>
								</div>
								<div class="col-md-6">
									<span id="info_customer_email">-</span>
								</div>
							</div>
						</div>
						<div class="col-md-12">
							<div style="margin-top:5px">
								<div class="col-md-6">
									<span for="" class="pull-right">客户名：</span>
								</div>
								<div class="col-md-6">
									<span id="info_customer_name">-</span>
								</div>
							</div>
							<div style="margin-top:5px">
								<div class="col-md-6">
									<span for="" class="pull-right">联系电话：</span>
								</div>
								<div class="col-md-6">
									<span id="info_customer_tel">-</span>
								</div>
							</div>
							<div style="margin-top:5px">
								<div class="col-md-6">
									<span for="" class="pull-right">联系地址：</span>
								</div>
								<div class="col-md-6">
									<span id="info_customer_address">-</span>
								</div>
							</div>

						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="row" style="margin-top:20px">
			<div class="col-md-6 col-sm-6">
				<div class="row">
					<div class="col-md-1 col-sm-1"></div>
					<div class="col-md-10 col-sm-11">
						<form action="" class="form-inline">
							<div class="form-group">
								<label for="" class="form-label">租入材料：</label>
								<select name="" id="goods_selector" class="form-control">
								</select>
							</div>
						</form>
					</div>
				</div>
			</div>
			<div class="col-md-6 col-sm-6">
				<div class="row">
					<div class="col-md-1 col-sm-1"></div>
					<div class="col-md-10 col-sm-11">
						<form action="" class="form-inline" id="stockin_form">
							<div class="form-group">
								<label for="" class="form-label">租入数量：</label>
								<input type="text" class="form-control" placeholder="请输入数量" id="stockin_input" name="stockin_input">
								<span> ( 当前库存量：</span>
								<span id="info_storage">-</span>
								<span> )</span>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
		<div class="row" style="margin-top:20px">
			<div class="col-md-8 col-sm-8">
				<div class="row">
					<div class="col-md-1 col-sm-1"></div>
					<div class="col-md-10 col-sm-11">
						<form action="" class="form-inline" id="">
							<div class="form-group">
								<label for="" class="form-label">总共价值：</label>
								<input type="text" class="form-control"   readonly id="price" name="stockin_input">

							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
		<div class="row" style="margin-top:80px"></div>
	</div>
	<div class="panel-footer">
		<div style="text-align:right">
			<button class="btn btn-success" id="submit">提交出租</button>
		</div>
	</div>
</div>