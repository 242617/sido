package interfaces {
	
	import com.styleru.stage3d.interfaces.IModelWrapper;
	import nape.phys.Body;
	
	/**
	 * ...
	 * @author Frankie Wilde
	 */
	
	public interface IObject {
		
		function get body():Body;
		function get wrapper():IModelWrapper;
		
	}

}
