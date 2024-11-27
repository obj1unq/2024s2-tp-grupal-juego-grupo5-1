import map.*
import wollok.game.*


object animacion {
    var property frame = 1

    method sumarFrame() {
        frame += 1
        self.volverAlInicio()
    }

    method volverAlInicio() {
      if (frame > 3) frame = 1
    }
}

