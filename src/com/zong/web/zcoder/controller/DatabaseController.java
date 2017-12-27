package com.zong.web.zcoder.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.zong.util.BeetlUtil;
import com.zong.util.CreateCodeUtil;
import com.zong.util.FileUploadDownload;
import com.zong.util.FileUtils;
import com.zong.zdb.bean.ColumnField;
import com.zong.zdb.bean.Table;
import com.zong.zdb.service.JdbcCodeService;
import com.zong.zdb.service.TemplateRoot;
import com.zong.zdb.util.Page;
import com.zong.zdb.util.PageData;

@Controller
public class DatabaseController {

	private JdbcCodeService codeService = JdbcCodeService.getInstance();
	public final static ObjectMapper mapper = new ObjectMapper();

	@RequestMapping(value = {"/","/dbs"})
	public String dbs(Model model) {
		model.addAttribute("nav", "dbs");
		return "db_list";
	}

	@RequestMapping(value = "/{dbname}/tables")
	public String tables(@PathVariable("dbname") String dbname, Model model) {
		model.addAttribute("dbname", dbname);
		model.addAttribute("tables", codeService.showTables(dbname));
		model.addAttribute("nav", "dbs");
		return "table_list";
	}

	@RequestMapping(value = "/{dbname}/tables/{tableName}")
	public String tables(@PathVariable("dbname") String dbname, @PathVariable("tableName") String tableName,
			Model model) {
		model.addAttribute("dbname", dbname);
		model.addAttribute("tableName", tableName);
		model.addAttribute("columns", codeService.showTableColumns(dbname, tableName));
		model.addAttribute("tab", "design");
		model.addAttribute("nav", "dbs");
		return "table_view";
	}

	@RequestMapping(value = "/{dbname}/tables/{tableName}/datas")
	public String datas(@PathVariable("dbname") String dbname, @PathVariable("tableName") String tableName, Page page,
			String orderColumn, String orderType, Model model) {
		page.setTable(tableName);
		page.getPd().put("orderColumn", orderColumn).put("orderType", orderType);
		model.addAttribute("dbname", dbname);
		model.addAttribute("tableName", tableName);
		List<ColumnField> columns = codeService.showTableColumns(dbname, tableName);
		model.addAttribute("columns", columns);
		List<PageData> datas = codeService.showTableData(dbname, page);
		for (PageData pd : datas) {
			for (ColumnField columnField : columns) {
				String value = pd.getString(columnField.getColumn());
				pd.put(columnField.getColumn(),
						value == null ? "" : value.replaceAll("<", "&lt;").replaceAll(">", "&gt;"));
			}
		}
		model.addAttribute("page", page);
		model.addAttribute("datas", datas);
		model.addAttribute("tab", "data");
		model.addAttribute("nav", "dbs");
		return "table_datas";
	}
	
	@RequestMapping(value = "/{dbname}/tables/{tableName}/jsons")
	public String jsons(@PathVariable("dbname") String dbname, @PathVariable("tableName") String tableName, Page page,
			String orderColumn, String orderType, Model model) {
		page.setTable(tableName);
		page.getPd().put("orderColumn", orderColumn).put("orderType", orderType);
		model.addAttribute("dbname", dbname);
		model.addAttribute("tableName", tableName);
		List<ColumnField> columns = codeService.showTableColumns(dbname, tableName);
		model.addAttribute("columns", columns);
		List<PageData> list = codeService.showTableData(dbname, page);
		List<String> datas = new ArrayList<String>();
		try {
			for (PageData pd : list) {
				datas.add(mapper.writerWithDefaultPrettyPrinter().writeValueAsString(pd));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("page", page);
		model.addAttribute("datas", datas);
		model.addAttribute("tab", "data");
		model.addAttribute("nav", "dbs");
		return "table_jsons";
	}

	@RequestMapping(value = "/{dbname}/tables/{tableName}/sqldatas")
	public String sqldatas(@PathVariable("dbname") String dbname, @PathVariable("tableName") String tableName,
			String sql, Model model) {
		model.addAttribute("dbname", dbname);
		model.addAttribute("tableName", tableName);
		model.addAttribute("sql", sql);
		if (sql != null && !sql.equals("")) {
			List<PageData> datas = codeService.showSqlData(dbname, sql);
			model.addAttribute("datas", datas);
		}
		model.addAttribute("tab", "data");
		model.addAttribute("nav", "dbs");
		return "sql_datas";
	}

	@ResponseBody
	@RequestMapping(value = "/{dbname}/tables/{tableName}/data")
	public List<PageData> data(@PathVariable("dbname") String dbname, @PathVariable("tableName") String tableName,
			Page page, Model model) {
		page.setTable(tableName);
		return codeService.showTableData(dbname, page);
	}

	@RequestMapping(value = "/{dbname}/tables/{tableName}/code")
	public String code(@PathVariable("dbname") String dbname, @PathVariable("tableName") String tableName,
			Model model) {
		model.addAttribute("dbname", dbname);
		model.addAttribute("tableName", tableName);
		model.addAttribute("table", TemplateRoot.createTemplateRoot(codeService.showTable(dbname, tableName)));
		model.addAttribute("tab", "code");
		model.addAttribute("nav", "dbs");
		List<String> ftls = new ArrayList<String>();
		for (File f : FileUtils.listFile(FileUtils.getClassResources() + "ftl/")) {
			ftls.add(f.getName().substring(0, f.getName().lastIndexOf(".")));
		}
		model.addAttribute("templates", ftls);
		return "table_code";
	}

	/**
	 * 根据beetl模板生成当前表的文件字符串返回
	 *
	 */
	@ResponseBody
	@RequestMapping(value = "/{dbname}/tables/{tableName}/beetlCode", method = RequestMethod.POST, produces = "text/plain;charset=utf-8")
	public String beetlCode(@PathVariable("dbname") String dbname, @PathVariable("tableName") String tableName,
			String btl, String objectName, String className, String packageName, Model model) {
		String result = "";
		try {
			TemplateRoot root = TemplateRoot.createTemplateRoot(codeService.showTable(dbname, tableName));
			if (objectName != null && !objectName.equals("")) {
				root.put("objectName", objectName);
			}
			if (className != null && !className.equals("")) {
				root.put("className", className);
			}
			if (packageName != null && !packageName.equals("")) {
				root.put("packageName", packageName);
			}
			Page page = new Page();
			page.setTable(tableName);
			List<PageData> datas = this.codeService.showTableData(dbname, page);
			if (!datas.isEmpty()) {
				root.put("data", datas.get(0));
			}
			result = BeetlUtil.printBtl(btl, root);
		} catch (Exception e) {
			e.printStackTrace();
			result = e.toString();
		}
		return result;
	}

	/**
	 * 根据freemaker生成当前表的文件字符串返回
	 *
	 * @param tableName
	 * @param type bean、mapperJava、mapperXml
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/{dbname}/tables/{tableName}/code/{type}")
	public String code(@PathVariable("dbname") String dbname, @PathVariable("tableName") String tableName,
			@PathVariable("type") String type, String objectName, String className, String packageName, Model model) {
		String result = CreateCodeUtil.createCode(codeService.showTable(dbname, tableName), type, objectName, className,
				packageName);
		return result;
	}

	/**
	 * 下载代码code.zip
	 */
	@RequestMapping(value = "/{dbname}/tables/{tableName}/downCode")
	public void downCode(@PathVariable("dbname") String dbname, @PathVariable("tableName") String tableName,
			String objectName, String className, String packageName, HttpServletResponse response) {
		try {
			// 生成代码
			String filePath = CreateCodeUtil.downCode(codeService.showTable(dbname, tableName), objectName, className,
					packageName);
			// 下载
			FileUploadDownload.fileDownload(response, filePath, "code_" + tableName + ".zip");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 导出表结构
	 */
	@RequestMapping(value = "/{dbname}/tables/tableColumns")
	public void tableColumns(@PathVariable("dbname") String dbname, HttpServletRequest request,
			HttpServletResponse response) {
		try {
			List<Table> tables = codeService.showTables(dbname);
			for (Table table : tables) {
				table.setColumnFields(codeService.showTableColumns(dbname, table.getTableName()));
			}
			PageData root = new PageData("tables", tables);
			String content = BeetlUtil.printString(FileUtils.getClassResources() + "/btl/table_columns.btl", root);
			// 取消空格
			content = content.replaceAll(">(\\s+)<", "><");
			String path = request.getServletContext().getRealPath("/static") + "/table_columns.doc";
			FileUtils.writeTxt(path, content);
			// 下载
			FileUploadDownload.fileDownload(response, path, dbname + "表结构.doc");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
