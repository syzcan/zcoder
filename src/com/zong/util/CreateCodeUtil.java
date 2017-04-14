package com.zong.util;

import java.io.File;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.zong.zdb.bean.Table;
import com.zong.zdb.service.TemplateRoot;

/**
 * @desc 代码生成类， ftl文件按关键字归类： bean，controller，mapperjava，mapperxml， service，jsp_
 * @author zong
 * @date 2016年12月2日 上午1:07:55
 */
public class CreateCodeUtil {

	/**
	 * 生成代码
	 * 
	 * @param table
	 * @param type bean、mapperJava、mapperXml 表结构模型
	 */
	public static String createCode(Table table, String type, String objectName, String className, String packageName) {
		String result = "";
		try {
			TemplateRoot root = TemplateRoot.createTemplateRoot(table, objectName, className, packageName);
			String ftlPath = FileUtils.getClassResources() + "ftl";
			System.out.println("======生成" + table.getTableName() + "代码start======");
			result = Freemarker.printString(type + ".ftl", ftlPath, root);
		} catch (Exception e) {
			e.printStackTrace();
			result = e.toString();
		}
		return result;
	}

	public static String downCode(Table table, String objectName, String className, String packageName) {
		String result = "";
		try {
			TemplateRoot root = TemplateRoot.createTemplateRoot(table, objectName, className, packageName);
			HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes())
					.getRequest();
			// String parentPath = FileUtils.getClassResources();//
			// code文件夹父文件夹路径
			String parentPath = request.getServletContext().getRealPath("/static");
			String codePath = parentPath + "/code";// 生成代码存放路径
			String ftlPath = FileUtils.getClassResources() + "ftl/";
			// 先删除原来的
			FileUtils.removeAllFile(codePath);

			System.out.println("======下载" + table.getTableName() + "代码start======");
			// 获取所有模板
			List<File> ftls = FileUtils.listFile(ftlPath, "ftl");
			for (File ftl : ftls) {
				// 根据模板名称归类分别处理
				String ftlName = ftl.getName().toLowerCase();
				String fileName = "";
				String filePath = "";
				if (ftlName.indexOf("bean") > -1) {
					// 生成实体bean
					fileName = root.getString("className") + ".java";
					filePath = root.getPackageBeanPath();
				} else if (ftlName.indexOf("controller") > -1) {
					// 生成controller
					fileName = root.getString("className") + "Controller.java";
					if (ftlName.indexOf("json") > -1) {
						fileName = root.getString("className") + "ControllerJson.java";
					} else if (ftlName.indexOf("view") > -1) {
						fileName = root.getString("className") + "ControllerView.java";
					}
					filePath = root.getPackageControllerPath();
				} else if (ftlName.indexOf("mapperjava") > -1) {
					// 生成mapper.java
					fileName = root.getString("className") + "Mapper.java";
					filePath = root.getPackageMapperPath();
				} else if (ftlName.indexOf("mapperxml") > -1) {
					// 生成mapper.xml
					fileName = root.getString("className") + "Mapper.xml";
					filePath = root.getPackageMapperPath();
				} else if (ftlName.indexOf("service") > -1) {
					// 生成service
					fileName = root.getString("className") + "Service.java";
					if (ftlName.indexOf("impl") > -1) {
						fileName = root.getString("className") + "ServiceImpl.java";
					}
					filePath = root.getPackageServicePath();
				} else if (ftlName.indexOf("jsp_") > -1) {
					// 生成jsp
					fileName = ftlName.replace(".ftl", ".jsp").replace("jsp_", root.getString("objectName") + "_");
					filePath = "jsp/" + root.getString("objectName");
				}
				if (!fileName.equals("")) {
					Freemarker.printFile(ftl.getName(), ftlPath, root, codePath + "/" + filePath + "/" + fileName);
				}
			}

			// 压缩
			result = parentPath + "/code.zip";
			File f = new File(result);
			f.delete();
			ZipUtil.zip(codePath, result);
		} catch (Exception e) {
			e.printStackTrace();
			result = e.toString();
		}
		return result;
	}

}
