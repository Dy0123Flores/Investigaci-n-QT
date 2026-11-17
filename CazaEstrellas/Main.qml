import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

ApplicationWindow {
    id: ventana
     width: 390
     height: 740
     minimumWidth: 320
     minimumHeight: 550
     visible: true
     title: "Órbita Fugaz"
     color: "#101827"

     property int pantalla: 0
     property string nombreJugador: ""
     property string aliasJugador: ""
     property int edadJugador: 0
     property string dificultad: "Normal"

     property int puntos: 0
     property int tiempo: 30
     property int combo: 0
     property int mejorCombo: 0
     property int estrellas: 0
     property int meteoritos: 0

     property bool jugando: false
     property bool pausado: false
     property bool partidaTerminada: false
     property bool sonidoActivo: true

     property int tipoObjetivo: 0
     property int tamañoObjetivo: 65
     property real posicionX: 0
     property real posicionY: 0
     property string avisoEtapa: ""

     readonly property int etapa: tiempo > 20 ? 1 : tiempo > 10 ? 2 : 3
     readonly property int intervaloObjetivos: {
         if (dificultad === "Fácil")
             return etapa === 1 ? 1800 : etapa === 2 ? 1300 : 900

         if (dificultad === "Normal")
             return etapa === 1 ? 1400 : etapa === 2 ? 950 : 600

         return etapa === 1 ? 1050 : etapa === 2 ? 700 : 400
     }

     function cambiarObjetivo() {
         tipoObjetivo = Math.random() < 0.25 ? 1 : 0

         posicionX = Math.random() *
                     Math.max(0, zonaJuego.width - tamañoObjetivo)

         posicionY = Math.random() *
                     Math.max(0, zonaJuego.height - tamañoObjetivo)
     }

     function iniciarJuego() {
         puntos = 0
         tiempo = 30
         combo = 0
         mejorCombo = 0
         estrellas = 0
         meteoritos = 0
         pausado = false
         partidaTerminada = false
         avisoEtapa = ""

         if (dificultad === "Fácil")
             tamañoObjetivo = 85
         else if (dificultad === "Normal")
             tamañoObjetivo = 65
         else
             tamañoObjetivo = 48

         pantalla = 1
         jugando = true

         Qt.callLater(cambiarObjetivo)

         if (sonidoActivo)
             musica.play()
    }

     function tocarObjetivo() {
            if (!jugando || pausado)
                return

            if (tipoObjetivo === 0) {
                estrellas++
                combo++

                if (combo > mejorCombo)
                    mejorCombo = combo

                var ganancia = dificultad === "Difícil" ? 3 : 2

                if (combo >= 5)
                    ganancia += 3
                else if (combo >= 3)
                    ganancia += 1

                puntos += ganancia

                if (sonidoActivo)
                    sonidoEstrella.play()
            } else {
                meteoritos++
                combo = 0
                puntos = Math.max(0, puntos - 3)

                if (sonidoActivo)
                    sonidoMeteorito.play()
            }

            cambiarObjetivo()
        }

        function cambiarPausa() {
            if (!jugando)
                return

            pausado = !pausado

            if (sonidoActivo) {
                if (pausado)
                    musica.pause()
                else
                    musica.play()
            }
        }

        function terminarJuego() {
            if (!jugando)
                return

            jugando = false
            pausado = false
            partidaTerminada = true

            musica.stop()

            registroPuntajes.agregarPartida(
                nombreJugador,
                aliasJugador,
                edadJugador,
                dificultad,
                puntos
            )

            pantalla = 2
        }

        onEtapaChanged: {
            if (jugando && etapa > 1) {
                avisoEtapa = "ETAPA " + etapa + " - MÁS VELOCIDAD"
                cambiarObjetivo()

                if (sonidoActivo)
                    sonidoEtapa.play()

                avisoTimer.restart()
            }
        }

        onSonidoActivoChanged: {
            if (!sonidoActivo)
                musica.stop()
            else if (jugando && !pausado)
                musica.play()
        }

        MediaPlayer {
                id: musica
                source: Qt.resolvedUrl("audio/musica.wav")
                loops: MediaPlayer.Infinite

                audioOutput: AudioOutput {
                    volume: 0.28
                }
            }

            SoundEffect {
                id: sonidoEstrella
                source: Qt.resolvedUrl("audio/estrella.wav")
                volume: 0.5
            }

            SoundEffect {
                id: sonidoMeteorito
                source: Qt.resolvedUrl("audio/meteorito.wav")
                volume: 0.5
            }

            SoundEffect {
                id: sonidoEtapa
                source: Qt.resolvedUrl("audio/etapa.wav")
                volume: 0.5
            }

            Timer {
                   id: cronometro
                   interval: 1000
                   repeat: true
                   running: ventana.jugando && !ventana.pausado

                   onTriggered: {
                       if (ventana.tiempo > 1) {
                           ventana.tiempo--
                       } else {
                           ventana.tiempo = 0
                           ventana.terminarJuego()
                       }
                   }
               }

               Timer {
                   id: movimientoTimer
                   interval: ventana.intervaloObjetivos
                   repeat: true
                   running: ventana.jugando && !ventana.pausado

                   onTriggered: ventana.cambiarObjetivo()
               }

               Timer {
                   id: avisoTimer
                   interval: 1400
                   onTriggered: ventana.avisoEtapa = ""
               }

               StackLayout {
                       anchors.fill: parent
                       currentIndex: ventana.pantalla

                       Item {
                           ColumnLayout {
                               anchors.fill: parent
                               anchors.margins: 20
                               spacing: 9

                               Item {
                                   Layout.fillHeight: true
                               }

                               Label {
                                   text: "★"
                                   color: "#ffd166"
                                   font.pixelSize: 70
                                   Layout.alignment: Qt.AlignHCenter
                               }

                               Label {
                                   text: "ÓRBITA FUGAZ"
                                   color: "white"
                                   font.pixelSize: 27
                                   font.bold: true
                                   Layout.alignment: Qt.AlignHCenter
                               }

                               Label {
                                   text: "Atrapa estrellas, esquiva meteoritos y supera las tres etapas"
                                   color: "#a9bdd8"
                                   wrapMode: Text.WordWrap
                                   horizontalAlignment: Text.AlignHCenter
                                   Layout.fillWidth: true
                               }


}
