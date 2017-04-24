package com.zong.web.zcoder.controller;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.zong.util.JsoupUtil;
import com.zong.util.PageData;
import com.zong.zdb.service.JdbcCodeService;

@Controller
@RequestMapping("/craw")
public class CrawController extends BaseController {
	private Logger logger = LoggerFactory.getLogger(CrawController.class);
	private JdbcCodeService codeService = JdbcCodeService.getInstance();

	/**
	 * 解析任何页面
	 * 
	 * @param craw_url 抓取地址【必须】
	 * @param exts 非craw_*关键参数的其他扩展规则
	 */
	@ResponseBody
	@RequestMapping("/data")
	public PageData data() {
		PageData result = new PageData("errMsg", "success");
		try {
			PageData pd = super.getPageData();
			PageData data = JsoupUtil.parseDetail(pd);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.toString(), e);
			result.put("errMsg", "系统错误");
		}
		return result;
	}

	/**
	 * 解析列表页面
	 * 
	 * @param craw_url 抓取地址【必须】
	 * @param craw_item 条目规则【必须】
	 * @param craw_next 下一页规则
	 * @param craw_store 存储表名，只有指定才保存到数据库
	 * @param exts 非craw_*关键参数的其他扩展规则
	 */
	@ResponseBody
	@RequestMapping("/list")
	public PageData list() {
		PageData result;
		try {
			PageData pd = super.getPageData();
			result = JsoupUtil.parseList(pd);
			saveData(pd.getString("craw_store"), result);
			result.put("errMsg", "success");
		} catch (Exception e) {
			logger.error(e.toString(), e);
			result = new PageData("errMsg", "系统错误");
		}
		return result;
	}

	@SuppressWarnings({ "unused", "unchecked" })
	private void saveData(String craw_store, PageData parseData) throws Exception {
		if (craw_store == null || "".equals(craw_store)) {
			return;
		}
		String[] arr = craw_store.split(";");
		List<PageData> list = (List<PageData>) parseData.get("data");
		for (PageData data : list) {
			com.zong.zdb.util.PageData pd = new com.zong.zdb.util.PageData();
			for (Object key : data.keySet()) {
				pd.put(key, data.get(key));
			}
			codeService.insert(arr[0], arr[1], pd);
		}
	}
}
