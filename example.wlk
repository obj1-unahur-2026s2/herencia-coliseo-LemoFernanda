// Armas
class ArmaFilo {
   var longitud // en cm
   var filo // entre  0 y 1

method longitud() = longitud
method longitud(nuevaLongitud) {

longitud = nuevaLongitud
}
method filo() = filo
method filo(nuevoFilo) {
filo = nuevoFilo }

method poderAtaque() = longitud * filo
}

class ArmaContundente {
  var peso

  method peso() = peso
  method peso(nuevoPeso) {
    peso = nuevoPeso
  }
  method poderAtaque() = peso
}

class Casco {
   method puntosArmadura(gladiador) = 10
}

class Escudo {
method puntosArmadura(gladiador) = 5 + (gladiador.destreza() * 0.10)

}

// Los Gladiadores
class Gladiador {
  var vida = 100

  method vida() = vida

  method recibirDaño(cantidad) {
    vida = 0.max(vida - cantidad)
  }
  method atacar(unGladiador){
    const dañar = 0.max(self.poderAtaque() - unGladiador.defensa() )
    unGladiador.recibirDaño(dañar)
  }
method poderAtaque() = 0
method defensa() = 0

method pelearseCon(unGladiador){
  self.atacar(unGladiador)
  if (unGladiador.vida() > 0){
    unGladiador.atacar(self)
  }
}
method curar() {
  vida = 100
}
}

class Mirmillon inherits Gladiador {
  const fuerza
  const arma
  var armadura
  const destreza = 15

method destreza() = destreza
method fuerza() = fuerza

override method poderAtaque() = arma.poderAtaque() + fuerza
override method defensa() = armadura.puntosArmadura(self) + destreza
method cambiarArmadura(nuevaArmadura) {
  armadura = nuevaArmadura
}

method crearGrupoCon(unGladiador) {
    const unGrupo = new Grupo()
    unGrupo.inicializarNombre("mirmillolandia")
    unGrupo.agregarGladiador(self)
    unGrupo.agregarGladiador(unGladiador)
    return unGrupo
  }
}

class Dimachaerus inherits Gladiador {
  const  armas = []
  const fuerza = 10
  var destreza

  method destreza() = destreza
  method fuerza() = fuerza

  override method poderAtaque() = fuerza + armas.sum({a => a.poderAtaque() })
  override method  defensa() = destreza / 2

  override method atacar(unGladiador) {
    super(unGladiador)
    destreza = destreza + 1
  }

  method crearGrupoCon(unGladiador) {
    const sumaPoderes = self.poderAtaque() + unGladiador.poderAtaque()
    const unGrupo = new Grupo()
    unGrupo.inicializarNombre("D-" + sumaPoderes)
    unGrupo.agregarGladiador(self)
    unGrupo.agregarGladiador(unGladiador)
    return unGrupo
  }
}


// Grupos
class Grupo {
  var nombre = ""
  var cantidadPeleas =0
  const gladiadores = []

  method inicializarNombre(unNombre){
    nombre = unNombre
  }

  method nombre() = nombre
  method nombre(nuevoNombre) {
    nombre = nuevoNombre
  }
  method cantidadPeleas() = cantidadPeleas
  method cantidadPeleas(nuevaCantidad){
    cantidadPeleas = nuevaCantidad 
  }
  method gladiadores() = gladiadores

  method agregarGladiador(unGladiador) {
    gladiadores.add(unGladiador)
  }

  method quitarGladiador(unGladiador) {
    gladiadores.remove(unGladiador)
  }

  method campeon() {
  const disponibles = gladiadores.filter({g => g.vida() > 0})
  if (disponibles.isEmpty()) {
    self.error("No hay gladiadores con vida para combatir")
  }
  return disponibles.max({g => g.poderAtaque() })
  }

}

object coliseo {

  // Combate entre dos grupos a 3 rounds
  method combatirGrupos(grupo1, grupo2) {
    grupo1.cantidadPeleas(grupo1.cantidadPeleas() + 1)
    grupo2.cantidadPeleas(grupo2.cantidadPeleas() + 1)
    
    // Método auxiliar que hace las 3 repeticiones de los 3 rounds
    self.repetirPelea(grupo1, grupo2, 3)
  }

  // Método auxiliar tradicional para los rounds
  method repetirPelea(grupo1, grupo2, veces) {
    if (veces > 0) {
      grupo1.campeon().pelearseCon(grupo2.campeon())
      self.repetirPelea(grupo1, grupo2, veces - 1)
    }
  }

  // Combate entre un grupo y un gladiador suelto
  method combatirGrupoContraGladiador(unGrupo, unGladiador) {
    unGrupo.cantidadPeleas(unGrupo.cantidadPeleas() + 1)
    unGrupo.campeon().pelearseCon(unGladiador)
  }

  // Curar a un gladiador suelto
  method curarGladiador(unGladiador) {
    unGladiador.curar()
  }

  // Curar a un grupo entero
  method curarGrupo(unGrupo) {
    unGrupo.gladiadores().forEach({ g => self.curarGladiador(g) })
  }
}