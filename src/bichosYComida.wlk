import wollok.game.*
import gerardo.*
import elementos.*
import direcciones.*

class Comida inherits Elemento {
	
	method image() 
	
	override method esComida() = true
	
	override method interactuar() { game.say(gerardo, "Uf que hambre..") }
	
	method energiaPorUnidad()
	
	method saludPorUnidad()
	
	override method serAgarrado() {
		gerardo.sumarEnergia(self.energiaPorUnidad())
		gerardo.sumarSalud(self.saludPorUnidad())
		game.say(gerardo, "Que rico!")
		game.removeVisual(self)
	}
	
	method moverAleatorio() {}
}

/** **************************************************** **/

class Garbanzo inherits Comida {
	
	override method image() = "garbanzo.png"
	
	override method energiaPorUnidad() = 0
	
	override method saludPorUnidad() = 10
}

/** **************************************************** **/

class Empanada inherits Comida {
	
	override method image() = "empanada.png"
	
	override method energiaPorUnidad() = 10
	
	override method saludPorUnidad() = 0
}

/** **************************************************** **/

class Birra inherits Comida {
	
	override method image() = "birra.png"
	
	override method energiaPorUnidad() = 15
	
	override method saludPorUnidad() = 15
}

class Cocacola inherits Comida {
	
	override method image() = "cocacola.png"
	
	override method energiaPorUnidad() = 20
	
	override method saludPorUnidad() = 20
}


/** *********************************************************************** **/


class Bicho inherits Elemento {
	var estaEnElNivel = true
	
	method image() 
	
	override method esBicho() = true

	method saludQueQuita()
	
	override method interactuar() {
		gerardo.restarSalud(self.saludQueQuita())
		game.say(gerardo, "Plagas de *** !")
		estaEnElNivel = false						// SI ROMPE SACAR
		game.removeVisual(self)
	}
	
	method moverAleatorioCada(milisegundos) {
		if (estaEnElNivel) {
			game.onTick(milisegundos, "Movete bichito", { self.moverAleatorio() })
		}
	}
	
	method moverAleatorio() {					//MUY POLÉMICO
		const nro = new Range(start = 0, end = 3).anyOne()
		
		if (nro == 0) {
			if (self.hayCeldaLibreAl(up)) {
				self.moveUp()
			} else {
				self.moverAleatorio()
			}
		}
		if (nro == 1) {
			if (self.hayCeldaLibreAl(down)) {
				self.moveDown()
			} else {
				self.moverAleatorio()
			}
		}
		if (nro == 2) {
			if (self.hayCeldaLibreAl(right)) {
				self.moveRight()
			} else {
				self.moverAleatorio()
			}
		}
		if (nro == 3) {
			if (self.hayCeldaLibreAl(left)) {
				self.moveLeft() 
			} else {
				self.moverAleatorio()
			}
		}
	}

	method moveUp() {
		if (not (self.position().y() == game.height() - 2)) {
			position = self.position().up(1)
		} else {
			position = new Position(x = self.position().x(), y = 0)
		}
	}
	
	method moveDown() {
		if (not (self.position().y() == 0)) {
			position = self.position().down(1)
		} else {
			position = new Position(x = self.position().x(), y = game.height()-2)
		}
	}
	
	method moveRight() {
		if (not (self.position().x() == game.width() - 1)) {
			position = self.position().right(1)
		} else {
			position = new Position(x = 0, y = self.position().y())
		}
	}
	
	method moveLeft() {
		if (not (self.position().x() == 0)) {
			position = self.position().left(1)
		} else {
			position = new Position(x = game.width()-1 , y = self.position().y())
		}
	}
	
	method hayCeldaLibreAl(dir) {
		var hayCeldaLibre = true
		
		if (dir.isUp()) {
			hayCeldaLibre = game.getObjectsIn(self.position().up(1)).all{obj => obj.sePuedePisar()}
		} else if (dir.isDown()) {
			hayCeldaLibre = game.getObjectsIn(self.position().down(1)).all{obj => obj.sePuedePisar()}
		} else if (dir.isRight()) {
			hayCeldaLibre = game.getObjectsIn(self.position().right(1)).all{obj => obj.sePuedePisar()}
		} else {
			hayCeldaLibre = game.getObjectsIn(self.position().left(1)).all{obj => obj.sePuedePisar()}
		}
		return hayCeldaLibre
	}
}

/** **************************************************** **/

class Pulga inherits Bicho {
	
	override method image() = "pulga.png"
	
	override method saludQueQuita() = 10
}

/** **************************************************** **/

class Garrapata inherits Bicho {
	
	override method image() = "garrapata.png"
	
	override method saludQueQuita() = 20
}
	
/** **************************************************** **/	
	
class Cucaracha inherits Bicho {
	
	override method image() = "cucaracha.png"
	
	override method saludQueQuita() = 30
}

class Mosquito inherits Bicho {
		
	override method image() = "mosquito.png"
	
	override method saludQueQuita() = 40
}

/** *********************************************************************** **/

class Pepucha inherits Bicho {
	var energiaParaDar = 50
	var saludParaDar = 100
	
	override method saludQueQuita() = 0
	
	override method image() = "pepucha.png"
	
	method tieneEnergia() = energiaParaDar > 0
	
	method tieneSalud() = saludParaDar > 0
	
	/**
	
	Pepucha es un bicho especial, un bicho bueno! si Gerardo se para sobre ella suma 10 de energia
	pero le saca esos 10 a ella, cuando se le termine la energia no le puede sacar más.
	
	En cambio si Gerardo agarra a pepucha hay dos casos a contemplar:
	
	Si la agarra y nunca se paró sobre ella recupera la totalidad de su salud.

	Si ya se paró sobre ella recupera un 20% menos de salud por cada vez que se haya parado.
		
		Es decir, si gerardo se para una vez sobre ella, recupera 10 puntos de energia
		y si después la agarra, en vez de recuperar 100 puntos de salud, recupera 80.

	En ambos casos si se queda sin energia o sin salud para dar, Gerardo la agarra, se manda a volar!
	Pero tranqui que se queda viendo que no pierdas el juego...

	
	 */
	
	override method esComida() = true
	 
	override method esBicho() = true
	 
	override method interactuar () {
		if (self.tieneEnergia() and self.tieneSalud()) {
			gerardo.sumarEnergia(10)
			energiaParaDar -= 10
			saludParaDar -= 20
			game.say(self, "Urrruuuu!")
			game.say(gerardo, "Gracias Pepucha!")
		} else {
			game.say(self, "urru...")
			game.say(gerardo, "Perdón pepucha querida...")
		}
			
		if (saludParaDar == 0) {
			game.say(gerardo, "Te dejo volar tranquila pepucha!")
			game.say(self, "Urru Urru!")
		}
	}
	 
	override method serAgarrado() {
		saludParaDar = 0
		gerardo.sumarSalud(saludParaDar)
		game.say(gerardo, "Te dejo volar tranquila pepucha!")
		game.say(self, "Urru Urru!")


	}
}