/**
 *
 * @author v.pavkin
 */
package views {
	
	import flash.display.Sprite;
	import interfaces.IMainModel;
	import interfaces.IMainView;
	
	public class MainView extends Sprite implements IMainView {
		
		private var _model:IMainModel;
		
		private var _objects:ObjectsView;
		private var _snow:SnowView;
		
		public function MainView(model:IMainModel) {
			super();
			_model = model;
			_objects = new ObjectsView();
			_snow = new SnowView();
		}
		
		public function start():void {
			addChild(_objects);
			addChild(_snow);
		}
		
		public function get objects():ObjectsView {
			return _objects;
		}
		
		public function get snow():SnowView {
			return _snow;
		}
	}
}

