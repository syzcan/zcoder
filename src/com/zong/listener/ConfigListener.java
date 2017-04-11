package com.zong.listener;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.log4j.Logger;

import com.zong.util.Config;

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
			logger.info("======加载config.json");
			ServletContext application = event.getServletContext();
			application.setAttribute(Config.CONFIG_DATA, Config.readConfig());
		} catch (Exception e) {
			logger.error("加载配置文件失败", e);
		}
	}

}
