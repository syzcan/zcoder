package com.zong.web.zcoder.controller;

import java.util.Map;

import org.apache.log4j.Logger;
import org.jsoup.Connection;
import org.jsoup.Connection.Method;
import org.jsoup.Connection.Response;
import org.jsoup.Jsoup;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
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

	public static final String CONTENT_TYPE = "Content-Type";

	@RequestMapping
	public String restclient(Model model) {
		model.addAttribute("nav", "rest");
		return "/restclient";
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@ResponseBody
	@RequestMapping(value = "/request", method = RequestMethod.POST)
	public PageData request(@RequestBody PageData request) {
		PageData result = new PageData("errMsg", "success");
		try {
			String method = request.getString("method");
			String url = request.getString("url");
			Map headers = (Map) request.get("headers");
			Map params = (Map) request.get("params");
			String contentType = (String) headers.get(CONTENT_TYPE);
			Connection connection = Jsoup.connect(url).userAgent(USER_AGENT).method(Method.valueOf(method))
					.ignoreContentType(true).ignoreHttpErrors(true).timeout(1000 * 60);
			Response response = null;
			for (Object key : headers.keySet()) {
				connection.header(key.toString(), headers.get(key).toString());
			}
			if (method.equals("GET")) {
				response = connection.execute();
			} else {
				if (contentType.equals("form-data")) {
					connection.header(CONTENT_TYPE, contentType).data(params);
				} else if (contentType.equals("x-www-form-urlencoded")) {
					connection.header(CONTENT_TYPE, contentType).data(params);
				} else {
					String payload = (String) params.get("payload");
					connection.header(CONTENT_TYPE, contentType).requestBody(payload);
				}
			}
			response = connection.execute();
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
