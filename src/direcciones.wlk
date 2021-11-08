class Direccion {
	
	method opuesto()
	
	method isUp() = false
	method isDown() = false
	method isRight() = false
	method isLeft() = false
	
}

object up inherits Direccion {
	
	override method opuesto() = down
	
	override method isUp() = true
}

object down inherits Direccion {
	
	override method opuesto() = up
	
	override method isDown() = true
}

object right inherits Direccion {
	
	override method opuesto() = left
	
	override method isRight() = true
}

object left inherits Direccion {
	
	override method opuesto() = right
	
	override method isLeft() = true
}