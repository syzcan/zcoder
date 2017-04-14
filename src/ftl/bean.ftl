package ${packageBean};

${importPackage}
import java.io.Serializable;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

/**
 * @desc ${objectName}实体类
 * @author zong
 * @date ${nowDate?string("yyyy年MM月dd日")}
 */
@JsonInclude(Include.NON_NULL)
public class ${className} implements Serializable {
<#list primaryColumns as columnField>	
	private ${columnField.javaType} ${columnField.field};
</#list>	
<#list normalColumns as columnField>
	<#if columnField.javaType=='Date'>
	<#--@JsonFormat(pattern="yyyy-MM-dd",timezone="GMT+8")-->
	</#if>
	private ${columnField.javaType} ${columnField.field};
</#list>
	
	public ${className}(){
	}
	
<#list primaryColumns as columnField>
	public ${columnField.javaType} get${columnField.fieldUpper}(){
		return ${columnField.field};
	}
	
	public void set${columnField.fieldUpper}(${columnField.javaType} ${columnField.field}){
		this.${columnField.field} = ${columnField.field};
	}
	
</#list>
<#list normalColumns as columnField>
	public ${columnField.javaType} get${columnField.fieldUpper}(){
		return ${columnField.field};
	}
	
	public void set${columnField.fieldUpper}(${columnField.javaType} ${columnField.field}){
		this.${columnField.field} = ${columnField.field};
	}
	
</#list>
}