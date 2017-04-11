package com.zong.web.dbclient.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.zong.util.Config;
import com.zong.util.CreateCodeUtil;
import com.zong.util.FileUploadDownload;
import com.zong.util.FileUtils;
import com.zong.util.Page;
import com.zong.util.PageData;
import com.zong.web.base.BaseController;
import com.zong.web.dbclient.bean.ColumnField;
import com.zong.web.dbclient.service.JdbcCodeService;

@Controller
public class DatabaseController extends BaseController {

	private JdbcCodeService codeService = new JdbcCodeService();

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
	public String tables(@PathVariable("dbname") String dbname, @PathVariable("tableName") String tableName, Model model) {
		model.addAttribute("dbname", dbname);
		model.addAttribute("tableName", tableName);
		model.addAttribute("columns", codeService.showTableColumns(dbname, tableName));
		model.addAttribute("tab", "design");
		return "table_view";
	}

	@RequestMapping(value = "/{dbname}/tables/{tableName}/datas")
	public String datas(@PathVariable("dbname") String dbname, @PathVariable("tableName") String tableName, Model model) {
		Page page = getPage();
		page.getPd().put("tableName", tableName);
		model.addAttribute("dbname", dbname);
		model.addAttribute("tableName", tableName);
		List<ColumnField> columns = codeService.showTableColumns(dbname, tableName);
		model.addAttribute("columns", columns);
		List<PageData> datas = codeService.showTableDatas(dbname, page);
		for (PageData pd : datas) {
			for (ColumnField columnField : columns) {
				String value = pd.getString(columnField.getColumn());
				pd.put(columnField.getColumn(), value == null ? "" : value.replaceAll("<", "&lt;").replaceAll(">", "&gt;"));
			}
		}
		model.addAttribute("datas", datas);
		model.addAttribute("tab", "data");
		return "table_datas";
	}

	@RequestMapping(value = "/{dbname}/tables/{tableName}/sqldatas")
	public String sqldatas(@PathVariable("dbname") String dbname, @PathVariable("tableName") String tableName,String sql, Model model) {
		Page page = getPage();
		page.getPd().put("tableName", tableName);
		model.addAttribute("dbname", dbname);
		model.addAttribute("tableName", tableName);
		model.addAttribute("sql", sql);
		if (sql != null && !sql.equals("")) {
			List datas = codeService.showSqlDatas(dbname, sql);
			model.addAttribute("datas", datas);
		}
		model.addAttribute("tab", "data");
		return "sql_datas";
	}

	@ResponseBody
	@RequestMapping(value = "/{dbname}/tables/{tableName}/data")
	public List<PageData> data(@PathVariable("dbname") String dbname, @PathVariable("tableName") String tableName, Model model) {
		Page page = getPage();
		page.getPd().put("tableName", tableName);
		return codeService.showTableDatas(dbname, page);
	}

	@RequestMapping(value = "/{dbname}/tables/{tableName}/code")
	public String code(@PathVariable("dbname") String dbname, @PathVariable("tableName") String tableName, Model model) {
		model.addAttribute("dbname", dbname);
		model.addAttribute("tableName", tableName);
		model.addAttribute("tableEntity", codeService.showTable(dbname, tableName));
		model.addAttribute("tab", "code");
		templates(model);
		return "table_code";
	}

	/**
	 * 根据freemaker生成当前表的文件字符串返回
	 *
	 * @param tableName
	 * @param type
	 *            bean、mapperJava、mapperXml
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/{dbname}/tables/{tableName}/code/{type}")
	public String code(@PathVariable("dbname") String dbname, @PathVariable("tableName") String tableName, @PathVariable("type") String type, String objectName, String className,
			String packageName, Model model) {
		String result = CreateCodeUtil.createCode(dbname, codeService.showTable(dbname, tableName), type, objectName, className, packageName);
		return result;
	}

	/**
	 * 下载代码code.zip
	 */
	@RequestMapping(value = "/{dbname}/tables/{tableName}/downCode")
	public void downCode(@PathVariable("dbname") String dbname, @PathVariable("tableName") String tableName, String objectName, String className, String packageName,
			HttpServletResponse response) {
		try {
			// 生成代码
			String filePath = CreateCodeUtil.downCode(dbname, codeService.showTable(dbname, tableName), objectName, className, packageName);
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
			content = FileUtils.readTxt(FileUtils.getClassResources() + name + ".json");
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
	public String editConfig(@PathVariable("name") String name, String content) {
		try {
			getRequest().getServletContext().setAttribute(Config.CONFIG_DATA, Config.writeConfig(content));
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
