package com.zong.web.zcoder.controller;

import org.apache.log4j.Logger;
import org.jsoup.Connection.Method;
import org.jsoup.Connection.Response;
import org.jsoup.Jsoup;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.zong.zdb.util.PageData;

/**
 * @desc rest接口测试客户端页面
 * @author zong
 * @date 2017年4月17日
 */
@Controller
@RequestMapping("/restclient")
public class RestClientController {
	private Logger logger = Logger.getLogger(RestClientController.class);
	// 模拟浏览器访问
	public static final String USER_AGENT = "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.64 Safari/537.31";

	@RequestMapping
	public String restclient(Model model) {
		model.addAttribute("nav", "rest");
		return "/restclient";
	}

	@ResponseBody
	@RequestMapping(value = "/request", method = RequestMethod.POST)
	public PageData request(String url, String type) {
		PageData result = new PageData("errMsg", "success");
		try {
			Response response = Jsoup.connect(url).userAgent(USER_AGENT).method(Method.valueOf(type))
					.ignoreContentType(true).execute();
			PageData data = new PageData();
			data.put("body", response.body());
			data.put("cookies", response.cookies());
			data.put("headers", response.headers());
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.toString(), e);
			result.put("errMsg", "系统错误");
		}
		return result;
	}
}
