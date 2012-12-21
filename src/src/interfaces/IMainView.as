/**
 *
 * @author v.pavkin
 */
package interfaces {
	
import views.ObjectsView;
import views.SnowView;

public interface IMainView {
	
	function start():void;
	
	function get snow():SnowView;
	
	function get objects():ObjectsView;
}
}
