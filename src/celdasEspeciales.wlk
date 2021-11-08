import wollok.game.*
import elementos.*
import gerardo.*
import utilidades.*
import bichosYComida.*

class CeldaEspecial inherits Elemento  {
	
	method image() = "puertaTrampa.png"
	
	override method esCeldaEspecial() = true
	
	method obtainNewRandomPosition() {
		const newPosition = utilidadesParaJuego.posicionArbitraria()
		
		// no permite crear elementos en la celda del medio ni en la celda origen donde se crea el fondo
		if (game.getObjectsIn(newPosition).any{elem => not(elem.sePuedePisar()) or not(elem.puedeSuperponer())} or newPosition == game.center()) {
			self.obtainNewRandomPosition()
		}
		return newPosition
	}
}

/** *********************************************************************** **/

class CeldaBuena inherits CeldaEspecial {
	
	override method interactuar() { gerardo.sumarEnergia(30) }
}

/** *********************************************************************** **/

class CeldaMala inherits CeldaEspecial {
	
	override method interactuar() { gerardo.restarEnergia(15) }
}

/** *********************************************************************** **/

class CeldaDeAparicion inherits CeldaEspecial {
	
	override method interactuar() {
		const nro = new Range(start = 0, end = 7).anyOne()
		var aparicion
		
		if (nro == 0) {
			aparicion = new Birra(position = self.obtainNewRandomPosition())
		} else if (nro == 1) {
			aparicion = new Empanada(position = self.obtainNewRandomPosition())
		} else if (nro == 2) {
			aparicion = new Garbanzo(position = self.obtainNewRandomPosition())
		} else if (nro == 3) {
			aparicion = new Cocacola(position = self.obtainNewRandomPosition())	
		} else if (nro == 4) {
			aparicion = new Pulga(position = self.obtainNewRandomPosition())
		} else if (nro == 5) {
			aparicion = new Garrapata(position = self.obtainNewRandomPosition())
		} else if (nro == 6) {
			aparicion = new Cucaracha(position = self.obtainNewRandomPosition())	
		} else if (nro == 7) {
			aparicion = new Mosquito(position = self.obtainNewRandomPosition())	
		}
		game.addVisual(aparicion)
		game.onTick(2000, "Movimiento aparicion", { aparicion.moverAleatorio() })

	}
}

/** *********************************************************************** **/

class CeldaDeTeletransportacion inherits CeldaEspecial {
	
	override method interactuar() { 
		gerardo.position(self.obtainNewRandomPosition())
		game.say(gerardo, "Dónde estoy?")
	}
}
