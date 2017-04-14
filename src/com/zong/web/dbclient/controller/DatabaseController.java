package com.zong.web.dbclient.controller;

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

import com.zong.util.BeetlUtil;
import com.zong.util.CreateCodeUtil;
import com.zong.util.FileUploadDownload;
import com.zong.util.FileUtils;
import com.zong.zdb.bean.ColumnField;
import com.zong.zdb.service.JdbcCodeService;
import com.zong.zdb.service.TemplateRoot;
import com.zong.zdb.util.Page;
import com.zong.zdb.util.PageData;
import com.zong.zdb.util.ZDBConfig;

@Controller
public class DatabaseController {

	private JdbcCodeService codeService = com.zong.zdb.service.JdbcCodeService.getInstance();

	@RequestMapping(value = "/dbs")
	public String dbs(Model model) {
		return "db_list";
	}

	@RequestMapping(value = "/{dbname}/tables")
	public String tables(@PathVariable("dbname") String dbname, Model model) {
		model.addAttribute("dbname", dbname);
		model.addAttribute("tables", codeService.showTables(dbname));
		return "table_list";
	}

	@RequestMapping(value = "/{dbname}/tables/{tableName}")
	public String tables(@PathVariable("dbname") String dbname, @PathVariable("tableName") String tableName,
			Model model) {
		model.addAttribute("dbname", dbname);
		model.addAttribute("tableName", tableName);
		model.addAttribute("columns", codeService.showTableColumns(dbname, tableName));
		model.addAttribute("tab", "design");
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
		return "table_datas";
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
		templates(model);
		return "table_code";
	}

	/**
	 * 根据beetl模板生成当前表的文件字符串返回
	 *
	 */
	@ResponseBody
	@RequestMapping(value = "/{dbname}/tables/{tableName}/beetlCode", method = RequestMethod.POST, produces = "text/plain;charset=utf-8")
	public String beetlCode(@PathVariable("dbname") String dbname, @PathVariable("tableName") String tableName,
			String btl, Model model) {
		String result = "";
		try {
			result = BeetlUtil.printBtl(btl, TemplateRoot.createTemplateRoot(codeService.showTable(dbname, tableName)));
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

	@RequestMapping(value = "/templates")
	public String templates(Model model) {
		List<String> ftls = new ArrayList<String>();
		for (File f : FileUtils.listFile(FileUtils.getClassResources() + "ftl/")) {
			ftls.add(f.getName().substring(0, f.getName().lastIndexOf(".")));
		}
		model.addAttribute("templates", ftls);
		model.addAttribute("content", template(ftls.get(0)));
		return "template";
	}

	@ResponseBody
	@RequestMapping(value = "/templates/{name}", produces = { "application/json;charset=UTF-8" })
	public String template(@PathVariable("name") String name) {
		String content = "";
		try {
			content = FileUtils.readTxt(FileUtils.getClassResources() + "/ftl/" + name + ".ftl");
		} catch (Exception e) {
			e.printStackTrace();
			content = e.toString();
		}
		return content;
	}

	@ResponseBody
	@RequestMapping(value = "/templates/{name}/edit")
	public String editTemplate(@PathVariable("name") String name, String content) {
		try {
			FileUtils.writeTxt(FileUtils.getClassResources() + "/ftl/" + name + ".ftl", content);
		} catch (Exception e) {
			e.printStackTrace();
			return e.toString();
		}
		return "Y";
	}

	@RequestMapping(value = "/config/{name}")
	public String config(@PathVariable("name") String name, Model model) {
		String content = "";
		try {
			content = FileUtils.readTxt(FileUtils.getClassResources() + "zdb.json");
		} catch (Exception e) {
			e.printStackTrace();
			content = e.toString();
		}
		model.addAttribute("name", name);
		model.addAttribute("content", content);
		return "config";
	}

	@ResponseBody
	@RequestMapping(value = "/config/{name}/edit")
	public String editConfig(@PathVariable("name") String name, String content, HttpServletRequest request) {
		try {
			request.getServletContext().setAttribute("configData", ZDBConfig.writeConfig(content));
		} catch (Exception e) {
			e.printStackTrace();
			return e.toString();
		}
		return "Y";
	}

	@RequestMapping(value = "/code")
	public String code() {
		return "code";
	}
}
