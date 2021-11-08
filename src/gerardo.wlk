import wollok.game.*
import celdasEspeciales.*
import direcciones.*
import nivelPerder.*

object gerardo {
	var property energia = 0
	var property salud = 0
	var property dinero = 0
	var property position = game.center()
	var property llavesEncontradas = 0
	var property llavesEntregadas = 0
	var property cajasEncontradas = 0
	
	var property direccion = right
	var property ultimoCostado = right
	
	method image() {		// solo contempla si mira a la derecha o izquierda
		var imagen			// si se corrige --> sacar de moveRight() y moveLeft()
		
		if (ultimoCostado.isRight()) {
			imagen = "gerardoderecha.png" 
		} else { // si es left
			imagen = "gerardoizquierda.png" 
		}
		return imagen
	}
	
	method seSuperpone() = false 
	// evita problemas con la creacion de elementos y posiciones aleatorias
	
	method sePuedePisar() = true	// Así los bichos pueden llegar a Gerardo
	
	method tieneEnergia() = energia > 0
	
	/** ************************************ **/
	
	// Suma y resta de energía salud y dinero
	method sumarSalud(cantidad) { salud = (salud + cantidad).min(100) }
	
	method restarSalud(cantidad) { salud = (salud - cantidad).max(0) }
	
	method sumarEnergia(cantidad) { energia = (energia + cantidad).min(50) }
	
	method restarEnergia(cantidad) { energia = (energia - cantidad).max(0) }
	
	method sumarDinero(cantidad) { dinero = (dinero + cantidad).min(30) }
	
	method restarDinero(cantidad) { dinero = (dinero - cantidad).max(0) }
	
	/** ************************************ **/
	
	// Interaccion con objetos
	method interactuar(elemento) { elemento.interactuar()}
	
	// Llaves 
	method sumarLlaves(cant) { llavesEncontradas += cant }
	
	// Cajas
	method sumarCajas(cant) { 
		cajasEncontradas += cant
	}
	
	method entregarLlaves() {
		llavesEncontradas -= 1
		llavesEntregadas += 1
		if (self.puedeGanarNivel1()) {
			game.say(self, "Listo el pollo!")
		} else {
			game.say(self, "Te dejo las llaves!")
		}
	}
	
	/** ************************************ **/
	
	// Movimientos
	method move(dir) {				
		
		if (self.tieneEnergia()) {
			if (dir.isUp()) {
				self.moveUp()
			} else if (dir.isDown()) {
				self.moveDown()
			} else if (dir.isRight()) {
				self.moveRight()
			} else {
				self.moveLeft()
			}
		} else {
			game.say(self, "Mejor reinicio mis pasos...")
		}
	}
	
	method hayCeldaLibreAl(dir) {
		var hayCeldaLibre = true
		
		if (dir.isUp()) {
			hayCeldaLibre = game.getObjectsIn(self.position().up(1)).all{obj => obj.puedeSuperponer()}
		} else if (dir.isDown()) {
			hayCeldaLibre = game.getObjectsIn(self.position().down(1)).all{obj => obj.puedeSuperponer()}
		} else if (dir.isRight()) {
			hayCeldaLibre = game.getObjectsIn(self.position().right(1)).all{obj => obj.puedeSuperponer()}
		} else {
			hayCeldaLibre = game.getObjectsIn(self.position().left(1)).all{obj => obj.puedeSuperponer()}
		}
		return hayCeldaLibre
	}
	
	method moveUp() {

		if (not (self.position().y() == game.height() - 2)) {
			self.position(self.position().up(1))
		} else {
			self.position(new Position(x = self.position().x(), y = 0))
		}
		self.restarEnergia(1)
		direccion = up
	}
	
	method moveDown() {
		if (not (self.position().y() == 0)) {
			self.position(self.position().down(1))
		} else {
			self.position(new Position(x = self.position().x(), y = game.height()-2))
		}
		self.restarEnergia(1)
		direccion = down
	}
	
	method moveRight() {
		if (not (self.position().x() == game.width() - 1)) {
			self.position(self.position().right(1))
		} else {
			self.position(new Position(x = 0, y = self.position().y()))
		}
		self.restarEnergia(1)
	
		direccion = right
		ultimoCostado = right // para imagen
	}
	
	method moveLeft() {
		if (not (self.position().x() == 0)) {
			self.position(self.position().left(1))
		} else {
			self.position(new Position(x = game.width()-1 , y = self.position().y()))
		}
		self.restarEnergia(1)
		
		direccion = left
		ultimoCostado = left // para imagen
	}
	
	method agarrar() {
		
		const objetosEnCeldaLindante = game.getObjectsIn(self.posicionVecinaA(self.direccion()))
		
		objetosEnCeldaLindante.forEach({
			objeto => objeto.serAgarrado()
		})
	}
	
	method posicionVecinaA(dir) {
		var posicion 
		
		if (dir.isUp()) {
			posicion = self.position().up(1)
		} else if (dir.isDown()) {
			posicion = self.position().down(1)
		} else if (dir.isRight()) {
			posicion = self.position().right(1)
		} else if (dir.isLeft()) {
			posicion = self.position().left(1)
		}
		return posicion
	}

	/** ************************************ **/
	
	method puedeGanarNivel1() {
		return self.llavesEntregadas() == 3 and self.cajasEncontradas() == 3
	}

	/** ************************************ **/
	
	method ingresarCaja() {}     // si no rompe con el collide de las cajas
}
