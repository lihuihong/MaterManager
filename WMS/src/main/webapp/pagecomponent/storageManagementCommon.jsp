<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>

<script>
    var search_type_storage = "searchAll";
    var search_keyWord = "所有";
    var select_goodsID;
    var select_repositoryID;

    $(function() {
        optionAction();
        searchAction();
        storageListInit();
        //bootstrapValidatorInit();

        supplierSelectorInit();

        importStorageAction();
        exportStorageAction()
    })

    // 下拉框選擇動作
    function optionAction() {
        $(".dropOption").click(function() {
            var type = $(this).text();
            $("#search_input").val("");
            if (type == "所有") {
                $("#search_input_type").attr("readOnly", "true");
                search_type_storage = "searchAll";
            } else if (type == "材料名称") {
                $("#search_input_type").removeAttr("readOnly");
                search_type_storage = "searchByGoodsName";
            } else if(type = "材料类型"){
                $("#search_input_type").removeAttr("readOnly");
                search_type_storage = "searchByGoodsType";
            } else {
                $("#search_input_type").removeAttr("readOnly");
            }

            $("#search_type").text(type);
            $("#search_input_type").attr("placeholder", type);
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
                    $('#supplier_selector').append("<option value='" + elem.id + "'>" + elem.name + "</option>");
                });
            },
            error : function(response){
                $('#supplier_selector').append("<option value='-1'>加载失败</option>");
            }


        })
    }


    // 搜索动作
    function searchAction() {
        $('#search_button').click(function() {
            search_keyWord = $('#search_input_type').val();
            tableRefresh();
        })
    }

    // 分页查询参数
    function queryParams(params) {
        var temp = {
            limit : params.limit,
            offset : params.offset,
            searchType : search_type_storage,
            keyword : search_keyWord
        }
        return temp;
    }

    // 表格初始化
    function storageListInit() {
        $('#storageList')
            .bootstrapTable(
                {
                    columns : [
                        {
                            field : 'goodsName',
                            title : '材料名称'
                        },
                        {
                            field : 'goodsType',
                            title : '材料类型'
                        },
                        {
                            field : 'goodsSize',
                            title : '材料尺寸',
                            visible : false
                        },
                        {
                            field : 'goodsValue',
                            title : '材料价值',
                            visible : false
                        },
                        {
                            field : 'supplierName',
                            title : '所属公司'
                        },
                        {
                            field : 'number',
                            title : '库存数量'
                        }],
                    url : '/storageManage/getStorageList',
                    onLoadError:function(status){
                        handleAjaxError(status);
                    },
                    method : 'GET',
                    queryParams : queryParams,
                    sidePagination : "server",
                    dataType : 'json',
                    pagination : true,
                    pageNumber : 1,
                    pageSize : 5,
                    pageList : [ 5, 10, 25, 50, 100 ],
                    clickToSelect : true
                });
    }

    // 表格刷新
    function tableRefresh() {
        $('#storageList').bootstrapTable('refresh', {
            query : {}
        });
    }

    // 行编辑操作
    function rowEditOperation(row) {
        $('#edit_modal').modal("show");

        // load info
        $('#storage_form_edit').bootstrapValidator("resetForm", true);
        $('#storage_goodsID_edit').text(row.goodsName);
        $('#storage_goodsID_e').val(row.goodsID);
        $('#storage_repositoryID_e').val(row.supplierID);
        $('#storage_repositoryID_edit').text(row.supplierName);
        $('#storage_number_edit').val(row.number);
    }

    // 添加供应商模态框数据校验
    function bootstrapValidatorInit() {
        $("#storage_form").bootstrapValidator({
            message : 'This is not valid',
            feedbackIcons : {
                valid : 'glyphicon glyphicon-ok',
                invalid : 'glyphicon glyphicon-remove',
                validating : 'glyphicon glyphicon-refresh'
            },
            excluded : [ ':disabled' ],
            fields : {
                storage_number : {
                    validators : {
                        notEmpty : {
                            message : '库存数量不能为空'
                        }
                    }
                }
            }
        })
    }


</script>
<div class="panel panel-default">
	<ol class="breadcrumb">
		<li>库存信息管理</li>
	</ol>
	<div class="panel-body">
		<div class="row">
			<div class="col-md-1  col-sm-2">
				<div class="btn-group">
					<button class="btn btn-default dropdown-toggle"
							data-toggle="dropdown">
						<span id="search_type">所有</span> <span class="caret"></span>
					</button>
					<ul class="dropdown-menu" role="menu">
						<li><a href="javascript:void(0)" class="dropOption">材料名称</a></li>
						<li><a href="javascript:void(0)" class="dropOption">材料类型</a></li>
						<li><a href="javascript:void(0)" class="dropOption">所有</a></li>
					</ul>
				</div>
			</div>
			<div class="col-md-9 col-sm-9">
				<div>
					<div class="col-md-3 col-sm-3">
						<input id="search_input_type" type="text" class="form-control"
							   placeholder="所有" readonly value="所有">
					</div>
					<div class="col-md-2 col-sm-2">
						<button id="search_button" class="btn btn-success">
							<span class="glyphicon glyphicon-search"></span> <span>查询</span>
						</button>
					</div>
				</div>
			</div>
		</div>


		<div class="row" style="margin-top: 15px">
			<div class="col-md-12">
				<table id="storageList" class="table table-striped"></table>
			</div>
		</div>
	</div>
</div>


<!-- 导出库存信息模态框 -->
<div class="modal fade" id="export_modal" table-index="-1" role="dialog"
	 aria-labelledby="myModalLabel" aria-hidden="true"
	 data-backdrop="static">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button class="close" type="button" data-dismiss="modal"
						aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">导出库存信息</h4>
			</div>
			<div class="modal-body">
				<div class="row">
					<div class="col-md-3 col-sm-3" style="text-align: center;">
						<img src="media/icons/warning-icon.png" alt=""
							 style="width: 70px; height: 70px; margin-top: 20px;">
					</div>
					<div class="col-md-8 col-sm-8">
						<h3>是否确认导出库存信息</h3>
						<p>(注意：请确定要导出的库存信息，导出的内容为当前列表的搜索结果)</p>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button class="btn btn-default" type="button" data-dismiss="modal">
					<span>取消</span>
				</button>
				<button class="btn btn-success" type="button" id="export_storage_download">
					<span>确认下载</span>
				</button>
			</div>
		</div>
	</div>
</div>

<!-- 删除提示模态框 -->
<div class="modal fade" id="deleteWarning_modal" table-index="-1"
	 role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button class="close" type="button" data-dismiss="modal"
						aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">警告</h4>
			</div>
			<div class="modal-body">
				<div class="row">
					<div class="col-md-3 col-sm-3" style="text-align: center;">
						<img src="media/icons/warning-icon.png" alt=""
							 style="width: 70px; height: 70px; margin-top: 20px;">
					</div>
					<div class="col-md-8 col-sm-8">
						<h3>是否确认删除该条库存信息</h3>
						<p>(注意：一旦删除该条库存信息，将不能恢复)</p>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button class="btn btn-default" type="button" data-dismiss="modal">
					<span>取消</span>
				</button>
				<button class="btn btn-danger" type="button" id="delete_confirm">
					<span>确认删除</span>
				</button>
			</div>
		</div>
	</div>
</div>
