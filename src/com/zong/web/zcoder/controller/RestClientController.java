package com.zong.web.zcoder.controller;

import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mashape.unirest.http.Headers;
import com.mashape.unirest.http.HttpResponse;
import com.mashape.unirest.http.Unirest;
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
			String accept = "application/json; charset=utf-8";
			String location = url.split("\\?")[0];
			if (location.lastIndexOf(".") >= 0) {
				String suffix = location.substring(location.lastIndexOf(".")).replace(".", "");
				if (suffix.equals("xml")) {
					accept = "application/xml; charset=utf-8";
				}
			}
			headers.put("Accept", accept);
			HttpResponse<String> response = null;
			if (method.equals("GET")) {
				response = Unirest.get(url).headers(headers).asString();
			} else {
				if (contentType.equals("form-data")) {
					response = Unirest.post(url).headers(headers).fields(params).asString();
				} else if (contentType.equals("x-www-form-urlencoded")) {
					if (method.equals("POST")) {
						response = Unirest.post(url).headers(headers).fields(params).asString();
					} else if (method.equals("PUT")) {
						response = Unirest.put(url).headers(headers).fields(params).asString();
					} else if (method.equals("DELETE")) {
						response = Unirest.delete(url).headers(headers).fields(params).asString();
					}
				} else {
					String payload = (String) params.get("payload");
					if (method.equals("POST")) {
						response = Unirest.post(url).headers(headers).body(payload).asString();
					} else if (method.equals("PUT")) {
						response = Unirest.put(url).headers(headers).body(payload).asString();
					} else if (method.equals("DELETE")) {
						response = Unirest.delete(url).headers(headers).body(payload).asString();
					}
				}
			}
			PageData data = new PageData();
			data.put("body", response.getBody());
			PageData headersData = new PageData();
			Headers hs = response.getHeaders();
			for (String key : hs.keySet()) {
				headersData.put(key, hs.getFirst(key));
				if (key.toLowerCase().equals("set-cookie")) {
					PageData cookies = new PageData();
					String[] arr = hs.getFirst(key).split(";");
					for (String value : arr) {
						cookies.put(value.split("=")[0], value.split("=")[1]);
					}
					data.put("cookies", cookies);
				}
			}
			data.put("headers", headersData);
			data.put("statusCode", response.getStatus());
			data.put("statusText", response.getStatusText());
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.toString(), e);
			result.put("errMsg", e.getMessage());
		}
		return result;
	}
}
