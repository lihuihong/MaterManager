<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<script>
	var search_type_supplier = "searchAll";
	var search_keyWord = "所有";
	var selectID;

	$(function() {
		optionAction();
		searchAction();
		supplierListInit();
		bootstrapValidatorInit();

		exportSupplierAction()
	})

	// 下拉框选择
	function optionAction() {
		$(".dropOption").click(function() {
			var type = $(this).text();
			$("#search_input").val("");
			if (type == "所有") {
				$("#search_input").attr("readOnly", "true");
				search_type_supplier = "searchAll";
			} else if (type == "公司名称") {
				$("#search_input").removeAttr("readOnly");
				search_type_supplier = "searchByName";
			} else {
				$("#search_input").removeAttr("readOnly");
			}

			$("#search_type").text(type);
			$("#search_input").attr("placeholder", type);
		})
	}

	// 搜索动作
	function searchAction() {
		$('#search_button').click(function() {
			search_keyWord = $('#search_input').val();
			tableRefresh();
		})
	}

	// 分页查询参数
	function queryParams(params) {
		var temp = {
			limit : params.limit,
			offset : params.offset,
			searchType : search_type_supplier,
			keyWord : search_keyWord
		}
		return temp;
	}

	// 表格初始化
	function supplierListInit() {
		$('#supplierList')
				.bootstrapTable(
						{
							columns : [
									{
										field : 'name',
										title : '供应商名称'
									},
									{
										field : 'personInCharge',
										title : '负责人'
									},
									{
										field : 'tel',
										title : '联系电话'
									},
									{
										field : 'address',
										title : '地址',
									},
									{
										field : 'email',
										title : '电子邮件',
									},
									],
							url : 'supplierManage/getSupplierList',
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
		$('#supplierList').bootstrapTable('refresh', {
			query : {}
		});
	}

	// 行编辑操作
	function rowEditOperation(row) {
		$('#edit_modal').modal("show");

		// load info
		$('#supplier_form_edit').bootstrapValidator("resetForm", true);
		$('#supplier_name_edit').val(row.name);
		$('#supplier_person_edit').val(row.personInCharge);
		$('#supplier_tel_edit').val(row.tel);
		$('#supplier_email_edit').val(row.email);
		$('#supplier_address_edit').val(row.address);
	}

	// 添加供应商模态框数据校验
	function bootstrapValidatorInit() {
		$("#supplier_form,#supplier_form_edit").bootstrapValidator({
			message : 'This is not valid',
			feedbackIcons : {
				valid : 'glyphicon glyphicon-ok',
				invalid : 'glyphicon glyphicon-remove',
				validating : 'glyphicon glyphicon-refresh'
			},
			excluded : [ ':disabled' ],
			fields : {
				supplier_name : {
					validators : {
						notEmpty : {
							message : '供应商名称不能为空'
						}
					}
				},
				supplier_tel : {
					validators : {
						notEmpty : {
							message : '供应商电话不能为空'
						}
					}
				},
				supplier_email : {
					validators : {
						notEmpty : {
							message : '供应商E-mail不能为空'
						},
						regexp : {
							regexp : '^[^@\\s]+@([^@\\s]+\\.)+[^@\\s]+$',
							message : 'E-mail的格式不正确'
						}
					}
				},
				supplier_address : {
					validators : {
						notEmpty : {
							message : '供应商地址不能为空'
						}
					}
				},
				supplier_person : {
					validators : {
						notEmpty : {
							message : '供应商负责人不能为空'
						}
					}
				}
			}
		})
	}

	// 导出供应商信息
	function exportSupplierAction() {
		$('#export_supplier').click(function() {
			$('#export_modal').modal("show");
		})

		$('#export_supplier_download').click(function(){
			var data = {
				searchType : search_type_supplier,
				keyWord : search_keyWord
			}
			var url = "supplierManage/exportSupplier?" + $.param(data)
			window.open(url, '_blank');
			$('#export_modal').modal("hide");
		})
	}

</script>
<div class="panel panel-default">
	<ol class="breadcrumb">
		<li>供应商信息管理</li>
	</ol>
	<div class="panel-body">
		<div class="row">
			<div class="col-md-1 col-sm-2">
				<div class="btn-group">
					<button class="btn btn-default dropdown-toggle"
						data-toggle="dropdown">
						<span id="search_type">所有</span> <span class="caret"></span>
					</button>
					<ul class="dropdown-menu" role="menu">
						<li><a href="javascript:void(0)" class="dropOption">公司名称</a></li>
						<li><a href="javascript:void(0)" class="dropOption">所有</a></li>
					</ul>
				</div>
			</div>
			<div class="col-md-9 col-sm-9">
				<div>
					<div class="col-md-3 col-sm-4">
						<input id="search_input" type="text" class="form-control" value="所有"
							placeholder="所有" readonly>
					</div>
					<div class="col-md-2 col-sm-3">
						<button id="search_button" class="btn btn-success">
							<span class="glyphicon glyphicon-search"></span> <span>查询</span>
						</button>
					</div>
				</div>
			</div>
		</div>


		<div class="row" style="margin-top: 15px">
			<div class="col-md-12">
				<table id="supplierList" class="table table-striped"></table>
			</div>
		</div>
	</div>
</div>



<!-- 导出供应商信息模态框 -->
<div class="modal fade" id="export_modal" table-index="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true"
	data-backdrop="static">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button class="close" type="button" data-dismiss="modal"
					aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">导出供应商信息</h4>
			</div>
			<div class="modal-body">
				<div class="row">
					<div class="col-md-3 col-sm-3" style="text-align: center;">
						<img src="media/icons/warning-icon.png" alt=""
							style="width: 70px; height: 70px; margin-top: 20px;">
					</div>
					<div class="col-md-8 col-sm-8">
						<h3>是否确认导出供应商信息</h3>
						<p>(注意：请确定要导出的供应商信息，导出的内容为当前列表的搜索结果)</p>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button class="btn btn-default" type="button" data-dismiss="modal">
					<span>取消</span>
				</button>
				<button class="btn btn-success" type="button" id="export_supplier_download">
					<span>确认下载</span>
				</button>
			</div>
		</div>
	</div>
</div>