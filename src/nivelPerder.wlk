import wollok.game.*
import gerardo.*
import elementos.*
import inicio.*
import fondo.*
import nivel1.*

object nivelPerder {
	method configurate() {
		
		game.addVisual(new FondoNivel(position = game.at(0,0), image = "gameOver.png"))
	
	
		keyboard.enter().onPressDo({
			game.clear()
			interfazInicioNivel1.seleccionar("comienzo_1")
			inicio.configurate()
		})
	}
}



