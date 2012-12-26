/**
 *
 * @author v.pavkin
 */
package views {
import flash.display.Sprite;

public class StaticBGView extends Sprite {

	[Embed(source='../../obj/bg.jpg')]
	public static var fon:Class;

	public function StaticBGView() {
		addChild(new fon());
	}

}
}
