package model {

import interfaces.IMainModel;
import interfaces.IObject;

/**
 * ...
 * @author Frankie Wilde
 */

public class MainModel extends Model implements IMainModel {

	private var _bouncingObjects:Vector.<IObject>;


	public function MainModel() {
		_bouncingObjects = new Vector.<IObject>();
	}

	public function get bouncingObjects():Vector.<IObject> {
		return _bouncingObjects;
	}

	public function start():void {

	}
}

}