package com.zong.util;

import java.io.File;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.zong.web.dbclient.bean.TableEntity;

/**
 * @desc 代码生成类， ftl文件按关键字归类： bean，controller，mapperjava，mapperxml， service，jsp_
 * @author zong
 * @date 2016年12月2日 上午1:07:55
 */
public class CreateCodeUtil {

	private static Map<String, Object> loadConfig(String dbname, TableEntity tableEntity, String objectName, String className, String packageName) {
		Properties props = new Properties(dbname);
		if (packageName == null || packageName.trim().equals("")) {
			packageName = props.getProperty("packageName");
		} else {
			packageName = packageName.trim();
		}
		String packageBean = props.getProperty("packageBean");
		String packageMapper = props.getProperty("packageMapper");
		String packageService = props.getProperty("packageService");
		String packageController = props.getProperty("packageController");
		String packageJsp = props.getProperty("packageJsp");

		tableEntity.setPackageBean(packageName + "." + packageBean);
		tableEntity.setPackageMapper(packageName + "." + packageMapper);
		tableEntity.setPackageService(packageName + "." + packageService);
		tableEntity.setPackageController(packageName + "." + packageController);
		tableEntity.setPackageJsp(packageJsp);

		tableEntity.setObjectName(objectName);
		tableEntity.setClassName(className);

		Map<String, Object> root = new HashMap<String, Object>(); // 创建数据模型
		root.put("tableEntity", tableEntity);
		root.put("columnFields", tableEntity.getColumnFields());
		root.put("className", tableEntity.getClassName()); // 类名
		root.put("objectName", tableEntity.getObjectName()); // 实体名
		root.put("packageBean", tableEntity.getPackageBean()); // 包名
		root.put("packageMapper", tableEntity.getPackageMapper());
		root.put("packageService", tableEntity.getPackageService());
		root.put("packageController", tableEntity.getPackageController());
		root.put("packageJsp", tableEntity.getPackageJsp());
		root.put("nowDate", new Date()); // 当前日期
		return root;
	}

	/**
	 * 生成代码
	 * 
	 * @param tableEntity
	 * @param type
	 *            bean、mapperJava、mapperXml 表结构模型
	 */
	public static String createCode(String dbname, TableEntity tableEntity, String type, String objectName, String className, String packageName) {
		String result = "";
		try {
			Map<String, Object> root = loadConfig(dbname, tableEntity, objectName, className, packageName); // 创建数据模型

			String ftlPath = FileUtils.getClassResources() + "ftl";
			System.out.println("======生成" + tableEntity.getTableName() + "代码start======");
			result = Freemarker.printString(type + ".ftl", ftlPath, root);
		} catch (Exception e) {
			e.printStackTrace();
			result = e.toString();
		}
		return result;
	}

	public static String downCode(String dbname, TableEntity tableEntity, String objectName, String className, String packageName) {
		String result = "";
		try {
			Map<String, Object> root = loadConfig(dbname, tableEntity, objectName, className, packageName); // 创建数据模型
			HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
			//String parentPath = FileUtils.getClassResources();// code文件夹父文件夹路径
			String parentPath = request.getServletContext().getRealPath("/static");
			String codePath = parentPath + "/code";// 生成代码存放路径
			String ftlPath = FileUtils.getClassResources() + "ftl/";
			// 先删除原来的
			FileUtils.removeAllFile(codePath);

			System.out.println("======下载" + tableEntity.getTableName() + "代码start======");
			// 获取所有模板
			List<File> ftls = FileUtils.listFile(ftlPath, "ftl");
			for (File ftl : ftls) {
				// 根据模板名称归类分别处理
				String ftlName = ftl.getName().toLowerCase();
				String fileName = "";
				String filePath = "";
				if (ftlName.indexOf("bean") > -1) {
					// 生成实体bean
					fileName = tableEntity.getClassName() + ".java";
					filePath = tableEntity.getPackageBeanPath();
				} else if (ftlName.indexOf("controller") > -1) {
					// 生成controller
					fileName = tableEntity.getClassName() + "Controller.java";
					if (ftlName.indexOf("json") > -1) {
						fileName = tableEntity.getClassName() + "ControllerJson.java";
					} else if (ftlName.indexOf("view") > -1) {
						fileName = tableEntity.getClassName() + "ControllerView.java";
					}
					filePath = tableEntity.getPackageControllerPath();
				} else if (ftlName.indexOf("mapperjava") > -1) {
					// 生成mapper.java
					fileName = tableEntity.getClassName() + "Mapper.java";
					filePath = tableEntity.getPackageMapperPath();
				} else if (ftlName.indexOf("mapperxml") > -1) {
					// 生成mapper.xml
					fileName = tableEntity.getClassName() + "Mapper.xml";
					filePath = tableEntity.getPackageMapperPath();
				} else if (ftlName.indexOf("service") > -1) {
					// 生成service
					fileName = tableEntity.getClassName() + "Service.java";
					if (ftlName.indexOf("impl") > -1) {
						fileName = tableEntity.getClassName() + "ServiceImpl.java";
					}
					filePath = tableEntity.getPackageServicePath();
				} else if (ftlName.indexOf("jsp_") > -1) {
					// 生成jsp
					fileName = ftlName.replace(".ftl", ".jsp").replace("jsp_", tableEntity.getObjectName() + "_");
					filePath = "jsp/" + tableEntity.getObjectName();
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
