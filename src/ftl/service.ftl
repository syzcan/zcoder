package ${packageService};

import java.util.List;

import ${packageBean}.${className};
import com.zong.util.Page;
import com.zong.util.PageData;

/**
 * @desc ${objectName}业务接口类
 * @author zong
 * @date ${nowDate?string("yyyy年MM月dd日")}
 */
public interface ${className}Service {

	/**
	 * 新增${objectName}
	 * 
	 * @param ${objectName}
	 * @throws Exception
	 */
	public void add${className}(${className} ${objectName}) throws Exception;
	
	/**
	 * 删除${objectName}
	 * 
	 * @param ${objectName}
	 */
	public void delete${className}(${className} ${objectName}) throws Exception;
	
	/**
	 * 删除多个${objectName}
	 * @param ids
	 */
	public void delete${className}s(String[] ids) throws Exception;
	
	/**
	 * 修改${objectName}
	 * 
	 * @param ${objectName}
	 * @throws Exception
	 */
	public void edit${className}(${className} ${objectName}) throws Exception;

	/**
	 * 根据id查询${objectName}
	 * 
	 * @param ${objectName}
	 * @return
	 */
	public ${className} load${className}(${className} ${objectName});

	/**
	 * 分页查询${objectName}
	 * 
	 * @param page
	 * @return
	 */
	public List<${className}> find${className}Page(Page page);
	
	/**
	 * 查询全部${objectName}
	 * 
	 * @param pageData
	 * @return
	 */
	public List<${className}> find${className}(PageData pageData);
}
