package ${packageController};

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.zong.base.BaseController;
import com.zong.util.BusinessException;
import com.zong.util.Page;
import com.zong.util.PageData;
import ${packageBean}.${className};
import ${packageService}.${className}Service;

/**
 * @desc ${objectName}控制层 ${comment}
 * @author zong
 * @date ${nowDate?string("yyyy年MM月dd日")}
 */
@Controller
@RequestMapping(value = "/${objectName}")
public class ${className}Controller extends BaseController {
	private final static Logger logger = LoggerFactory.getLogger(${className}Controller.class);

	@Autowired
	private ${className}Service ${objectName}Service;

	/**
	 * 查询${objectName}列表
	 */
	@RequestMapping(value = "/list")
	public String list(Model model) {
		Page page = super.getPage();
		model.addAttribute("${objectName}s", ${objectName}Service.find${className}Page(page));
		return "/<#if packageJsp==""><#else>${packageJsp}/</#if>${objectName}/${objectName}_list";
	}
	
	/**
	 * 新增${objectName}页面
	 */
	@RequestMapping(value = "/toAdd")
	public String toAdd(Model model) {
		return "/<#if packageJsp==""><#else>${packageJsp}/</#if>${objectName}/${objectName}_form";
	}

	/**
	 * 修改${objectName}页面
	 */
	@RequestMapping(value = "/toEdit")
	public String toEdit(${className} ${objectName}, Model model) {
		${objectName} = ${objectName}Service.load${className}(${objectName});
		model.addAttribute("${objectName}", ${objectName});
		model.addAttribute("formType", "edit");
		return "/<#if packageJsp==""><#else>${packageJsp}/</#if>${objectName}/${objectName}_form";
	}
	
	/**
	 * 新增${objectName}
	 */
	@ResponseBody
	@RequestMapping(value = "/add")
	public PageData add(${className} ${objectName}, Model model) {
		PageData result = new PageData("errMsg", "success");
		try {
			${objectName}Service.add${className}(${objectName});
		} catch (BusinessException e) {
			logger.warn(e.getErrMsg());
			result.put("errMsg", e.getErrMsg());
		} catch (Exception e) {
			logger.error(e.toString(), e);
			result.put("errMsg", "系统错误！");
		}
		return result;
	}
	
	/**
	 * 修改${objectName}
	 */
	@ResponseBody
	@RequestMapping(value = "/edit")
	public PageData edit(${className} ${objectName}, Model model) {
		PageData result = new PageData("errMsg", "success");
		try {
			${objectName}Service.edit${className}(${objectName});
		} catch (BusinessException e) {
			logger.warn(e.getErrMsg());
			result.put("errMsg", e.getErrMsg());
		} catch (Exception e) {
			logger.error(e.toString(), e);
			result.put("errMsg", "系统错误！");
		}
		return result;
	}

	/**
	 * 删除${objectName}
	 */
	@ResponseBody
	@RequestMapping(value = "/delete")
	public PageData delete(${className} ${objectName}) {
		PageData result = new PageData("errMsg", "success");
		try {
			${objectName}Service.delete${className}(${objectName});
		} catch (BusinessException e) {
			logger.warn(e.getErrMsg());
			result.put("errMsg", e.getErrMsg());
		} catch (Exception e) {
			logger.error(e.toString(), e);
			result.put("errMsg", "系统错误！");
		}
		return result;
	}
	
	/**
	 * 删除多个${objectName}
	 */
	@ResponseBody
	@RequestMapping(value = "/deleteAll")
	public PageData deleteAll() {
		PageData result = new PageData("errMsg", "success");
		try {
			${objectName}Service.delete${className}s(getRequest().getParameterValues("id"));
		} catch (BusinessException e) {
			logger.warn(e.getErrMsg());
			result.put("errMsg", e.getErrMsg());
		} catch (Exception e) {
			logger.error(e.toString(), e);
			result.put("errMsg", "系统错误！");
		}
		return result;
	}

	/**
	 * 查询${objectName}详情data
	 */
	@ResponseBody
	@RequestMapping(value = "/data")
	public PageData data(${className} ${objectName}) {
		PageData result = new PageData("errMsg", "success");
		${objectName} = ${objectName}Service.load${className}(${objectName});
		result.put("data", ${objectName});
		return result;
	}

	/**
	 * 查询${objectName}列表datas
	 */
	@ResponseBody
	@RequestMapping(value = "/datas")
	public PageData datas() {
		PageData result = new PageData("errMsg", "success");
		Page page = super.getPage();
		List<${className}> ${objectName}s = ${objectName}Service.find${className}Page(page);
		result.put("data", ${objectName}s).put("page", page);
		return result;
	}	
}
