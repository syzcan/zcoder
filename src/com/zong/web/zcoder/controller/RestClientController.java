package com.zong.web.zcoder.controller;

import java.io.File;
import java.io.FileInputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.mashape.unirest.http.Headers;
import com.mashape.unirest.http.HttpResponse;
import com.mashape.unirest.http.Unirest;
import com.mashape.unirest.request.HttpRequestWithBody;
import com.mashape.unirest.request.body.MultipartBody;
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

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@ResponseBody
	@RequestMapping(value = "/request", method = RequestMethod.POST)
	public PageData request(@RequestBody PageData request, HttpServletRequest res) {
		PageData result = new PageData("errMsg", "success");
		try {
			String method = request.getString("method");
			String url = request.getString("url");
			Map headers = (Map) request.get("headers");
			Map params = (Map) request.get("params");
			String contentType = (String) headers.get("Content-Type");
			// 期望获得数据格式，根据后缀判断
			String accept = (String) headers.get("Accept");
			if (accept == null) {
				String location = url.split("\\?")[0];
				if (location.lastIndexOf(".") >= 0) {
					String suffix = location.substring(location.lastIndexOf(".")).replace(".", "");
					if (suffix.equals("json")) {
						accept = "application/json; charset=utf-8";
					} else if (suffix.equals("xml")) {
						accept = "application/xml; charset=utf-8";
					}
				}
				if (accept != null) {
					headers.put("Accept", accept);
				}
			}
			HttpResponse<String> response = null;
			if (method.equals("GET")) {
				response = Unirest.get(url).headers(headers).asString();
			} else {
				if (contentType.equals("form-data")) {
					// 有文件上传时，unirest会自动加上头部，这里删除页面传来的
					headers.remove("Content-Type");
					HttpRequestWithBody requestWithBody = null;
					if (method.equals("POST")) {
						requestWithBody = Unirest.post(url).headers(headers);
					} else if (method.equals("PUT")) {
						requestWithBody = Unirest.put(url).headers(headers);
					} else if (method.equals("DELETE")) {
						requestWithBody = Unirest.delete(url).headers(headers);
					}
					response = formData(requestWithBody, headers, params, res);
				} else if (contentType.equals("x-www-form-urlencoded")) {
					headers.put("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
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
						value = value.trim();
						if (!value.equals("")) {
							String[] arrs = value.split("=");
							cookies.put(arrs[0], arrs.length > 1 ? arrs[1] : "");
						}
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

	@SuppressWarnings("rawtypes")
	private HttpResponse<String> formData(HttpRequestWithBody requestWithBody, Map headers, Map params,
			HttpServletRequest res) throws Exception {
		HttpResponse<String> response = null;
		// 上传文件或者上传文件和文本同时提交必须使用MultipartBody
		MultipartBody multipartBody = null;
		for (Object key : params.keySet()) {
			String[] arr = params.get(key).toString().split("\\|");
			String fieldType = arr[0];
			if (fieldType.equals("text")) {
				if (multipartBody == null) {
					multipartBody = requestWithBody.field(key.toString(), arr[1]);
				} else {
					multipartBody = multipartBody.field(key.toString(), arr[1]);
				}
			} else {// 有文件参数且存在文件则取出地址，从服务器读出来提交
				if (arr.length == 3) {
					String fileName = arr[1];
					String filePath = res.getServletContext().getRealPath("/" + arr[2]);
					if (multipartBody == null) {
						multipartBody = requestWithBody.field(key.toString(), new FileInputStream(filePath), fileName);
					} else {
						multipartBody = multipartBody.field(key.toString(), new FileInputStream(filePath), fileName);
					}
				}
			}
		}
		if (multipartBody == null) {
			response = requestWithBody.asString();
		} else {
			response = multipartBody.asString();
		}
		return response;
	}

	/**
	 * 上传附件
	 * 
	 */
	@ResponseBody
	@RequestMapping(value = "/uploadFile", method = RequestMethod.POST)
	public Map<String, String> uploadFile(MultipartFile file, HttpServletRequest request) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("fileName", file.getOriginalFilename());
		map.put("url", this.upload(file, request));
		return map;
	}

	/**
	 * 
	 * @param file
	 * @param uploadPath 文件保存位置
	 * @return 返回附件访问路径
	 */
	private String upload(MultipartFile file, HttpServletRequest request) {
		// 文件目录按时间归类文件夹
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
		String dateDir = dateFormat.format(new Date());
		String path = "upload/" + dateDir;
		Random random = new Random();
		String extName = "";
		if (file.getOriginalFilename().lastIndexOf(".") >= 0) {
			extName = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf("."));
		}
		String randomNum = "";
		int num = random.nextInt(10000);
		if (num < 10) {
			randomNum = "000" + num;
		} else if (num < 100) {
			randomNum = "00" + num;
		} else if (num < 1000) {
			randomNum = "0" + num;
		} else {
			randomNum = "" + num;
		}
		path += "/" + System.currentTimeMillis() + randomNum + extName;
		File f = new File(request.getSession().getServletContext().getRealPath("/" + path));
		if (!f.getParentFile().exists()) {
			f.getParentFile().mkdirs();
		}
		try {
			file.transferTo(f);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		return path;
	}
}
