import wollok.game.*
import gerardo.*
import celdasEspeciales.*
import barrasSuperiores.*
import elementos.*
import direcciones.*
import nivel2.*
import nivelPerder.*
import fondo.*
import bichosYComida.*

object inicioNivel1 {
	method configurate() {
		
		game.addVisual(interfazInicioNivel1)
		
		keyboard.enter().onPressDo({ interfazInicioNivel1.seleccionar() })
	}
}

object interfazInicioNivel1 {
	var property seleccion = "comienzo_1"
	
	method position() = game.at(0,0)
	
	method image() {
		var imagen
		
		if (seleccion == "comienzo_1") {
			imagen = "comienzo_nivel1_1.png"
		} else if (seleccion == "comienzo_2") {
			imagen = "comienzo_nivel1_2.png"
		}
		return imagen
	}
	
	method seleccionar(opcion) {
		seleccion = opcion
	}
	
	method seleccionar() {
		if (seleccion == "comienzo_1") {
			self.seleccionar("comienzo_2")
		} else if (seleccion == "comienzo_2") {
			game.clear()
			nivel1.configurate()
		}
	}
}

object nivel1 {
	method configurate() {
		
		// Fondo
		game.addVisual(new FondoNivel(position = game.at(0,0), image = "ladrillo.png"))
		
		// Celdas especiales
		const celdaBuena = new CeldaBuena()
		const celdaMala = new CeldaMala()
		const celdaDeAparicion = new CeldaDeAparicion()
		const celdaDeTeletransportacion = new CeldaDeTeletransportacion()
		
		const celdasEspeciales = #{celdaBuena, celdaMala, celdaDeAparicion, celdaDeTeletransportacion}
		
		const depo1 = new Deposito(llavesRecuperadas = 0, cajasRecuperadas = 0)
		const depo2 = new Deposito(llavesRecuperadas = 0, cajasRecuperadas = 0)
		const depo3 = new Deposito(llavesRecuperadas = 0, cajasRecuperadas = 0)
		
		const depositos = #{depo1, depo2, depo3}
		
		const caja1 = new Caja() 
		const caja2 = new Caja()
		const caja3 = new Caja()
		
		const cajas = #{caja1, caja2, caja3}
		
		const llave1 = new Llave()
		const llave2 = new Llave()
		const llave3 = new Llave()
		
		const llaves = #{llave1, llave2, llave3}
		
		const pulga = new Pulga()
		const garrapata = new Garrapata()
		const cucaracha = new Cucaracha()
		const mosquito = new Mosquito() 
		
		const bichosMalos = #{pulga, garrapata, cucaracha, mosquito}
		
		const garbanzo = new Garbanzo()	
		const empanada = new Empanada()
		const birra = new Birra()
		const cocacola = new Cocacola()
		
		const comidas = #{garbanzo, empanada, birra, cocacola}
		
		const pepucha = new Pepucha()
	
		/////////
		
		celdasEspeciales.forEach{celda => game.addVisual(celda)}
		cajas.forEach{caja => game.addVisual(caja)}
		depositos.forEach{depo => game.addVisual(depo)}
		llaves.forEach{llave => game.addVisual(llave)}
		bichosMalos.forEach{bicho => game.addVisual(bicho)}
		comidas.forEach{comida => game.addVisual(comida)}
		
		
		game.addVisual(pepucha)
		
		celdasEspeciales.forEach{celda => celda.setNewRandomPosition()}
		cajas.forEach{caja => caja.setNewRandomPosition()}
		depositos.forEach{depo => depo.setNewRandomPosition()}
		llaves.forEach{llave => llave.setNewRandomPosition()}
		bichosMalos.forEach{bicho => bicho.setNewRandomPosition()}
		comidas.forEach{comida => comida.setNewRandomPosition()}
		
		pepucha.setNewRandomPosition()
		
		//game.onTick(3000, "Movimiento bichos", { bichosMalos.forEach{bicho => bicho.moverAleatorio()} })
		
		self.moverAleatorio(pepucha, 1000)
		
		bichosMalos.forEach{ bicho => bicho.moverAleatorioCada(1000) }		// SI ROMPE SACAR
		 
		/////////
		
		self.setGerardo()
		
		self.agregarBarra()
		
		// Gerardo
		game.addVisual(gerardo)
		
		// Collide(s)
		game.onCollideDo(gerardo, {objeto => gerardo.interactuar(objeto)})
		// funciona porque solo acepta cajas ( method esCaja() )
		cajas.forEach{caja => game.onCollideDo(caja, {depo => depo.ingresarCaja()})}
		
		
		// Movimiendo Gerardo
		keyboard.up().onPressDo({ gerardo.move(up) })
		keyboard.down().onPressDo({ gerardo.move(down) })
		keyboard.right().onPressDo({ gerardo.move(right) })
		keyboard.left().onPressDo({ gerardo.move(left) })
		
		keyboard.e().onPressDo({  gerardo.agarrar() })
		
		keyboard.r().onPressDo({ self.restart() })
		
		game.onTick(1, "Ganar o Perder", { self.ganarSiCorresponde() })
		
		game.onTick(1, "Perder si corresponde", { self.perderSiCorresponde() })
		
		game.onTick(1, "Mostrar llaves", { self.mostrarLlaves()})
		
		game.onTick(1, "Mostrar cajas", { self.mostrarCajas() })
		
		// Para probar ganar
		keyboard.t().onPressDo({self.ganarALaFuerza()})
		// Para probar perder
		keyboard.y().onPressDo({self.perderALaFuerza()})
		
	}
	
		/** ******************************** **/
	
	method setGerardo() {
		
		// Gerardo
		gerardo.energia(30)
		gerardo.salud(100)
		gerardo.llavesEncontradas(0)
		gerardo.cajasEncontradas(0)
		gerardo.llavesEntregadas(0)
		
		// esto si se quiere setear
		gerardo.position(game.center())
		gerardo.ultimoCostado(right)
	}
	
	method agregarBarra() {
		// Salud y energía de Gerardo
		game.addVisual(barraDeSalud)
		game.addVisual(rayito)
		game.addVisual(contadorEnergia1)
		game.addVisual(contadorEnergia2)
	}
	
	method mostrarCajas() {
		const cajas = gerardo.cajasEncontradas() 
		
		if (cajas == 1 and not game.hasVisual(cont_caja1)) { game.addVisual(cont_caja1) }
		if (cajas == 2 and not game.hasVisual(cont_caja2)) { game.addVisual(cont_caja2) }
		if (cajas == 3 and not game.hasVisual(cont_caja3)) { game.addVisual(cont_caja3) }
	}
	
	method mostrarLlaves() {
		const llaves = gerardo.llavesEncontradas()
		
		if (llaves == 1 and not game.hasVisual(cont_llave1)) { game.addVisual(cont_llave1) }
		if (llaves == 2 and not game.hasVisual(cont_llave2)) { game.addVisual(cont_llave2) }
		if (llaves == 3 and not game.hasVisual(cont_llave3)) { game.addVisual(cont_llave3) }
	}
	
	method restart() {
		game.clear()
		self.configurate()
	}
	
	method perderSiCorresponde() {
		if (gerardo.salud() == 0) {
			game.say(gerardo, "Ay la Pepucha!")
			game.schedule(1000, {
				game.clear()
				nivelPerder.configurate()
			})
		}
	}
	
	method ganarSiCorresponde() {
		if (gerardo.llavesEntregadas() == 3 and gerardo.cajasEncontradas() == 3) {
			game.schedule(2000, {
				game.say(gerardo, "Listo el pollo!")
			})
			game.schedule(5000, {
				game.clear()
				finNivel1.configurate()
			})
		}
	}
	
	method moverAleatorio(objeto, milisegundos) {
		if (game.hasVisual(objeto)) {
			game.onTick(milisegundos, "Movimiento aleatorio", { objeto.moverAleatorio() })
		}
	}
	
	method ganarALaFuerza() {
		game.schedule(2000, {
				game.say(gerardo, "Listo el pollo!")
			})
			game.schedule(5000, {
				game.clear()
				finNivel1.configurate()
			})
	}
	
	method perderALaFuerza() {
		game.say(gerardo, "Ay la Pepucha!")
			game.schedule(1000, {
				game.clear()
				nivelPerder.configurate()
			})
	}
}

/** *********************************************************************** **/

object finNivel1 {
	method configurate() {
		game.addVisual(new FondoNivel(position = game.at(0,0), image = "ganarNivel1.png"))
		
		keyboard.enter().onPressDo({
			game.clear()
			inicioNivel2.configurate()
		})
	}
}