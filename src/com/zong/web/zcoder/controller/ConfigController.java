package com.zong.web.zcoder.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.zong.util.FileUtils;
import com.zong.zdb.util.ZDBConfig;

@Controller
public class ConfigController {
	@RequestMapping(value = "/templates")
	public String templates(Model model) {
		List<String> ftls = new ArrayList<String>();
		for (File f : FileUtils.listFile(FileUtils.getClassResources() + "ftl/")) {
			ftls.add(f.getName().substring(0, f.getName().lastIndexOf(".")));
		}
		model.addAttribute("templates", ftls);
		model.addAttribute("content", template(ftls.get(0)));
		model.addAttribute("nav", "config");
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
		model.addAttribute("nav", "config");
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
	public String code(Model model) {
		model.addAttribute("nav", "code");
		return "code";
	}
}
