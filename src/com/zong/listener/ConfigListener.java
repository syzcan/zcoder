package com.zong.listener;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.log4j.Logger;

import com.zong.util.FileUtils;
import com.zong.zdb.util.ZDBConfig;

/**
 * @desc tomcat启动时执行初始化数据，加载常量到application
 * @author zong
 * @date 2016年11月27日 下午10:35:33
 */
public class ConfigListener implements ServletContextListener {

	public static final Logger logger = Logger.getLogger(ConfigListener.class);

	@Override
	public void contextDestroyed(ServletContextEvent event) {
		// TODO Auto-generated method stub
	}

	@Override
	public void contextInitialized(ServletContextEvent event) {
		try {
			logger.info("======加载zdb.json");
			ServletContext application = event.getServletContext();
			application.setAttribute("configData", ZDBConfig.readConfig());
			// 清空之前restclient测试上传的文件
			File file = new File(application.getRealPath("/upload"));
			if (file.exists()) {
				// 文件目录按时间归类文件夹
				SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
				int today = Integer.parseInt(dateFormat.format(new Date()));
				for (File f : file.listFiles()) {
					try {
						if (Integer.parseInt(f.getName()) < today) {
							// 先删除下面的文件再删除文件夹
							FileUtils.removeAllFile(f.getAbsolutePath());
							f.delete();
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		} catch (Exception e) {
			logger.error("加载配置文件失败", e);
		}
	}

}
