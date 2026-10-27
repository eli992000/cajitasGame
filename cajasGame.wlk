import wollok.game.*

class Caja {
	var property position
	const property llegadas
	
	method movete(direccion) {
		self.validarLugarLibre(direccion)
		position = direccion.siguiente(position)
	}
	
	method validarLugarLibre(direccion) {
		const posAlLado = direccion.siguiente(position)
		const lugarLibre = game.getObjectsIn(posAlLado).all(
			{ obj => obj.puedePisarte(self) }
		)
		if (!lugarLibre) {
			throw new DomainException(message = "Algo traba la caja.", source = jugador)
		}
	}
	
	method puedePisarte(_) = false
	
	method image() = if (self.estaBienPosicionada()) "caja_ok.png" else "caja.png"
	
	method estaBienPosicionada() = llegadas.any({ llegada => llegada.position() == position })
}

object jugador {
	var property position = game.at(4, 3)
	var direccion = arriba

	method empuja(unElemento) {
		try
			unElemento.movete(direccion)
		catch e {
			self.retrocede()
			throw e
		}
	}
	
	method retrocede() {
		position = direccion.opuesto().siguiente(position)
	}
	
	method retrocedeCon(caja) {
		self.retrocede()
		caja.movete(direccion.opuesto())
	}

	method irArriba() {
		direccion = arriba
		self.avanzar()
	}

	method irAbajo() {
		direccion = abajo
		self.avanzar()
	}

	method irIzquierda() {
		direccion = izquierda
		self.avanzar()
	}

	method irDerecha() {
		direccion = derecha
		self.avanzar()
	}
	
	method avanzar() {
		position = direccion.siguiente(position)
	}
	
	method setDireccion(unaDireccion) {
		direccion = unaDireccion
	}
	
	method image() = "jugador.png"
	
//	method position() = position
//	method position(_position) {
//		position = _position
//	} 
}


class Direccion {
	method siguiente(position)
}

object izquierda inherits Direccion { 
	override method siguiente(position) = position.left(1) 
	method opuesto() = derecha
}

object derecha inherits Direccion { 
	override method siguiente(position) = position.right(1) 
	method opuesto() = izquierda
}

object abajo inherits Direccion { 
	override method siguiente(position) = position.down(1) 
	method opuesto() = arriba
}

object arriba inherits Direccion { 
	override method siguiente(position) = position.up(1) 
	method opuesto() = abajo
}

class Llegada {
	const property position

	// No pasa naranja cuando se quiere mover
	method movete(direccion) { }
	method puedePisarte(_) = true
	method image() = "moneda.png"

}

object nivel1 {
	method cargar() {
		
		// PAREDES
		const ancho = game.width() - 1
		const largo = game.height() - 1

		const posicionesParedes = [
			// Borde inferior
			new Position(x = 0, y = 0),
			new Position(x = 1, y = 0),
			new Position(x = 2, y = 0),
			new Position(x = 3, y = 0),
			new Position(x = 4, y = 0),
			new Position(x = 5, y = 0),
			new Position(x = 6, y = 0),
			new Position(x = 7, y = 0),
			new Position(x = 8, y = 0),

			// Borde superior
			new Position(x = 0, y = 6),
			new Position(x = 1, y = 6),
			new Position(x = 2, y = 6),
			new Position(x = 3, y = 6),
			new Position(x = 4, y = 6),
			new Position(x = 5, y = 6),
			new Position(x = 6, y = 6),
			new Position(x = 7, y = 6),
			new Position(x = 8, y = 6),

			// Borde izquierdo
			new Position(x = 0, y = 1),
			new Position(x = 0, y = 2),
			new Position(x = 0, y = 3),
			new Position(x = 0, y = 4),
			new Position(x = 0, y = 5),

			// Borde derecho
			new Position(x = 8, y = 1),
			new Position(x = 8, y = 2),
			new Position(x = 8, y = 3),
			new Position(x = 8, y = 4),
			new Position(x = 8, y = 5),

			// Paredes interiores
			new Position(x = 3, y = 5),
			new Position(x = 4, y = 5),
			new Position(x = 5, y = 5),

			new Position(x = 1, y = 2),
			new Position(x = 2, y = 2),
			new Position(x = 6, y = 2),
			new Position(x = 7, y = 2),

			new Position(x = 1, y = 1),
			new Position(x = 2, y = 1),
			new Position(x = 6, y = 1),
			new Position(x = 7, y = 1)
		]

		posicionesParedes.forEach({ posicion =>
			self.dibujar(new Pared(position = posicion))
		})


		
		posicionesParedes.addAll(
			[
				new Position(x = 3, y = 5),
				new Position(x = 4, y = 5),
				new Position(x = 5, y = 5)
			]
		)
		posicionesParedes.addAll(
			[
				new Position(x = 1, y = 2),
				new Position(x = 2, y = 2),
				new Position(x = 6, y = 2),
				new Position(x = 7, y = 2)
			]
		)
		posicionesParedes.addAll(
			[
				new Position(x = 1, y = 1),
				new Position(x = 2, y = 1),
				new Position(x = 6, y = 1),
				new Position(x = 7, y = 1)
			]
		)
		posicionesParedes.forEach({ posicionParedes => self.dibujar(new Pared(position = posicionParedes)) })

		//	LLEGADAS
		const llegadas = [
			new Position(x = 4, y = 4),
			new Position(x = 4, y = 3),
			new Position(x = 4, y = 2),
			new Position(x = 4, y = 1)
		].map({ posicion => self.dibujar(new Llegada(position = posicion)) }) //	CAJAS
		const cajas = [
			new Position(x = 2, y = 4),
			new Position(x = 6, y = 4),
			new Position(x = 4, y = 2),
			new Position(x = 5, y = 2)
		].map({ posicion => self.dibujar(new Caja(position = posicion, llegadas = llegadas)) })
		//	SOKOBAN
		
		game.addVisual(jugador) //	TECLADO
		
		keyboard.up().onPressDo({ jugador.irArriba() })
		keyboard.down().onPressDo({ jugador.irAbajo() })
		keyboard.left().onPressDo({ jugador.irIzquierda() })
		keyboard.right().onPressDo({ jugador.irDerecha() })
		keyboard.r().onPressDo({ self.restart() })
		//	COLISIONES.onPressDo({ self.comprobarSiGano(cajas) })
		game.whenCollideDo(jugador, { elemento => jugador.empuja(elemento) })
	}
	
	method restart() {
		game.clear()
		self.cargar()
	}
	
	method dibujar(dibujo) {
		game.addVisual(dibujo)
		return dibujo
	}
	
	method comprobarSiGano(cajas) {
		if (cajas.all({ caja => caja.estaBienPosicionada() }))
			game.say(jugador, "GANASTE!")
			game.onTick(5000, "gameEnd", { game.stop() })
	}
}

class Pared {
	var property position
	
	method movete(direccion) {
		throw new DomainException(message = "No puedes mover las paredes.", source = jugador)
	}
	
	method puedePisarte(_) = false
	method image() = "murohd.png"
}


