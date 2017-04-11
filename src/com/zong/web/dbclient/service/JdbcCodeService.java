package com.zong.web.dbclient.service;

import java.util.List;
import java.util.Map;

import com.zong.util.Page;
import com.zong.util.PageData;
import com.zong.util.Properties;
import com.zong.web.dbclient.bean.ColumnField;
import com.zong.web.dbclient.bean.TableEntity;
import com.zong.web.dbclient.dao.IJdbcDao;
import com.zong.web.dbclient.dao.MysqlCodeDao;
import com.zong.web.dbclient.dao.OracleCodeDao;

public class JdbcCodeService {
	private static final String DRIVER_ORACLE = "oracle.jdbc.driver.OracleDriver";
	private static final String DRIVER_MYSQL = "com.mysql.jdbc.Driver";

	private IJdbcDao makeJdbcDao(String dbname) {
		Properties props = new Properties(dbname);
		String driverClassName = props.getProperty("jdbc.driverClassName");
		if (driverClassName.equals(DRIVER_MYSQL)) {
			return new MysqlCodeDao(props);
		} else if (driverClassName.equals(DRIVER_ORACLE)) {
			return new OracleCodeDao(props);
		}
		return null;
	}

	public TableEntity showTable(String dbname, String tableName) {
		IJdbcDao jdbcDao = makeJdbcDao(dbname);
		TableEntity tableEntity = jdbcDao.showTable(tableName);
		tableEntity.setColumnFields(jdbcDao.showTableColumns(tableName));
		return tableEntity;
	}

	public List<TableEntity> showTables(String dbname) {
		return makeJdbcDao(dbname).showTables();
	}

	public List<ColumnField> showTableColumns(String dbname, String tableName) {
		return makeJdbcDao(dbname).showTableColumns(tableName);
	}

	public List showTableDatas(String dbname, Page page) {
		return makeJdbcDao(dbname).showTableDatas(page);
	}

	public List showSqlDatas(String dbname, String sql) {
		return makeJdbcDao(dbname).showSqlDatas(sql);
	}

}
